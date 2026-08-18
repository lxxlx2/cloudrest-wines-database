# Cloudrest Wines Delivery Instructions

## Current status

The authoritative source files have completed the current manual-audit correction pass. On the working branch `audit/final-manual-fixes`, successful source verification now automatically refreshes the generated database SQL, query SQL and data dictionary.

The following branch files are current generated technical artifacts after the latest verified refresh:

- `Cloudrest_Wines_Database.sql`
- `Cloudrest_Wines_Queries.sql`
- `docs/report/data-dictionary.csv`
- `docs/report/data-dictionary.md`

The Word report, Workbench model and ER image still require genuine student/manual completion before submission.

## Final submission components

The main course submission is expected to contain:

1. `Cloudrest_Wines_Report.docx`, submitted through the Turnitin report point after genuine evidence and final student information are inserted.
2. `Cloudrest_Wines_Database.sql`, the portable MySQL build containing tables, constraints, data, reporting objects and the six decision-support queries.
3. `Cloudrest_Wines_Video.mp4`, recorded by the four team members.
4. GenAI Reflection, completed separately through RiPPlE using genuine prompt progression and the tutor-confirmed peer-review requirement.

Support files such as `Cloudrest_Wines_Queries.sql`, `Cloudrest_Wines_Rule_Violations.sql`, `.mwb`, ER PNG and screenshots should be retained for report preparation, video demonstration and explanation. Upload them as extra attachments only if the final Blackboard submission page requests them.

## Student workflow

Students do not need Git. Use the files supplied directly by the project coordinator and follow `deliverables/student-pack/01_学生操作手册.md`.

### 1. Build the database

1. Open the student's MySQL Workbench connection.
2. Choose **File → Open SQL Script**.
3. Open `Cloudrest_Wines_Database.sql`.
4. Execute the complete script with the lightning icon.
5. Refresh **SCHEMAS** and confirm `cloudrestwines` exists.
6. Stop and report the full error if the clean import does not complete successfully.

The script intentionally drops and rebuilds `cloudrestwines`. Do not run it against a database containing irreplaceable work.

### 2. Finalise the ER model

1. Open `Cloudrest_Wines_Model.mwb` in MySQL Workbench.
2. Open the complete EER diagram.
3. Select **Model → Relationship Notation → UML**.
4. Arrange the complete model on a wide landscape canvas.
5. Save the `.mwb` after selecting UML.
6. Re-export the complete ER PNG.
7. Confirm entity names, attributes, PK/FK markers and cardinalities remain readable at report size.

Follow `docs/evidence/workbench-model-finalization.md`.

### 3. Capture the 14 unique Workbench screenshots

Follow `docs/evidence/student-screenshot-checklist.md`.

The current evidence plan requires six rule/integrity screenshots and eight query/procedure/EXPLAIN screenshots. Overlapping Task 3 and Task 6 tests reuse the same genuine execution image where appropriate.

### 4. Complete the Word report using Scheme B

One team member manually completes the Word report:

1. Insert each genuine Workbench screenshot at its matching evidence placeholder.
2. Reuse the same genuine test screenshot where Task 3 and Task 6 reference the same executed test.
3. Insert the final UML landscape ER image in the Task 4 location.
4. Remove each completed placeholder after the real evidence has been inserted.
5. Keep SQL code as readable report text. Screenshots provide execution evidence.
6. Add short figure captions.
7. Open the report at 100% zoom and check readability and page layout.

### 5. Complete later course-dependent material

When the Official A2 Workbook is supplied, complete actual data profiling, cleaning SQL, before/after evidence, accepted/rejected reconciliation and production-import verification. Do not invent workbook-specific findings in advance.

When the Week 11 Assigned Scenario is supplied, complete the exact allocated scenario and preserve its actual SQL/results/evidence.

### 6. Complete genuine student information

Before final submission, confirm:

- Mia, Zora, Rianna and Jason are shown with their enrolled full names where required.
- all four real student numbers are entered.
- submission date is entered.
- actual completion dates and contribution information reflect genuine team activity.

### 7. Complete RiPPlE and video

Use `docs/reflection/reflection-capture-pack.md` to preserve genuine prompt progression. Keep `docs/requirements/tutor-confirmations.md` unchanged until the Tutor/LMS confirms the unresolved peer-review and specification conflicts.

Use `docs/video/five-minute-script.md` for the four-person video run sheet. The video should execute all six queries and call `getExpiringQualifications` with both 30 and 90.

## Current technical expectations

After a clean build of the current verified sources, the expected design contains 55 base tables, one view, 282 columns, 72 foreign keys, 48 CHECK constraints, 43 triggers and five stored routines. The student's live MySQL metadata remains the final technical source of truth.

## Items still required before final submission

- Official A2 Workbook cleaning and genuine evidence
- Week 11 Assigned Scenario
- final UML Workbench model and landscape ER export
- 14 genuine Workbench screenshots
- completed Word report with placeholders removed
- four-person video
- genuine RiPPlE prompt progression and tutor-confirmed peer review
- four student numbers, submission date, actual completion dates and contribution records
- final visual and technical QA

## Tutor questions

Keep and use `docs/requirements/tutor-confirmations.md`. It records the unresolved course-source questions so the team can ask the Tutor directly and update the project only after a real answer is received.
