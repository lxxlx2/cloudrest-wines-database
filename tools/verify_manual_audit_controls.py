"""Verify controls added by the final manual-audit pass after local regeneration.

Run only after:
1. python3 tools/build_submission_sql.py
2. clean import of Cloudrest_Wines_Database.sql into MySQL 8.4
3. python3 tools/generate_data_dictionary.py

This verifier deliberately fails when generated artifacts are still stale.
"""
from __future__ import annotations
import csv
import json
import os
import subprocess
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
MYSQL=os.getenv('MYSQL_BIN','/opt/homebrew/opt/mysql@8.4/bin/mysql')
OUT=ROOT/'verification'
FINAL_SQL=ROOT/'deliverables/final-submission/Cloudrest_Wines_Database.sql'
checks=[]


def record(name, passed, evidence):
    checks.append({'check':name,'passed':bool(passed),'evidence':str(evidence)})


def run_sql(sql):
    return subprocess.run([MYSQL,'-u','root'],input=sql,text=True,capture_output=True)


def run_file(path):
    return run_sql(Path(path).read_text(encoding='utf-8'))


def scalar(sql):
    result=subprocess.run([MYSQL,'-u','root','--batch','--skip-column-names','-e',sql],text=True,capture_output=True)
    if result.returncode:
        raise RuntimeError(result.stderr)
    return result.stdout.strip()


# Generated package must have been rebuilt after the source pass.
dbtext=FINAL_SQL.read_text(encoding='utf-8') if FINAL_SQL.exists() else ''
record('Portable SQL contains final control source','BEGIN database/schema/04_final_controls.sql' in dbtext,'04_final_controls embedded')
record('Portable SQL contains picking-pack data alignment','BEGIN database/data/02_manual_audit_patch.sql' in dbtext,'02_manual_audit_patch embedded')

# Live schema must reflect the regenerated sources.
trigger_count=int(scalar("SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_schema='cloudrestwines'"))
routine_count=int(scalar("SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema='cloudrestwines'"))
record('Expanded trigger set installed',trigger_count>=43,f'triggers={trigger_count}')
record('Validation routines installed',routine_count>=4,f'routines={routine_count}')

expected_controls=[
 'trg_employeeaddress_samekind_insert','trg_customeraddress_samekind_insert',
 'trg_customerorder_subtype_insert','trg_wineproduct_composition_insert',
 'trg_vineyard_business_insert','trg_shipment_order_complete_insert',
 'trg_customerorder_shipped_state','trg_receipt_chronology_insert'
]
live_triggers=set(scalar("SELECT trigger_name FROM information_schema.triggers WHERE trigger_schema='cloudrestwines'").splitlines())
record('Named manual-audit triggers installed',all(x in live_triggers for x in expected_controls),sorted(live_triggers))

# Baseline data should pass deferred pack validation after the supervisor patch.
baseline=run_sql('USE cloudrestwines; CALL validatePickingPackRules();')
record('Baseline picking pack passes validation',baseline.returncode==0,baseline.stderr or 'PASS')
pack_supervisor=scalar("SELECT supervisorId FROM cloudrestwines.pickerpack WHERE pickerPackId='PACK001'")
record('Synthetic pack uses grape-farmer supervisor',pack_supervisor=='EMP0003',pack_supervisor)

# Additional negative/positive controls. Every failing script is isolated in its own
# connection so an uncommitted transaction is rolled back on disconnect.
fail_tests={
 'Employee same-kind address overlap':'additional_employee_address_overlap.sql',
 'Customer same-kind address overlap':'additional_customer_address_overlap.sql',
 'Pack fewer than four members':'additional_pack_minimum.sql',
 'Incomplete wine composition release':'additional_winecomposition_incomplete.sql',
 'Order without lines cannot ship':'additional_order_requires_line.sql',
 'Customer missing subtype cannot order':'additional_customer_missing_subtype_order.sql',
 'Customer subtype mismatch':'additional_customer_subtype_mismatch.sql',
 'Unordered bottle receipt':'additional_receipt_unordered_bottle.sql',
 'Employee duplicate primary phone':'additional_employee_duplicate_primary.sql',
 'Customer duplicate primary phone':'additional_customer_duplicate_primary.sql',
 'Future customer address cannot ship':'additional_future_shipment_address.sql',
 'Product-price period overlap':'additional_productprice_overlap.sql',
 'Supplier same-type address overlap':'additional_supplier_physical_overlap.sql',
}
for name,filename in fail_tests.items():
    result=run_file(ROOT/'database/tests'/filename)
    record(name,result.returncode!=0,(result.stdout+result.stderr).strip()[:500])

positive=run_file(ROOT/'database/tests/additional_supplier_postal_coexist.sql')
record('Supplier physical and postal addresses may coexist',positive.returncode==0,(positive.stdout+positive.stderr).strip()[:500] or 'PASS')

# Query semantics and hand reconciliation.
rate=scalar("""
WITH h AS (
 SELECT SUM(sa.regularHours+sa.overtimeHours) labourHours
 FROM cloudrestwines.shift s JOIN cloudrestwines.shiftassignment sa ON sa.shiftId=s.shiftId
 WHERE s.operationalAreaId='AREA01' AND s.shiftDate>=DATE_SUB(CURRENT_DATE,INTERVAL 12 MONTH)
), i AS (
 SELECT COUNT(*) incidentCount FROM cloudrestwines.incident
 WHERE operationalAreaId='AREA01' AND incidentDateTime>=DATE_SUB(CURRENT_DATE,INTERVAL 12 MONTH)
)
SELECT CONCAT((SELECT labourHours FROM h),'|',(SELECT incidentCount FROM i),'|',ROUND((SELECT incidentCount FROM i)*1000.0/(SELECT labourHours FROM h),2));
""")
record('Q2 Vineyard hand reconciliation is 88 hours, 2 incidents, 22.73','88.00|2|22.73' in rate or '88|2|22.73' in rate,rate)
q2=(ROOT/'database/queries/02_incidentrate.sql').read_text(encoding='utf-8')
record('Q2 starts from operationalarea and preserves zero-hour areas','FROM operationalarea oa' in q2 and 'WHEN COALESCE(h.labourHours,0)=0 THEN NULL' in q2,'operational-area driving set + NULL denominator')
q3=(ROOT/'database/queries/03_trainingimpact.sql').read_text(encoding='utf-8')
record('Q3 uses latest safety completion','MAX(ta.completionDate)' in q3 and 'MIN(ta.completionDate)' not in q3,'MAX completionDate')
q4=(ROOT/'database/queries/04_overtimerisk.sql').read_text(encoding='utf-8')
record('Q4 has no arbitrary weighted risk score','* 5' not in q4 and 'overtimeHours >= 4' not in q4,'transparent rule-based ordering')

# Dictionary semantics. This assumes generate_data_dictionary.py was rerun against
# the current live schema.
dict_csv=ROOT/'docs/report/data-dictionary.csv'
rows=list(csv.DictReader(dict_csv.open(encoding='utf-8-sig')))
by={(r['tableName'],r['attributeName']):r for r in rows}
composite_samples=[('customeraddress','customerId'),('customeraddress','addressId'),('customeraddress','startDateTime'),('employeeaddress','employeeId'),('checkintopic','checkinId')]
record('Composite-key members are not falsely marked individually unique',all(by.get(k,{}).get('isUnique')=='N' for k in composite_samples),[(k,by.get(k,{}).get('isUnique')) for k in composite_samples])
record('Bottle capacity domain states positive range','Positive' in by.get(('bottletype','capacityMl'),{}).get('domain',''),by.get(('bottletype','capacityMl'),{}).get('domain',''))

# Report/final-input source checks.
builder=(ROOT/'tools/build_word_reports.py').read_text(encoding='utf-8')
record('Task 1 no longer hard-codes placeholder member roles',all(x not in builder for x in ["'1 / Zora'","'Zora / 1'","'1 / Mia'","'1 / Rianna'","'Rianna / 1'"]),'member4 variable used')
record('Final cover supports student numbers','studentNumbers' in builder and "('Student numbers'" in builder,'student number source/output')
record('Appendix final status is conditional','Completed from genuine final inputs' in builder,'FINAL_MODE-aware appendix')

passed=sum(c['passed'] for c in checks)
summary={'status':'PASS' if passed==len(checks) else 'FAIL','passed':passed,'total':len(checks),'checks':checks}
(OUT/'manual-audit-verification.json').write_text(json.dumps(summary,indent=2),encoding='utf-8')
lines=['# Manual-Audit Verification','',f"- Status: **{summary['status']}**",f"- Checks: {passed}/{len(checks)}",'', '| Result | Check | Evidence |','|:---:|---|---|']
for c in checks:
    lines.append(f"| {'PASS' if c['passed'] else 'FAIL'} | {c['check']} | {c['evidence'].replace('|','/').replace(chr(10),' ')[:500]} |")
(OUT/'manual-audit-verification.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
print(json.dumps({'status':summary['status'],'passed':passed,'total':len(checks),'triggers':trigger_count,'routines':routine_count},indent=2))
raise SystemExit(0 if summary['status']=='PASS' else 1)
