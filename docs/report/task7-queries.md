# Task 7 — Decision-Support SQL Queries

The specification inconsistently states five and six queries. Cloudrest Wines supplies six because the overview and video instructions repeatedly require execution of all six.

## Query 1 — Annual safety and sustainability training coverage

**Decision.** Direct training resources to operational areas below target. The query counts active workers and employees who completed both categories during the current year. Current test results show gaps that management can use to schedule missing sustainability/safety sessions rather than treating attendance at either category as full coverage.

**Features.** Six tables/CTEs, left join, annual date logic, distinct-category validation, safe percentage calculation.

## Query 2 — Incidents per 1,000 labour hours

**Decision.** Prioritise intervention using an exposure-adjusted measure rather than raw event counts. `operationalarea` is the driver, so an area with incidents but no recorded labour hours remains visible instead of disappearing from the result. Its rate is shown as `NULL` because a denominator of zero cannot support a valid rate. Lost-hours context is aggregated from `incidentemployee.employeeLostHours`, while each incident is counted once per operational area.

**Features.** Rolling 12-month window, operational-area driver, separate numerator/denominator CTEs, multiple joins, zero-denominator handling and employee-level lost-hours aggregation. This is sustainability query two.

## Query 3 — Incidents before and after training

**Decision.** Assess whether annual safety training is associated with fewer employee incidents. For each employee, the query uses the first completed safety course and compares equal observed periods before and after training, capped at 180 days. If fewer than 180 days have elapsed since training, the pre-training window is shortened to the same number of days so that the comparison is not biased by unequal observation time. The result is an association indicator only; the report must not claim causality from this small synthetic sample.

**Features.** Matched pre/post observation windows, date arithmetic, conditional aggregation, employee/course/session/incident joins.

## Query 4 — Recent workforce review indicators

**Decision.** Surface active employees with recent workload, safety or wellbeing indicators for supervisor judgement without exposing confidential wellbeing notes. The query starts from the active workforce and left-joins recent shifts, incidents and concerns, so an employee is still visible even when there is no shift in the last 30 days. It does not use an arbitrary weighted risk score. Any recent overtime, incident or wellbeing concern produces a `SUPERVISOR REVIEW` label; management still interprets the underlying columns rather than treating the label as a medical or disciplinary conclusion.

**Features.** Active-workforce driver, last-30-days logic, multiple CTEs, left joins, area/role context, privacy-aware output and transparent review flag.

## Query 5 — Expiring qualifications procedure

**Decision.** Plan renewals using different horizons. `CALL getExpiringQualifications(30)` and `CALL getExpiringQualifications(90)` demonstrate different planning windows. The input is validated as non-NULL and between 0 and 730 days; invalid values raise an error rather than silently returning an empty result.

**Features.** Stored procedure with input parameter, two video calls, current-date interval logic, multiple joins and explicit parameter validation.

## Query 6 — Open corrective actions View and EXPLAIN

**Decision.** Prioritise overdue/high-severity corrective action. The View excludes completed/cancelled actions and calculates days overdue consistently.

**Features.** View, multiple joins, current-date elapsed logic and `EXPLAIN`.

**Execution-plan interpretation (under 100 words).** On the small synthetic dataset, MySQL chooses a full scan of `correctiveaction` rather than the available `idx_action_status_date`; that is a normal cost-based choice when the table has only a few rows. The incident join uses the corrective-action foreign-key relationship, while operational-area and employee rows are resolved with indexed key lookups. The calculated priority ordering requires a temporary result/filesort. The plan should therefore be described from the captured `EXPLAIN` output rather than claiming the status/date index is selected when it is not.
