"""Update the existing native Workbench model to reflect Hint 8's line delivery fields."""
from pathlib import Path
import zipfile, xml.etree.ElementTree as ET, copy, uuid

ROOT=Path(__file__).resolve().parents[1]
SRC=ROOT/'diagrams/Cloudrest_Wines_Model.mwb'
OUT=ROOT/'deliverables/final-submission/Cloudrest_Wines_Model.mwb'
with zipfile.ZipFile(SRC) as zin:
    files={f.filename:zin.read(f.filename) for f in zin.infolist()}
root=ET.fromstring(files['document.mwb.xml'])
def name(n): return n.findtext("value[@key='name']")
objects={n.get('id'):n for n in root.iter('value') if n.get('id')}
tables={name(n):n for n in objects.values() if n.get('struct-name')=='db.mysql.Table'}
line=tables['orderline']; ship=tables['shipment']
linecols=line.find("value[@key='columns']");shipcols=ship.find("value[@key='columns']")
def uid():return str(uuid.uuid4()).upper()
def val(node,key,s):node.find(f"value[@key='{key}']").text=str(s)
def newcol(t,name_,size,dt,owner,nullable=True):
    c=copy.deepcopy(t);c.set('id',uid())
    val(c,'name',name_);val(c,'oldName',name_)
    val(c,'length',size);val(c,'isNotNull',int(not nullable))
    val(c,'precision',-1);val(c,'scale',-1)
    c.find("link[@key='simpleType']").text='com.mysql.rdbms.mysql.datatype.'+dt
    c.find("link[@key='owner']").text=owner
    return c

for field,size,typ in [
 ('deliveryRecipientName',120,'varchar'),('deliveryStreetAddress',220,'varchar'),
 ('deliveryLocality',80,'varchar'),('deliveryStateCode',3,'char'),('deliveryPostcode',4,'char')]:
    if field not in [name(c) for c in linecols]:
        linecols.append(newcol(linecols[1],field,size,typ,line.get('id')))
if 'productId' not in [name(c) for c in shipcols]:
    product=newcol(shipcols[1],'productId',7,'char',ship.get('id'),False)
    shipcols.insert(2,product)
else:
    product=next(c for c in shipcols if name(c)=='productId')
idx=next(i for i in ship.find("value[@key='indices']") if i.findtext("value[@key='indexType']")=='UNIQUE')
idxcols=idx.find("value[@key='columns']")
if not any(x.findtext("link[@key='referencedColumn']")==product.get('id') for x in idxcols):
    x=copy.deepcopy(idxcols[0]);x.set('id',uid())
    x.find("link[@key='referencedColumn']").text=product.get('id')
    idxcols.append(x)
fk=next(f for f in ship.find("value[@key='foreignKeys']")
        if name(f) in ['fk_shipment_order','fk_shipment_orderline'])
val(fk,'name','fk_shipment_orderline')
fk.find("link[@key='referencedTable']").text=line.get('id')
orderkey=next(c.get('id') for c in linecols if name(c)=='customerOrderId')
productkey=next(c.get('id') for c in linecols if name(c)=='productId')
loc=fk.find("value[@key='columns']");refs=fk.find("value[@key='referencedColumns']")
refs[0].text=orderkey
if not any(e.text==product.get('id') for e in loc):
    x=copy.deepcopy(loc[0]);x.text=product.get('id');loc.append(x)
if not any(e.text==productkey for e in refs):
    x=copy.deepcopy(refs[0]);x.text=productkey;refs.append(x)
figs=[x for x in objects.values() if x.get('struct-name')=='workbench.physical.TableFigure']
for node in objects.values():
    if node.get('struct-name')!='workbench.physical.Connection' or node.findtext("link[@key='foreignKey']")!=fk.get('id'):continue
    val(node,'caption','fk_shipment_orderline')
    diagram=node.findtext("link[@key='owner']")
    fig=next((x for x in figs if x.findtext("link[@key='table']")==line.get('id')
        and x.findtext("link[@key='owner']")==diagram),None)
    if fig is not None:node.find("link[@key='endFigure']").text=fig.get('id')
files['document.mwb.xml']=ET.tostring(root,encoding='utf-8',xml_declaration=True)
with zipfile.ZipFile(SRC,'w') as out:
    for filename,data in files.items():out.writestr(filename,data,compress_type=zipfile.ZIP_DEFLATED)
OUT.parent.mkdir(parents=True,exist_ok=True)
OUT.write_bytes(SRC.read_bytes())
print('Updated native MWB and final copy:',len(tables),'tables')
