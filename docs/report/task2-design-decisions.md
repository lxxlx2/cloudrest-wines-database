# Task 2 — Design Decision Record (Working Draft)

The final report version must remain within 1,200 words and add precise case citations. This working record preserves the alternatives and rationale that are traceable to the schema.

## Selected perspective and sustainability initiative

Cloudrest Wines extends the complete winery base model through the Human Resources, Workforce Planning and Wellbeing perspective. Its sustainability initiative measures training coverage and incidents per 1,000 labour hours, supported by overtime, qualification expiry, corrective-action and wellbeing indicators. This differentiates the system from a conventional personnel register: management can relate workforce preparation and exposure to safety outcomes by operational area and period. The design stores only the detail needed for responsible follow-up, while aggregated reporting reduces unnecessary exposure of sensitive wellbeing information.

## Decision 1 — Model customer types with a supertype and subtypes

**Challenge.** All customers share identifiers, email, phone, address and order behaviour. Individuals require names and date of birth to evidence legal age, while businesses require company name, ABN, business type and contact names.

**Alternatives.** A single customer table could contain every attribute, with type-dependent nullable columns. Alternatively, separate individual and business tables could duplicate all shared contact and order relationships. The selected model uses `customer` as the supertype and `individualcustomer`/`businesscustomer` as subtype tables.

**Choice and justification.** The selected structure avoids duplicated common attributes and avoids the numerous inapplicable NULLs of a single wide table. It supports third normal form because subtype attributes depend on the customer key and type, while every order references one common customer key. The trade-off is an additional join when displaying full names, accepted in favour of stronger integrity and extension to future business categories.

## Decision 2 — Separate an address from its time-dependent use

**Challenge.** Employees, customers and suppliers can change addresses, historical validity must be retained, postal addresses may be PO Boxes/private bags, shipments must use a current physical address, and vineyard locations do not change.

**Alternatives.** Address columns could be copied into every owner table. A second option is a shared `address` table with owner ID/type columns, but that creates a polymorphic foreign key MySQL cannot enforce. The selected model stores address structure once and uses typed association tables such as `employeeaddress` and `customeraddress` with start/end timestamps.

**Choice and justification.** Typed associations provide enforceable foreign keys and preserve history without overwriting prior values. A shipment stores the actual address key used, preserving the transaction even after a customer moves. Vineyard directly references an address because the case says it does not move. More joins are required, but temporal accuracy, referential integrity and OLTP-safe updates outweigh that cost.

## Decision 3 — Separate training definition, delivery and attendance

**Challenge.** The HR perspective requires course name, provider, completion and renewal dates and competency, while management needs annual training coverage by operational area.

**Alternatives.** A single employee-training table could repeat course and provider text for every participant. A course table plus employee completion record would reduce repetition but could not represent multiple employees attending one delivery or distinguish repeated sessions. The selected design uses `trainingcourse`, `trainingsession` and `trainingattendance`.

**Choice and justification.** Course attributes are stored once; each delivery has its date, trainer, mode and area; each employee outcome stores status, completion, renewal and competency. This removes update anomalies and supports attendance, completion and renewal queries. The design costs two joins in reports, but those joins use indexed keys and preserve a precise operational audit trail.

## Decision 4 — Model incidents and involved employees as many-to-many

**Challenge.** A workplace event may affect several employees and also involve witnesses or reporters. The case extension requires incident type, severity, corrective action and lost time.

**Alternatives.** Storing one employee ID in `incident` is simple but cannot accurately represent multi-person events. Repeating the incident once per employee creates contradictory copies of severity and corrective action. The selected model stores the event once and associates people through `incidentemployee`, including involvement role and employee-level lost hours.

**Choice and justification.** This design prevents event duplication, supports multiple affected employees and permits person- and area-level analysis. Corrective actions depend on the incident rather than an employee copy. The associative table adds complexity, but it is necessary for accurate cardinality and produces a stable 3NF structure suitable for future safety reporting.

