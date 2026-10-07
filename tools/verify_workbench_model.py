"""Audit editable Workbench contents against the current schema-backed dictionary."""
import csv,hashlib,json,zipfile,xml.etree.ElementTree as ET
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
path=ROOT/'diagrams/Cloudrest_Wines_Model.mwb'
with zipfile.ZipFile(path) as archive:
    root=ET.fromstring(archive.read('document.mwb.xml'))
objects={node.get('id'):node for node in root.iter('value') if node.get('id')}
def value(node,key): return node.findtext(f"value[@key='{key}']")
tables={value(n,'name'):n for n in objects.values() if n.get('struct-name')=='db.mysql.Table'}
columns={name:[value(c,'name') for c in table.find("value[@key='columns']")] for name,table in tables.items()}
def pk(name):
    table=tables[name]; link=table.findtext("link[@key='primaryKey']")
    index=objects[link]
    return [value(objects[c.findtext("link[@key='referencedColumn']")],'name') for c in index.find("value[@key='columns']")]
rows=list(csv.DictReader((ROOT/'docs/report/data-dictionary.csv').open(encoding='utf-8-sig')))
dictionary={}
for row in rows:
    if row['tableName'] in tables: dictionary.setdefault(row['tableName'],[]).append(row)
checks={
    '55 base tables':len(tables)==55,
    'column names match current dictionary':all(columns[name]==[r['attributeName'] for r in dictionary.get(name,[])] for name in tables),
    'primary keys match current dictionary':all(pk(name)==[r['attributeName'] for r in dictionary[name] if r['isPrimary']=='Y'] for name in tables),
    'vineyardplanting three-column PK':pk('vineyardplanting')==['vineyardId','vintageYear','grapeVarietyId'],
    'packmember joinedDate in PK':'joinedDate' in pk('packmember'),
    'harvest grape variety':'grapeVarietyId' in columns['harvest'],
    'refund product':'productId' in columns['refund'],
    'customer address purpose':'addressPurpose' in columns['customeraddress'],
    'actual shift start/end/break':all(c in columns['shiftassignment'] for c in ['actualStartTime','actualEndTime','breakMinutes']),
    'obsolete stored hours absent':not {'regularHours','overtimeHours'} & set(columns['shiftassignment']),
    'UML notation':any(n.get('key')=='relationshipNotation' and n.text=='uml' for n in root.iter('value')),
    'seven diagrams':sum(n.get('struct-name')=='workbench.physical.Diagram' for n in objects.values())==7,
}
fk_count=sum(len(t.find("value[@key='foreignKeys']")) for t in tables.values())
checks['72 modeled foreign keys']=fk_count==72
submission=ROOT/'deliverables/final-submission'/path.name
checks['submission model byte-identical']=submission.read_bytes()==path.read_bytes()
for image in (ROOT/'diagrams').glob('*.png'):
    checks[f'submission {image.name} byte-identical']=(ROOT/'deliverables/final-submission'/image.name).read_bytes()==image.read_bytes()
result={'status':'PASS' if all(checks.values()) else 'FAIL','modelSHA256':hashlib.sha256(path.read_bytes()).hexdigest(),
        'baseTables':len(tables),'modeledBaseColumns':sum(map(len,columns.values())),
        'foreignKeys':fk_count,'schemaColumnsIncludingView':len(rows),'checks':checks}
(ROOT/'verification/workbench-model-audit.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
raise SystemExit(0 if all(checks.values()) else 1)
