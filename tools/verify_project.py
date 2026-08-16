"""Full reproducibility and logic audit for Cloudrest Wines."""
from __future__ import annotations
import json, re, subprocess
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MYSQL = "/opt/homebrew/opt/mysql@8.4/bin/mysql"
FINAL_SQL = ROOT / "deliverables/final-submission/Cloudrest_Wines_Database.sql"
OUT = ROOT / "verification"
OUT.mkdir(exist_ok=True)
checks=[]

def record(name, passed, evidence, severity="required"):
    checks.append({"check":name,"passed":bool(passed),"severity":severity,"evidence":str(evidence)})

def run_file(path, table=False):
    cmd=[MYSQL,"-u","root"]
    if table: cmd.append("--table")
    return subprocess.run(cmd, input=Path(path).read_text(encoding="utf-8"), text=True, capture_output=True)

def scalar(sql):
    r=subprocess.run([MYSQL,"-u","root","--batch","--skip-column-names","-e",sql],text=True,capture_output=True)
    if r.returncode: raise RuntimeError(r.stderr)
    return r.stdout.strip()

# Clean portable build.
build=run_file(FINAL_SQL)
record("Portable SQL rebuilds from empty database", build.returncode==0, build.stderr or "exitCode=0")

metrics={
 "base tables":("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='cloudrestwines' AND table_type='BASE TABLE'",53),
 "views":("SELECT COUNT(*) FROM information_schema.views WHERE table_schema='cloudrestwines'",1),
 "triggers":("SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_schema='cloudrestwines'",11),
 "routines":("SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema='cloudrestwines'",1),
 "columns":("SELECT COUNT(*) FROM information_schema.columns WHERE table_schema='cloudrestwines'",274),
 "foreign keys":("SELECT COUNT(*) FROM information_schema.referential_constraints WHERE constraint_schema='cloudrestwines'",69),
 "check constraints":("SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema='cloudrestwines' AND constraint_type='CHECK'",47),
}
for label,(sql,expected) in metrics.items():
    actual=int(scalar(sql))
    record(f"Expected {label}",actual==expected,f"expected={expected}, actual={actual}")

# Naming rules.
tables=scalar("SELECT table_name FROM information_schema.tables WHERE table_schema='cloudrestwines' AND table_type='BASE TABLE' ORDER BY table_name").splitlines()
bad_tables=[t for t in tables if not re.fullmatch(r"[a-z][a-z0-9]*",t)]
record("Table names are lowercase without spaces/underscores",not bad_tables,bad_tables or "53 compliant names")
cols=scalar("SELECT column_name FROM information_schema.columns WHERE table_schema='cloudrestwines'").splitlines()
bad_cols=[c for c in cols if not re.fullmatch(r"[a-z][A-Za-z0-9]*",c)]
record("Attributes use lowerCamelCase-compatible names",not bad_cols,bad_cols or "274 compliant names")

missing_pk=scalar("""SELECT t.table_name FROM information_schema.tables t LEFT JOIN information_schema.table_constraints c ON c.constraint_schema=t.table_schema AND c.table_name=t.table_name AND c.constraint_type='PRIMARY KEY' WHERE t.table_schema='cloudrestwines' AND t.table_type='BASE TABLE' AND c.constraint_name IS NULL""").splitlines()
record("Every base table has a primary key",not missing_pk,missing_pk or "all 53 tables")

# Data invariants.
invariants={
 "No picking pack has fewer than four active members":"SELECT COUNT(*) FROM (SELECT p.pickerPackId FROM cloudrestwines.pickerpack p LEFT JOIN cloudrestwines.packmember pm ON pm.pickerPackId=p.pickerPackId AND pm.leftDate IS NULL GROUP BY p.pickerPackId HAVING COUNT(pm.employeeId)<4) x",
 "All wine compositions total 100 percent":"SELECT COUNT(*) FROM (SELECT wineId FROM cloudrestwines.winecomposition GROUP BY wineId HAVING ABS(SUM(proportionPercent)-100)>0.001) x",
 "No employee has multiple active role rows":"SELECT COUNT(*) FROM (SELECT employeeId FROM cloudrestwines.employeerole WHERE endDateTime IS NULL GROUP BY employeeId HAVING COUNT(*)>1) x",
 "No employee has multiple active supervisors":"SELECT COUNT(*) FROM (SELECT employeeId FROM cloudrestwines.supervision WHERE endDateTime IS NULL GROUP BY employeeId HAVING COUNT(*)>1) x",
 "Completed training has completion and competency":"SELECT COUNT(*) FROM cloudrestwines.trainingattendance WHERE attendanceStatus='COMPLETED' AND (completionDate IS NULL OR competencyLevel IS NULL)",
 "No non-reorder bottle lacks a comment":"SELECT COUNT(*) FROM cloudrestwines.bottletype WHERE reorderFlag=FALSE AND NULLIF(TRIM(reorderComment),'') IS NULL",
 "No shipment uses a postal address":"SELECT COUNT(*) FROM cloudrestwines.shipment s JOIN cloudrestwines.address a ON a.addressId=s.addressId WHERE a.addressKind<>'PHYSICAL' OR a.postalType IN ('POBOX','PRIVATEBAG')",
 "No shipped order is unpaid":"SELECT COUNT(*) FROM cloudrestwines.customerorder WHERE orderStatus='SHIPPED' AND paidFlag=FALSE",
}
for name,sql in invariants.items():
    count=int(scalar(sql))
    record(name,count==0,f"violations={count}")

# Six query scripts execute and return visible output.
for path in sorted((ROOT/"database/queries").glob("0*.sql")):
    result=run_file(path)
    record(f"Query script executes: {path.name}",result.returncode==0 and bool(result.stdout.strip()),f"exitCode={result.returncode}, outputChars={len(result.stdout)}; {result.stderr.strip()}")

# Test suite: reset baseline before each isolated script.
expectations={
 "t01_validtraining.sql":(0,"PASS"),
 "t02_invalidroledate.sql":(1,"chk_employeerole_dates"),
 "t03_missingreordercomment.sql":(1,"chk_bottletype_reorder"),
 "t04_underagecustomer.sql":(1,"Individual customer must be at least 18 years old"),
 "t05_postalshipment.sql":(1,"Shipment address must be a physical address"),
 "t06_invalidconversionpercentage.sql":(1,"chk_grapevariety_conversion"),
}
for filename,(expected_code,needle) in expectations.items():
    run_file(FINAL_SQL)
    result=run_file(ROOT/"database/tests"/filename)
    combined=result.stdout+result.stderr
    record(f"Integrity test behaves as expected: {filename}",result.returncode==expected_code and needle in combined,f"exitCode={result.returncode}, expectedNeedle={needle}, output={combined.strip()[:500]}")

# Restore clean baseline after destructive/negative tests.
run_file(FINAL_SQL)

required_failures=[c for c in checks if c["severity"]=="required" and not c["passed"]]
summary={
 "generatedAt":datetime.now().isoformat(timespec="seconds"),
 "mysqlVersion":scalar("SELECT VERSION()"),
 "totalChecks":len(checks),
 "passed":sum(c["passed"] for c in checks),
 "failed":len(required_failures),
 "status":"PASS" if not required_failures else "FAIL",
 "checks":checks,
 "externalDependencies":[
  "Official A2 spreadsheet is not supplied; actual cleaning evidence remains pending.",
  "Week 11 business scenario is not supplied.",
  "Final Workbench screenshots, four-person video, genuine prompt logs and peer reviews require student action."
 ]
}
(OUT/"verification-report.json").write_text(json.dumps(summary,indent=2),encoding="utf-8")
lines=["# Cloudrest Wines Independent Verification Report","",f"- Status: **{summary['status']}**",f"- MySQL: `{summary['mysqlVersion']}`",f"- Checks: {summary['passed']}/{summary['totalChecks']} passed",f"- Generated: {summary['generatedAt']}","","## Check results","","| Result | Check | Evidence |","|:---:|---|---|"]
for c in checks:
    ev=c['evidence'].replace('|','\\|').replace('\n',' ')[:600]
    lines.append(f"| {'PASS' if c['passed'] else 'FAIL'} | {c['check']} | {ev} |")
lines += ["","## External dependencies / honest limitations",""] + [f"- {x}" for x in summary["externalDependencies"]]
(OUT/"verification-report.md").write_text("\n".join(lines)+"\n",encoding="utf-8")
print(json.dumps({k:summary[k] for k in ['status','totalChecks','passed','failed','mysqlVersion']},indent=2))
raise SystemExit(0 if not required_failures else 1)
