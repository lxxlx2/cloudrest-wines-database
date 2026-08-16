# Cloudrest Wines Independent Verification Report

- Status: **PASS**
- MySQL: `8.4.11`
- Checks: 31/31 passed
- Generated: 2026-08-16T22:20:53

## Check results

| Result | Check | Evidence |
|:---:|---|---|
| PASS | Portable SQL rebuilds from empty database | exitCode=0 |
| PASS | Expected base tables | expected=53, actual=53 |
| PASS | Expected views | expected=1, actual=1 |
| PASS | Expected triggers | expected=11, actual=11 |
| PASS | Expected routines | expected=1, actual=1 |
| PASS | Expected columns | expected=274, actual=274 |
| PASS | Expected foreign keys | expected=69, actual=69 |
| PASS | Expected check constraints | expected=47, actual=47 |
| PASS | Table names are lowercase without spaces/underscores | 53 compliant names |
| PASS | Attributes use lowerCamelCase-compatible names | 274 compliant names |
| PASS | Every base table has a primary key | all 53 tables |
| PASS | No picking pack has fewer than four active members | violations=0 |
| PASS | All wine compositions total 100 percent | violations=0 |
| PASS | No employee has multiple active role rows | violations=0 |
| PASS | No employee has multiple active supervisors | violations=0 |
| PASS | Completed training has completion and competency | violations=0 |
| PASS | No non-reorder bottle lacks a comment | violations=0 |
| PASS | No shipment uses a postal address | violations=0 |
| PASS | No shipped order is unpaid | violations=0 |
| PASS | Query script executes: 01_trainingcoverage.sql | exitCode=0, outputChars=114;  |
| PASS | Query script executes: 02_incidentrate.sql | exitCode=0, outputChars=122;  |
| PASS | Query script executes: 03_trainingimpact.sql | exitCode=0, outputChars=239;  |
| PASS | Query script executes: 04_overtimerisk.sql | exitCode=0, outputChars=422;  |
| PASS | Query script executes: 05_expiringqualification.sql | exitCode=0, outputChars=347;  |
| PASS | Query script executes: 06_openactions.sql | exitCode=0, outputChars=971;  |
| PASS | Integrity test behaves as expected: t01_validtraining.sql | exitCode=0, expectedNeedle=PASS, output=testResult PASS: valid completed training was accepted |
| PASS | Integrity test behaves as expected: t02_invalidroledate.sql | exitCode=1, expectedNeedle=chk_employeerole_dates, output=ERROR 3819 (HY000) at line 3: Check constraint 'chk_employeerole_dates' is violated. |
| PASS | Integrity test behaves as expected: t03_missingreordercomment.sql | exitCode=1, expectedNeedle=chk_bottletype_reorder, output=ERROR 3819 (HY000) at line 2: Check constraint 'chk_bottletype_reorder' is violated. |
| PASS | Integrity test behaves as expected: t04_underagecustomer.sql | exitCode=1, expectedNeedle=Individual customer must be at least 18 years old, output=ERROR 1644 (45000) at line 3: Individual customer must be at least 18 years old |
| PASS | Integrity test behaves as expected: t05_postalshipment.sql | exitCode=1, expectedNeedle=Shipment address must be a physical address, output=ERROR 1644 (45000) at line 4: Shipment address must be a physical address, not PO Box or Private Bag |
| PASS | Integrity test behaves as expected: t06_invalidconversionpercentage.sql | exitCode=1, expectedNeedle=chk_grapevariety_conversion, output=ERROR 3819 (HY000) at line 3: Check constraint 'chk_grapevariety_conversion' is violated. |

## External dependencies / honest limitations

- Official A2 spreadsheet is not supplied; actual cleaning evidence remains pending.
- Week 11 business scenario is not supplied.
- Final Workbench screenshots, four-person video, genuine prompt logs and peer reviews require student action.
