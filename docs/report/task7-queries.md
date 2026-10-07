# Task 7 — Decision-Support SQL Queries

The assessment materials are inconsistent about five versus six queries, so the project retains all six demonstrated queries. The official A2 v4 workbook contains customer, order and address data but no HR training, qualification, shift, incident or wellbeing records. Therefore the six HR-perspective decision queries are executed against the final validated synthetic HR dataset, in a final database that also contains the accepted cleaned supplied customer/order/address data.

For each query the report explains how it runs, who uses it, the decision supported and the actual result from the revised fixture. The figures below are tied to the revised SQL/test data and were captured in local Workbench on 2026-10-08; submitting students must review them and recapture if course policy requires their own account.

## Query 1 — Annual safety and sustainability training coverage

### How the query works

The `activeworkforce` CTE reads current `employeerole` rows and identifies each active employee's operational area. The `completion` CTE joins `trainingattendance` to `trainingsession` and `trainingcourse`, keeps only `COMPLETED` attendance in the current calendar year, and limits categories to `SAFETY` and `SUSTAINABILITY`. `HAVING COUNT(DISTINCT trainingCategory)=2` requires the same employee to have completed both categories.

The final query joins `operationalarea` to the active workforce and left-joins the completion set. It uses distinct employee counts for both numerator and denominator and `NULLIF` to avoid division by zero.

### Business use and action

The HR Manager, Safety Officer and operational-area supervisors use the percentage to identify workforce preparation gaps. An area below target should receive additional training sessions rather than treating completion of only one category as adequate sustainability coverage.

### Actual result — frozen MySQL 8.4.11 build, 2026-10-08

- **Vineyard:** 6 active employees, 3 completed both required categories, **50.0% coverage**.
- **Cellar:** 4 active employees, 0 completed both categories, **0.0% coverage**.
- **Administration:** 3 active employees, 0 completed both categories, **0.0% coverage**.

The result identifies a partial gap in Vineyard and complete gaps in Cellar and Administration. The immediate management action is to schedule missing Safety/Sustainability training and then rerun the metric.

## Query 2 — Incidents per 1,000 actual labour hours

### How the query works

The revised shift design no longer stores independent regular/overtime hour totals. `shiftassignment` records actual start time, actual end time and break minutes. The `assignmenthours` CTE derives labour hours as the elapsed minutes minus breaks, divided by 60.

`hoursbyarea` aggregates those actual hours by operational area over the rolling 12 months. `incidentloss` reads incidents from the same rolling period, left-joins `incidentemployee` and sums employee lost hours while retaining one row per incident. `incidentsbyarea` then counts incidents once per area. The final calculation is `incidentCount × 1000 / labourHours`; a zero denominator returns NULL.

### Business use and action

Raw incident counts can make a busy area look less safe simply because more hours are worked. The exposure-adjusted rate lets the Safety Officer and management compare operational areas on a consistent basis. High-rate areas can be targeted for investigation, training, equipment changes or corrective actions.

### Actual result — frozen MySQL 8.4.11 build, 2026-10-08

- **Vineyard:** 88.00 actual labour hours, 2 incidents, 2 lost hours, **22.73 incidents per 1,000 hours**.
- **Cellar:** 54.00 actual labour hours, 1 incident, 16 lost hours, **18.52 incidents per 1,000 hours**.

Vineyard has the higher event frequency, while Cellar has fewer incidents but much greater lost time. Management should therefore avoid using the rate alone: Vineyard needs frequency reduction, while Cellar's severe lost-time outcome warrants focused handling/equipment controls.

## Query 3 — Incidents before and after safety training

### How the query works

The `completion` CTE finds the first completed Safety training date for each employee. The `observed` CTE calculates a matched observation window using the lesser of 180 days and the number of days since training. This prevents a newly trained employee from receiving a longer pre-training window than post-training window.

The result joins employees to `incidentemployee` only where `involvementRole='AFFECTED'`, then to `incident`. Conditional `SUM(CASE ...)` expressions count incidents in equal windows immediately before and after completion.

### Business use and action

HR and the Safety Officer can use this as an association check when reviewing whether safety training coincides with improved outcomes. It is not a causal experiment. If incidents remain high after training, management should inspect course content, work practices and corrective actions rather than claiming training failed solely from this query.

### Actual result — frozen MySQL 8.4.11 build, 2026-10-08

Five employees have completed Safety training in the fixture. **EMP0008 has 1 affected incident before training and 0 after training** within the matched window; the other trained employees have 0 before and 0 after. The sample is too small to claim causality, but it demonstrates how future real records could support a more meaningful before/after review.

## Query 4 — Recent workload, safety and wellbeing review indicators

### How the query works

`activeworkforce` supplies every current employee with role and operational area context. `assignmenthours` derives worked hours from actual assignment start/end/break values for the last 30 days. `workload` sums up to 8 regular hours per assignment and treats hours above 8 as overtime. Separate CTEs count recent incident involvement and wellbeing check-ins with `concernRaisedFlag=TRUE`.

All three result sets are left-joined to the active workforce, so employees with no recent shift remain visible. A transparent `CASE` returns `SUPERVISOR REVIEW` when overtime, a recent incident or a wellbeing concern is present. No confidential wellbeing note is exposed.

### Business use and action

Supervisors and HR use the query as a prioritisation list, not a medical or disciplinary score. The underlying columns show why somebody appears. Management can adjust rosters, check fatigue controls, follow up an incident or schedule a wellbeing conversation.

### Actual result — frozen MySQL 8.4.11 build, 2026-10-08

Five employees are flagged for review:

- **EMP0011 Jack Moore:** 7 overtime hours, 1 recent incident, 1 wellbeing concern.
- **EMP0009 Leo Wilson:** 7 overtime hours, 1 recent incident involvement, 1 wellbeing concern.
- **EMP0005 Liam Singh:** 3 overtime hours.
- **EMP0008 Mia Taylor:** 3 overtime hours.
- **EMP0013 Finn Walker:** 1 overtime hour.

EMP0010 and EMP0012 have recent hours but no overtime/incident/concern indicator; other active employees remain visible with zero recent workload. The highest-priority follow-up is EMP0011/EMP0009 because multiple independent indicators are present.

## Query 5 — Expiring qualifications stored procedure

### How the query works

`getExpiringQualifications(daysAhead)` validates that the parameter is non-NULL and from 0 to 730. It joins `employeequalification`, `employee` and `qualification`, filters expiry dates between today and today plus the requested horizon, calculates `daysUntilExpiry`, and sorts by expiry date.

The demonstration calls the same procedure with 30 and 90 days, proving that the database logic is reusable rather than hard-coded to one report period.

### Business use and action

HR and supervisors use the short horizon for urgent renewal booking and the longer horizon for planning budgets, rosters and course capacity.

### Actual result — frozen MySQL 8.4.11 build, 2026-10-08

- `CALL getExpiringQualifications(30)` returns **EMP0002 / First Aid Certificate / 25 days**.
- `CALL getExpiringQualifications(90)` returns the same record plus **EMP0003 / Chemical Handling Permit / 80 days**.

The operational action is to book EMP0002 first and include EMP0003 in the next planning cycle.

## Query 6 — Open corrective actions View and EXPLAIN

### How the query works

`openincidentaction` joins `correctiveaction`, `incident`, `operationalarea` and the responsible `employee`. It excludes `COMPLETED` and `CANCELLED` actions and calculates `daysOverdue` with `GREATEST(DATEDIFF(...),0)`.

The management query reads the view and orders overdue rows first, then severity, overdue days and target date. `EXPLAIN` is executed on the same final query to inspect the access plan.

### Business use and action

The Safety Officer and managers use this list to prevent corrective actions from disappearing after an incident is recorded. Overdue actions should be escalated; high-severity actions approaching their target date should be resourced before they become overdue.

### Actual result — frozen MySQL 8.4.11 build, 2026-10-08

Two actions remain open:

- **ACTN0001:** 5 days overdue, Low-severity incident, status `INPROGRESS`.
- **ACTN0002:** not overdue (target in 14 days), High-severity incident, status `OPEN`.

The ordering places ACTN0001 first because it is already overdue. ACTN0002 still deserves attention because the underlying incident severity is High.

### EXPLAIN interpretation

The final Workbench and matching CLI EXPLAIN on 2026-10-08 starts with `incident` (`i`): `ALL`, estimated 3 rows, using temporary/filesort. `correctiveaction` (`ca`) uses `ref` on `fk_action_incident`, estimated 1 row and 66.67% filtered, using where. `operationalarea` and `employee` use `eq_ref` primary-key lookups, estimated 1 row. The plan remains ALL/ref/eq_ref after the combined-data rebuild. It does not establish production performance. Final screenshots and `verification/final-query-results/06_openactions.tsv` show the same plan.

## Risks and limitations by query

| Query | Risk / limitation |
|---|---|
| 1 | Current workforce membership differs from historical membership; both categories must be completed in the current calendar year. |
| 2 | Very small exposure denominators make rates unstable; missing assignments or incidents bias the metric. |
| 3 | Equal windows reduce exposure imbalance but do not control work mix or confounding; no causal claim is supported. |
| 4 | Eight hours per assignment is the demonstration rule, not an asserted payroll entitlement; flags require supervisor context. |
| 5 | Expiry is only as reliable as recorded qualification dates; book renewals and verify validity with the issuer. |
| 6 | Open actions depend on timely status updates; the small-fixture EXPLAIN does not establish production performance. |

All six outputs use synthetic assessment HR records and cannot describe actual winery performance.

## Final evidence rule

The numeric interpretations above are reproducible from the revised fixture, but final submission evidence must be captured after the final SQL build is frozen. If any fixture or query changes, all six outputs and the Query 6 EXPLAIN screenshot must be regenerated together.
