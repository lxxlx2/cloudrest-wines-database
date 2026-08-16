# Task 2 — Design Decision Record

## Selected perspective and sustainability initiative

Cloudrest Wines extends the complete winery base model through the Human Resources, Workforce Planning and Wellbeing perspective. Its sustainability initiative measures training coverage and incidents per 1,000 labour hours, supported by overtime, qualification expiry, corrective-action and wellbeing indicators. This differentiates the system from a conventional personnel register: management can relate workforce preparation and exposure to safety outcomes by operational area and period. The design stores only the detail needed for responsible follow-up, while aggregated reporting reduces unnecessary exposure of sensitive wellbeing information.

## Decision 1 — Model customer types with a supertype and subtypes

**Challenge and source.** All customers share identifiers, email, phone, address and order behaviour. Individuals require names/date of birth while businesses require company name, ABN, type and contact names (Wine Company Case, pp. 3–4, “Customers”).

**Alternatives.** A single customer table could contain every attribute, with type-dependent nullable columns. Alternatively, separate individual and business tables could duplicate all shared contact and order relationships. The selected model uses `customer` as the supertype and `individualcustomer`/`businesscustomer` as subtype tables.

**Selected design, justification, trade-off and ER traceability.** `customer` is the supertype and `individualcustomer`/`businesscustomer` are subtypes. The structure avoids duplicated common attributes and inapplicable NULLs, supports 3NF and gives every order one enforceable customer FK. Type-specific controls improve data quality and reduce accidental exposure of date of birth. The trade-off is an extra join. The ER traces one customer to exactly one subtype and to dated contact associations.

## Decision 2 — Separate an address from its time-dependent use

**Challenge and source.** Employee role, supervisor, address and phone history must be retained; customer delivery uses the current physical address; supplier contact details support procurement (Wine Company Case, pp. 1, 3–5).

**Alternatives.** Address columns could be copied into every owner table. A second option is a shared `address` table with owner ID/type columns, but that creates a polymorphic foreign key MySQL cannot enforce. The selected model stores address structure once and uses typed association tables such as `employeeaddress` and `customeraddress` with start/end timestamps.

**Selected design, justification, trade-off and ER traceability.** A shared `address` plus typed `employeeaddress`, `customeraddress` and `supplieraddress` associations provide enforceable FKs and preserve validity periods without overwriting. `phone` is similarly reused by dated owner-specific associations. A shipment retains its address key. More joins and overlap controls are required, but temporal accuracy, controlled updates and extensibility outweigh the performance cost at course scale. The ER traces each owner to contact history and the shipment to the actual address used.

## Decision 3 — Separate training definition, delivery and attendance

**Challenge and source.** The HR perspective requires course, provider, completion, renewal and competency data and annual coverage by operational area (BISM2207 Assessment Specification, p. 2, “Human Resources”).

**Alternatives.** A single employee-training table could repeat course and provider text for every participant. A course table plus employee completion record would reduce repetition but could not represent multiple employees attending one delivery or distinguish repeated sessions. The selected design uses `trainingcourse`, `trainingsession` and `trainingattendance`.

**Selected design, justification, trade-off and ER traceability.** `trainingcourse`, `trainingsession` and `trainingattendance` separate definition, delivery and outcome. This removes update anomalies, validates attendance controls and supports repeated/company-wide delivery. Two indexed joins are the accepted OLTP/reporting trade-off. The ER traces course 1:M session and session M:N employee through attendance.

## Decision 4 — Model incidents and involved employees as many-to-many

**Challenge and source.** A workplace event may involve several affected employees, witnesses or reporters; the HR perspective requires incident type, severity, corrective action and lost time (BISM2207 Assessment Specification, p. 2).

**Alternatives.** Storing one employee ID in `incident` is simple but cannot accurately represent multi-person events. Repeating the incident once per employee creates contradictory copies of severity and corrective action. The selected model stores the event once and associates people through `incidentemployee`, including involvement role and employee-level lost hours.

**Selected design, justification, trade-off and ER traceability.** `incident` stores the event once and `incidentemployee` records people and involvement roles; `correctiveaction` depends on the incident. This prevents contradictory copies, permits privacy-aware person/area analysis and avoids duplicate incident-rate numerators. The associative table is additional complexity but correctly represents cardinality. The ER traces incident M:N employee and incident 1:M corrective action.
