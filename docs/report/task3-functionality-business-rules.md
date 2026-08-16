# Task 3 — Functionality, Stakeholders and Business Rules

## 3a. Functionality description

Cloudrest Wines needs a transactional database because spreadsheet and document records no longer scale to business growth, biosecurity reporting and sustainability evidence (Wine Company Case, p. 1). The MySQL system integrates personnel, vineyard plantings, harvests, wines, bottles, suppliers, customers and orders. The selected HR perspective adds qualifications, training, shifts, labour hours, incidents, corrective actions and confidential wellbeing check-ins (BISM2207 Assessment Specification, p. 2). It supports annual safety/sustainability training coverage and recorded safety-incident rates per 1,000 labour hours.

The design targets 3NF and OLTP use. Repeating phones and addresses are separate entities; temporal association tables preserve employee, customer and supplier contact history and prevent overlapping periods of the same address kind. Course definitions, delivered sessions and individual attendance are separated. Many-to-many facts use associative tables, including wine composition, incident involvement and training attendance. Role, supervisor, address, phone and price histories retain effective dates rather than overwriting facts.

Controls combine types, `NOT NULL`, candidate keys, foreign keys, `CHECK` constraints, triggers and explicit cross-row validation routines. Row constraints reject invalid dates and domains. Triggers enforce rules needing other rows or tables, such as non-overlapping supervision and paid, current, physical shipment addresses. Additional controls validate customer subtypes, ordered receipt lines, completed wine compositions, picking packs, current contact state and shipment/order chronology. Negative test records remain outside the clean baseline.

Privacy is prioritised for TFNs, dates of birth, contact data, incident participation and wellbeing notes. The six management queries expose only decision-relevant identifiers/aggregates and never return TFNs, dates of birth or `confidentialNote`. Production deployment should grant base-table access only to authorised roles and expose reporting through least-privilege accounts/views. `CREATE USER`/`GRANT` statements are deliberately not forced into the portable assessment build because student MySQL accounts may lack account-administration privileges; this deployment boundary is documented rather than claiming an unimplemented security configuration.

Payroll, payment instruments, delivery costing and unrelated inventory remain outside scope, consistent with the case. The system provides reliable operational evidence without adding enterprise functions the four-person team could not explain or validate.

## Stakeholder and community requirements

| Stakeholder | Need / risk | Database requirement | Design response | Priority / trade-off |
|---|---|---|---|---|
| Owners / management | Reliable growth, compliance and sustainability reporting | Integrated operational history and decision queries | Normalised OLTP schema, view and six queries | High; reporting convenience must not duplicate facts |
| HR manager | Accurate employment and confidential wellbeing records | Role/classification history, qualifications and restricted notes | Temporal HR tables; confidential note excluded from routine queries | Privacy overrides managerial curiosity |
| Supervisors | Current teams, hours, training and actions | One supervisor at a point in time; current-role area | Supervision history trigger and area-linked queries | Integrity over flexible duplicate assignments |
| Permanent employees | Correct role/contact history | Current plus historical role, supervisor, address and phone | Dated association tables and current-state validation | High |
| Casual / seasonal employees | Seasonal pattern and fair re-employment evidence | CASUAL + SEASONAL classification and seasonal ratings | Separate employment type and pattern; pack validation | Avoids conflating legal status with work pattern |
| Safety / compliance staff | Multi-person incidents and serious near misses | Many-to-many involvement, severity, nonnegative lost hours | `incidentemployee`; zero lost hours allowed | Safety evidence without unsupported assumptions |
| Customers | Physical delivery plus optional postal correspondence | Multiple dated addresses; shipment validation | Postal retained but blocked for shipment | Delivery integrity takes priority |
| Suppliers | Contact changes without lost procurement history | Address and phone history | `supplieraddress` and `supplierphone` | Extra joins accepted for auditability |
| Regulatory / sustainability users | Reproducible measures without personal leakage | Aggregated training and incident-rate queries | Defined numerators/denominators and safe zero-exposure handling | Accuracy and privacy |
| Community / public value | Safe work and responsible operations | Traceable training, incident and corrective-action evidence | Auditable records using fictitious assessment data | Transparency without exposing private notes |

Exception coverage includes multi-person incidents; employee role, supervisor, address and phone changes; supplier address and phone changes; simultaneous physical/postal addresses; high overtime without an incident; confidential wellbeing notes; a serious near miss with zero lost hours; staged customer subtype loading; and staged wine/pack rows that must pass executable finalisation validation before operational use.

## 3b. Five assessed database-enforced business rules

### Rule 1 — Historical role dates

- **Rule:** An employee role end date/time cannot precede its start date/time.
- **Case source:** Personnel requires role history with start and end dates (Wine Company Case, pp. 1–2).
- **Mechanism:** `chk_employeerole_dates` CHECK.
- **Violation:** `database/tests/t02_invalidroledate.sql` inserts an end in May before a June start.
- **Expected result:** MySQL Error 3819 naming `chk_employeerole_dates`.
- **Genuine Workbench evidence:** `[PENDING STUDENT WORKBENCH SCREENSHOT — RULE 1]`

### Rule 2 — Bottle reorder explanation

- **Rule:** `reorderFlag = FALSE` requires a nonblank explanation.
- **Case source:** Bottle quality problems and reasons for not reordering must be recorded (Wine Company Case, p. 3).
- **Mechanism:** `chk_bottletype_reorder` CHECK.
- **Violation:** `database/tests/t03_missingreordercomment.sql` supplies NULL.
- **Expected result:** MySQL Error 3819 naming `chk_bottletype_reorder`.
- **Genuine Workbench evidence:** `[PENDING STUDENT WORKBENCH SCREENSHOT — RULE 2]`

### Rule 3 — Current physical shipment address

- **Rule:** Shipment must use the customer's current physical address, never a PO Box or Private Bag.
- **Case source:** Customer orders use the current physical address, while postal addresses such as PO Boxes and Private Bags cannot be used for shipment (Wine Company Case, pp. 3–4, “Customers” and “Addresses”).
- **Mechanism:** shipment insert/update triggers inspect `address` and current `customeraddress` rows.
- **Violation:** `database/tests/additional_postalshipment.sql` uses current PO Box `ADDR0004`.
- **Expected result:** MySQL Error 1644 with the physical-address message.
- **Genuine Workbench evidence:** `[PENDING STUDENT WORKBENCH SCREENSHOT — RULE 3]`

### Rule 4 — Paid before shipment

- **Rule:** An order must have `paidFlag = TRUE` before shipment.
- **Case source:** The order is shipped only after accounting confirms payment (Wine Company Case, p. 5).
- **Mechanism:** shipment insert/update triggers read `customerorder.paidFlag`.
- **Violation:** `database/tests/t04_unpaidshipment.sql` attempts shipment for an unpaid order.
- **Expected result:** MySQL Error 1644: `Order must be paid before shipment`.
- **Genuine Workbench evidence:** `[PENDING STUDENT WORKBENCH SCREENSHOT — RULE 4]`

### Rule 5 — One supervisor at a point in time

- **Rule:** A supervised employee may have only one supervisor at any point in time.
- **Case source:** Each supervised employee reports to only one supervisor and supervisor history is retained (Wine Company Case, p. 1).
- **Mechanism:** supervision insert/update overlap triggers.
- **Violation:** `database/tests/t05_overlappingsupervision.sql` inserts a second current supervisor for `EMP0008`.
- **Expected result:** MySQL Error 1644 with the overlapping-supervision message.
- **Genuine Workbench evidence:** `[PENDING STUDENT WORKBENCH SCREENSHOT — RULE 5]`

Readable assessed SQL is in `database/tests/task3b_ruleviolations.sql`. Legal-age, grape-conversion and the additional cross-row controls remain extra integrity evidence rather than replacements for the five assessed Task 3b rules.
