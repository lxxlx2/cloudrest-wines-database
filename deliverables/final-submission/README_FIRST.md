# Cloudrest Wines — Delivery Instructions

TECHNICAL / DOCUMENT DELIVERABLES READY — 2026-10-08.

## Files for the team

- Cloudrest_Wines_Report.docx — final Task 1–7 report, complete dictionary and ER views.
- Cloudrest_Wines_Database.sql — portable MySQL schema, cleaned supplied data and additional test data.
- Cloudrest_Wines_Queries.sql — six Task 7 queries.
- Cloudrest_Wines_Rule_Violations.sql — assessed rule demonstrations.
- Cloudrest_Wines_Model.mwb — editable Workbench model.
- Cloudrest_Wines_ER_Diagram.png and six domain PNGs — UML diagrams.

## Import and demonstration

Open Cloudrest_Wines_Database.sql in the student's MySQL Workbench connection and execute the complete script. It drops and rebuilds cloudrestwines, so use a disposable coursework database. Refresh SCHEMAS, then open Cloudrest_Wines_Queries.sql and execute each numbered query separately. Demonstrate getExpiringQualifications with both 30 and 90 days.

MySQL 8.4.11 empty-database build passes. Schema remains 55 base tables / 1 view / 286 columns / 72 foreign keys / 50 CHECKs / 30 triggers / 3 routines. Existing verifier passes 73/73. Model and dictionary remain consistent with this schema.

## Task 6 final import

182 supplied order rows = 132 imported + 1 exact duplicate rejected + 15 ambiguous-pair rows quarantined + 34 other rows quarantined. Imported rows form 79 complete orders. Final database also contains 50 supplied customers, 102 addresses, 53 address histories, 66 unshared phones/associations and 10 source product IDs/wine names. Shared phones (seven associations) and 72 absent shipment-detail facts are quarantined. Export-reset dates remain unchanged. Required missing product attributes are explicitly supplemental test data; see Task 6 for all assumptions and table verification.

Original before/after evidence is preserved. Final combined-database query/import screenshots are in docs/evidence/combined-database. Raw workbook and raw CSV/contact exports are excluded from the public repository. Earlier finalisation/hash/QA snapshots describe earlier packages and are historical, not the acceptance record for this revision.

## Final work package allocation

These are prospective responsibilities, not historical contribution hours.

- Zixuan Shen: final report integration; Project Plan / Risk; tutor-feedback consistency; submission QA.
- Feiyue Ma: Workbench model; ER Diagram; Data Dictionary / model consistency.
- Xinzhu Wang: SQL / constraints; official v4 cleaning/import; Task 6; integrity tests.
- Chengye Jiang: six Task 7 queries; EXPLAIN; query results; personal video demonstration to be completed later.

Earlier Mia/Zora/Rianna/Jason aliases have no confirmed mapping. No mapping, actual completion date, submission date or historical contribution is invented.

## STUDENT-ONLY ITEMS REMAIN

Video; RiPPlE; Buddycheck; final personal contribution confirmation. Students should review and understand the supplied evidence, and recapture under their own account if course policy requires it.

WAITING FOR COURSE MATERIAL: Week 11 assigned business scenario (Task 8). Add the tutor's actual scenario when supplied. These student/course items do not block delivery of the current report, SQL and model package.
