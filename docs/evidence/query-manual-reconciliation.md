# Six-Query Manual Reconciliation

| Query | Small hand check | Expected / SQL confirmation |
|---|---|---|
| Q1 training coverage | Vineyard has 6 active employees; EMP0002, EMP0003 and EMP0008 completed both required categories | 3/6 = 50.0%; distinct employee/category counting prevents duplicates and company-wide sessions remain eligible |
| Q2 incident rate | Vineyard has 88 labour hours in the current synthetic 12-month fixture and two recorded safety incidents | `(2 / 88) × 1,000 = 22.73`; hours are summed independently from incidents, all operational areas remain visible, and a zero-hour area returns a NULL rate instead of disappearing |
| Q3 training comparison | Only `AFFECTED` rows belong in an employee's incident experience | REPORTER/WITNESS rows excluded; synthetic result demonstrates association logic, not causation |
| Q4 overtime risk | Employee overtime is summed once from shift assignments; incident count uses a separate aggregate | No many-to-many multiplication; an employee may have high overtime and zero affected incidents |
| Q5 expiring qualifications | 30-day call includes the 25-day item; 90-day call includes 25- and 80-day items | Boundary uses inclusive `BETWEEN`; invalid/zero denominator is not applicable |
| Q6 open actions | Only OPEN/INPROGRESS actions appear; completed action is absent | View produces one row per corrective action and exposes no confidential wellbeing text |

The 88 Vineyard labour hours are hand-reconciled from the fixture: SHFT0001 = 37 hours, SHFT0002 = 35 hours and SHFT0005 = 16 hours. The SQL evidence must be recalculated after any genuine data change before submission.
