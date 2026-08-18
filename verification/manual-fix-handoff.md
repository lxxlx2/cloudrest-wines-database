# Final Manual-Audit Handoff

## Branch baseline

- Base: `18bd120c415073042251a78a70ab1120bb794485`
- Working branch: `audit/final-manual-fixes`
- Draft PR: #1

## Confirmed team identity

- Mia
- Zora
- Rianna
- Jason

Jason is the confirmed fourth team member. Student numbers, submission date, actual completion dates/hours and genuine contribution records remain pending.

## Audit standard for external reviewers

Start with:

- `source-materials/assessment/SOURCE_INDEX.md`
- `source-materials/assessment/AUDIT_STANDARD.md`
- `docs/requirements/tutor-confirmations.md`

`AUDIT_STANDARD.md` is the structured audit map derived from the supplied assessment specification, rubric, Wine Company Case and RiPPlE instructions. Known source conflicts remain explicit pending tutor confirmation.

## Current source and generated-artifact status

The authoritative schema, query, report-source and verification files have received two grading-oriented manual-audit passes.

The GitHub Actions source-verification workflow now rebuilds and verifies the authoritative SQL under MySQL 8.4. After a successful push verification on `audit/final-manual-fixes`, it automatically refreshes these generated text artifacts on the branch:

- `deliverables/final-submission/Cloudrest_Wines_Database.sql`
- `deliverables/final-submission/Cloudrest_Wines_Queries.sql`
- `docs/report/data-dictionary.csv`
- `docs/report/data-dictionary.md`

These four files therefore no longer belong to the old stale-generated set when the latest auto-refresh commit is present. `Cloudrest_Wines_Database.sql` identifies the team as Mia, Zora, Rianna and Jason and contains the latest controls.

## Artifacts that still require manual/final completion

Do not treat the following as final submission evidence yet:

- `deliverables/final-submission/Cloudrest_Wines_Report.docx`
- `deliverables/final-submission/Cloudrest_Wines_Verification_Report.docx`
- `deliverables/final-submission/Cloudrest_Wines_Model.mwb`
- `deliverables/final-submission/Cloudrest_Wines_ER_Diagram.png`
- `verification/verification-report.json`
- `verification/verification-report.md`
- final SHA-256 manifest

The report is a working evidence-insertion document until genuine Workbench screenshots, the final UML ER export, Official A2 evidence, Week 11 Scenario material and final student metadata are inserted and visually checked.

The `.mwb` and ER PNG remain manual MySQL Workbench gates. The final model must use **Model → Relationship Notation → UML**, be saved after selecting UML, arranged on a readable landscape canvas and re-exported.

## Scheme B final-report workflow

The team will use manual evidence insertion into the current Word report.

1. Use the refreshed `Cloudrest_Wines_Database.sql` to build `cloudrestwines` in MySQL Workbench.
2. Capture the 14 unique genuine Workbench screenshots listed in `docs/evidence/student-screenshot-checklist.md`.
3. Finalise the `.mwb` in UML notation and export the final landscape ER PNG.
4. One team member inserts the genuine screenshots and final ER image into the current Word report and removes the matching placeholders.
5. When the Official A2 Workbook arrives, add the actual cleaning analysis, SQL and before/after evidence.
6. When the Week 11 Assigned Scenario arrives, complete and document the allocated scenario.
7. Fill genuine student numbers, submission date, actual completion dates and contribution records.
8. Visually inspect the completed report at 100% zoom and confirm that all figures, tables, SQL and captions are readable.
9. Run the final verification/QA checks after all genuine course inputs exist.

Students do not need Git. Student-facing instructions are under `deliverables/student-pack/`.

## Current expected schema state

The latest verified source design expects:

- 55 base tables
- 1 view
- 282 columns
- 72 foreign keys
- 48 CHECK constraints
- 43 triggers
- 5 stored routines

Live MySQL metadata after the student's clean import remains the final technical source of truth.

## Manual items intentionally unresolved

- Official A2 Workbook and actual cleaning evidence
- Week 11 Assigned Scenario
- 14 genuine Workbench screenshots
- final Workbench UML confirmation and landscape ER export
- four-person video
- genuine RiPPlE prompt iterations and tutor-confirmed peer reviews
- four student numbers, submission date, actual completion dates/hours/contributions
- tutor-confirmation questions in `docs/requirements/tutor-confirmations.md`

## Tutor-confirmation file

Keep `docs/requirements/tutor-confirmations.md` unchanged until the students receive an actual Tutor/LMS answer. Record the real answer rather than silently choosing an interpretation.

## External reviewer guidance

Technical verification and generated SQL/data-dictionary consistency do not replace visual legibility, genuine student evidence, final Workbench confirmation or tutor-dependent interpretation. Continue classifying findings as BLOCKING, LIKELY MARK LOSS, HD IMPROVEMENT or OPTIONAL ROBUSTNESS.
