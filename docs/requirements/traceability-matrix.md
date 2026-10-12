# Requirements Traceability Matrix

This matrix is the schema-review baseline. Every material case requirement is mapped to an implementation or an explicit exclusion.

| Area | Requirement | Planned implementation | Enforcement/evidence |
|---|---|---|---|
| Personnel | Unique employee ID and retained TFN | `employee` | PK/unique TFN; TFN is treated as privacy-sensitive and production access control is a deployment responsibility outside the submitted SQL |
| Personnel | Multiple phones, one primary, retained history | `phone`, `employeephone` | dated association; trigger prevents more than one current primary phone per employee |
| Personnel | Role, permanent/casual, full/part-time and seasonal-work history | `role`, `employeerole` | separate work-time, employment type and employment pattern; dated rows; overlap trigger |
| Personnel | One current supervisor per employee, retained history | `supervision` | composite key; self-supervision and overlap triggers |
| Personnel | Seasonal worker end-of-season rating | `seasonalrating` | unique worker/season record; supervisor FK |
| Personnel | Picking pack has fun name; membership history supports leave and rejoin | `pickerpack`, `packmember` | PK `(pickerPackId, employeeId, joinedDate)` permits rejoin; overlap trigger prevents simultaneous memberships; minimum-four rule remains a completion/service validation |
| Vineyard | Unique vineyard, decimal hectares, manager and fixed GPS | `vineyard` | unique name/manager; decimal and coordinate checks |
| Vineyard | Multiple grape varieties may be planted in one vineyard and vintage | `vineyardplanting` | composite PK `(vineyardId, vintageYear, grapeVarietyId)` |
| Harvest | Weight and ripeness by vineyard, vintage and grape variety | `harvest` | triple FK to the exact `vineyardplanting` row plus weight/ripeness checks |
| Wine | Unique wine, vintage, category, alcohol and winemaker | `wine`, `winecategory` | PK/FK/checks |
| Wine | Multi-variety composition and proportion totals exactly 100% | `winecomposition`, `validateWineComposition`, `validateAllWineComposition` | row percentage CHECK; active-product release validation; released recipes locked against ad-hoc edits |
| Wine | Multiple medals | `medal` | wine FK and unique award tuple |
| Product | Wine + bottle + case quantity + dated price | `wineproduct`, `productprice` | unique product combination; positive checks; dated price history |
| Bottle | Capacity, material, colour, inventory, cost and reorder state | `bottletype` | domain checks; comment-required rule |
| Procurement | Bottle can have several suppliers | `supplierbottle` | M:N association |
| Procurement | Supplier address and phone changes retained | `supplieraddress`, `supplierphone`, `phone`, `address` | dated associations, FKs, date checks and overlap/current-primary triggers |
| Procurement | Supplier order has many lines and split receipts | `purchaseorder`, `purchaseorderline`, `receipt`, `receiptline` | compound keys and quantity checks |
| Customer | Shared customer data plus individual/business details | `customer`, `individualcustomer`, `businesscustomer` | supertype/subtype design |
| Customer | Multiple phones and retained address history | `customerphone`, `customeraddress` | `addressPurpose` distinguishes PRIMARY/DELIVERY/BILLING/CORRESPONDENCE; non-overlap is enforced per purpose; one current primary phone is enforced |
| Address | Australian physical/postal structure | `address` | address-kind domain plus required `postalType` for POSTAL addresses |
| Order | Multiple product lines; single shipment; paid before shipment | `customerorder`, `orderline`, `shipment` | PK/FK; shipment trigger rejects unpaid/cancelled orders, invalid dates and non-current PRIMARY/DELIVERY physical addresses |
| Order | Shipment cannot use PO Box/private bag | `shipment` + `address` | shipment trigger |
| Refund | Refund identifies the affected product within the order | `refund` | `(customerOrderId, productId)` FK to `orderline`; reason domain and verified-transit-damage rule |
| HR | Operational areas | `operationalarea` | role history and HR activity links |
| HR | Qualifications and renewal | `qualification`, `employeequalification` | dated certification records |
| HR | Course, provider, completion, renewal and competency | `trainingcourse`, `trainingsession`, `trainingattendance` | normalised course/session/attendance model |
| HR | Shifts, labour hours, overtime, task and supervisor | `shift`, `shiftassignment`, `taskcategory` | assignment stores actual start/end/break only; labour and overtime are derived in queries, removing duplicate hour facts |
| HR | Incidents, severity, corrective action and lost time | `incident`, `incidentemployee`, `correctiveaction` | nonnegative lost-time checks; employee-level lost hours feed Query 2; event-level summary is reconciled in QA |
| HR | Check-ins, topics, concerns and actions | `wellbeingcheckin`, `wellbeingtopic`, `checkintopic`, `wellbeingaction` | detailed notes excluded from routine decision-support output; production user/role controls remain deployment work |
| Sustainability | Annual safety + sustainability training coverage by area | Query 1 | measurable percentage with active-workforce denominator, annual date filtering and both-category completion requirement |
| Sustainability | Workplace incidents per 1,000 actual labour hours | Query 2 | rolling 12-month rate using derived assignment hours, incident numerator and safe zero-denominator handling |
| Exclusion | Payroll | Out of scope | external accounting system |
| Exclusion | Detailed payment/refund instrument and delivery cost | Out of scope | only paid/refund indicators retained |
| Exclusion | Cork, label, barrel and packing-box inventory | Out of scope | case instruction |

## Remaining controlled validations

Cross-row rules that cannot be expressed as ordinary row CHECK constraints are handled explicitly:

- Wine composition is validated at product release and by `validateAllWineComposition()`.
- Picking-pack minimum membership remains an activation/finalisation rule because enforcing a minimum on each row insert would prevent incremental pack construction.
- Official v4 repeated order/product rows remain a staging exception until their business meaning is confirmed; the production schema is not silently changed to accommodate ambiguous dirty data.
