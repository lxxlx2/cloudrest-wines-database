# Explicit Modelling Assumptions

These assumptions resolve ambiguity without contradicting the case. They must be reviewed by the team/tutor and placed beneath the final ER diagram.

| Design area | Assumption | Reason |
|---|---|---|
| Employee names | Names are split into first and last name for all employees | The case says employee name but does not prescribe structure; splitting supports contact and reporting use |
| Concurrent roles | The first implementation allows one active role period per employee | The case describes role changes but does not explicitly require concurrent roles; this can be relaxed if tutor confirms concurrent appointments |
| Supervisor history | An employee has no more than one supervisor at any instant | Explicit case requirement |
| Employment classification | Full/part-time, permanent/casual and ongoing/seasonal are independent dimensions | Prevents a seasonal casual from being misclassified as a third legal employment type |
| Supplier contact history | A supplier has one non-overlapping address period and one current primary phone, while principal contact name/email remain on supplier | Matches the case need to retain address/phone history without over-normalising contact persons |
| Owners | Christine is represented as an employee/owner role so supervisor FKs remain enforceable | Supervisors report to Christine and the model needs an identifiable parent record |
| Picking pack | Minimum four members is checked at pack activation/finalisation, not on the first member insert | A row trigger would make it impossible to build a new pack incrementally |
| Vineyard manager | The manager is the current manager; a future extension could add dated vineyard-management history | Case states one manager and no employee manages more than one vineyard, but does not explicitly request this history |
| Wine recipe | Composition rows must total 100% before a wine is released | The case requires proportions; staged recipe entry means this is not enforced on each individual row insert |
| Product identity | Wine, bottle type and case quantity uniquely define a product | Directly follows the case definition of product |
| Shipment | Each customer order has at most one shipment and the shipment retains its physical address ID | The case prohibits back orders and requires a single shipment to the current physical address |
| HR incident rate | One incident is counted once per operational area regardless of people involved | Prevents multi-person incidents being double-counted in the sustainability numerator |
| Serious near miss | HIGH or CRITICAL severity may have zero lost hours | Severity and lost time measure different concepts; the case does not require positive lost time |
| Labour hours | `regularHours + overtimeHours` in shift assignments is the reportable labour-hours denominator | Required to calculate incidents per 1,000 labour hours |
| Wellbeing privacy | Detailed notes are restricted; decision-support queries expose only concern counts and actions | Applies data minimisation to sensitive HR information |
