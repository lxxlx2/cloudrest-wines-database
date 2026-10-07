# Explicit Modelling Assumptions

These assumptions resolve ambiguity without contradicting the case. They must be reviewed by the team/tutor and placed beneath the final ER diagram.

| Design area | Assumption | Reason |
|---|---|---|
| Employee names | Names are split into first and last name for all employees | The case says employee name but does not prescribe structure; splitting supports contact and reporting use |
| Concurrent roles | An employee has at most one active role period; the previous role must finish before the next starts | Tutor confirmed that the previous role should finish before the next role starts; the existing overlap trigger enforces this |
| Supervisor history | An employee has no more than one supervisor at any instant | Explicit case requirement |
| Employment classification | Full/part-time, permanent/casual and ongoing/seasonal are independent dimensions | Prevents a seasonal casual from being misclassified as a third legal employment type |
| Supplier contact history | Supplier address periods cannot overlap within the same address kind, and only one current primary phone is allowed | Preserves history while allowing different legitimate address kinds and preventing duplicate current facts |
| Employee/customer contact history | Employee address periods cannot overlap within the same address kind; customer address periods cannot overlap within the same business purpose; employee and customer phone history permits only one current primary phone | Tutor requires current-history integrity, while the official v4 workbook demonstrates that a customer can legitimately have concurrent Delivery and Billing addresses |
| Owners | Christine is represented as an employee/owner role so supervisor FKs remain enforceable | Supervisors report to Christine and the model needs an identifiable parent record |
| Picking pack | The minimum four-person requirement is checked operationally before scheduling/finalisation and is not enforced by the current database schema | Enforcing the minimum on each member insert would prevent incremental pack construction; adding lifecycle status plus a finalisation trigger would be a future extension |
| Vineyard manager | The manager is the current manager; a future extension could add dated vineyard-management history | Case states one manager and no employee manages more than one vineyard, but does not explicitly request this history |
| Wine recipe | Composition rows must total 100% before an active product is released; released recipes are locked against ad-hoc composition edits | MySQL cannot express this cross-row total with a normal CHECK, so release-boundary validation preserves staged recipe entry while enforcing the tutor requirement |
| Product identity | Wine, bottle type and case quantity uniquely define a product | Directly follows the case definition of product |
| Shipment | Each customer order has at most one shipment and the shipment retains its physical address ID; cancelled orders and shipment dates before order receipt are rejected | The case prohibits back orders and requires a single shipment to the current physical address |
| HR incident rate | One incident is counted once per operational area regardless of people involved | Prevents multi-person incidents being double-counted in the sustainability numerator |
| Incident lost hours | Employee-level `incidentemployee.employeeLostHours` is the detailed source used by the sustainability query; `incident.totalLostHours` is retained as an event-level summary and must be reconciled in QA rather than treated as an independent authoritative fact | Avoids double-counting multi-person incidents while acknowledging the retained summary field |
| Serious near miss | HIGH or CRITICAL severity may have zero lost hours | Severity and lost time measure different concepts; the case does not require positive lost time |
| Labour hours | Labour hours are derived from `shiftassignment.actualStartTime`, `actualEndTime` and `breakMinutes`; overtime is derived as hours above 8 per assignment for the current analytical rule | Removes the duplicate manual hour facts identified by the tutor and keeps one auditable source for worked time |
| Wellbeing privacy | Detailed notes are excluded from routine decision-support output; database users/roles and application authorisation are deployment controls outside this assessment build | The submitted SQL demonstrates data minimisation but does not claim production access-control configuration |
