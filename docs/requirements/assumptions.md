# Explicit Modelling Assumptions

These assumptions resolve ambiguity without contradicting the case. They must be reviewed by the team/tutor and placed beneath the final ER diagram.

| Design area | Assumption | Reason |
|---|---|---|
| Employee names | Names are split into first and last name for all employees | The case says employee name but does not prescribe structure; splitting supports contact and reporting use |
| Concurrent roles | The first implementation allows one active role period per employee | The case describes role changes but does not explicitly require concurrent roles; this can be relaxed if tutor confirms concurrent appointments |
| Supervisor history | An employee has no more than one supervisor at any instant | Explicit case requirement |
| Employment classification | Full/part-time, permanent/casual and ongoing/seasonal are independent dimensions | Prevents a seasonal casual from being misclassified as a third legal employment type |
| Supplier contact history | A supplier may hold a current physical address and an optional current postal address at the same time; histories must not overlap within the same address type. Multiple phone numbers may coexist, but only one current phone may be primary | Matches the case requirement for physical address plus optional postal correspondence while retaining address/phone history |
| Owners | Christine is represented as an employee/owner role so supervisor FKs remain enforceable | Supervisors report to Christine and the model needs an identifiable parent record |
| Picking pack | Minimum four members is checked at pack activation/finalisation, not on the first member insert | A row trigger would make it impossible to build a new pack incrementally |
| Vineyard manager | The manager is the current manager; a future extension could add dated vineyard-management history | Case states one manager and no employee manages more than one vineyard, but does not explicitly request this history |
| Wine recipe | Composition rows must total 100% before a wine is released | The case requires proportions; staged recipe entry means this is not enforced on each individual row insert |
| Product identity | Wine, bottle type and case quantity uniquely define a product | Directly follows the case definition of product |
| Shipment | Each customer order has at most one shipment and the shipment retains its physical address ID | The case prohibits back orders and requires a single shipment to the current physical address |
| Customer subtypes | Parent customer rows may be staged before the subtype row is inserted; once populated, the subtype must match `customerType` and the same customer cannot exist in both subtype tables | Supports transaction loading while preserving supertype/subtype consistency |
| Receipt lines | A received bottle type must exist on the purchase order associated with the receipt; cumulative over-delivery is not automatically rejected | The case links receipts to supplier orders but does not state how over-delivery should be handled |
| Product price history | Price validity periods for the same product must not overlap and use DATE granularity | The case requires dated price history with 24-hour price changes |
| HR incident rate | One incident is counted once per operational area regardless of people involved | Prevents multi-person incidents being double-counted in the sustainability numerator |
| Serious near miss | HIGH or CRITICAL severity may have zero lost hours | Severity and lost time measure different concepts; the case does not require positive lost time |
| Labour hours | `regularHours + overtimeHours` in shift assignments is the reportable labour-hours denominator | Required to calculate incidents per 1,000 labour hours |
| Wellbeing privacy | Detailed notes are restricted; decision-support queries expose only concern counts and actions | Applies data minimisation to sensitive HR information |
