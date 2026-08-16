# Final Manual-Audit Handoff

## Branch baseline

- Base: `18bd120c415073042251a78a70ab1120bb794485`
- Working branch: `audit/final-manual-fixes`
- Draft PR: #1

## Source changes completed

The final manual audit has corrected the authoritative sources for:

- supplier physical/postal address coexistence with same-type overlap protection
- supplier phone history semantics
- employee/customer primary-phone period uniqueness
- customer subtype consistency
- future-dated shipment-address rejection
- receipt-line validation against purchase-order lines
- product-price validity-period overlap
- Query 4 `AFFECTED` incident semantics
- Query 1 metric wording
- customer/shipment Case page citations
- Task 3 report ordering
- real Word landscape/portrait section creation
- development/final-mode metadata handling
- explicit Workbench UML and landscape finalisation
- expanded verification and additional integrity tests

The five assessed Task 3b business rules and the five assessed Task 6 integrity tests remain unchanged.

## Expected schema effect after regeneration

The table/column/FK/CHECK structure is unchanged by this final pass. The authoritative trigger source now contains 28 triggers, because 13 additional controls were added to the previously verified 15-trigger design.

The actual live count must be confirmed by the expanded verifier after `Cloudrest_Wines_Database.sql` is rebuilt.

## Generated artifacts currently stale until rebuilt

Do not audit the following files as final outputs until the regeneration sequence has been run:

- `deliverables/final-submission/Cloudrest_Wines_Database.sql`
- `deliverables/final-submission/Cloudrest_Wines_Report.docx`
- `deliverables/final-submission/Cloudrest_Wines_Verification_Report.docx`
- `deliverables/final-submission/Cloudrest_Wines_Model.mwb`
- `deliverables/final-submission/Cloudrest_Wines_ER_Diagram.png`
- `verification/verification-report.json`
- `verification/verification-report.md`
- final SHA-256 manifest

`Cloudrest_Wines_Queries.sql` has been manually refreshed for the corrected Query 1/4 source logic, but it should still be rebuilt by the normal builder for reproducibility.

## Required local regeneration

1. `python3 tools/build_submission_sql.py`
2. clean-import the rebuilt SQL into MySQL 8.4
3. run `python3 tools/verify_project.py`
4. rebuild `.mwb` and diagrams inside MySQL Workbench
5. manually select UML relationship notation, arrange the complete model landscape, save, and re-export
6. run verification again
7. run `python3 tools/build_word_reports.py`
8. render/visually inspect the Word report
9. capture and insert genuine student Workbench screenshots
10. rerun final-mode checks only after genuine student/course data is present

## Manual items that remain intentionally unresolved

- official A2 workbook and real cleaning evidence
- Week 11 assigned scenario
- genuine student screenshots
- final Workbench UML confirmation and final ER export
- four-person video
- genuine RiPPlE prompt iterations and peer reviews
- fourth member name, student numbers, submission date, actual completion dates/hours/contributions
- tutor-confirmation questions in `docs/requirements/tutor-confirmations.md`

## External reviewer guidance

Review source changes on PR #1 first. Do not judge the branch by the previous `64/64` verification report because that report predates this manual-audit pass. A new expanded verification result is required after regeneration.
