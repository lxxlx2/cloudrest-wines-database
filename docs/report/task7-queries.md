# Task 7 — Decision-Support SQL Queries

The specification inconsistently states five and six queries. Cloudrest Wines supplies six because the overview and video instructions repeatedly require execution of all six.

## Query 1 — Annual safety and sustainability training coverage

**Decision.** Direct training resources to operational areas below target. The query counts active workers and employees who completed both safety and sustainability training categories during the current year. Current test results show Vineyard at 50%, while Cellar and Administration are 0%; management should schedule the missing category rather than treating attendance at either category as full coverage.

**Features.** Six tables/CTEs, left join, annual date logic, distinct-category validation, company-wide session support and safe percentage calculation.

## Query 2 — Recorded safety incidents per 1,000 labour hours

**Decision.** Prioritise intervention using an exposure-adjusted measure rather than raw event counts. The selected management KPI counts all safety events stored in `incident`, including near misses; `reportableFlag` remains available for separate statutory/reportability analysis. In the current test baseline, Vineyard has 88 labour hours and two incidents, giving 22.73 per 1,000 hours. Cellar is 18.52. Because the dataset is intentionally small, these are demonstration results and not real operational estimates.

**Features.** Rolling 12-month window, separate numerator/denominator CTEs, operational-area driving set, left joins, lost-hours context and safe NULL output where labour-hour exposure is zero. This is sustainability query two.

## Query 3 — Affected incidents before and after latest safety training

**Decision.** Support a pre/post comparison around each employee's latest completed safety training. The query counts only incidents where the employee was recorded as `AFFECTED`, using symmetric 180-day windows. The result can suggest where further review is useful, but the report must not claim that training caused a change from this small synthetic sample.

**Features.** Latest-completion aggregation, pre/post date arithmetic, conditional aggregation, employee/course/session/incident joins and involvement-role filtering.

## Query 4 — Recent overtime and review indicators

**Decision.** Identify employees for supervisor workload/safety review without exposing confidential wellbeing notes. A recent affected incident or a recorded wellbeing concern produces `SUPERVISOR REVIEW`; overtime on its own remains visible as `MONITOR OVERTIME`. Witness/reporter participation is excluded from the employee incident count. The output is a triage aid and does not use an invented weighted risk score or imply a medical/disciplinary conclusion.

**Features.** Last-30-days logic, three CTEs, affected-incident filtering, left joins, privacy-aware output and transparent rule-based action labels.

## Query 5 — Expiring qualifications procedure

**Decision.** Plan renewals using different horizons. `CALL getExpiringQualifications(30)` returns one first-aid certificate; `CALL getExpiringQualifications(90)` adds a chemical-handling permit. The parameter is constrained to 0–730 days to reject unreasonable input.

**Features.** Stored procedure with input parameter, two video calls, current-date interval logic, multiple joins.

## Query 6 — Open corrective actions View and EXPLAIN

**Decision.** Prioritise overdue/high-severity corrective action. The View reports one action five days overdue and one future high-severity action. It excludes completed/cancelled actions and calculates days overdue consistently.

**Features.** View, multiple joins, current-date elapsed logic and `EXPLAIN`.

**Execution-plan interpretation (under 100 words).** MySQL uses `idx_action_status_date` with range access to filter open/in-progress actions, then resolves incident, operational-area and employee joins using `eq_ref` primary-key lookups (one matching row each). This indicates efficient join access. The final calculated ordering requires a temporary table and filesort because it combines `daysOverdue`, a Boolean expression and custom severity ordering. That is acceptable for the small action queue; if volume grows, a persisted priority or simpler indexed ordering should be evaluated without denormalising the authoritative incident data prematurely.
