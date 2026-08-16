# Genuine Student MySQL Workbench Screenshot Checklist

The generated CLI images are internal QA only. Capture the following in the submitting student's MySQL Workbench with readable SQL, result/action output and the `cloudrestwines` schema visible where practical.

## Model confirmation before screenshots

- Open the final `.mwb` model.
- Confirm **Model → Relationship Notation → UML**.
- Save the model after selecting UML.
- Confirm the complete EER model uses a wide landscape layout and remains readable.
- Re-export the complete ER PNG before rebuilding the report.

## Task 3b — five assessed rule violations

- Rule 1 role end before start: SQL plus Error 3819.
- Rule 2 reorder FALSE with blank comment: SQL plus Error 3819.
- Rule 3 PO Box/Private Bag shipment: SQL plus Error 1644.
- Rule 4 unpaid shipment: SQL plus Error 1644.
- Rule 5 overlapping supervision: SQL plus Error 1644.

## Task 6 — five assessed integrity tests

- T01 accepted training insert and rollback.
- T02 rejected role dates.
- T03 rejected missing reorder comment.
- T04 rejected unpaid shipment.
- T05 rejected overlapping supervision.

## Additional integrity controls for internal QA

These controls strengthen the implementation but do not replace the five assessed Task 3b rules:

- Supplier physical and postal addresses can coexist.
- Supplier overlapping addresses of the same type are rejected.
- Customer subtype mismatch is rejected.
- Receipt line for a bottle not present on the related purchase order is rejected.
- Duplicate overlapping employee primary phone is rejected.
- Duplicate overlapping customer primary phone is rejected.
- Future-dated customer address is rejected as a shipment address.
- Overlapping product price period is rejected.

These additional controls need internal execution verification; screenshots are optional unless the tutor asks for more evidence.

## Task 7 — query evidence

- Query 1 coverage output.
- Query 2 incident-rate output.
- Query 3 affected-employee pre/post output.
- Query 4 overtime-risk output, with recent incident counts limited to `AFFECTED` involvement.
- Query 5 procedure output for 30 days.
- Query 5 procedure output for 90 days.
- Query 6 open-actions output.
- Query 6 `EXPLAIN` output.

## Task 6a — official A2 workbook

For every supplied-data table: source sheet/row evidence, profiling result, correction SQL, before result, after result, accepted/rejected reconciliation and production-import verification. This remains blocked until the official workbook is supplied.
