# Requirements Traceability Matrix

This matrix is the schema-review baseline. Every material case requirement is mapped to an implementation or an explicit exclusion.

| Area | Requirement | Planned implementation | Enforcement/evidence |
|---|---|---|---|
| Personnel | Unique employee ID and retained TFN | `employee` | PK; encrypted/controlled access discussed in report |
| Personnel | Multiple phones, one primary, retained history | `phone`, `employeephone` | dated association; trigger prevents invalid dates |
| Personnel | Role, permanent/casual and full/part-time history | `role`, `employeerole` | composite key; dated rows; overlap trigger |
| Personnel | One current supervisor per employee, retained history | `supervision` | composite key; self-supervision and overlap triggers |
| Personnel | Seasonal worker end-of-season rating | `seasonalrating` | unique worker/season record; supervisor FK |
| Personnel | Picking pack has fun name and at least four pickers | `pickerpack`, `packmember` | membership model; minimum four documented as deferred transaction rule |
| Vineyard | Unique vineyard, decimal hectares, manager and fixed GPS | `vineyard` | unique name/manager; decimal and coordinate checks |
| Vineyard | One variety per vineyard and vintage, retained planting | `vineyardplanting` | composite PK `(vineyardId, vintageYear)` |
| Harvest | Weight and ripeness by vineyard and vintage | `harvest` | non-negative and percentage checks |
| Wine | Unique wine, vintage, category, alcohol and winemaker | `wine`, `winecategory` | PK/FK/checks |
| Wine | Multi-variety composition and proportion | `winecomposition` | composite PK; 0–100 proportion check |
| Wine | Multiple medals | `medal` | wine FK and unique award tuple |
| Product | Wine + bottle + case quantity + dated price | `wineproduct`, `productprice` | unique product combination; positive checks; dated price history |
| Bottle | Capacity, material, colour, inventory, cost and reorder state | `bottletype` | domain checks; comment-required rule |
| Procurement | Bottle can have several suppliers | `supplierbottle` | M:N association |
| Procurement | Supplier order has many lines and split receipts | `purchaseorder`, `purchaseorderline`, `receipt`, `receiptline` | compound keys and quantity checks |
| Customer | Shared customer data plus individual/business details | `customer`, `individualcustomer`, `businesscustomer` | supertype/subtype design |
| Customer | Multiple phones and retained address history | `customerphone`, `customeraddress` | dated associations and primary indicator |
| Address | Australian physical/postal structure | `address` | structured optional and required fields; address-kind domain |
| Order | Multiple product lines; single shipment; paid before shipment | `customerorder`, `orderline`, `shipment` | PK/FK; shipment trigger |
| Order | Shipment cannot use PO Box/private bag | `shipment` + `address` | shipment trigger |
| Refund | Short supply and verified transit damage | `refund` | reason domain and verified flag |
| HR | Operational areas | `operationalarea` | role history and HR activity links |
| HR | Qualifications and renewal | `qualification`, `employeequalification` | dated certification records |
| HR | Course, provider, completion, renewal and competency | `trainingcourse`, `trainingsession`, `trainingattendance` | normalised course/session/attendance model |
| HR | Shifts, labour hours, overtime, task and supervisor | `shift`, `shiftassignment`, `taskcategory` | hour checks and composite assignment PK |
| HR | Incidents, severity, corrective action and lost time | `incident`, `incidentemployee`, `correctiveaction` | severity/lost-time checks; dated actions |
| HR | Check-ins, topics, concerns and actions | `wellbeingcheckin`, `wellbeingtopic`, `checkintopic`, `wellbeingaction` | restricted-detail model and management follow-up |
| Sustainability | Training completion rate by area | Query 1 | annual parameter/date filtering |
| Sustainability | Incidents per 1,000 labour hours | Query 2 | date range and safe division |
| Exclusion | Payroll | Out of scope | external accounting system |
| Exclusion | Detailed payment/refund instrument and delivery cost | Out of scope | only paid/refund indicators retained |
| Exclusion | Cork, label, barrel and packing-box inventory | Out of scope | case instruction |

## Known deferred validations

Some cross-row rules cannot safely be represented by a row-level `CHECK`. Pack minimum membership, wine-composition total of exactly 100%, and order stock allocation are documented transaction/service rules. They should be validated through controlled procedures or end-of-transaction checks rather than triggers that make staged data loading impossible.

