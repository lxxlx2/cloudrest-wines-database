"""Generate a schema-backed data dictionary in Markdown and CSV."""
from __future__ import annotations
import csv
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MYSQL = "/opt/homebrew/opt/mysql@8.4/bin/mysql"


def query(sql: str) -> list[dict]:
    result = subprocess.run(
        [MYSQL, "-u", "root", "--batch", "--raw", "--skip-column-names", "-e", sql],
        check=True, text=True, capture_output=True
    )
    rows = []
    for line in result.stdout.splitlines():
        if line:
            rows.append(json.loads(line))
    return rows


# `isUnique` means the attribute itself is unique. A column that merely participates
# in a composite PK/UNIQUE index must not be marked Y.
sql = r"""
SELECT JSON_OBJECT(
 'tableName', c.TABLE_NAME,
 'ordinal', c.ORDINAL_POSITION,
 'attributeName', c.COLUMN_NAME,
 'dataType', c.COLUMN_TYPE,
 'nullable', c.IS_NULLABLE,
 'defaultValue', COALESCE(CAST(c.COLUMN_DEFAULT AS CHAR), ''),
 'extraInfo', c.EXTRA,
 'isPrimary', IF(EXISTS(
   SELECT 1 FROM information_schema.KEY_COLUMN_USAGE k
   WHERE k.CONSTRAINT_SCHEMA=c.TABLE_SCHEMA AND k.TABLE_NAME=c.TABLE_NAME
     AND k.COLUMN_NAME=c.COLUMN_NAME AND k.CONSTRAINT_NAME='PRIMARY'), 'Y','N'),
 'isUnique', IF(EXISTS(
   SELECT 1
   FROM information_schema.STATISTICS s
   WHERE s.TABLE_SCHEMA=c.TABLE_SCHEMA
     AND s.TABLE_NAME=c.TABLE_NAME
     AND s.COLUMN_NAME=c.COLUMN_NAME
     AND s.NON_UNIQUE=0
     AND (
       SELECT COUNT(*)
       FROM information_schema.STATISTICS sx
       WHERE sx.TABLE_SCHEMA=s.TABLE_SCHEMA
         AND sx.TABLE_NAME=s.TABLE_NAME
         AND sx.INDEX_NAME=s.INDEX_NAME
     )=1
 ), 'Y','N'),
 'foreignReference', COALESCE((
   SELECT CONCAT(k.REFERENCED_TABLE_NAME,'.',k.REFERENCED_COLUMN_NAME)
   FROM information_schema.KEY_COLUMN_USAGE k
   WHERE k.CONSTRAINT_SCHEMA=c.TABLE_SCHEMA AND k.TABLE_NAME=c.TABLE_NAME
     AND k.COLUMN_NAME=c.COLUMN_NAME AND k.REFERENCED_TABLE_NAME IS NOT NULL
   LIMIT 1), ''),
 'columnComment', COALESCE(c.COLUMN_COMMENT,'')
)
FROM information_schema.COLUMNS c
WHERE c.TABLE_SCHEMA='cloudrestwines'
ORDER BY c.TABLE_NAME, c.ORDINAL_POSITION;
"""
rows = query(sql)

special = {
    "taxFileNumber": "Australian tax file number retained as a sensitive HR identifier for authorised administration.",
    "dateOfBirth": "Birth date used to demonstrate that an individual customer satisfies the legal-age requirement.",
    "australianBusinessNumber": "Australian Business Number identifying a business customer.",
    "confidentialNote": "Restricted wellbeing note excluded from routine management query output.",
    "juiceConversionPercent": "Expected percentage of harvested grape weight converted to juice for the variety.",
    "ripenessSugarPercent": "Sugar percentage recorded at harvest as the grape-ripeness measure.",
    "proportionPercent": "Percentage contribution of a grape variety to a wine recipe.",
    "paidFlag": "Accounting confirmation used by the shipment control to determine whether dispatch may proceed.",
    "reorderFlag": "Indicates whether the winery intends to reorder the bottle type.",
    "reorderComment": "Records the required explanation when a bottle type will not be reordered.",
    "regularHours": "Regular labour hours worked by an employee on the assigned shift.",
    "overtimeHours": "Overtime labour hours used for workload and safety exposure analysis.",
    "totalLostHours": "Labour hours lost because of an incident; zero remains valid for a near miss.",
    "employmentType": "Employment engagement category, kept separately from work-time and seasonal pattern.",
    "employmentPattern": "Ongoing or seasonal work pattern, independent of permanent/casual engagement.",
    "workTimeType": "Full-time or part-time work-time classification for the role period.",
    "severity": "Incident seriousness classification used for safety follow-up and corrective-action priority.",
    "capacityMl": "Nominal bottle capacity in millilitres.",
    "inventoryQuantity": "Current number of bottles of this type held in inventory.",
    "agingDays": "Usual ageing duration in days for wine made from the grape variety.",
    "orderedQuantity": "Number of bottle units ordered on the purchase-order line.",
    "receivedQuantity": "Number of bottle units actually received on the receipt line.",
    "reportableFlag": "Indicates whether the safety incident is classified as reportable; retained separately from the all-incident management KPI.",
}

context_purpose = {
    ("wineproduct","caseQuantity"): "Number of bottles packaged in one saleable case of this wine product.",
    ("orderline","caseQuantity"): "Number of cases of the product requested on the customer order line.",
    ("bottletype","usualUnitCost"): "Usual expected procurement cost for one bottle of this type.",
    ("purchaseorderline","quotedUnitPrice"): "Supplier quoted unit price for the bottle type on the purchase order.",
    ("receiptline","actualUnitPrice"): "Actual unit price paid/recorded for the bottle type on this receipt.",
    ("productprice","casePrice"): "Sale price for one case of the product during the effective date period.",
    ("orderline","agreedCasePrice"): "Case price agreed for the product when the customer order was placed.",
    ("pickerpack","supervisorId"): "Grape-farmer employee responsible for supervising the picking pack during the season.",
    ("vineyard","managerId"): "Current grape-farmer employee responsible for managing the vineyard.",
    ("shipment","addressId"): "Physical customer address actually used for the shipment after current-address validation.",
}


def humanise(name: str) -> str:
    return re.sub(r"(?<!^)(?=[A-Z])", " ", name).lower()


def purpose(row: dict) -> str:
    name = row["attributeName"]
    table = row["tableName"]
    if row["columnComment"]:
        return row["columnComment"]
    if (table,name) in context_purpose:
        return context_purpose[(table,name)]
    if name in special:
        return special[name]
    if name.endswith("Id"):
        if row["foreignReference"]:
            related = row['foreignReference'].split('.')[0]
            return f"References the related {related} record required for this {table} fact."
        return f"Stable business identifier for a {table} record."
    if name == "startDateTime":
        return f"Inclusive start date/time of the {table} history period."
    if name == "endDateTime":
        return f"Optional end date/time of the {table} history period; NULL represents an open-ended period."
    if name == "effectiveDate":
        return f"Date on which the {table} value becomes effective."
    if name == "endDate":
        return f"Optional final effective date for the {table} value; NULL represents an open-ended period."
    if name.endswith("Date"):
        return f"Business date associated with the {humanise(table)} event or validity period."
    if name.startswith("is") or name.endswith("Flag"):
        return f"TRUE/FALSE business indicator for {humanise(name)}."
    if name.endswith("Name"):
        return f"Human-readable business name of the {humanise(table)}."
    if name.endswith("Description"):
        return f"Business description used to explain the {humanise(table)}."
    if "Quantity" in name:
        return f"Quantity recorded for the {humanise(table)} transaction or inventory fact."
    if "Price" in name or "Cost" in name or "Amount" in name:
        return f"Monetary amount recorded for the {humanise(table)} fact in Australian dollars."
    return f"Records {humanise(name)} required for the {humanise(table)} business record."


def domain(row: dict) -> str:
    dtype = row["dataType"].lower()
    name = row["attributeName"]
    table = row["tableName"]
    default = row["defaultValue"]
    suffix = f"; default {default}" if default else ""

    if dtype.startswith("enum("):
        return "Permitted values: " + ", ".join(re.findall(r"'([^']+)'", dtype)) + "."
    if dtype == "tinyint(1)":
        return "TRUE/FALSE" + suffix + "."
    if name == "taxFileNumber": return "Exactly 9 numeric digits."
    if name == "australianBusinessNumber": return "Exactly 11 numeric digits."
    if name == "postcode": return "Exactly 4 numeric digits."
    if name == "capacityMl": return "Positive whole-number millilitres (> 0)."
    if name == "inventoryQuantity": return "Non-negative whole-number bottle quantity (>= 0)."
    if name == "caseQuantity":
        return "Positive whole-number bottles per case (> 0)." if table=="wineproduct" else "Positive whole-number case quantity (> 0)."
    if name == "agingDays": return "Unsigned whole-number days (>= 0)."
    if name in {"orderedQuantity","receivedQuantity"}: return "Positive whole-number quantity (> 0)."
    if name == "ratingValue": return "Integer from 1 to 5 inclusive."
    if name == "areaHectares": return "Positive decimal hectares (> 0)."
    if name == "latitude": return "Decimal latitude from -90 to 90 inclusive."
    if name == "longitude": return "Decimal longitude from -180 to 180 inclusive."
    if name == "alcoholPercent": return "Percentage greater than 0 and no more than 25."
    if name == "ripenessSugarPercent": return "Percentage from 0 to 100 inclusive."
    if name in {"juiceConversionPercent","proportionPercent"}: return "Percentage greater than 0 and no more than 100."
    if name == "regularHours": return "Hours greater than 0 and no more than 16; combined regular plus overtime hours no more than 18."
    if name == "overtimeHours": return "Non-negative hours; combined regular plus overtime hours no more than 18."
    if name in {"totalLostHours","usualUnitCost","quotedUnitPrice","actualUnitPrice","refundAmount"}: return "Non-negative numeric value."
    if name in {"weightKg","casePrice","agreedCasePrice"}: return "Positive numeric value."
    if name == "endDateTime": return "NULL/open-ended or a value not earlier than the corresponding startDateTime."
    if name == "endDate": return "NULL/open-ended or a value not earlier than the corresponding start/effective date."
    if dtype.startswith(("char(","varchar(")):
        return f"Text within the implemented {dtype} length" + suffix + "."
    if dtype in {"date","datetime","time","year"}:
        return f"Valid MySQL {dtype} value" + suffix + "."
    if "unsigned" in dtype and "int" in dtype:
        return "Non-negative whole number within the implemented unsigned MySQL type" + suffix + "."
    if "int" in dtype:
        return "Whole number within the implemented MySQL type" + suffix + "."
    if "decimal" in dtype:
        return "Decimal value within the implemented precision/scale" + suffix + "."
    return dtype + suffix + "."


for row in rows:
    row["domain"] = domain(row)
    row["purpose"] = purpose(row)

out_dir = ROOT / "docs/report"
csv_path = out_dir / "data-dictionary.csv"
md_path = out_dir / "data-dictionary.md"
fields = ["tableName","attributeName","dataType","domain","nullable","isUnique","isPrimary","foreignReference","purpose"]
with csv_path.open("w", newline="", encoding="utf-8-sig") as f:
    writer = csv.DictWriter(f, fieldnames=fields, lineterminator="\n")
    writer.writeheader()
    writer.writerows({k: r[k] for k in fields} for r in rows)

grouped: dict[str, list[dict]] = {}
for row in rows:
    grouped.setdefault(row["tableName"], []).append(row)

lines = [
    "# Cloudrest Wines Data Dictionary", "",
    "The data dictionary was prepared as Word-ready tables and cross-checked against the implemented MySQL schema for consistency. Automation is used internally to prevent schema drift. `Unique = Y` means the attribute is individually unique; membership in a composite primary/unique key does not make each component individually unique.", ""
]
for table, table_rows in grouped.items():
    lines += [f"## `{table}`", "", "| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |", "|---|---|---|:---:|:---:|:---:|---|---|"]
    for r in table_rows:
        values = [r["attributeName"], r["dataType"], r["domain"], r["nullable"], r["isUnique"], r["isPrimary"], r["foreignReference"] or "—", r["purpose"]]
        values = [str(v).replace("|", "\\|").replace("\n", " ") for v in values]
        lines.append("| " + " | ".join(values) + " |")
    lines.append("")
md_path.write_text("\n".join(lines), encoding="utf-8")
print(f"Generated {len(rows)} attributes across {len(grouped)} tables")
