# Cloudrest Wines Independent Verification Report

- Status: **PASS**
- Mode: **DEVELOPMENT**
- MySQL: `8.4.11`
- Checks: 64/64 passed
- Schema: `{'baseTables': 55, 'views': 1, 'columns': 282, 'foreignKeys': 72, 'checkConstraints': 48, 'triggers': 15, 'routines': 1}`

## Check results

| Result | Check | Evidence |
|:---:|---|---|
| PASS | Portable SQL rebuilds from empty database | exitCode=0 |
| PASS | Schema statistics collected dynamically | {'baseTables': 55, 'views': 1, 'columns': 282, 'foreignKeys': 72, 'checkConstraints': 48, 'triggers': 15, 'routines': 1} |
| PASS | supplieraddress exists | ['address', 'bottletype', 'businesscustomer', 'checkintopic', 'correctiveaction', 'customer', 'customeraddress', 'customerorder', 'customerphone', 'employee', 'employeeaddress', 'employeephone', 'employeequalification', 'employeerole', 'grapevariety', 'harvest', 'incident', 'incidentemployee', 'individualcustomer', 'medal', 'operationalarea', 'orderline', 'packmember', 'phone', 'pickerpack', 'productprice', 'purchaseorder', 'purchaseorderline', 'qualification', 'receipt', 'receiptline', 'refund' |
| PASS | supplierphone exists | ['address', 'bottletype', 'businesscustomer', 'checkintopic', 'correctiveaction', 'customer', 'customeraddress', 'customerorder', 'customerphone', 'employee', 'employeeaddress', 'employeephone', 'employeequalification', 'employeerole', 'grapevariety', 'harvest', 'incident', 'incidentemployee', 'individualcustomer', 'medal', 'operationalarea', 'orderline', 'packmember', 'phone', 'pickerpack', 'productprice', 'purchaseorder', 'purchaseorderline', 'qualification', 'receipt', 'receiptline', 'refund' |
| PASS | Supplier direct redundant contact columns removed | supplier.addressId/phoneNumber absent |
| PASS | Employment classification separates type and pattern | enum('PERMANENT','CASUAL'); enum('ONGOING','SEASONAL') |
| PASS | Seasonal pickers are CASUAL + SEASONAL | violations=0 |
| PASS | Vineyard constraint is positive-only | positive-only |
| PASS | Severity does not require positive lost hours | unsupported constraint absent |
| PASS | Every employee has one current physical address | violations=0 |
| PASS | Every employee has exactly one current primary phone | violations=0 |
| PASS | Supplier address history exists | violations=0 |
| PASS | Supplier phone history exists | violations=0 |
| PASS | Employee role history example exists | violations=0 |
| PASS | Supervisor history example exists | violations=0 |
| PASS | Employee address history example exists | violations=0 |
| PASS | Employee phone history example exists | violations=0 |
| PASS | No multiple current roles | violations=0 |
| PASS | No multiple current supervisors | violations=0 |
| PASS | No invalid shipment address | violations=0 |
| PASS | No shipped unpaid order | violations=0 |
| PASS | Query executes: 01_trainingcoverage.sql | exit=0, chars=114,  |
| PASS | Query executes: 02_incidentrate.sql | exit=0, chars=122,  |
| PASS | Query executes: 03_trainingimpact.sql | exit=0, chars=239,  |
| PASS | Query executes: 04_overtimerisk.sql | exit=0, chars=422,  |
| PASS | Query executes: 05_expiringqualification.sql | exit=0, chars=347,  |
| PASS | Query executes: 06_openactions.sql | exit=0, chars=971,  |
| PASS | Assessed integrity test: t01_validtraining.sql | exit=0; expected=PASS; testResult PASS: valid completed training was accepted |
| PASS | Assessed integrity test: t02_invalidroledate.sql | exit=1; expected=chk_employeerole_dates; ERROR 3819 (HY000) at line 3: Check constraint 'chk_employeerole_dates' is violated. |
| PASS | Assessed integrity test: t03_missingreordercomment.sql | exit=1; expected=chk_bottletype_reorder; ERROR 3819 (HY000) at line 2: Check constraint 'chk_bottletype_reorder' is violated. |
| PASS | Assessed integrity test: t04_unpaidshipment.sql | exit=1; expected=Order must be paid before shipment; ERROR 1644 (45000) at line 4: Order must be paid before shipment |
| PASS | Assessed integrity test: t05_overlappingsupervision.sql | exit=1; expected=already has a supervisor; ERROR 1644 (45000) at line 3: Employee already has a supervisor during this period |
| PASS | Assessed business rule: Rule 1 role dates | t02_invalidroledate.sql; ERROR 3819 (HY000) at line 3: Check constraint 'chk_employeerole_dates' is violated. |
| PASS | Assessed business rule: Rule 2 reorder comment | t03_missingreordercomment.sql; ERROR 3819 (HY000) at line 2: Check constraint 'chk_bottletype_reorder' is violated. |
| PASS | Assessed business rule: Rule 3 current physical address | additional_postalshipment.sql; ERROR 1644 (45000) at line 3: Shipment address must be a physical address, not PO Box or Private Bag |
| PASS | Assessed business rule: Rule 4 paid before shipment | t04_unpaidshipment.sql; ERROR 1644 (45000) at line 4: Order must be paid before shipment |
| PASS | Assessed business rule: Rule 5 one supervisor | t05_overlappingsupervision.sql; ERROR 1644 (45000) at line 3: Employee already has a supervisor during this period |
| PASS | Project Plan requires Actual Completion Date | plan columns |
| PASS | Task 2 has four decisions and page citations | four decisions/citations |
| PASS | Task 2 within 1,200 words | words=696 |
| PASS | Task 3 stakeholder table exists | required stakeholder columns/rows |
| PASS | Five assessed Task 3b rules exist | rules=5 |
| PASS | Each assessed rule has violation SQL | test files present |
| PASS | Query submission contains CREATE VIEW | CREATE VIEW openincidentaction |
| PASS | Query submission contains CREATE PROCEDURE | CREATE PROCEDURE getExpiringQualifications |
| PASS | Query submission contains 30-day call | CALL getExpiringQualifications(30) |
| PASS | Query submission contains 90-day call | CALL getExpiringQualifications(90) |
| PASS | Query submission contains EXPLAIN | EXPLAIN |
| PASS | Query submission contains six queries | six query markers |
| PASS | Database export contains six queries | embedded query section |
| PASS | Query 3 filters AFFECTED involvement | filter present |
| PASS | Data Dictionary has explicit domains | generic domain absent |
| PASS | Data Dictionary has semantic descriptions | generic description absent |
| PASS | Full ER image meets resolution requirement | resolution=(1586, 2551) |
| PASS | Final report contains Task 1 | Task 1 |
| PASS | Final report contains Task 2 | Task 2 |
| PASS | Final report contains Task 3 | Task 3 |
| PASS | Final report contains Task 4 | Task 4 |
| PASS | Final report contains Task 5 | Task 5 |
| PASS | Final report contains Task 6 | Task 6 |
| PASS | Final report contains Task 7 | Task 7 |
| PASS | Final report contains AI use declaration | AI use declaration |
| PASS | Development report retains honest dependencies | dependency notices |
| PASS | Development mode honestly retains placeholders | FINAL_MODE=0 |

## Genuine external dependencies

- Official A2 workbook and actual cleaning evidence.
- Week 11 assigned business scenario.
- Genuine student Workbench screenshots.
- Four-person video, genuine contribution data, RiPPlE prompt history and peer reviews.
- Replacement of member 1 and submission date.
