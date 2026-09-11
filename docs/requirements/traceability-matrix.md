# Requirements Traceability Matrix

This matrix is the schema-review baseline. Every material case requirement is mapped to an implementation or an explicit exclusion.

| Area | Requirement | Planned implementation | Enforcement/evidence |
|---|---|---|---|
| Personnel | Unique employee ID and retained TFN | `employee` | PK/unique TFN; TFN is treated as privacy-sensitive and production access control is a deployment responsibility outside the submitted SQL |
| Personnel | Multiple phones, one primary, retained history | `phone`, `employeephone` | dated association and primary indicator; clean test data contains one current primary per employee, while exactly-one-current enforcement is documented as a deferred service/transaction rule |
| Personnel | Role, permanent/casual, full/part-time and seasonal-work history | `role`, `employeerole` | separate work-time, employment type and employment pattern; dated rows; overlap trigger |
| Personnel | One current supervisor per employee, retained history | `supervision` | composite key; self-supervision and overlap triggers |
| Personnel | Seasonal worker end-of-season rating | `seasonalrating` | unique worker/season record; supervisor FK |
| Personnel | Picking pack has fun name and at least four pickers | `pickerpack`, `packmember` | membership model; minimum four documented as deferred transaction/service rule |
| Vineyard | Unique vineyard, decimal hectares, manager and fixed GPS | `vineyard` | unique name/manager; decimal and coordinate checks |
| Vineyard | One variety per vineyard and vintage, retained planting | `vineyardplanting` | composite PK `(vineyardId, vintageYear)` |
| Harvest | Weight and ripeness by vineyard and vintage | `harvest` | non-negative and percentage checks |
| Wine | Unique wine, vintage, category, alcohol and winemaker | `wine`, `winecategory` | PK/FK/checks |
| Wine | Multi-variety composition and proportion | `winecomposition` | composite PK; 0–100 proportion check |
| Wine | Multiple medals | `medal` | wine FK and unique award tuple |
| Product | Wine + bottle + case quantity + dated price | `wineproduct`, `productprice` | unique product combination; positive checks; dated price history |
| Bottle | Capacity, material, colour, inventory, cost and reorder state | `bottletype` | domain checks; comment-required rule |
| Procurement | Bottle can have several suppliers | `supplierbottle` | M:N association |
| Procurement | Supplier address and phone changes retained | `supplieraddress`, `supplierphone`, `phone`, `address` | dated associations, FKs, date checks and overlap/current-primary triggers |
| Procurement | Supplier order has many lines and split receipts | `purchaseorder`, `purchaseorderline`, `receipt`, `receiptline` | compound keys and quantity checks |
| Customer | Shared customer data plus individual/business details | `customer`, `individualcustomer`, `businesscustomer` | supertype/subtype design |
| Customer | Multiple phones and retained address history | `customerphone`, `customeraddress` | dated associations and primary indicator; simultaneous current physical/postal addresses are permitted where appropriate |
| Address | Australian physical/postal structure | `address` | address-kind domain plus required `postalType` for POSTAL addresses |
| Order | Multiple product lines; single shipment; paid before shipment | `customerorder`, `orderline`, `shipment` | PK/FK; shipment trigger rejects unpaid/cancelled orders and shipment dates before order receipt |
| Order | Shipment cannot use PO Box/private bag | `shipment` + `address` | shipment trigger |
| Refund | Short supply and verified transit damage | `refund` | reason domain and verified flag |
| HR | Operational areas | `operationalarea` | role history and HR activity links |
| HR | Qualifications and renewal | `qualification`, `employeequalification` | dated certification records |
| HR | Course, provider, completion, renewal and competency | `trainingcourse`, `trainingsession`, `trainingattendance` | normalised course/session/attendance model |
| HR | Shifts, labour hours, overtime, task and supervisor | `shift`, `shiftassignment`, `taskcategory` | hour checks and composite assignment PK |
| HR | Incidents, severity, corrective action and lost time | `incident`, `incidentemployee`, `correctiveaction` | nonnegative lost-time checks; employee-level lost hours feed Query 2; event-level summary is reconciled in QA |
| HR | Check-ins, topics, concerns and actions | `wellbeingcheckin`, `wellbeingtopic`, `checkintopic`, `wellbeingaction` | detailed notes excluded from routine decision-support output; production user/role controls remain deployment work |
| Sustainability | Training completion rate by area | Query 1 | annual parameter/date filtering |
| Sustainability | Incidents per 1,000 labour hours | Query 2 | rolling date range, operational-area driver and safe zero-denominator handling |
| Exclusion | Payroll | Out of scope | external accounting system |
| Exclusion | Detailed payment/refund instrument and delivery cost | Out of scope | only paid/refund indicators retained |
| Exclusion | Cork, label, barrel and packing-box inventory | Out of scope | case instruction |

## Known deferred validations

Some cross-row rules cannot safely be represented by a row-level `CHECK`. Pack minimum membership, wine-composition total of exactly 100%, employee exactly-one-current-primary-phone enforcement, and order stock allocation are documented transaction/service rules. They should be validated through controlled procedures or end-of-transaction checks rather than triggers that make staged data loading impossible or claim semantics the current schema does not implement.
