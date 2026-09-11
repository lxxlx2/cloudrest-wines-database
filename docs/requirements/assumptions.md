# Explicit Modelling Assumptions

These assumptions resolve ambiguity without contradicting the case. They must be reviewed by the team/tutor and placed beneath the final ER diagram.

| Design area | Assumption | Reason |
|---|---|---|
| Employee names | Names are split into first and last name for all employees | The case says employee name but does not prescribe structure; splitting supports contact and reporting use |
| Concurrent roles | The first implementation allows one active role period per employee | The case describes role changes but does not explicitly require concurrent appointments; this can be relaxed if tutor confirms concurrent appointments |
| Supervisor history | An employee has no more than one supervisor at any instant | Explicit case requirement |
| Employment classification | Full/part-time, permanent/casual and ongoing/seasonal are independent dimensions | Prevents a seasonal casual from being misclassified as a third legal employment type |
| Supplier contact history | A supplier has one non-overlapping address period and one current primary phone, while principal contact name/email remain on supplier | Matches the case need to retain address/phone history without over-normalising contact persons |
| Employee/customer contact history | Test data is designed with sensible current contact rows; the current schema preserves dated employee/customer phone and address history but does not claim a database-enforced exactly-one-current rule for those associations | Customer records may legitimately have simultaneous current physical and postal addresses, so an undifferentiated single-current-address constraint would be incorrect |
| Owners | Christine is represented as an employee/owner role so supervisor FKs remain enforceable | Supervisors report to Christine and the model needs an identifiable parent record |
| Picking pack | The minimum four-person requirement is checked operationally before scheduling/finalisation and is not enforced by the current database schema | Enforcing the minimum on each member insert would prevent incremental pack construction; adding lifecycle status plus a finalisation trigger would be a future extension |
| Vineyard manager | The manager is the current manager; a future extension could add dated vineyard-management history | Case states one manager and no employee manages more than one vineyard, but does not explicitly request this history |
| Wine recipe | Composition rows must total 100% before a wine is released | The case requires proportions; staged recipe entry means this is not enforced on each individual row insert |
| Product identity | Wine, bottle type and case quantity uniquely define a product | Directly follows the case definition of product |
| Shipment | Each customer order has at most one shipment and the shipment retains its physical address ID; cancelled orders and shipment dates before order receipt are rejected | The case prohibits back orders and requires a single shipment to the current physical address |
| HR incident rate | One incident is counted once per operational area regardless of people involved | Prevents multi-person incidents being double-counted in the sustainability numerator |
| Incident lost hours | Employee-level `incidentemployee.employeeLostHours` is the detailed source used by the sustainability query; `incident.totalLostHours` is retained as an event-level summary and must be reconciled in QA rather than treated as an independent authoritative fact | Avoids double-counting multi-person incidents while acknowledging the retained summary field |
| Serious near miss | HIGH or CRITICAL severity may have zero lost hours | Severity and lost time measure different concepts; the case does not require positive lost time |
| Labour hours | `regularHours + overtimeHours` in shift assignments is the reportable labour-hours denominator | Required to calculate incidents per 1,000 labour hours |
| Wellbeing privacy | Detailed notes are excluded from routine decision-support output; database users/roles and application authorisation are deployment controls outside this assessment build | The submitted SQL demonstrates data minimisation but does not claim production access-control configuration |
