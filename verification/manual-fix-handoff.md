# Final Manual-Audit Handoff

## Branch baseline

- Base: `18bd120c415073042251a78a70ab1120bb794485`
- Working branch: `audit/final-manual-fixes`
- Draft PR: #1

## Audit standard for external reviewers

Start with:

- `source-materials/assessment/SOURCE_INDEX.md`
- `source-materials/assessment/AUDIT_STANDARD.md`
- `docs/requirements/tutor-confirmations.md`

`AUDIT_STANDARD.md` is a structured audit map derived from the four student-supplied source documents: the main assessment specification, BISM2207 rubric, Wine Company Case and separate RiPPlE reflection instructions. It preserves known conflicts instead of silently resolving them.

The original PDFs are not copied into this public repository by automation. If redistribution is permitted, or if the repository is made private, the students can add the four original PDFs next to the audit map for direct source-to-project comparison.

## Source changes completed

Two independent manual-audit passes have now been applied to authoritative sources. The branch includes controls or corrections for:

- supplier physical/postal address coexistence with same-type overlap protection
- supplier phone history semantics
- employee/customer primary-phone period uniqueness
- required-current-state validation for active employee/customer/supplier contacts
- employee/customer same-address-kind temporal overlap
- customer subtype consistency and exact subtype before transaction
- future-dated shipment-address rejection
- receipt-line validation against purchase-order lines
- receipt/order and shipment/order chronology
- at least one order line before shipment and SHIPPED-state protection
- product-price validity-period overlap
- wine composition total validation before saleable product creation
- picking-pack minimum/member/role/supervisor rules through an executable validation procedure
- synthetic picking-pack supervisor alignment to the active Grape Farmer
- vineyard active Grape Farmer manager and physical-address validation
- Query 2 KPI semantics, zero-hour-area visibility and corrected manual reconciliation
- Query 3 latest-completed-safety-training semantics
- Query 4 `AFFECTED` incident semantics and removal of arbitrary risk-score weights
- corrected Case page citations
- Task 3 report ordering
- real Word landscape/portrait section creation
- FINAL_MODE fourth-member replacement, student-number inputs and conditional final checklist state
- Data Dictionary individual-uniqueness semantics and stronger context-specific domains/purposes
- tutor-dependent RiPPlE peer-review wording retained as unresolved
- expanded traceability, assumptions, verification and negative tests

The five assessed Task 3b business rules and the five assessed Task 6 integrity tests remain unchanged. New controls are additional integrity evidence and should not silently replace assessed items.

## Expected schema effect after regeneration

The table/column/FK/CHECK structure remains unchanged by the second pass. The existing trigger files plus `database/schema/04_final_controls.sql` contain an expected total of 43 trigger definitions. The database should contain five stored routines when `getExpiringQualifications`, `validateCustomerSubtype`, `validateWineComposition`, `validatePickingPackRules` and `validateRequiredCurrentState` are installed.

These are source counts only. Actual live counts must be obtained from MySQL 8.4 after `Cloudrest_Wines_Database.sql` is rebuilt and imported.

## Generated artifacts currently stale until rebuilt

Do not audit the following files as current final outputs until the regeneration sequence has been run:

- `deliverables/final-submission/Cloudrest_Wines_Database.sql`
- `deliverables/final-submission/Cloudrest_Wines_Queries.sql`
- `deliverables/final-submission/Cloudrest_Wines_Report.docx`
- `deliverables/final-submission/Cloudrest_Wines_Verification_Report.docx`
- `deliverables/final-submission/Cloudrest_Wines_Model.mwb`
- `deliverables/final-submission/Cloudrest_Wines_ER_Diagram.png`
- `docs/report/data-dictionary.csv`
- `docs/report/data-dictionary.md`
- `verification/verification-report.json`
- `verification/verification-report.md`
- final SHA-256 manifest

## Required local regeneration

Follow `deliverables/final-submission/README_FIRST.md`. In summary:

1. `python3 tools/build_submission_sql.py`
2. clean-import rebuilt SQL into MySQL 8.4
3. `python3 tools/generate_data_dictionary.py`
4. `python3 tools/verify_project.py`
5. `python3 tools/verify_manual_audit_controls.py`
6. rebuild `.mwb` and diagrams inside MySQL Workbench
7. manually select UML relationship notation, arrange the complete model landscape, save and re-export
8. rerun both verification layers
9. rebuild Word reports
10. render and visually inspect the Word report
11. capture and insert genuine student Workbench screenshots
12. run final mode only after genuine student/course inputs exist

## Manual items intentionally unresolved

- official A2 workbook and real cleaning evidence
- Week 11 assigned scenario
- genuine student screenshots
- final Workbench UML confirmation and final ER export
- four-person video
- genuine RiPPlE prompt iterations and tutor-confirmed peer reviews
- fourth member name, four student numbers, submission date, actual completion dates/hours/contributions
- tutor-confirmation questions in `docs/requirements/tutor-confirmations.md`

## External reviewer guidance

Review PR #1 source changes first. Do not use the historical `64/64` report or old generated Word/SQL/ER artifacts as evidence for this branch. A new expanded verification result is required after local regeneration.

For grading-oriented audit, classify findings as:

- BLOCKING
- LIKELY MARK LOSS
- HD IMPROVEMENT
- OPTIONAL ROBUSTNESS

Do not treat automated test success as proof of rubric interpretation, visual legibility, genuine student evidence or tutor-dependent requirements.
