"""CI verification for authoritative SQL/query/dictionary sources.

This intentionally excludes MySQL Workbench UML/layout and genuine student evidence.
Those remain manual blockers. It provides a current technical result even while the
final .mwb/ER/screenshots are pending.
"""
from __future__ import annotations
import json
import os
import subprocess
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
MYSQL=os.getenv('MYSQL_BIN','mysql')
ENV=os.environ.copy()
checks=[]


def record(name,passed,evidence=''):
    checks.append({'check':name,'passed':bool(passed),'evidence':str(evidence)[:800]})


def cmd(args, **kwargs):
    return subprocess.run(args,text=True,capture_output=True,env=ENV,**kwargs)


def mysql_file(path):
    return subprocess.run([MYSQL,'-u','root'],input=Path(path).read_text(encoding='utf-8'),text=True,capture_output=True,env=ENV)


# Build current portable text artifacts.
r=cmd(['python3',str(ROOT/'tools/build_submission_sql.py')])
record('Submission SQL builder succeeds',r.returncode==0,r.stdout+r.stderr)
if r.returncode:
    raise SystemExit(1)

final_sql=ROOT/'deliverables/final-submission/Cloudrest_Wines_Database.sql'
r=mysql_file(final_sql)
record('Portable SQL clean-build succeeds',r.returncode==0,r.stderr)
if r.returncode:
    print(json.dumps(checks,indent=2)); raise SystemExit(1)

# Regenerate dictionary from the live schema.
r=cmd(['python3',str(ROOT/'tools/generate_data_dictionary.py')])
record('Data Dictionary regeneration succeeds',r.returncode==0,r.stdout+r.stderr)

# Six query source files must all execute on the clean fixture.
for path in sorted((ROOT/'database/queries').glob('0*.sql')):
    r=mysql_file(path)
    record(f'Query executes: {path.name}',r.returncode==0 and bool(r.stdout.strip()),r.stdout+r.stderr)

# Five assessed Task 6 tests: one valid + four expected failures.
assessed={
 't01_validtraining.sql':(0,'PASS'),
 't02_invalidroledate.sql':(1,'chk_employeerole_dates'),
 't03_missingreordercomment.sql':(1,'chk_bottletype_reorder'),
 't04_unpaidshipment.sql':(1,'Order must be paid before shipment'),
 't05_overlappingsupervision.sql':(1,'already has a supervisor'),
}
for filename,(expected_code,needle) in assessed.items():
    # Reset baseline before each isolated assessed test.
    base=mysql_file(final_sql)
    if base.returncode:
        record(f'Baseline reset before {filename}',False,base.stderr); continue
    r=mysql_file(ROOT/'database/tests'/filename)
    text=r.stdout+r.stderr
    record(f'Assessed integrity test: {filename}',r.returncode==expected_code and needle in text,text)

# Five assessed Task 3b business rules. Rule 3 has its own violation file.
rule_tests={
 'Rule 1 role dates':('t02_invalidroledate.sql','chk_employeerole_dates'),
 'Rule 2 reorder comment':('t03_missingreordercomment.sql','chk_bottletype_reorder'),
 'Rule 3 physical shipment':('additional_postalshipment.sql','Shipment address must be a physical address'),
 'Rule 4 paid shipment':('t04_unpaidshipment.sql','Order must be paid before shipment'),
 'Rule 5 one supervisor':('t05_overlappingsupervision.sql','already has a supervisor'),
}
for name,(filename,needle) in rule_tests.items():
    base=mysql_file(final_sql)
    if base.returncode:
        record(name,False,base.stderr); continue
    r=mysql_file(ROOT/'database/tests'/filename)
    text=r.stdout+r.stderr
    record(name,r.returncode!=0 and needle in text,text)

# Reset one last time and run the second-layer manual-audit verifier.
base=mysql_file(final_sql)
record('Baseline reset before manual-audit verifier',base.returncode==0,base.stderr)
r=cmd(['python3',str(ROOT/'tools/verify_manual_audit_controls.py')])
record('Manual-audit control verifier passes',r.returncode==0,r.stdout+r.stderr)

passed=sum(c['passed'] for c in checks)
summary={'status':'PASS' if passed==len(checks) else 'FAIL','passed':passed,'total':len(checks),'checks':checks,
         'manualBlockers':['Final MySQL Workbench UML notation and landscape ER export','Official A2 workbook cleaning evidence','Week 11 scenario','Genuine student Workbench screenshots','Four-person video','Genuine RiPPlE work','Real fourth member/student numbers/dates/contributions']}
out=ROOT/'verification/ci-source-verification.json'
out.write_text(json.dumps(summary,indent=2),encoding='utf-8')
print(json.dumps({'status':summary['status'],'passed':passed,'total':len(checks)},indent=2))
raise SystemExit(0 if summary['status']=='PASS' else 1)
