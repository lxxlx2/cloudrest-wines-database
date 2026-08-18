# External Audit Round 2 Response

This file records the disposition of the second independent grading-oriented audit received after the first manual-fix pass. It is an implementation handoff, not a claim that final student/course evidence is complete.

## Blocking items

| Finding | Status | Response |
|---|---|---|
| B01/B02 stale generated package and old verification | OPEN until regeneration | Handoff/README explicitly invalidate old SQL/Word/MWB/ER/verification. Current authoritative source has a GitHub Actions MySQL verification path, while final Workbench/Word artifacts still require regeneration. |
| B03 UML/landscape Workbench confirmation | OPEN manual dependency | `docs/evidence/workbench-model-finalization.md`; final mode remains blocked until confirmed/exported. |
| B04 genuine Workbench screenshots | OPEN student dependency | Screenshot checklist retained; generated/CI output is internal QA only. |
| B05 official A2 workbook | OPEN course dependency | No fabricated cleaning evidence. |
| B06 Week 11 scenario | OPEN course dependency | No fabricated scenario. |
| B07 four-person video | OPEN student dependency | Script only until genuine recording. |
| B08 genuine RiPPlE | OPEN student dependency | Capture framework only; peer-review count remains tutor-dependent. |
| B09 fourth member identity, dates/contributions | PARTIALLY RESOLVED | Fourth member identity is confirmed as Jason. All four student numbers, submission date, actual completion dates/hours and genuine contribution records remain pending. |
| B10 hard-coded member `1` in Task 1 | RESOLVED IN SOURCE | Project planning and video materials now use Jason. The final-input example is prefilled with Jason, while final report generation still requires the genuine final-input file and remaining student data. |
| B11 final Appendix C placeholder row | RESOLVED IN SOURCE | Appendix statuses are FINAL_MODE-aware and do not instruct replacement after a successful final build. |
| B12 student numbers absent | RESOLVED IN SOURCE | `final-inputs.example.json` and report cover support all four student numbers; final mode requires them. |
| B13 tutor conflicts | OPEN by design | `docs/requirements/tutor-confirmations.md` remains authoritative; no silent resolution. |
| B14 PR merge gate | RECHECK REQUIRED | PR remains Draft intentionally. Mergeability must be checked from the current GitHub state and is not inferred from the earlier audit snapshot. |

## Likely mark-loss items

| Finding | Status | Response |
|---|---|---|
| L01 employee/customer address overlap | RESOLVED IN SOURCE | Same-address-kind temporal overlap triggers added for both histories. |
| L02 picking-pack validation mechanism | RESOLVED IN SOURCE | `validatePickingPackRules()` checks minimum 4, current picker classification, supervisor role, matching supervision, coverage and one-current-pack rule. |
| L03 pack supervisor role mismatch | RESOLVED IN SOURCE | Synthetic baseline patch moves PACK001 and picker supervision/rating to EMP0003, the active Grape Farmer. |
| L04 wine composition 100% | RESOLVED IN SOURCE | `validateWineComposition()` is called before wine-product INSERT/UPDATE. |
| L05 exact customer subtype | RESOLVED/CLARIFIED | Parent may be staged, subtype mismatch/dual membership is blocked, and `validateCustomerSubtype()` blocks customer-order transactions until exactly one matching subtype exists. Task 2 wording is aligned. |
| L06 Query 2 KPI mismatch | RESOLVED | Project KPI explicitly counts all recorded safety events; Query 2 and report use the same definition. `reportableFlag` remains separate. |
| L07 Q2 manual reconciliation stale | RESOLVED | Reconciled fixture: 88 Vineyard labour hours, 2 incidents, 22.73 per 1,000 hours. |
| L08 Data Dictionary Unique semantics | RESOLVED IN GENERATOR | `Unique=Y` requires a single-column unique index; composite key members are not individually marked unique. |
| L09 generic dictionary domains/purposes | IMPROVED IN GENERATOR | Explicit and context-sensitive domains/purposes added for major case fields. Must regenerate after live build. |
| L10 RiPPlE peer-review pre-decision | RESOLVED | Capture pack defers count/wording to tutor/LMS-confirmed requirement. |
| L11 order can have zero lines | RESOLVED AT FINALISATION BOUNDARY | Shipment INSERT/UPDATE requires at least one orderline; single shipment remains enforced by UNIQUE. |
| L12 traceability not synced | RESOLVED IN SOURCE | Traceability matrix maps subtype, address, phone, receipt, price, pack, composition, chronology and analytics controls. |

## HD improvements

| Finding | Status | Response |
|---|---|---|
| H01 arbitrary Query 4 weights/threshold | RESOLVED | Removed weighted score and 4-hour threshold. Incidents/concerns trigger review; overtime alone is monitored and used transparently as a secondary sort. |
| H02 Query 3 first-ever training | RESOLVED | Uses latest completed safety training with symmetric 180-day windows. |
| H03 Query 2 hours-only driving set | RESOLVED | Query starts from `operationalarea`, left joins numerator/denominator and returns NULL rate when exposure is zero. |
| H04 privacy implementation | PARTIAL/INTENTIONAL | Sensitive TFN/DOB/wellbeing note are excluded from management query output. Portable assessment SQL documents least-privilege deployment without assuming student accounts can administer MySQL users/GRANTs. |
| H05 required current primary phone | RESOLVED AT VALIDATION BOUNDARY | At-most-one primary periods are enforced by triggers. `validateRequiredCurrentState()` requires exactly one current primary phone for each active employee/customer and supplier, plus required current physical addresses; baseline calls it after staged loading. |
| H06 broader negative tests | IMPROVED | Added address-overlap, pack-minimum, missing subtype, incomplete composition, empty-order finalisation, required-primary-contact and other negative tests in addition to prior controls. |
| H07 citation closure | OPEN manual check | Citation audit retained; final PDF-to-report check still required. |
| H08 bottle unsourceable clarity | OPEN optional | Existing `supplierbottle.isAvailable` + bottle reorder state retained; no extra reporting object added solely for this optional improvement. |
| H09 vineyard manager/address | RESOLVED IN SOURCE | Vineyard INSERT/UPDATE validates active Grape Farmer manager and PHYSICAL address. |

## Optional robustness

| Finding | Status | Response |
|---|---|---|
| O01 direct SHIPPED status | RESOLVED IN SOURCE | Customer-order update cannot transition to SHIPPED without a shipment row. |
| O02 chronology | RESOLVED IN SOURCE | Shipment/order and receipt/purchase-order chronology triggers added. |
| O03 same-day shift/hard bounds | DOCUMENTED ASSUMPTION | Explicitly identified as course implementation/data-quality bounds pending tutor preference. |
| O04 public repository | OPEN owner decision | README recommends private visibility before real submission. |

## Verification state

`RESOLVED` means the authoritative source remediation is committed. The generated final Word/MWB/ER/student evidence still requires the documented regeneration and genuine activity. Technical source verification is implemented through `.github/workflows/source-verification.yml`, `tools/ci_source_verify.py` and `tools/verify_manual_audit_controls.py`.

The next reviewer should use a fresh CI/local verification result and must still inspect the final Workbench/Word evidence manually.
