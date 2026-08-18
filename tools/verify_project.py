"""Reproducibility, assessment-content and development/final-mode audit."""
from __future__ import annotations
import html, json, os, re, subprocess, zipfile
from datetime import datetime
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
MYSQL=os.getenv('MYSQL_BIN','/opt/homebrew/opt/mysql@8.4/bin/mysql')
FINAL_SQL=ROOT/'deliverables/final-submission/Cloudrest_Wines_Database.sql'
QUERY_SQL=ROOT/'deliverables/final-submission/Cloudrest_Wines_Queries.sql'
OUT=ROOT/'verification'; OUT.mkdir(exist_ok=True)
FINAL_MODE=os.getenv('FINAL_MODE','0')=='1'
checks=[]
manual_requirements=[]


def record(name,passed,evidence,severity='required'):
    checks.append({'check':name,'passed':bool(passed),'severity':severity,'evidence':str(evidence)})


def manual(name,evidence):
    manual_requirements.append({'requirement':name,'evidence':str(evidence)})


def run_file(path):
    return subprocess.run([MYSQL,'-u','root'],input=Path(path).read_text(encoding='utf-8'),text=True,capture_output=True)


def scalar(sql):
    r=subprocess.run([MYSQL,'-u','root','--batch','--skip-column-names','-e',sql],text=True,capture_output=True)
    if r.returncode: raise RuntimeError(r.stderr)
    return r.stdout.strip()


def contains(path,*needles):
    text=Path(path).read_text(encoding='utf-8')
    return all(n in text for n in needles)


def docx_parts(path):
    if not path.exists(): return {},''
    with zipfile.ZipFile(path) as z:
        parts={name:z.read(name).decode('utf-8',errors='ignore') for name in z.namelist() if name.startswith('word/') and name.endswith('.xml')}
    visible=[]
    for xml in parts.values():
        visible.extend(html.unescape(x) for x in re.findall(r'<w:t[^>]*>(.*?)</w:t>',xml))
    return parts,' '.join(visible)


# Rebuild the submitted portable SQL exactly as a student would.
build=run_file(FINAL_SQL)
record('Portable SQL rebuilds from empty database',build.returncode==0,build.stderr or 'exitCode=0')

metric_sql={
 'baseTables':"SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='cloudrestwines' AND table_type='BASE TABLE'",
 'views':"SELECT COUNT(*) FROM information_schema.views WHERE table_schema='cloudrestwines'",
 'columns':"SELECT COUNT(*) FROM information_schema.columns WHERE table_schema='cloudrestwines'",
 'foreignKeys':"SELECT COUNT(*) FROM information_schema.referential_constraints WHERE constraint_schema='cloudrestwines'",
 'checkConstraints':"SELECT COUNT(*) FROM information_schema.table_constraints WHERE constraint_schema='cloudrestwines' AND constraint_type='CHECK'",
 'triggers':"SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_schema='cloudrestwines'",
 'routines':"SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema='cloudrestwines'",
}
metrics={k:int(scalar(v)) for k,v in metric_sql.items()}
record('Schema statistics collected dynamically',all(v>0 for v in metrics.values()),metrics)
tables=set(scalar("SELECT table_name FROM information_schema.tables WHERE table_schema='cloudrestwines' AND table_type='BASE TABLE'").splitlines())
record('supplieraddress exists','supplieraddress' in tables,'supplieraddress')
record('supplierphone exists','supplierphone' in tables,'supplierphone')
record('Supplier direct redundant contact columns removed',scalar("SELECT COUNT(*) FROM information_schema.columns WHERE table_schema='cloudrestwines' AND table_name='supplier' AND column_name IN ('addressId','phoneNumber')")=='0','supplier.addressId/phoneNumber absent')
role_type=scalar("SELECT column_type FROM information_schema.columns WHERE table_schema='cloudrestwines' AND table_name='employeerole' AND column_name='employmentType'")
pattern=scalar("SELECT column_type FROM information_schema.columns WHERE table_schema='cloudrestwines' AND table_name='employeerole' AND column_name='employmentPattern'")
record('Employment classification separates type and pattern',role_type=="enum('PERMANENT','CASUAL')" and pattern=="enum('ONGOING','SEASONAL')",f'{role_type}; {pattern}')
record('Seasonal pickers are CASUAL + SEASONAL',int(scalar("SELECT COUNT(*) FROM cloudrestwines.employeerole er JOIN cloudrestwines.role r ON r.roleId=er.roleId WHERE r.roleName='Seasonal Picker' AND (er.employmentType<>'CASUAL' OR er.employmentPattern<>'SEASONAL')"))==0,'violations=0')
schema_text=(ROOT/'database/schema/01_tables.sql').read_text(encoding='utf-8')
trigger_text=(ROOT/'database/schema/02_triggers.sql').read_text(encoding='utf-8')
record('Vineyard constraint is positive-only','CHECK (areaHectares > 0)' in schema_text and 'BETWEEN 2.00 AND 42.00' not in schema_text,'positive-only')
record('Severity does not require positive lost hours','chk_incident_severity' not in schema_text,'unsupported constraint absent')

invariants={
 'Every employee has one current physical address':"SELECT COUNT(*) FROM (SELECT e.employeeId FROM cloudrestwines.employee e LEFT JOIN cloudrestwines.employeeaddress ea ON ea.employeeId=e.employeeId AND ea.startDateTime<=NOW() AND (ea.endDateTime IS NULL OR ea.endDateTime>NOW()) LEFT JOIN cloudrestwines.address a ON a.addressId=ea.addressId AND a.addressKind='PHYSICAL' GROUP BY e.employeeId HAVING COUNT(a.addressId)<>1)x",
 'Every employee has exactly one current primary phone':"SELECT COUNT(*) FROM (SELECT e.employeeId FROM cloudrestwines.employee e LEFT JOIN cloudrestwines.employeephone ep ON ep.employeeId=e.employeeId AND ep.startDateTime<=NOW() AND (ep.endDateTime IS NULL OR ep.endDateTime>NOW()) AND ep.isPrimary=TRUE GROUP BY e.employeeId HAVING COUNT(ep.phoneId)<>1)x",
 'Supplier address history exists':"SELECT IF(COUNT(*)>=2,0,1) FROM cloudrestwines.supplieraddress WHERE supplierId='SUPP001'",
 'Supplier phone history exists':"SELECT IF(COUNT(*)>=2,0,1) FROM cloudrestwines.supplierphone WHERE supplierId='SUPP001'",
 'Employee role history example exists':"SELECT IF(COUNT(*)>=2,0,1) FROM cloudrestwines.employeerole WHERE employeeId='EMP0005'",
 'Supervisor history example exists':"SELECT IF(COUNT(*)>=2,0,1) FROM cloudrestwines.supervision WHERE employeeId='EMP0007'",
 'Employee address history example exists':"SELECT IF(COUNT(*)>=2,0,1) FROM cloudrestwines.employeeaddress WHERE employeeId='EMP0002'",
 'Employee phone history example exists':"SELECT IF(COUNT(*)>=2,0,1) FROM cloudrestwines.employeephone WHERE employeeId='EMP0002'",
 'No multiple current roles':"SELECT COUNT(*) FROM (SELECT employeeId FROM cloudrestwines.employeerole WHERE startDateTime<=NOW() AND (endDateTime IS NULL OR endDateTime>NOW()) GROUP BY employeeId HAVING COUNT(*)>1)x",
 'No multiple current supervisors':"SELECT COUNT(*) FROM (SELECT employeeId FROM cloudrestwines.supervision WHERE startDateTime<=NOW() AND (endDateTime IS NULL OR endDateTime>NOW()) GROUP BY employeeId HAVING COUNT(*)>1)x",
 'No invalid shipment address':"SELECT COUNT(*) FROM cloudrestwines.shipment s JOIN cloudrestwines.address a ON a.addressId=s.addressId WHERE a.addressKind<>'PHYSICAL' OR a.postalType IN ('POBOX','PRIVATEBAG')",
 'No shipped unpaid order':"SELECT COUNT(*) FROM cloudrestwines.customerorder WHERE orderStatus='SHIPPED' AND paidFlag=FALSE",
}
for name,sql in invariants.items():
    n=int(scalar(sql)); record(name,n==0,f'violations={n}')

# Six assessed management queries.
for path in sorted((ROOT/'database/queries').glob('0*.sql')):
    result=run_file(path)
    record(f'Query executes: {path.name}',result.returncode==0 and bool(result.stdout.strip()),f'exit={result.returncode}, chars={len(result.stdout)}, {result.stderr.strip()}')

# Five assessed integrity tests remain unchanged.
expectations={
 't01_validtraining.sql':(0,'PASS'),
 't02_invalidroledate.sql':(1,'chk_employeerole_dates'),
 't03_missingreordercomment.sql':(1,'chk_bottletype_reorder'),
 't04_unpaidshipment.sql':(1,'Order must be paid before shipment'),
 't05_overlappingsupervision.sql':(1,'already has a supervisor'),
}
for filename,(code,needle) in expectations.items():
    run_file(FINAL_SQL); result=run_file(ROOT/'database/tests'/filename); output=result.stdout+result.stderr
    record(f'Assessed integrity test: {filename}',result.returncode==code and needle in output,f'exit={result.returncode}; expected={needle}; {output.strip()[:400]}')

business_rules={
 'Rule 1 role dates':('t02_invalidroledate.sql','chk_employeerole_dates'),
 'Rule 2 reorder comment':('t03_missingreordercomment.sql','chk_bottletype_reorder'),
 'Rule 3 current physical address':('additional_postalshipment.sql','Shipment address must be a physical address'),
 'Rule 4 paid before shipment':('t04_unpaidshipment.sql','Order must be paid before shipment'),
 'Rule 5 one supervisor':('t05_overlappingsupervision.sql','already has a supervisor'),
}
for name,(filename,needle) in business_rules.items():
    run_file(FINAL_SQL); result=run_file(ROOT/'database/tests'/filename); output=result.stdout+result.stderr
    record(f'Assessed business rule: {name}',result.returncode==1 and needle in output,f'{filename}; {output.strip()[:350]}')

# Additional integrity controls found in the final manual audit.
additional={
 'Supplier physical and postal coexist':('additional_supplier_postal_coexist.sql',0,'PASS: supplier physical and postal addresses coexist'),
 'Supplier same-type address overlap rejected':('additional_supplier_physical_overlap.sql',1,'same type'),
 'Customer subtype mismatch rejected':('additional_customer_subtype_mismatch.sql',1,'subtype must match parent customerType'),
 'Unordered receipt bottle rejected':('additional_receipt_unordered_bottle.sql',1,'must exist on the related purchase order'),
 'Employee duplicate primary phone rejected':('additional_employee_duplicate_primary.sql',1,'only one primary phone'),
 'Customer duplicate primary phone rejected':('additional_customer_duplicate_primary.sql',1,'only one primary phone'),
 'Future-dated shipment address rejected':('additional_future_shipment_address.sql',1,'customer current address'),
 'Product price overlap rejected':('additional_productprice_overlap.sql',1,'overlaps an existing price period'),
}
for name,(filename,code,needle) in additional.items():
    run_file(FINAL_SQL); result=run_file(ROOT/'database/tests'/filename); output=result.stdout+result.stderr
    record(f'Additional integrity: {name}',result.returncode==code and needle in output,f'{filename}; exit={result.returncode}; {output.strip()[:350]}')
run_file(FINAL_SQL)

# Source-level content checks.
task2=(ROOT/'docs/report/task2-design-decisions.md').read_text(encoding='utf-8')
task3=(ROOT/'docs/report/task3-functionality-business-rules.md').read_text(encoding='utf-8')
task7=(ROOT/'docs/report/task7-queries.md').read_text(encoding='utf-8')
dictionary=(ROOT/'docs/report/data-dictionary.md').read_text(encoding='utf-8')
record('Project Plan requires Actual Completion Date',contains(ROOT/'project-management/project-plan.md','Actual Completion Date','AI Used / How Used'),'plan columns')
record('Task 2 has four decisions and page citations',len(re.findall(r'## Decision [1-4]',task2))==4 and 'pp. 3–4, “Customers”' in task2,'four decisions/corrected customer citation')
record('Task 2 within 1,200 words',len(task2.split())<=1200,f'words={len(task2.split())}')
record('Task 3 stakeholder table exists',all(x in task3 for x in ['Stakeholder','Need / risk','Community / public value']),'required stakeholder columns/rows')
record('Task 3 shipment citation corrected','pp. 3–4, “Customers” and “Addresses”' in task3,'rule 3 citation')
record('Five assessed Task 3b rules exist',len(re.findall(r'### Rule [1-5]',task3))==5,'rules=5')
record('Query 1 wording does not claim mandatory training','mandatory safety' not in (ROOT/'database/queries/01_trainingcoverage.sql').read_text(encoding='utf-8').lower(),'terminology aligned')
record('Query 3 filters AFFECTED involvement',contains(ROOT/'database/queries/03_trainingimpact.sql',"involvementRole = 'AFFECTED'"),'filter present')
record('Query 4 filters AFFECTED involvement',contains(ROOT/'database/queries/04_overtimerisk.sql',"involvementRole = 'AFFECTED'"),'filter present')
record('Supplier address trigger distinguishes address type','a.addressKind = vAddressKind' in trigger_text,'same-type overlap only')
record('Shipment current-address trigger rejects future start','startDateTime <= NOW()' in trigger_text and '(endDateTime IS NULL OR endDateTime > NOW())' in trigger_text,'current interval logic')
record('Customer subtype consistency triggers present',all(x in trigger_text for x in ['trg_individualcustomer_subtype_insert','trg_businesscustomer_subtype_insert','trg_customer_type_update']),'subtype controls')
record('Receipt-line purchase-order validation present','trg_receiptline_ordered_insert' in trigger_text,'receipt control')
record('Employee/customer primary-phone controls present',all(x in trigger_text for x in ['trg_employeephone_primary_insert','trg_customerphone_primary_insert']),'phone controls')
record('Product-price overlap control present','trg_productprice_nooverlap_insert' in trigger_text,'price history control')
record('Data Dictionary has explicit domains','See schema constraints' not in dictionary,'generic domain absent')
record('Data Dictionary has semantic descriptions','Business attribute' not in dictionary,'generic description absent')

qtext=QUERY_SQL.read_text(encoding='utf-8')
dbtext=FINAL_SQL.read_text(encoding='utf-8')
for label,needle in [('CREATE VIEW','CREATE VIEW openincidentaction'),('CREATE PROCEDURE','CREATE PROCEDURE getExpiringQualifications'),('30-day call','CALL getExpiringQualifications(30)'),('90-day call','CALL getExpiringQualifications(90)'),('EXPLAIN','EXPLAIN')]:
    record(f'Query submission contains {label}',needle in qtext,needle)
record('Query submission contains six queries',qtext.count('-- ===== QUERY')==6,'six query markers')
record('Database export contains six queries','SIX DECISION-SUPPORT QUERIES' in dbtext,'embedded query section')
record('Database export includes latest trigger controls','trg_productprice_nooverlap_insert' in dbtext and 'trg_customer_type_update' in dbtext,'regeneration check')
record('Query export includes latest Query 4 logic',"ie.involvementRole = 'AFFECTED'" in qtext,'regeneration check')

# ER and Word-document structural checks.
er=ROOT/'diagrams/Cloudrest_Wines_ER_Diagram.png'
try:
    from PIL import Image
    wh=Image.open(er).size
except Exception:
    wh=(0,0)
record('Full ER image meets minimum resolution',wh[0]>=3000 and wh[1]>=1800,f'resolution={wh}')
record('Full ER image is landscape',wh[0]>wh[1],f'resolution={wh}')
manual('UML relationship notation','Open final .mwb in MySQL Workbench, select Model → Relationship Notation → UML, save, and re-export. Workbench session default can revert to Crow\'s Foot.')

report_path=ROOT/'deliverables/final-submission/Cloudrest_Wines_Report.docx'
parts,report_visible=docx_parts(report_path)
document_xml=parts.get('word/document.xml','')
landscape_sections=len(re.findall(r'w:orient="landscape"',document_xml))
record('Word report contains genuine landscape sections',landscape_sections>=3,f'landscapeSections={landscape_sections}')
for heading in ['Task 1','Task 2','Task 3','Task 4','Task 5','Task 6','Task 7','AI use declaration']:
    record(f'Final report contains {heading}',heading in report_visible,heading)
positions=[report_visible.find('3a. Functionality description'),report_visible.find('Stakeholder and community requirements'),report_visible.find('3b. Five assessed database-enforced business rules')]
record('Task 3 report section order is correct',all(p>=0 for p in positions) and positions==sorted(positions),positions)
record('Development report retains honest dependencies',all(x in report_visible for x in ['A2','Week 11','RiPPlE']),'dependency notices')

combined_xml='\n'.join(parts.values())
forbidden=['[STUDENT TO COMPLETE]','Assessment draft','TODO','TBC','FIXME','PENDING STUDENT WORKBENCH SCREENSHOT','Confidential assessment draft']
if FINAL_MODE:
    hits=[x for x in forbidden if x.lower() in combined_xml.lower()]
    record('FINAL_MODE contains no placeholders or draft labels',not hits,hits)
    record('FINAL_MODE member name completed','Rianna | 1' not in report_visible,'member 1 absent')
else:
    record('Development mode honestly retains placeholders',any(x.lower() in combined_xml.lower() for x in forbidden),'FINAL_MODE=0')

required_failures=[c for c in checks if c['severity']=='required' and not c['passed']]
summary={
 'generatedAt':datetime.now().isoformat(timespec='seconds'),
 'mode':'FINAL' if FINAL_MODE else 'DEVELOPMENT',
 'mysqlVersion':scalar('SELECT VERSION()'),
 'schemaMetrics':metrics,
 'totalChecks':len(checks),
 'passed':sum(c['passed'] for c in checks),
 'failed':len(required_failures),
 'status':'PASS' if not required_failures else 'FAIL',
 'checks':checks,
 'manualRequirements':manual_requirements,
 'externalDependencies':[
   'Official A2 workbook and actual cleaning evidence.',
   'Week 11 assigned business scenario.',
   'Genuine student Workbench screenshots.',
   'Final MySQL Workbench UML relationship-notation confirmation and landscape ER export.',
   'Four-person video, genuine contribution data, RiPPlE prompt history and peer reviews.',
   'Replacement of member 1, student numbers, submission date and actual completion data.'
 ]
}
(OUT/'verification-report.json').write_text(json.dumps(summary,indent=2),encoding='utf-8')
lines=['# Cloudrest Wines Independent Verification Report','',f"- Status: **{summary['status']}**",f"- Mode: **{summary['mode']}**",f"- MySQL: `{summary['mysqlVersion']}`",f"- Checks: {summary['passed']}/{summary['totalChecks']} passed",f"- Schema: `{metrics}`",'', '## Check results','', '| Result | Check | Evidence |','|:---:|---|---|']
for c in checks:
    lines.append(f"| {'PASS' if c['passed'] else 'FAIL'} | {c['check']} | {c['evidence'].replace('|','/').replace(chr(10),' ')[:500]} |")
lines += ['', '## Manual requirements','']+[f"- **{x['requirement']}**: {x['evidence']}" for x in manual_requirements]
lines += ['', '## Genuine external dependencies','']+[f'- {x}' for x in summary['externalDependencies']]
(OUT/'verification-report.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
print(json.dumps({k:summary[k] for k in ['status','mode','totalChecks','passed','failed','mysqlVersion','schemaMetrics']},indent=2))
raise SystemExit(0 if not required_failures else 1)
