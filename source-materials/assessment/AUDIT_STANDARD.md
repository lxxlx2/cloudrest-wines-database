# BISM2207 independent audit standard

Purpose: give an independent reviewer a single structured checklist derived from the four student-supplied assessment documents. This file is an audit map, not a replacement for the original PDFs. Where wording or numbering conflicts between source documents, the conflict is preserved below.

## 1. Project baseline

- Team project, normally 4 to 5 students.
- Build a MySQL database for the Wine Company Case.
- MySQL 8.x and MySQL Workbench are required.
- AI may be used as a support tool, but the team must demonstrate its own judgement and understanding.
- The project must implement the complete base Wine Company model plus one selected perspective.
- Current selected perspective for Cloudrest Wines: Human Resources, Workforce Planning and Wellbeing.
- A sustainability-reporting initiative must be supported by the selected perspective.
- The team must execute SQL on its own database and be able to explain/defend design choices.

## 2. HR perspective requirements

The HR perspective extends the base model to support workforce planning, safety and wellbeing. The design should cover, at minimum:

- employee profiles and role/employment information
- full-time/part-time and casual/permanent status, with seasonal characteristics where appropriate
- qualifications
- training and certifications
- shifts and labour allocation
- hours worked and overtime
- task category
- supervisor relationships
- health and safety incidents
- wellbeing/engagement manager check-ins

Example sustainability measures supplied by the assignment include:

- percentage of workforce completing annual safety/sustainability training by department/operational area
- year-on-year incident rate per 1,000 labour hours

These examples are starting points, so an additional justified HR sustainability measure may be proposed.

## 3. Wine Company Case requirements that must remain represented

### Personnel

- unique role identifier, role name and role description
- employees can change roles over time
- record full-time/part-time and casual/permanent as part of role history
- each supervised employee reports to one supervisor at a time
- supervisors ultimately report to Christine
- casual employees can be seasonal and report to the grape-farmer supervisor
- unique employee identifier
- employee name, tax file number, address and phone
- multiple employee phones with a primary contact
- preserve history of role, supervisor, address and phone using start/end dates; current end date is null
- seasonal casual employees are rated by a supervisor at the end of the season
- a role can be held by multiple employees
- every picker belongs to a picking pack
- a picking pack contains at least four pickers
- pack has a name and all members report to the same grape-farm supervisor

### Vineyard and grape varieties

- multiple vineyards with unique names
- decimal vineyard area
- each vineyard managed by a grape farmer
- no employee manages more than one vineyard
- vineyard location and GPS point
- one grape variety per vineyard per vintage year
- preserve planting/replanting history
- grape variety records include juice conversion percentage, storage-container type and ageing days
- harvest records include vineyard, vintage/harvest information, grape weight and ripeness percentage

The case states current vineyards range from 2 to 42 hectares. Treat this as descriptive current-state information unless explicitly documented as a design assumption; do not automatically make it a permanent allowed range.

### Wine, products and bottles

- wine has unique identifier, name, vintage year, category and alcohol percentage
- medal history includes medal, year and awarding organisation
- record employee responsible for making wine
- wine can be a single variety or blend
- record proportion of each grape variety in a wine
- wines are not vineyard-specified
- product is a specific wine, bottle size, case quantity and price
- no partial cases and no mixed wine/bottle type in one case
- bottle type includes unique code, capacity, shape, material, colour, stock count and usual cost
- bottle types that can no longer be sourced are flagged
- when a bottle should not be reordered, the record needs a reorder flag and explanatory comment

### Suppliers and procurement

- supplier has unique identifier, name, address, phone, principal contact name and contact email
- a bottle type may have multiple possible suppliers
- each purchase order is for one supplier and may contain multiple bottle types
- supplier order may be delivered across multiple receipts/shipments because of backorder
- record quantities ordered and received, dates ordered/received and actual price
- supplier physical and optional postal address history should be preserved consistently with the Address section

### Customers and orders

- customers include restaurants, wine shops, Australian businesses/export companies and individuals
- unique customer identifier
- customer address, email and multiple phones with main/primary phone
- individuals have first/last name and date of birth to demonstrate legal age
- business customer stores contact first/last name, company name and ABN
- no direct overseas customer shipping
- customer order has unique number/date and one or more product/quantity lines
- shipment goes to the current customer physical address
- shipment must never use a PO Box or Private Bag
- pending status before shipment, shipped status after shipment
- customer order is fulfilled in one shipment; no customer backorders
- verified transit damage can produce a monetary refund

### Addresses

- customers, suppliers, employees and vineyards require a physical address
- customer, supplier and employee may change addresses
- system must know which address was valid on a given date
- optional postal addresses may include PO Boxes and Private Bags
- postal addresses are for accounts/mail-outs and never for order shipment
- preserve postal-address history
- vineyard GPS location does not change

### Scope exclusions/limitations

- payroll is outside scope
- accounting systems remain external
- payment method/refund payment-account details remain external, although a paid indicator is stored for shipment control
- delivery costs are handled by accounting
- refund records are required for unfillable desired products and verified shipping damage
- inventory outside the case-identified inventory is excluded

## 4. Task-by-task specification

### Task 1: Project Plan with Risk Register, 10%

Required project plan should cover checkpoints, iteration and final submission. It must include:

- task description
- responsible team member(s)
- estimated hours
- target completion date
- actual completion date as progress occurs
- risk/challenge
- mitigation

Shared tasks must identify one individual responsible for the final deliverable. For HD quality, sequencing, outputs, coordination, shared accountability and realistic contingencies should be clear.

### Task 2: Design Decision Record, 10%

- maximum 1,200 words
- four genuinely different design decisions
- each should identify the design challenge and case source
- consider at least two valid alternatives
- state chosen approach and justify using normalisation, OLTP and/or business requirements
- decisions must trace to the actual ER model
- include a brief selected-perspective and sustainability-initiative description, maximum 150 words

For HD quality, explicitly discuss relevant trade-offs such as integrity, performance, data quality, controls/security and extensibility.

### Task 3: Database Functionality and Business Rules, 10%

#### 3a Functionality

- maximum 800 words
- explain how the design addresses the business problems
- state normalisation level
- discuss OLTP design
- discuss input controls/data validation
- discuss security/privacy, especially sensitive data such as TFN, DOB and ABN

#### 3b Business rules

- identify five specific business rules supported by the case
- explain each in plain English and cite the relevant case section/page
- enforce each at database level using appropriate CHECK, FK with explicit referential actions, and/or trigger
- include SQL code as readable text
- include MySQL evidence showing rule violation/rejection
- five rules should be distinct

Current Cloudrest assessed rules are intended to remain:

1. employee role end date/time cannot precede start date/time
2. reorderFlag FALSE requires a nonblank reorderComment
3. shipment must use the customer's current physical address and not PO Box/Private Bag
4. order must be paid before shipment proceeds
5. a supervised employee may have only one supervisor at a given point in time

Additional integrity controls may exist but should not silently replace the five assessed rules.

### Task 4: ER Diagram with Annotated Design Alternatives, 15%

- computer-generated in MySQL Workbench
- UML class-diagram notation required by specification
- fully normalised and suitable for OLTP
- show entities, attributes, PKs, FKs, relationships and cardinalities
- complete base model plus selected HR perspective
- assumptions table directly below the diagram
- assumptions must resolve ambiguity without contradicting the case
- annotation table for three meaningful entities/relationships/structural decisions: design element, alternative approach, reason for choice
- avoid trivial naming-only alternatives

For HD quality, the model should be precise, internally consistent, extensible and readable.

### Task 5: Data Dictionary and database build, 10%

For every table/attribute provide a Word-table dictionary containing:

- table name
- attribute name in lowerCamelCase
- data type and size
- valid domain/range
- null/not-null
- unique
- PK yes/no
- FK reference
- definition/business purpose

Table naming requirement: lowercase, no spaces, no underscores, plural forms avoided according to specification wording.

Demonstrate compound-key knowledge. The dictionary should be manually presented in Word and align exactly with the ER model and implemented schema. Database must build without error.

### Task 6: Data Cleaning, Test Data and Integrity Verification, 10%

#### 6a Official supplied workbook

When the official A2 workbook is supplied:

- identify all supplied-data errors
- cover type mismatch, inconsistent formats, missing required data and referential-integrity problems
- document detection, correction and prevention strategy
- use SQL cleaning where appropriate
- provide before/after evidence
- explain import and verification

Do not fabricate workbook-specific findings before the official workbook is available.

#### 6b Added test data

- explain how test data was created, including AI use if applicable
- verify suitability for the schema
- add enough data to exercise the design, business rules and all six queries
- include boundary cases and plausible anomalies for HD quality

#### 6c Integrity verification

Provide five test cases. Each needs:

- plain-English scenario
- SQL statement
- screenshot/result evidence
- one-sentence explanation
- both positive and negative cases overall
- at least two tests directly linked to Task 3b rules

### Task 7: Decision-support SQL, 15%

The main specification is internally inconsistent because one section says five queries while the overview, detailed collective requirements and video repeatedly require six. Current project strategy is to supply six and ask the tutor to confirm.

All six should collectively satisfy:

- based on selected HR perspective
- two sustainability queries
- all are multi-table queries
- demonstrate different join types
- at least three queries use date logic in at least three different ways
- at least one query is based on a view and includes CREATE VIEW in the query submission
- at least one query uses a stored procedure/function with at least one input parameter and includes creation script
- video calls the procedure with at least two parameter values
- one query includes EXPLAIN plus maximum 100-word discussion of one efficiency/performance point
- all code submitted as readable text, not screenshots
- output screenshot for each query from the cleaned plus added-test-data database
- 2 to 4 sentences explaining management decision value for each query

Routine lookups are insufficient. Outputs must be useful for management planning or decisions.

### Task 8: Video Presentation, 10%

- maximum five minutes
- state selected perspective and sustainability initiative
- at least one member explains a Task 2 design decision in their own words, including trade-off
- execute all six queries in MySQL Workbench
- call stored procedure/function with at least two parameter values and show differing results
- every team member appears
- contribution of each member is clear
- assessable qualities include content, knowledge and professional delivery

Rubric splits video into Structure + Demonstration 5% and Communication & Audience Impact 5%.

### GenAI Reflection, 10%

Main specification labels this inconsistently as Task 9 in overview and Task 10 later. It is submitted separately through RiPPlE.

Main-assignment requirements include:

- one group reflection
- two prompt examples from different allowed project stages: ideation/requirements, conceptual modelling, SQL/query/constraint development
- general report writing, grammar correction, assessment summarisation or asking AI to complete the assessment are unsuitable examples
- show prompt evolution through revisions to a satisfactory output
- at least two revised versions for each example
- evaluate each iteration, including useful, incorrect/incomplete elements and what changed
- explain validation using course knowledge, modelling principles, database documentation, testing or other evidence

The separate RiPPlE PDF additionally specifies:

- problem statement minimum 20 words
- evaluation minimum 100 words
- prompt revision explanation minimum 50 words
- improved-output discussion minimum 50 words
- at least two iterations for each example

Peer-review instructions conflict across documents and must be confirmed with tutor:

- main assignment: each group reviews two prompt-log examples from another group; overall review under 100 words; two peer reviews total per group
- RiPPlE PDF: each student provides at least two constructive comments on another student's reflection
- rubric HD: more than two constructive peer comments

Do not silently resolve this conflict.

## 5. Iteration and checkpoints

Project timeline in the specification includes:

- Week 3 team formation
- Week 4 Checkpoint 1: case understanding, selected perspective, initial functionality plan
- Week 7 Checkpoint 2: draft ER and early design decisions
- Week 8 Friday iteration submission
- Week 10 Checkpoint 3: normalisation, cleaning plan, draft business rules
- Week 11 Checkpoint 4: draft queries and tutor-assigned business scenario
- Week 12 final submission
- Week 13 plus one week: Buddycheck peer review

Iteration Word draft should include at least:

- updated Task 1
- Task 2 with at least two decisions
- Task 3 functionality draft plus at least two implemented business rules
- draft ER
- partial data dictionary acceptable
- cleaning plan plus partial cleaning
- at least two queries with results

Late iteration normally receives no feedback without approved extension.

## 6. Final submission requirements

Main final submission materials:

1. Word report through Turnitin containing all tasks except the separate AI reflection, including written content and screenshots
2. MySQL `.sql` export containing tables, constraints, data, stored procedures, views and queries
3. video presentation
4. GenAI reflection separately in RiPPlE
5. individual mark may be adjusted through Buddycheck and tutor judgement

Formatting:

- Times New Roman 12-point
- single spacing
- tables may use 10-point
- APA referencing
- cover sheet with all contributing enrolled names, group/wine-company name and submission date
- ER diagrams embedded as clear images in the report

## 7. HD rubric targets

An independent audit should assess against the High Distinction descriptors, not just minimum task compliance.

### Planning 10%

Look for coherent collaborative sequencing, clear responsibility/timing/output ownership, shared accountability, realistic risks and feasible contingency responses.

### Design justification and systems thinking 10%

Look for integrated reasoning across business requirements, data quality, normalisation, OLTP, controls/security and explicit trade-offs resolved in the case context.

### Stakeholder and community requirements 10%

Look for translation of stakeholder/community needs into requirements, assumptions and constraints. Include less-obvious users/exceptions and show how competing needs are prioritised.

### Conceptual data modelling 15%

Look for precise UML-compliant ER modelling, accurate entities/relationships/attributes/cardinalities, normalisation/OLTP suitability, explicit assumptions and foreseeable extensions.

### Logical design and data dictionary 10%

Look for complete table-organised dictionary, PK/FK including compound keys, appropriate data types/constraints, business-context definitions, exact ER alignment and clean database build.

### Data quality 10%

Look for completeness, consistency and accuracy strategy, SQL validation, real error correction, boundary cases and plausible anomalies.

### Decision-support SQL 15%

Look for error-free meaningful queries, suitable SQL features, clean/tested data, management decision value and sustainability/social/public-value relevance. Note the query-count conflict and audit six in the current project unless tutor directs otherwise.

### Reflection 10%

Look for purposeful refinement across two examples, multiple iterations, explicit strengths/limitations, validation and constructive peer feedback. Preserve the peer-review conflict for tutor confirmation.

### Video 10%

Look for a concise professional system demonstration with correct decision-support outputs, clear links between problem/design/outputs and strong communication of organisational/public value.

## 8. Independent-review protocol

When auditing the Cloudrest Wines repository:

1. Use this audit standard and the original source PDFs if available.
2. Audit authoritative source files before generated artifacts.
3. Check that every report/database claim is traceable to the case, selected HR perspective, explicit assumption or assessment requirement.
4. Flag any extra rule that over-constrains the case.
5. Check SQL semantics as well as successful execution.
6. Check ER/data dictionary/schema/report consistency.
7. Distinguish automated QA from genuine student evidence.
8. Do not count placeholder screenshots, synthetic CLI images, fabricated RiPPlE logs or invented A2 findings as completed evidence.
9. Preserve unresolved source conflicts rather than choosing silently.
10. Report findings by severity: blocking requirement, likely mark loss, HD improvement, optional robustness improvement.

## 9. Known source conflicts requiring confirmation

- SQL query count: some text says five; overview/detailed requirements/video repeatedly say six.
- GenAI numbering: overview uses Task 9; later specification calls it Task 10.
- FAQ refers to assigned Business Scenario as Task 8 while Task 8 elsewhere is Video Presentation.
- RiPPlE peer-review requirement differs between main assignment, separate RiPPlE instructions and HD rubric.
- Wine Case conclusion contains a reference to a Vineyard Operations & Sustainability perspective that does not match the two current perspective options in the main specification; treat it as potentially stale unless tutor confirms otherwise.

See `docs/requirements/tutor-confirmations.md` for the live question list.
