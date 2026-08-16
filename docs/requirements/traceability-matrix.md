# Requirements Traceability Matrix

This matrix is the schema-review baseline. Every material case requirement is mapped to an implementation, an executable deferred validation, or an explicit exclusion.

| Area | Requirement | Planned implementation | Enforcement/evidence |
|---|---|---|---|
| Personnel | Unique employee ID and retained TFN | `employee` | PK; sensitive identifier excluded from routine management queries; least-privilege deployment discussed in report |
| Personnel | Multiple phones, one primary, retained history | `phone`, `employeephone` | dated association; date CHECK; primary-period overlap triggers; `validateRequiredCurrentState()` requires exactly one current primary phone for each active employee |
| Personnel | Role, permanent/casual, full/part-time and seasonal-work history | `role`, `employeerole` | separate work-time, employment type and employment pattern; dated rows; overlap trigger |
| Personnel | One current supervisor per employee, retained history | `supervision` | composite key; self-supervision and overlap triggers |
| Personnel | Employee address history valid on a date | `employeeaddress`, `address` | dated association; same-address-kind overlap triggers; `validateRequiredCurrentState()` requires one current physical address for each active employee |
| Personnel | Seasonal worker end-of-season rating | `seasonalrating` | unique worker/season record; supervisor FK |
| Personnel | Picking pack has fun name and at least four pickers; members report to same grape-farmer supervisor | `pickerpack`, `packmember`, `supervision`, `employeerole` | `validatePickingPackRules()` checks minimum four, current casual-seasonal Picker role, one current pack per picker, active Grape Farmer supervisor and matching supervision |
| Vineyard | Unique vineyard, decimal hectares, grape-farmer manager, physical address and fixed GPS | `vineyard` | unique name/manager; positive/coordinate CHECKs; vineyard INSERT/UPDATE business triggers verify active Grape Farmer role and PHYSICAL address |
| Vineyard | One variety per vineyard and vintage, retained planting | `vineyardplanting` | composite PK `(vineyardId, vintageYear)` |
| Harvest | Weight and ripeness by vineyard and vintage | `harvest` | planting FK; positive weight and percentage CHECKs |
| Wine | Unique wine, vintage, category, alcohol and winemaker | `wine`, `winecategory` | PK/FK/CHECKs |
| Wine | Multi-variety composition and proportion totals 100% before saleable product release | `winecomposition`, `wineproduct` | row percentage CHECK plus `validateWineComposition()` called by product INSERT/UPDATE triggers |
| Wine | Multiple medals | `medal` | wine FK and unique award tuple |
| Product | Wine + bottle + case quantity + dated price | `wineproduct`, `productprice` | unique product combination; positive CHECKs; product-price overlap triggers |
| Bottle | Capacity, material, colour, inventory, cost and reorder state | `bottletype` | domain/CHECK controls; comment-required rule |
| Procurement | Bottle can have several suppliers and availability state | `supplierbottle` | M:N association and `isAvailable` |
| Procurement | Supplier address and phone changes retained with current physical/primary contact | `supplieraddress`, `supplierphone`, `phone`, `address` | dated associations; same-address-kind overlap controls; primary-phone period control; `validateRequiredCurrentState()` checks current physical address and primary phone |
| Procurement | Supplier order has many lines and split receipts | `purchaseorder`, `purchaseorderline`, `receipt`, `receiptline` | compound keys; quantity CHECKs; receipt-line trigger confirms bottle was ordered; receipt chronology trigger |
| Customer | Shared customer data plus exactly one matching individual/business subtype before transaction | `customer`, `individualcustomer`, `businesscustomer` | subtype INSERT/UPDATE/type-change triggers plus `validateCustomerSubtype()` on customer-order INSERT/UPDATE |
| Customer | Multiple phones with one primary and retained address history | `customerphone`, `customeraddress`, `phone`, `address` | dated associations; primary-phone overlap triggers; same-address-kind overlap triggers; `validateRequiredCurrentState()` checks one current primary phone and physical address for active customers |
| Address | Australian physical/postal structure | `address` | structured optional/required fields; address-kind/postcode CHECKs |
| Order | One or more product lines before dispatch; single shipment; paid before shipment | `customerorder`, `orderline`, `shipment` | positive line quantity; unique shipment per order; shipment controls require at least one line and paid order |
| Order | Shipment cannot use PO Box/private bag and must use currently valid customer physical address | `shipment`, `customeraddress`, `address` | shipment triggers include address type and start/end validity checks |
| Order | Shipment cannot precede order receipt; SHIPPED state requires shipment record | `customerorder`, `shipment` | chronology and state-transition triggers |
| Refund | Short supply and verified transit damage | `refund` | reason domain and verified flag |
| HR | Operational areas | `operationalarea` | role history and HR activity links |
| HR | Qualifications and renewal | `qualification`, `employeequalification` | dated certification records |
| HR | Course, provider, completion, renewal and competency | `trainingcourse`, `trainingsession`, `trainingattendance` | normalised course/session/attendance model |
| HR | Shifts, labour hours, overtime, task and supervisor | `shift`, `shiftassignment`, `taskcategory` | hour checks and composite assignment PK; same-day shift assumption documented |
| HR | Incidents, severity, corrective action and lost time | `incident`, `incidentemployee`, `correctiveaction` | nonnegative lost-time check; involvement role separates AFFECTED/WITNESS/REPORTER |
| HR | Check-ins, topics, concerns and actions | `wellbeingcheckin`, `wellbeingtopic`, `checkintopic`, `wellbeingaction` | restricted-detail model and privacy-aware management output |
| Sustainability | Training completion rate by area | Query 1 | annual date logic; employee area from active role; company-wide sessions remain eligible |
| Sustainability | All recorded safety incidents per 1,000 labour hours | Query 2 | rolling 12-month numerator/denominator CTEs; operational-area driving set; safe NULL rate when exposure is zero |
| Analytics | Pre/post latest safety-training incident comparison | Query 3 | symmetric 180-day windows; AFFECTED involvement only; association only, no causal claim |
| Analytics | Workload/safety review | Query 4 | separate workload/incident/concern aggregates; no confidential notes and no arbitrary weighted risk score |
| Exclusion | Payroll | Out of scope | external accounting system |
| Exclusion | Detailed payment/refund instrument and delivery cost | Out of scope | only paid/refund indicators retained |
| Exclusion | Cork, label, barrel and packing-box inventory | Out of scope | case instruction |

## Executable deferred validations

Cross-row rules that cannot be represented safely by a single-row `CHECK` are not left as prose-only assumptions. `validatePickingPackRules()` checks the completed picking-pack state before operational use. `validateWineComposition()` is invoked automatically before a wine product is created or changed. `validateCustomerSubtype()` is invoked before an order can be created or reassigned. `validateRequiredCurrentState()` verifies required active contact state after staged loading. Order-line presence is checked at shipment finalisation.
