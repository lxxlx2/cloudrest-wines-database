# Task 3 — Functionality, Stakeholders and Business Rules

## 3a. Functionality description

Cloudrest Wines needs a transactional database because spreadsheet and document records no longer scale to business growth, biosecurity reporting and sustainability evidence (Wine Company Case, p. 1). The MySQL system integrates personnel, vineyard plantings, harvests, wines, bottles, suppliers, customers and orders. The selected HR perspective adds qualifications, training, shifts, labour hours, incidents, corrective actions and confidential wellbeing check-ins (BISM2207 Assessment Specification, p. 2). It supports annual safety/sustainability training coverage and incident rates per 1,000 labour hours.

The design targets 3NF and OLTP use. Repeating phones and addresses are separate entities; temporal association tables preserve employee, customer and supplier contact history. Course definitions, delivered sessions and individual attendance are separated. Many-to-many facts use associative tables, including wine composition, incident involvement and training attendance. Role, supervisor, address, phone and price histories retain effective dates rather than overwriting facts.

Controls combine types, `NOT NULL`, candidate keys, foreign keys, `CHECK` constraints and triggers. Row constraints reject invalid dates and domains. Triggers enforce rules needing other rows or tables, such as non-overlapping supervision and paid, non-cancelled, current, physical shipment addresses with shipment dates on or after order receipt. The submitted rule script uses transactions and rollback. Standalone screenshot tests were followed by a clean verifier rebuild before final query capture, removing all setup rows. Employee/customer contact histories are stored with effective dates; the test data follows sensible current-contact patterns, while the current schema does not claim an exactly-one-current rule for every employee/customer phone or address association.

Privacy is handled in the submitted build through data minimisation: routine decision-support output uses IDs or aggregates and excludes confidential wellbeing notes. The SQL submission does not define production MySQL users/roles or application authorisation policies, so the report does not claim database-level access control that is absent from the code. A production deployment would add least-privilege database roles and application-level access control for TFNs, dates of birth, contact data, incident participation and wellbeing details.

Payroll, payment instruments, delivery costing and unrelated inventory remain outside scope, consistent with the case. The system provides reliable operational evidence without adding enterprise functions the four-person team could not explain or validate.

## Stakeholder and community requirements

| Stakeholder | Need / risk | Database requirement | Design response | Priority / trade-off |
|---|---|---|---|---|
| Owners / management | Reliable growth, compliance and sustainability reporting | Integrated operational history and decision queries | Normalised OLTP schema, view and six queries | High; reporting convenience must not duplicate facts |
| HR manager | Accurate employment and confidential wellbeing records | Role/classification history, qualifications and restricted notes | Temporal HR tables; confidential note excluded from routine queries | Privacy overrides managerial curiosity |
| Supervisors | Current teams, hours, training and actions | One supervisor at a point in time; current-role area | Supervision history trigger and area-linked queries | Integrity over flexible duplicate assignments |
| Permanent employees | Correct role/contact history | Current plus historical role, supervisor, address and phone | Dated association tables | High |
| Casual / seasonal employees | Seasonal pattern and fair re-employment evidence | CASUAL + SEASONAL classification and seasonal ratings | Separate employment type and pattern | Avoids conflating legal status with work pattern |
| Safety / compliance staff | Multi-person incidents and serious near misses | Many-to-many involvement, severity, nonnegative lost hours | `incidentemployee`; zero lost hours allowed | Safety evidence without unsupported assumptions |
| Customers | Physical delivery plus optional postal correspondence | Multiple dated addresses; shipment validation | Postal retained but blocked for shipment | Delivery integrity takes priority |
| Suppliers | Contact changes without lost procurement history | Address and phone history | `supplieraddress` and `supplierphone` | Extra joins accepted for auditability |
| Regulatory / sustainability users | Reproducible measures without personal leakage | Aggregated training and incident-rate queries | Defined numerators/denominators; `NULLIF` safeguards | Accuracy and privacy |
| Community / public value | Safe work and responsible operations | Traceable training, incident and corrective-action evidence | Auditable records using fictitious assessment data | Transparency without exposing private notes |

Exception coverage includes multi-person incidents; employee role, supervisor, address and phone changes; supplier address and phone changes; simultaneous customer physical/postal addresses; high overtime without an incident; confidential wellbeing notes; and a serious near miss with zero lost hours.

## 3a.1 Tutor-feedback integrity revisions

The revised schema addresses the specific integrity gaps identified in tutor review.

- **Vineyard planting and harvest.** `vineyardplanting` is identified by vineyard, vintage and grape variety, allowing more than one variety in the same vineyard/year. `harvest` stores the same grape-variety key and references the exact planting row.
- **Refund grain.** `refund` stores `productId` with `customerOrderId` and uses a composite foreign key to `orderline`, so a refund cannot refer to a product that was not part of the order.
- **Picking-pack history.** `joinedDate` is part of the `packmember` primary key. A picker can leave and later rejoin the same pack, while an overlap trigger prevents simultaneous membership periods.
- **Historical contacts.** Employee and supplier address periods cannot overlap for the same address kind. Customer address history records a purpose (Primary, Delivery, Billing or Correspondence) and cannot overlap within the same purpose. This permits legitimate concurrent Delivery and Billing addresses in the supplied v4 data. Employee, customer and supplier phone history allows retained numbers but prevents more than one current primary phone.
- **Wine composition.** Row percentages remain individually constrained, while a cross-row validation procedure requires a wine recipe to contain at least one variety and total exactly 100% before an active product is released. Released recipes are locked against ad-hoc composition edits until their products are deactivated.
- **Shift integrity.** `shiftassignment` no longer stores independent regular/overtime totals alongside shift times. It stores actual start time, actual end time and break minutes. Labour hours and overtime are derived in reporting queries, removing the duplicate fact that the tutor identified.
- **Role history.** Existing role-overlap triggers already implement the tutor clarification that the previous role must finish before the next active role starts.
- **Sustainability reporting.** The selected HR perspective is measured through two explicit quantitative indicators: annual completion coverage for both Safety and Sustainability training, and workplace incidents per 1,000 actual labour hours. The second metric uses the revised derived assignment hours as its denominator.

These controls are additional to the five assessed Task 3b rules below. They are included because they protect the model and the final decision-support results even where they are not selected as one of the five screenshot rules.

## 3b. Five assessed database-enforced business rules

### Rule 1 — Historical role dates

- **Rule:** An employee role end date/time cannot precede its start date/time.
- **Case source:** Personnel requires role history with start and end dates (Wine Company Case, pp. 1–2).
- **Mechanism:** `chk_employeerole_dates` CHECK.
- **Violation:** `database/tests/task3b_ruleviolations.sql` creates a temporary test employee inside a transaction and inserts an end in May before a June start.
- **Expected result:** MySQL Error 3819 naming `chk_employeerole_dates`.
- **Genuine Workbench evidence:** `Genuine local Workbench capture available in docs/evidence/final-workbench (2026-10-07); submitting students review before submission.`

### Rule 2 — Bottle reorder explanation

- **Rule:** `reorderFlag = FALSE` requires a nonblank explanation.
- **Case source:** Bottle quality problems and reasons for not reordering must be recorded (Wine Company Case, p. 3).
- **Mechanism:** `chk_bottletype_reorder` CHECK.
- **Violation:** `database/tests/task3b_ruleviolations.sql` supplies NULL inside an isolated transaction.
- **Expected result:** MySQL Error 3819 naming `chk_bottletype_reorder`.
- **Genuine Workbench evidence:** `Genuine local Workbench capture available in docs/evidence/final-workbench (2026-10-07); submitting students review before submission.`

### Rule 3 — Current physical shipment address

- **Rule:** Shipment must use the customer's current physical address, never a PO Box or Private Bag.
- **Case source:** Orders are delivered to the current physical address and not postal addresses (Wine Company Case, p. 5).
- **Mechanism:** shipment insert/update triggers inspect `address` and current `customeraddress` rows.
- **Violation:** `database/tests/task3b_ruleviolations.sql` uses current PO Box `ADDR0004`.
- **Expected result:** MySQL Error 1644 with the physical-address message.
- **Genuine Workbench evidence:** `Genuine local Workbench capture available in docs/evidence/final-workbench (2026-10-07); submitting students review before submission.`

### Rule 4 — Paid before shipment

- **Rule:** An order must have `paidFlag = TRUE` before shipment.
- **Case source:** The order is shipped only after accounting confirms payment (Wine Company Case, p. 5).
- **Mechanism:** shipment insert/update triggers read `customerorder.paidFlag`.
- **Violation:** `database/tests/task3b_ruleviolations.sql` creates an unpaid order inside a transaction and attempts shipment.
- **Expected result:** MySQL Error 1644: `Order must be paid before shipment`.
- **Genuine Workbench evidence:** `Genuine local Workbench capture available in docs/evidence/final-workbench (2026-10-07); submitting students review before submission.`

### Rule 5 — One supervisor at a point in time

- **Rule:** A supervised employee may have only one supervisor at any point in time.
- **Case source:** Each supervised employee reports to only one supervisor and supervisor history is retained (Wine Company Case, p. 1).
- **Mechanism:** supervision insert/update overlap triggers.
- **Violation:** `database/tests/task3b_ruleviolations.sql` inserts a second current supervisor for `EMP0008` inside an isolated transaction.
- **Expected result:** MySQL Error 1644 with the overlapping-supervision message.
- **Genuine Workbench evidence:** `Genuine local Workbench capture available in docs/evidence/final-workbench (2026-10-07); submitting students review before submission.`

The submitted rule script rolls back its transactions; standalone screenshot setup rows were removed by the final clean rebuild. Readable assessed SQL is in `database/tests/task3b_ruleviolations.sql`. Legal-age, postal-address completeness, cancelled-shipment and shipment-date validation remain additional controls rather than assessed Task 3b rules.
