"""Generate a schema-backed data dictionary in Markdown and CSV."""
from __future__ import annotations
import csv
import json
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
    "totalLostHours": "Total labour hours lost because of an incident.",
}

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
    if name.endswith("DateTime"):
        return f"Date and time associated with the {table} event or validity period."
    if name.endswith("Date"):
        return f"Date associated with the {table} record or validity period."
    if name.startswith("is") or name.endswith("Flag"):
        return f"Boolean control/indicator for {table}.{name}."
    if name.endswith("Name"):
        return f"Human-readable name used for the {table} record."
    if name.endswith("Description"):
        return f"Business description of the {table} record."
    if "Quantity" in name:
        return f"Quantity recorded for the {table} transaction or inventory fact."
    if "Price" in name or "Cost" in name or "Amount" in name:
        return f"Monetary value recorded for the {table} fact in Australian dollars."
    return f"Business attribute `{name}` for the `{table}` record."

for row in rows:
    row["domain"] = row["dataType"] if row["dataType"].startswith("enum(") else (row["defaultValue"] or "See schema constraints")
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

lines = ["# Cloudrest Wines Data Dictionary", "", "Generated from the validated MySQL 8.4 schema. Domain details and cross-row rules remain authoritative in the SQL build.", ""]
for table, table_rows in grouped.items():
    lines += [f"## `{table}`", "", "| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |", "|---|---|---|:---:|:---:|:---:|---|---|"]
    for r in table_rows:
        values = [r["attributeName"], r["dataType"], r["domain"], r["nullable"], r["isUnique"], r["isPrimary"], r["foreignReference"] or "—", r["purpose"]]
        values = [str(v).replace("|", "\\|").replace("\n", " ") for v in values]
        lines.append("| " + " | ".join(values) + " |")
    lines.append("")
md_path.write_text("\n".join(lines), encoding="utf-8")
print(f"Generated {len(rows)} attributes across {len(grouped)} tables")
