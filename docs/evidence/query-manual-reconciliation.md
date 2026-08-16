# Six-Query Manual Reconciliation

| Query | Small hand check | Expected / SQL confirmation |
|---|---|---|
| Q1 training coverage | Vineyard has 6 active employees; EMP0002, EMP0003 and EMP0008 completed both required categories | 3/6 = 50.0%; distinct employee/category counting prevents duplicates and company-wide sessions remain eligible |
| Q2 incident rate | Two incidents over 100 labour hours | `(2 / 100) × 1,000 = 20.00`; SQL counts incidents by area separately from summed assignments and uses `NULLIF` |
| Q3 training comparison | Only `AFFECTED` rows belong in an employee's incident experience | REPORTER/WITNESS rows excluded; synthetic result demonstrates logic, not causation |
| Q4 overtime risk | Employee overtime is summed once from shift assignments; incident count uses a separate aggregate | No many-to-many multiplication; an employee may have high overtime and zero incidents |
| Q5 expiring qualifications | 30-day call includes the 25-day item; 90-day call includes 25- and 80-day items | Boundary uses inclusive `BETWEEN`; invalid/zero denominator is not applicable |
| Q6 open actions | Only OPEN/INPROGRESS actions appear; completed action is absent | View produces one row per corrective action and exposes no confidential wellbeing text |

The SQL evidence is checked automatically. Students should recalculate the displayed values after any genuine data change before submission.
