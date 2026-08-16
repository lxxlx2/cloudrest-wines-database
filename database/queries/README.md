# Decision-Support Query Catalogue

| Query | Management decision | Rubric features |
|---|---|---|
| 01 Training coverage | Direct training resources to operational areas below target | Sustainability; multiple joins; annual date logic; company-wide sessions; left join |
| 02 Incident rate | Prioritise safety intervention by exposure-adjusted incident rate | Sustainability; multiple joins; rolling 12 months; CTEs |
| 03 Training impact | Assess whether annual safety training is associated with fewer affected-employee incidents | Pre/post elapsed-date windows; multiple joins; `AFFECTED` role filter |
| 04 Overtime risk | Identify employees needing workload/safety review without exposing confidential notes | Last 30 days; multiple left joins; affected-incident filter; privacy-aware output |
| 05 Expiring qualifications | Schedule renewal activity for different planning horizons | Parameterised stored procedure; 30/90-day video calls |
| 06 Open actions | Prioritise overdue corrective action by severity | View; elapsed days; `EXPLAIN`; indexed joins/filter |

The specification inconsistently states five and six queries. Six are supplied because the overview and video requirements repeatedly require all six. Confirm this interpretation with the tutor before final submission.
