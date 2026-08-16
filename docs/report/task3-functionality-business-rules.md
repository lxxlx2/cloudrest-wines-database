# Task 3 — Database Functionality and Business Rules (Working Draft)

## 3a. Functionality description

Cloudrest Wines requires an operational database because its spreadsheet and document records no longer support business growth, government reporting or retained history. The proposed MySQL 8.x system integrates personnel, vineyards, grape varieties, harvests, wines, products, bottle procurement, customers and orders. The selected Human Resources, Workforce Planning and Wellbeing extension adds qualifications, training, shifts, labour allocation, incidents, corrective action and manager check-ins. These records support two defined sustainability measures: annual safety/sustainability training coverage and incidents per 1,000 labour hours.

The logical design targets third normal form. Repeating groups such as phones, wine components, order lines and training participants are represented by separate tables. Many-to-many relationships use associative tables, including `winecomposition`, `trainingattendance` and `incidentemployee`. Time-dependent facts are not overwritten: employee role, supervisor, phone and address associations retain start and end timestamps, while product prices retain effective dates. These structures reduce insertion, update and deletion anomalies while preserving an audit trail.

The database follows OLTP principles by storing one fact in one authoritative location, using short stable identifiers, enforcing referential integrity and separating transactions from derived reports. For example, a training course definition is stored once, each delivery is a `trainingsession`, and each employee outcome is a `trainingattendance` record. Purchase orders are separated from receipts because one order may arrive in multiple shipments. Customer orders retain the actual shipment-address key so a later customer move does not alter the historical transaction. Reporting logic is implemented through read-only queries and a view rather than storing duplicated totals.

Input controls combine appropriate types, domains and database constraints. Enumerated domains restrict employment, address, incident, training and order statuses. `NOT NULL`, `UNIQUE` and range `CHECK` constraints prevent incomplete or implausible records. Composite keys prevent duplicate relationship instances. Foreign keys specify deliberate update/delete actions. Triggers enforce cross-row or cross-table rules that row-level checks cannot express, including preventing overlapping role/supervisor histories and blocking shipment to a postal address. Test data includes valid cases, boundary conditions and expected failures.

Security is based on least privilege and data minimisation. TFNs, dates of birth, contact details, incident records and wellbeing notes are sensitive. Production access should be divided into administrator, HR manager, safety officer, supervisor and de-identified report-viewer roles. Ordinary reporting should identify employees by internal ID and expose aggregated concern counts rather than confidential notes. TFNs should be encrypted or masked outside authorised HR workflows, exports should omit unnecessary personal data, and all development/test records must remain fictitious. Backups and SQL exports require the same access controls as the live database.

The design deliberately excludes payroll, detailed payment instruments, delivery-cost accounting and inventory for corks, labels, barrels and packing boxes. Those functions remain in external accounting or purchasing processes, as specified by the case. This boundary keeps the database transaction-focused while providing management with reliable workforce and sustainability information.

## 3b. Five database-enforced business rules

### Rule 1 — Historical role dates

**Plain-English rule.** An employee role appointment may be current with no end date, but if an end date/time is recorded it cannot precede the start date/time. This implements the case requirement to retain personnel history using start and end dates.

**Mechanism.** `CHECK (endDateTime IS NULL OR endDateTime >= startDateTime)` on `employeerole`.

**Violation evidence.** Insert a new employee role with an end in May 2026 and a start in June 2026. MySQL returns Error 3819 for `chk_employeerole_dates`.

### Rule 2 — Bottle reorder explanation

**Plain-English rule.** When a bottle type is flagged not to be reordered, a non-blank explanation must be stored, particularly where quality or sourcing problems exist.

**Mechanism.** A `CHECK` requires either `reorderFlag = TRUE` or a non-empty `reorderComment`.

**Violation evidence.** Insert a bottle with `reorderFlag = FALSE` and a NULL comment. MySQL returns Error 3819 for `chk_bottletype_reorder`.

### Rule 3 — Referenced training-course retention

**Plain-English rule.** A training course that is already referenced by a delivered session cannot be deleted because doing so would destroy the meaning of employee training history.

**Mechanism.** `fk_trainingsession_course` explicitly uses `ON DELETE RESTRICT ON UPDATE CASCADE`.

**Violation evidence.** Attempt to delete `TRCR001`, which has several session records. MySQL returns Error 1451 and identifies the foreign key.

### Rule 4 — Physical shipment address

**Plain-English rule.** A customer order must be shipped to the customer's current physical address and never to a PO Box or private bag. It must also be paid before shipment.

**Mechanism.** `trg_shipment_validate_insert` reads the order, address and current customer-address association before allowing a shipment.

**Violation evidence.** Create a paid order and attempt shipment to `ADDR0004`, a current PO Box address. The trigger raises Error 1644 with a purpose-written message.

### Rule 5 — Grape juice conversion percentage

**Plain-English rule.** The case defines a grape variety's juice conversion ratio as a percentage. It must therefore be greater than zero and cannot exceed 100 percent.

**Mechanism.** `CHECK (juiceConversionPercent > 0 AND juiceConversionPercent <= 100)` on `grapevariety`.

**Violation evidence.** Insert a test grape variety with a conversion ratio of 120 percent. MySQL returns Error 3819 for `chk_grapevariety_conversion`.

The readable demonstration SQL is maintained in `database/tests/task3b_ruleviolations.sql`. Final MySQL Workbench screenshots should be inserted immediately after each rule in the Word report.
