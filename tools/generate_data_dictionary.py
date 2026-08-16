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
        if not line:
            continue
        rows.append(json.loads(line))
    return rows

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
   SELECT 1 FROM information_schema.STATISTICS s
   WHERE s.TABLE_SCHEMA=c.TABLE_SCHEMA AND s.TABLE_NAME=c.TABLE_NAME
     AND s.COLUMN_NAME=c.COLUMN_NAME AND s.NON_UNIQUE=0), 'Y','N'),
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
    "taxFileNumber": "Australian tax file number; sensitive HR identifier.",
    "dateOfBirth": "Birth date retained to demonstrate an individual customer's legal age.",
    "australianBusinessNumber": "Eleven-digit ABN identifying an Australian business customer.",
    "confidentialNote": "Restricted wellbeing note; excluded from routine management reporting.",
    "juiceConversionPercent": "Expected percentage of grape weight converted to juice.",
    "ripenessSugarPercent": "Harvest ripeness expressed as percentage sugar.",
    "proportionPercent": "Percentage contribution of a grape variety to a wine composition.",
    "paidFlag": "Indicates accounting confirmation that shipment may proceed.",
    "reorderFlag": "Indicates whether this bottle type may be reordered.",
    "reorderComment": "Required explanation when a bottle type will not be reordered.",
    "regularHours": "Regular labour hours worked on the assigned shift.",
    "overtimeHours": "Overtime hours used in workload and safety analysis.",
    "totalLostHours": "Non-negative total labour hours lost because of an incident; may be zero for a serious near miss.",
    "employmentType": "Legal engagement category: permanent or casual.",
    "employmentPattern": "Indicates ongoing or seasonal work pattern independently of employment type.",
    "workTimeType": "Indicates whether the appointment is full-time or part-time.",
    "severity": "Classifies incident seriousness for safety follow-up and reporting.",
}

def humanise(name: str) -> str:
    return re.sub(r"(?<!^)(?=[A-Z])", " ", name).lower()

def purpose(row: dict) -> str:
    name = row["attributeName"]
    table = row["tableName"]
    if row["columnComment"]:
        return row["columnComment"]
    if name in special:
        return special[name]
    if name.endswith("Id"):
        if row["foreignReference"]:
            return f"Identifies the related {row['foreignReference'].split('.')[0]} record."
        return f"Stable identifier for a {table} record."
    if name == "startDateTime":
        return f"Inclusive start date/time of the {table} history period."
    if name == "endDateTime":
        return f"Optional end date/time of the {table} history period; NULL identifies the current row."
    if name.endswith("Date"):
        return f"Date associated with the {table} record or validity period."
    if name.startswith("is") or name.endswith("Flag"):
        return f"TRUE/FALSE indicator for {humanise(name)} on the {humanise(table)} record."
    if name.endswith("Name"):
        return f"Human-readable name used for the {table} record."
    if name.endswith("Description"):
        return f"Business description of the {table} record."
    if "Quantity" in name:
        return f"Quantity recorded for the {table} transaction or inventory fact."
    if "Price" in name or "Cost" in name or "Amount" in name:
        return f"Monetary value recorded for the {table} fact in Australian dollars."
    return f"Records the {humanise(name)} of the {humanise(table)}."

def domain(row: dict) -> str:
    dtype = row["dataType"].lower()
    name = row["attributeName"]
    default = row["defaultValue"]
    if dtype.startswith("enum("):
        return "Permitted values: " + ", ".join(re.findall(r"'([^']+)'", dtype)) + "."
    if dtype == "tinyint(1)":
        return "TRUE/FALSE" + (f"; default {default}" if default else "") + "."
    if name == "taxFileNumber": return "Exactly 9 numeric digits."
    if name == "australianBusinessNumber": return "Exactly 11 numeric digits."
    if name == "postcode": return "Exactly 4 numeric digits."
    if "Percent" in name or name == "alcoholPercent": return "Numeric percentage greater than 0 and no more than 100, except alcohol is capped at 25 as implemented."
    if name in {"regularHours","overtimeHours","totalLostHours","usualUnitCost","quotedUnitPrice","actualUnitPrice","refundAmount"}: return "Non-negative numeric value."
    if name in {"weightKg","casePrice"} or "Quantity" in name: return "Positive numeric value."
    if name == "areaHectares": return "Positive decimal hectares."
    if name == "latitude": return "Decimal latitude from -90 to 90."
    if name == "longitude": return "Decimal longitude from -180 to 180."
    if name == "ratingValue": return "Integer from 1 to 5."
    if name == "endDateTime": return "NULL for current, otherwise not earlier than startDateTime."
    if name == "endDate": return "NULL for current, otherwise not earlier than the corresponding start/effective date."
    if dtype.startswith(("char(","varchar(")): return f"Text up to the implemented {dtype} size" + (f"; default {default}" if default else "") + "."
    if dtype in {"date","datetime","time","year"}: return f"Valid MySQL {dtype} value" + (f"; default {default}" if default else "") + "."
    if "int" in dtype or "decimal" in dtype: return "Numeric value within the implemented MySQL type" + (f"; default {default}" if default else "") + "."
    return dtype + (f"; default {default}" if default else "") + "."

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

lines = ["# Cloudrest Wines Data Dictionary", "", "The data dictionary was prepared as Word-ready tables and cross-checked against the implemented MySQL schema for consistency. Automation is used internally to prevent schema drift.", ""]
for table, table_rows in grouped.items():
    lines += [f"## `{table}`", "", "| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |", "|---|---|---|:---:|:---:|:---:|---|---|"]
    for r in table_rows:
        values = [r["attributeName"], r["dataType"], r["domain"], r["nullable"], r["isUnique"], r["isPrimary"], r["foreignReference"] or "—", r["purpose"]]
        values = [str(v).replace("|", "\\|").replace("\n", " ") for v in values]
        lines.append("| " + " | ".join(values) + " |")
    lines.append("")
md_path.write_text("\n".join(lines), encoding="utf-8")
print(f"Generated {len(rows)} attributes across {len(grouped)} tables")
