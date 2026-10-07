# Cloudrest Wines finalisation report — 20261007 work round

Prepared 2026-10-08 (Asia/Bangkok); database execution and Workbench evidence frozen on 2026-10-07. Dates and fixture outcomes are preserved as captured, not silently refreshed on the later report date.

## Git identity and publication

- Branch: revision/tutor-feedback-v4-20261007
- Final tested package HEAD / final artifact commit SHA: `8df44ab2ef4e62ee29e8efc969d08e04dd65e436`
- Preserved remote documentation commit: a737655ca3d909775c163deace114bd8896f0892; rebase was conflict-free and affected only source-materials/README.md.
- Final publication HEAD / final report commit SHA: the commit containing this report. Resolve exactly with `git log -1 --format=%H -- verification/finalization-report-20261007.md`; after publication it is also `git rev-parse HEAD` on the unchanged branch. A commit cannot contain its own SHA literally; the immutable tested package SHA above identifies every delivered binary/SQL/evidence file, while this separate report-only publication commit records the handoff.
- Package push: succeeded; no force push, no main modification, no merge of the old audit or source-transfer branches.
- PR #2: https://github.com/lxxlx2/cloudrest-wines-database/pull/2 ; OPEN, description updated; not merged.

## Verification and CI

- MySQL: 8.4.11, isolated local server at 127.0.0.1:33317; empty-database rebuild executed.
- Schema: 55 base tables, 1 view, 286 columns, 72 foreign keys, 50 CHECK constraints, 30 triggers, 3 routines.
- Repository verifier: PASS 73/73, zero required failures, DEVELOPMENT mode. T01–T11, five assessed business rules and all six queries are included. This does not certify unresolved course requirements.
- Separate native model audit: PASS, 55 tables / 276 base columns / 72 FKs / seven UML diagrams; reporting view adds ten dictionary attributes. Key fields and absence of stored regularHours/overtimeHours checked.
- CI tested package: PASS / success (run 37662633921, exact artifact SHA above). Final report-only publication CI must also be checked on its exact HEAD; final user handoff records that run URL and status. Live source: https://github.com/lxxlx2/cloudrest-wines-database/actions/runs/37662633921 .
- No further local rebuild after final frozen screenshots; Query 6 statistics were refreshed with ANALYZE TABLE, then its matching CLI/Workbench plan recaptured.

## Task 6 — official v4

Workbook SHA-256: 88362589a519b6f9aeae031fe806bcf85f0d8b513c12b11f6a4e619ee855c4ac. Supplied local workbook independently checked; no original workbook, private raw CSV/SQL or contact values added by this finalisation to the public branch. Private exports remain ignored under database/local/v4.

Raw staging counts: orders 182, starting addresses 102, history 53 business rows (two blank rows and one source note excluded). Raw rows preserve source values and original Excel row numbers. Source export-reset dates remain unchanged; originals cannot be recovered or invented.

Deterministic clean projections fix six Customer ID rows (cust018, cust015, CUST 019), 24 Rosewood Trail RosÃ© values, nine address mojibake dashes and three Vino Vibes double-space values. One exact ORD125/PROD001 copy at source row 160 is excluded only from the projection. Binary staging collation fixes a demonstrated case-insensitive lowercase-ID false negative; production schema is unchanged.

Seven ambiguous non-exact pairs retain 15 rows: ORD042/PROD003 (2), ORD046/PROD010 (2), ORD054/PROD008 (3), ORD056/PROD008 (2), ORD066/PROD005 (2), ORD110/PROD005 (2), ORD143/PROD003 (2). None were summed, discarded or used to change the production PK.

Accounting: **182 = 1 exact copy excluded + 15 ambiguous rows held + 166 other candidate rows**. The 166 candidates are not approved/accepted production records. Production import: NONE; final source = accepted + rejected reconciliation: **UNRESOLVED** pending actual tutor/business decisions.

Other exceptions: ten mixed-shipment orders; ORD056 mixed payment; 67 distinct full-address strings across 102 rows, 19 duplicate-address groups / 35 additional IDs, two structural-metadata conflicts; three shared-phone groups (2, 2, 3 customers). No automatic canonicalisation. Monetary identity and damaged-quantity violations: zero. Public evidence uses aggregates/source IDs, not contact values.

Genuine E01–E10 Workbench captures and complete TSV outputs are stored in docs/evidence/final-workbench and verification/final-query-results/task6-v4-evidence.tsv. Some multirow grids show only the visible viewport; full results are preserved in TSV.

## Task 7 — six frozen actual query results

All figures below use **synthetic assessment HR fixtures**, not actual winery performance. Each query's report includes tables, joins, date logic, aggregation, actual results, business use, manager, decision/action and risk/limitation.

| Query | Frozen result, 2026-10-07 |
|---|---|
| Q1 training coverage | Administration 3 active / 0 trained / 0.0%; Cellar 4 / 0 / 0.0%; Vineyard 6 / 3 / 50.0% |
| Q2 exposure-adjusted incident rate | Vineyard 88.00 hours / 2 incidents / 2.00 lost hours / 22.73 per 1,000 hours; Cellar 54.00 / 1 / 16.00 / 18.52 |
| Q3 matched training windows | EMP0008 Mia Taylor 1 before / 0 after, 100-day matched window; EMP0002/0003 0/0 at 100 days, EMP0004/0005 0/0 at 70 days |
| Q4 supervisor review | EMP0011 and EMP0009 each overtime 7 / incident 1 / concern 1; EMP0005 and EMP0008 overtime 3; EMP0013 overtime 1. All 13 active rows retained in output |
| Q5 reusable procedure | 30 days: EMP0002 First Aid, 25 days until 2026-11-01. 90 days adds EMP0003 Chemical Handling, 80 days until 2026-12-26 |
| Q6 open actions | ACTN0001 overdue 5 days, INPROGRESS / LOW; ACTN0002 0 days overdue, OPEN / HIGH, target 2026-10-21 |

Final Q6 EXPLAIN: incident `i` ALL, three estimated rows, Using temporary / Using filesort; correctiveaction `ca` ref using fk_action_incident, one estimated row, 66.67% filtered, Using where; operationalarea `oa` and employee `e` eq_ref PRIMARY, one estimated row each. The analyzed plan matches final CLI TSV and both real Workbench EXPLAIN captures. Small-fixture estimates do not establish production performance.

## ER / MWB / Word status

Workbench regenerated the native model and complete ER plus six domain exports from the revised table SQL using UML relationship notation. Submission copies are byte-identical; structural checks include planting grape-variety PK, harvest variety, refund product, packmember joinedDate PK, customer address purpose and actual shift start/end/break values. Complete ER is 3327 × 2245; its overview is supplemented by six enlarged, readable domain figures.

Word generation and real LibreOffice rendering completed. Main report 100 pages; verification report five pages. Every page inspected at original image size, with corrections on pages 8/13/18 rerendered and inspected; the remaining 97 pages were pixel-identical to the inspected render. No observed clipping or blank pages. All 34 embedded main-report images match latest source bytes. Main report contains expanded Risk Register, current feedback changes, new ER, 286-row dictionary, executed official v4 evidence, six full query explanations and AI declaration. No official-workbook-pending statement, old schema metrics, TODO/TBC or student-completion placeholder remains in the generated report; genuine human dependencies are explicitly disclosed.

Queries and rule-violation submission SQL were regenerated and verified but remained byte-identical to the existing revised files; database SQL changed only removal of five blank lines. Production schema and query semantics were not redesigned.

## Final file list

- deliverables/final-submission/Cloudrest_Wines_Database.sql
- deliverables/final-submission/Cloudrest_Wines_ER_Diagram.png
- deliverables/final-submission/Cloudrest_Wines_Model.mwb
- deliverables/final-submission/Cloudrest_Wines_Queries.sql
- deliverables/final-submission/Cloudrest_Wines_Report.docx
- deliverables/final-submission/Cloudrest_Wines_Rule_Violations.sql
- deliverables/final-submission/Cloudrest_Wines_Verification_Report.docx
- deliverables/final-submission/ER_Customers_Orders.png
- deliverables/final-submission/ER_HR_Shifts_Safety_Wellbeing.png
- deliverables/final-submission/ER_HR_Training_Qualifications.png
- deliverables/final-submission/ER_Personnel_History.png
- deliverables/final-submission/ER_Products_Procurement.png
- deliverables/final-submission/ER_Vineyard_Wine_Production.png
- deliverables/final-submission/README_FIRST.md

Additional evidence: verification/verification-report.json and .md; verification/workbench-model-audit.json; verification/v4-final-audit.json; verification/word-render-qa.json; verification/final-package-sha256.txt; verification/final-query-results/*.tsv; docs/evidence/final-workbench/*.png and provenance README. The dictionary remains docs/report/data-dictionary.csv and .md, regenerated to the same 286 attributes.

## Team finalisation responsibilities — prospective current round

- Zixuan Shen: final integration, Task 1 Risk Register, report consistency, tutor-feedback traceability, Word report, AI declaration, final submission QA.
- Feiyue Ma: Workbench Data Model, latest .mwb, complete UML ER, six domain ER views, Task 4, Task 5 schema/dictionary consistency, ER screenshots.
- Xinzhu Wang: SQL integrity, T01–T11, official v4 staging/import/cleaning, Task 6 before/after evidence, exception/reconciliation.
- Chengye Jiang: six Task 7 queries, result screenshots, Q6 EXPLAIN, actual numeric interpretation, video run sheet and demo order.

These assignments are not claims that the students historically performed this automated finalisation. **NEEDS HUMAN CONFIRMATION: alias → real-name mapping**. Existing Mia/Zora/Rianna/Jason owner/speaker labels are retained, not guessed.

## Remaining human-only items / submission readiness

1. Tutor/business disposition for ambiguous pairs, mixed statuses, duplicate address canonicalisation and shared phones, followed by accepted/rejected production reconciliation.
2. Confirm alias mapping, genuine individual contributions, actual completion dates/hours and final submission date.
3. Supply the Week 11 assigned business scenario if still missing, then assess any required course-specific additions.
4. Students review evidence and explain the SQL/model; recapture in their own account only if course policy requires it.
5. Genuine four-person video, RiPPlE prompt progression, peer reviews and Buddycheck.

**READY FOR SUBMISSION: NO.** Engineering development validation passes; mandatory human/course items remain. No screenshots, SQL outputs, dates, historical contributions or real winery outcomes were fabricated.

## Files changed in tested artifact commit

- .github/workflows/revision-ci.yml
- database/cleaning/01_v4_staging.sql
- database/cleaning/02_v4_profile_and_clean.sql
- deliverables/final-submission/Cloudrest_Wines_Database.sql
- deliverables/final-submission/Cloudrest_Wines_ER_Diagram.png
- deliverables/final-submission/Cloudrest_Wines_Model.mwb
- deliverables/final-submission/Cloudrest_Wines_Report.docx
- deliverables/final-submission/Cloudrest_Wines_Verification_Report.docx
- deliverables/final-submission/ER_Customers_Orders.png
- deliverables/final-submission/ER_HR_Shifts_Safety_Wellbeing.png
- deliverables/final-submission/ER_HR_Training_Qualifications.png
- deliverables/final-submission/ER_Personnel_History.png
- deliverables/final-submission/ER_Products_Procurement.png
- deliverables/final-submission/ER_Vineyard_Wine_Production.png
- deliverables/final-submission/README_FIRST.md
- diagrams/Cloudrest_Wines_ER_Diagram.png
- diagrams/Cloudrest_Wines_Model.mwb
- diagrams/ER_Customers_Orders.png
- diagrams/ER_HR_Shifts_Safety_Wellbeing.png
- diagrams/ER_HR_Training_Qualifications.png
- diagrams/ER_Personnel_History.png
- diagrams/ER_Products_Procurement.png
- diagrams/ER_Vineyard_Wine_Production.png
- docs/evidence/a2-v4-data-quality-audit.md
- docs/evidence/final-workbench/README.md
- docs/evidence/final-workbench/additional_postalshipment.png
- docs/evidence/final-workbench/query01.png
- docs/evidence/final-workbench/query02.png
- docs/evidence/final-workbench/query03.png
- docs/evidence/final-workbench/query04-left.png
- docs/evidence/final-workbench/query05-30days.png
- docs/evidence/final-workbench/query05-90days.png
- docs/evidence/final-workbench/query06-explain-left.png
- docs/evidence/final-workbench/query06-explain-right.png
- docs/evidence/final-workbench/query06-results-right.png
- docs/evidence/final-workbench/query06-results.png
- docs/evidence/final-workbench/t01_validtraining.png
- docs/evidence/final-workbench/t02_invalidroledate.png
- docs/evidence/final-workbench/t03_missingreordercomment.png
- docs/evidence/final-workbench/t04_unpaidshipment.png
- docs/evidence/final-workbench/t05_overlappingsupervision.png
- docs/evidence/final-workbench/t06_pack_rejoin.png
- docs/evidence/final-workbench/t07_employee_current_address_overlap.png
- docs/evidence/final-workbench/t08_customer_primary_phone_overlap.png
- docs/evidence/final-workbench/t09_incomplete_wine_composition.png
- docs/evidence/final-workbench/t10_harvest_requires_variety_planting.png
- docs/evidence/final-workbench/t11_refund_requires_order_product.png
- docs/evidence/final-workbench/task6-e01-1.png
- docs/evidence/final-workbench/task6-e02-1.png
- docs/evidence/final-workbench/task6-e03-1.png
- docs/evidence/final-workbench/task6-e03-2.png
- docs/evidence/final-workbench/task6-e04-1.png
- docs/evidence/final-workbench/task6-e05-1.png
- docs/evidence/final-workbench/task6-e06-1.png
- docs/evidence/final-workbench/task6-e07-1.png
- docs/evidence/final-workbench/task6-e08-1.png
- docs/evidence/final-workbench/task6-e09-1.png
- docs/evidence/final-workbench/task6-e10-1.png
- docs/evidence/student-screenshot-checklist.md
- docs/report/task3-functionality-business-rules.md
- docs/report/task5-data-dictionary.md
- docs/report/task6-data-quality.md
- docs/report/task7-queries.md
- docs/video/five-minute-script.md
- project-management/project-plan.md
- tools/build_word_reports.py
- tools/final_v4_evidence_queries.sql
- tools/import_v4_staging.py
- tools/verify_project.py
- tools/verify_workbench_model.py
- tools/workbench_build_model.py
- verification/codex-finalization-handoff.md
- verification/completion-audit.md
- verification/final-package-sha256.txt
- verification/final-query-results/01_trainingcoverage.tsv
- verification/final-query-results/02_incidentrate.tsv
- verification/final-query-results/03_trainingimpact.tsv
- verification/final-query-results/04_overtimerisk.tsv
- verification/final-query-results/05_expiringqualification.tsv
- verification/final-query-results/06_openactions.tsv
- verification/final-query-results/task6-v4-evidence.tsv
- verification/v4-final-audit.json
- verification/verification-report.json
- verification/verification-report.md
- verification/word-render-qa.json
- verification/workbench-model-audit.json
