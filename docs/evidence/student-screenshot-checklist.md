# Genuine Student MySQL Workbench Screenshot Checklist

Finalisation update (2026-10-07): genuine local Workbench captures now exist in `docs/evidence/final-workbench/` for all listed integrity tests, six queries/EXPLAIN and v4 cleaning/exception classes. This checklist remains for student review or own-account recapture if required by course policy. Final production accepted/rejected reconciliation remains unresolved; no approved disposition is invented.

The generated CLI images are internal QA only. Capture the following in the submitting student's MySQL Workbench with readable SQL, result/action output and the `cloudrestwines` schema visible where practical.

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

## Task 7 — query evidence

- Query 1 coverage output.
- Query 2 incident-rate output.
- Query 3 affected-employee pre/post output.
- Query 4 overtime-risk output.
- Query 5 procedure output for 30 days.
- Query 5 procedure output for 90 days.
- Query 6 open-actions output.
- Query 6 `EXPLAIN` output.

## Task 6a — official A2 workbook

The official v4 workbook is available. Capture source/staging row counts for all three worksheets, then show readable before/after evidence for representative deterministic defects:

- Customer Id standardisation such as `cust018` / `CUST 019`.
- Mojibake repair for `Rosewood Trail RosÃ©` and an address containing `â€“`.
- Exact duplicate detection for the repeated `ORD125 / PROD001` row.
- Repeated-whitespace company-name correction.

Also capture the exception queries for ambiguous repeated Order Id + Product Id rows, mixed shipment/payment status, duplicate address strings and shared phone values. Finish with source = accepted + rejected reconciliation only after the ambiguous rows have an approved disposition. Do not invent an accepted/rejected total while those cases remain unresolved.

## Tutor-feedback regression evidence

These are additional robustness demonstrations and do not replace the five assessed Task 3b screenshots:

- T06 picker leaves and successfully rejoins the same pack.
- T07 overlapping current employee physical address is rejected.
- T08 second current primary customer phone is rejected.
- T09 active product release with a 60% wine composition is rejected.
- T10 harvest without the matching vineyard/vintage/grape-variety planting is rejected.
- T11 refund for a product not present on the order is rejected.

## Final ER evidence

Regenerate the MySQL Workbench model from the revised schema. The final UML diagram must visibly contain the three-column vineyard-planting key, harvest grape variety, refund product link, joinedDate in the Pack Member key, customer address purpose, and actual assignment start/end/break fields. The old model/PNG predates these tutor-feedback changes.
