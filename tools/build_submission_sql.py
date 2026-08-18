"""Build portable SQL deliverables from authoritative source scripts."""
import json, os
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "deliverables" / "final-submission"
OUT.mkdir(parents=True, exist_ok=True)
FINAL_MODE = os.getenv("FINAL_MODE", "0") == "1"
FINAL_INPUTS = ROOT / "project-management" / "final-inputs.json"

member4 = "Jason"
if FINAL_MODE:
    if not FINAL_INPUTS.exists():
        raise RuntimeError("FINAL_MODE requires project-management/final-inputs.json")
    final_data = json.loads(FINAL_INPUTS.read_text(encoding="utf-8"))
    member4 = str(final_data.get("member4Name", "")).strip()
    if not member4 or member4 == "1":
        raise RuntimeError("FINAL_MODE requires the real fourth member name")

parts = [
    ROOT / "database/schema/01_tables.sql",
    ROOT / "database/schema/02_triggers.sql",
    ROOT / "database/schema/03_reporting.sql",
    ROOT / "database/schema/04_final_controls.sql",
    ROOT / "database/schema/05_validation_routines.sql",
    ROOT / "database/data/01_testdata.sql",
    ROOT / "database/data/02_manual_audit_patch.sql",
]
query_parts = [ROOT / f"database/queries/0{i}_{name}.sql" for i, name in [
    (1,"trainingcoverage"),(2,"incidentrate"),(3,"trainingimpact"),
    (4,"overtimerisk"),(5,"expiringqualification"),(6,"openactions")]]
header = f"""-- Cloudrest Wines Database — portable MySQL 8.x build
-- Team: Mia, Zora, Rianna, {member4}
-- Perspective: Human Resources, Workforce Planning and Wellbeing
-- Open this file in MySQL Workbench and execute the full script.
-- All data is fictitious and intended only for assessment/testing.

"""
body = [header]
for part in parts:
    body.append(f"\n-- ===== BEGIN {part.relative_to(ROOT)} =====\n")
    body.append(part.read_text(encoding="utf-8").rstrip() + "\n")
    body.append(f"-- ===== END {part.relative_to(ROOT)} =====\n")

body.append("\n-- ===== SIX DECISION-SUPPORT QUERIES =====\n")
for part in query_parts:
    body.append(part.read_text(encoding="utf-8").rstrip() + "\n")

body.append("""
-- Import verification summary
SELECT COUNT(*) AS baseTableCount
FROM information_schema.tables
WHERE table_schema='cloudrestwines' AND table_type='BASE TABLE';
SELECT COUNT(*) AS viewCount
FROM information_schema.views WHERE table_schema='cloudrestwines';
SELECT COUNT(*) AS triggerCount
FROM information_schema.triggers WHERE trigger_schema='cloudrestwines';
SELECT COUNT(*) AS routineCount
FROM information_schema.routines WHERE routine_schema='cloudrestwines';
""")
(OUT / "Cloudrest_Wines_Database.sql").write_text("".join(body), encoding="utf-8")

qbody = ["-- Cloudrest Wines — six decision-support queries\n-- Execute each numbered section in MySQL Workbench for video/report evidence.\n\n"]
qbody.append((ROOT / "database/schema/03_reporting.sql").read_text(encoding="utf-8").rstrip() + "\n")
for part in query_parts:
    qbody.append(f"\n-- ===== QUERY {part.name[:2]}: {part.stem[3:]} =====\n")
    qbody.append(part.read_text(encoding="utf-8").rstrip() + "\n")
(OUT / "Cloudrest_Wines_Queries.sql").write_text("".join(qbody), encoding="utf-8")

tests = (ROOT / "database/tests/task3b_ruleviolations.sql").read_text(encoding="utf-8")
(OUT / "Cloudrest_Wines_Rule_Violations.sql").write_text(tests, encoding="utf-8")
print(OUT)
