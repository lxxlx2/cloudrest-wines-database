"""Run inside MySQL Workbench to build an editable model from validated SQL.

The script creates the model and diagrams. Final UML relationship notation and the
landscape arrangement must still be confirmed in MySQL Workbench before the last
export; see docs/evidence/workbench-model-finalization.md.
"""
import grt
from pathlib import Path

ROOT = Path('/Users/jerson/Documents/教学接单/Cloudrest-Wines')
OUT = ROOT / 'diagrams'
OUT.mkdir(parents=True, exist_ok=True)
log=[]
try:
    grt.modules.Workbench.newDocument()
    model = grt.root.wb.doc.physicalModels[0]
    model.name = 'Cloudrest Wines'
    catalog = model.catalog
    catalog.schemata.remove_all()
    sql = (ROOT / 'database/schema/01_tables.sql').read_text(encoding='utf-8')
    context = grt.modules.MySQLParserServices.createNewParserContext(
        catalog.characterSets, catalog.version,
        'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION', 1)
    result = grt.modules.MySQLParserServices.parseSQLIntoCatalogSql(context, catalog, sql, {})
    log.append('parse result='+repr(result))
    log.append('schemata='+','.join(s.name for s in catalog.schemata))
    log.append('tables='+str(sum(len(s.tables) for s in catalog.schemata)))
    diagram_result = grt.modules.WbModel.createDiagramWithCatalog(model, catalog)
    log.append('diagram result='+repr(diagram_result))
    if model.diagrams:
        diagram=model.diagrams[0]
        diagram.name='Cloudrest Wines — Complete EER Model'
        try:
            layout_result=grt.modules.WbModel.autolayout(diagram)
            log.append('autolayout='+repr(layout_result))
        except Exception as exc:
            log.append('autolayout error='+repr(exc))
    schema = next(s for s in catalog.schemata if s.name == 'cloudrestwines')
    by_name = {t.name:t for t in schema.tables}
    domains = {
        'Personnel_History': ['employee','role','employeerole','supervision','phone','employeephone','address','employeeaddress','pickerpack','packmember','seasonalrating','operationalarea'],
        'HR_Training_Qualifications': ['employee','employeerole','operationalarea','qualification','employeequalification','trainingcourse','trainingsession','trainingattendance'],
        'HR_Shifts_Safety_Wellbeing': ['employee','operationalarea','taskcategory','shift','shiftassignment','incident','incidentemployee','correctiveaction','wellbeingcheckin','wellbeingtopic','checkintopic','wellbeingaction'],
        'Vineyard_Wine_Production': ['employee','address','vineyard','grapevariety','vineyardplanting','harvest','winecategory','wine','winecomposition','medal'],
        'Products_Procurement': ['wine','bottletype','wineproduct','productprice','supplier','supplieraddress','supplierphone','phone','supplierbottle','purchaseorder','purchaseorderline','receipt','receiptline','address'],
        'Customers_Orders': ['customer','individualcustomer','businesscustomer','phone','customerphone','address','customeraddress','customerorder','orderline','shipment','refund','wineproduct'],
    }
    domain_diagrams=[]
    for domain_name, names in domains.items():
        objects=grt.List(grt.OBJECT,'db.DatabaseObject')
        for name in names:
            objects.append(by_name[name])
        grt.modules.WbModel.createDiagramWithObjects(model,objects)
        d=model.diagrams[-1]
        d.name=domain_name.replace('_',' ')
        grt.modules.WbModel.autolayout(d)
        domain_diagrams.append((domain_name,d))
    save_result=grt.modules.Workbench.saveModelAs(str(OUT/'Cloudrest_Wines_Model.mwb'))
    log.append('save='+repr(save_result))
    if model.diagrams:
        try:
            export_result=grt.modules.Workbench.exportDiagramToPng(diagram, str(OUT/'Cloudrest_Wines_ER_Diagram.png'))
            log.append('png='+repr(export_result))
        except Exception as exc:
            log.append('png error='+repr(exc))
    for domain_name,d in domain_diagrams:
        try:
            grt.modules.Workbench.exportDiagramToPng(d,str(OUT/f'ER_{domain_name}.png'))
        except Exception as exc:
            log.append(f'{domain_name} png error='+repr(exc))
    log.append('MANUAL REQUIRED: open the saved model, select Model > Relationship Notation > UML, arrange the complete diagram on a wide landscape canvas, save, and re-export the final PNG.')
except Exception as exc:
    log.append('FATAL='+repr(exc))
    import traceback
    log.append(traceback.format_exc())
(OUT/'workbench-model-build.log').write_text('\n'.join(log),encoding='utf-8')
