# Task 6 — Data Quality Strategy and Validation

## 6a. Cleaning and migration plan

Cloudrest Wines will use a controlled raw-to-staging-to-production pipeline. The supplied A2 workbook will first be copied unchanged and its file hash, sheet names, row counts and import date recorded. Each worksheet will be imported into a staging table using permissive text columns, ensuring malformed values are not silently lost during import. Profiling queries will identify completeness, uniqueness, consistency, validity and referential-integrity defects before any production insert.

Detection will include duplicate identifiers; blank mandatory fields; invalid dates and chronological order; inconsistent employment/status values; malformed TFNs, ABNs, postcodes, emails and phones; negative hours/weights/costs; percentages outside 0–100; multiple current history rows; and references to missing parents. Deterministic corrections—trimming, case standardisation, controlled value mapping and date conversion—will be performed with logged SQL. Ambiguous identity, address or missing-parent corrections will be quarantined for documented manual review rather than guessed.

After correction, rows will be inserted in dependency order. Quality control will reconcile source, accepted and rejected counts; query orphan checks; review exception tables; and run the full integrity suite. Before/after screenshots will show the defect query, correction SQL and verified result for every supplied table. Prevention measures include structured input controls, reference tables/enums, PK/UK/FK/CHECK constraints, triggers, least-privilege import roles and regular exception reporting.

**Current limitation.** The official A2 workbook has not been supplied. Therefore no claim is made that actual source errors have been found or corrected. The repository provides a reproducible framework and explicit evidence placeholders; actual errors, scripts and screenshots must be completed after receipt of the workbook.

## 6b. Test-data creation

Synthetic data was designed backwards from the five rules and six management questions. It includes permanent, casual and seasonal employees; several operational areas; completed, failed and absent training; 25/80/150-day qualification horizons; normal and overtime shifts; low, moderate and high incidents; open, overdue and completed corrective actions; wellbeing concerns; base winery production; procurement; and a paid customer shipment. All names, TFNs, ABNs, emails and operational events are fictitious.

AI assisted with scenario coverage and value generation. Suitability was then verified by successful FK-constrained import, domain checks, manual result reconciliation and non-empty query outputs. Boundary/negative data is executed separately so deliberately invalid rows never remain in the baseline database.

## 6c. Integrity suite

| Test | Type | Expected result | Demonstrates |
|---|---|---|---|
| Valid completed training | Positive | Accepted, then rolled back | Valid HR outcome with completion, renewal and competency is supported |
| End before role start | Negative | CHECK rejection | Invalid personnel history cannot be stored |
| Reorder false without comment | Negative | CHECK rejection | Bottle sourcing/quality explanation is mandatory |
| Insert underage individual | Negative | Trigger rejection | Individual customer legal age is enforced |
| Ship to PO Box | Negative | Trigger rejection | Only the paid customer's current physical address may be shipped to |

The SQL and genuine MySQL output are maintained under `database/tests/` and `docs/evidence/test-output/`.
