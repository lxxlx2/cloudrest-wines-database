# Task 7 — Decision-Support SQL Queries

The specification inconsistently states five and six queries. Cloudrest Wines supplies six because the overview and video instructions repeatedly require execution of all six.

## Query 1 — Annual safety and sustainability training coverage

**Decision.** Direct training resources to operational areas below target. The query counts active workers and employees who completed both categories during the current year. Current test results show Vineyard at 50%, while Cellar and Administration are 0%; management should schedule the missing sustainability/safety sessions rather than treating attendance at either category as full coverage.

**Features.** Six tables/CTEs, left join, annual date logic, distinct-category validation, safe percentage calculation.

## Query 2 — Incidents per 1,000 labour hours

**Decision.** Prioritise intervention using an exposure-adjusted measure rather than raw event counts. In the current test baseline, Vineyard records 22.73 incidents per 1,000 hours and Cellar 18.52. Because the dataset is intentionally small, these are demonstration results and not real operational estimates.

**Features.** Rolling 12-month window, separate numerator/denominator CTEs, several joins, safe division, lost-hours context. This is sustainability query two.

## Query 3 — Incidents before and after training

**Decision.** Assess whether annual safety training is associated with fewer employee incidents. The query uses each employee's first completed safety course and counts incidents in symmetric 180-day windows. Test employee EMP0008 changes from one incident before to zero after; the report must not claim causality from this small synthetic sample.

**Features.** Pre/post date arithmetic, conditional aggregation, employee/course/session/incident joins.

## Query 4 — Recent overtime and review indicators

**Decision.** Identify employees for supervisor workload/safety review without exposing confidential wellbeing notes. The test output flags EMP0009 and EMP0011 because each has seven overtime hours plus a recent incident and concern. Results are triage indicators, not medical or disciplinary conclusions.

**Features.** Last-30-days logic, three CTEs, left joins, privacy-aware output and rule-based action label.

## Query 5 — Expiring qualifications procedure

**Decision.** Plan renewals using different horizons. `CALL getExpiringQualifications(30)` returns one first-aid certificate; `CALL getExpiringQualifications(90)` adds a chemical-handling permit. The parameter is constrained to 0–730 days to reject unreasonable input.

**Features.** Stored procedure with input parameter, two video calls, current-date interval logic, multiple joins.

## Query 6 — Open corrective actions View and EXPLAIN

**Decision.** Prioritise overdue/high-severity corrective action. The View reports one action five days overdue and one future high-severity action. It excludes completed/cancelled actions and calculates days overdue consistently.

**Features.** View, multiple joins, current-date elapsed logic and `EXPLAIN`.

**Execution-plan interpretation (under 100 words).** MySQL uses `idx_action_status_date` with range access to filter open/in-progress actions, then resolves incident, operational-area and employee joins using `eq_ref` primary-key lookups (one matching row each). This indicates efficient join access. The final calculated ordering requires a temporary table and filesort because it combines `daysOverdue`, a Boolean expression and custom severity ordering. That is acceptable for the small action queue; if volume grows, a persisted priority or simpler indexed ordering should be evaluated without denormalising the authoritative incident data prematurely.
