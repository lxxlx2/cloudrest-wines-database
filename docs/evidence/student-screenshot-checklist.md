# Genuine Student MySQL Workbench Screenshot Checklist

Use this checklist for the report evidence. Capture screenshots in the student's own MySQL Workbench session. Each screenshot should clearly show the SQL being executed and the relevant Result Grid or Action Output. The `cloudrestwines` schema should be visible when practical.

## Before taking screenshots

1. Open the final `Cloudrest_Wines_Database.sql` in MySQL Workbench.
2. Execute the whole file successfully.
3. Refresh **SCHEMAS** and confirm `cloudrestwines` exists.
4. Keep the SQL editor, Result Grid / Action Output and enough of the Workbench window visible so the evidence is readable.
5. Increase the editor/result font size if necessary.
6. Do not crop away the SQL or the MySQL result/error message.

## Fourteen unique screenshots to capture now

The Task 3 and Task 6 negative tests overlap, so one clear screenshot can be reused where it proves the same executed rule.

| No. | Suggested file name | What to run / show | What the screenshot must prove |
|---:|---|---|---|
| 01 | `T01_valid_training.png` | `database/tests/t01_validtraining.sql` | Valid completed training is accepted, followed by the test rollback. |
| 02 | `Rule1_invalid_role_date.png` | `database/tests/t02_invalidroledate.sql` | MySQL rejects an employee-role end date/time earlier than the start date/time, expected Error 3819 / `chk_employeerole_dates`. |
| 03 | `Rule2_reorder_comment.png` | `database/tests/t03_missingreordercomment.sql` | MySQL rejects `reorderFlag = FALSE` with a missing/blank explanation, expected Error 3819 / `chk_bottletype_reorder`. |
| 04 | `Rule3_postal_shipment.png` | `database/tests/additional_postalshipment.sql` | MySQL rejects shipment to a PO Box / Private Bag or other non-physical address, expected Error 1644. |
| 05 | `Rule4_unpaid_order.png` | `database/tests/t04_unpaidshipment.sql` | MySQL rejects shipment before payment confirmation, expected message `Order must be paid before shipment`. |
| 06 | `Rule5_supervisor_overlap.png` | `database/tests/t05_overlappingsupervision.sql` | MySQL rejects an overlapping second supervisor period, expected Error 1644. |
| 07 | `Q1_training_coverage.png` | Query 1 from `Cloudrest_Wines_Queries.sql` | Training-coverage result grid by operational area is visible. |
| 08 | `Q2_incident_rate.png` | Query 2 | Incident rate per 1,000 labour hours result grid is visible. |
| 09 | `Q3_training_impact.png` | Query 3 | Pre/post latest safety-training result grid is visible. |
| 10 | `Q4_overtime_risk.png` | Query 4 | Overtime/workload review result grid is visible and no confidential wellbeing note is displayed. |
| 11 | `Q5_30_days.png` | `CALL getExpiringQualifications(30);` | Stored procedure executes with 30 as the input parameter and returns its result. |
| 12 | `Q5_90_days.png` | `CALL getExpiringQualifications(90);` | The same procedure executes with 90 and produces the wider planning-horizon result. |
| 13 | `Q6_open_actions.png` | Query 6 | Open corrective-action priority result grid is visible. |
| 14 | `Q6_explain.png` | Query 6 `EXPLAIN` statement | MySQL execution-plan output is visible for the report's performance discussion. |

## Task 4 model evidence

This is separate from the fourteen SQL/result screenshots.

- Open the final `.mwb` model.
- Select **Model → Relationship Notation → UML**.
- Save the model after selecting UML.
- Arrange the complete model on a wide landscape canvas.
- Re-export the complete ER PNG.
- Confirm entity names, attributes, PK/FK markers and cardinalities are readable.

## Where the screenshots go in the Word report

The current Word report is intentionally generated with clearly marked evidence placeholders.

- Screenshots 02 to 06 go beside the matching Task 3b business rules.
- Screenshots 01, 02, 03, 05 and 06 support the five Task 6 integrity tests. Reuse the already captured image when the same executed test is referenced.
- Screenshots 07 to 14 go under the matching Task 7 query sections.

After inserting the screenshots, delete the corresponding placeholder box/text and add a short figure caption. Keep the SQL code as readable text in the report; the screenshot is evidence of execution, not a replacement for the SQL text.

## Official A2 workbook evidence

This section remains blocked until the official A2 workbook is supplied. After it is received, capture genuine evidence for the supplied data: source sheet/row context, profiling result, correction SQL, before result, after result, accepted/rejected reconciliation and final production-import verification.

## Final visual check

Before submission, open the Word report at 100% zoom and confirm every screenshot is readable, correctly matched to the nearby SQL/rule/query, and contains no unrelated personal information.
