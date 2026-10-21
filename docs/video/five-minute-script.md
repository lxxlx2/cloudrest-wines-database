# Cloudrest Wines — Five-Minute Video Presentation

## Presentation timeline

| Time | Speaker | Screen action |
|---|---|---|
| 0:00–0:30 | Zixuan Shen | Camera on + Cloudrest Wines title; open schema cloudrestwines. |
| 0:30–1:05 | Feiyue Ma | Open Cloudrest_Wines_Model.mwb; show trainingcourse, trainingsession, trainingattendance. |
| 1:05–1:29 | Xinzhu Wang | Show a valid/invalid integrity test; execute Query 1 and highlight coveragePercent. |
| 1:29–1:55 | Xinzhu Wang | Execute Query 2; highlight labourHours and incidentsPer1000Hours. |
| 1:55–2:16 | Zixuan Shen | Execute Query 3; show before/after counts for EMP0008. |
| 2:16–2:37 | Zixuan Shen | Execute Query 4; highlight thirteen active employees and five flagged rows. |
| 2:37–3:22 | Chengye Jiang | Execute CALL getExpiringQualifications(30); then CALL getExpiringQualifications(90). |
| 3:22–3:48 | Chengye Jiang | Execute Query 6; highlight target dates, severity and daysOverdue. |
| 3:48–4:06 | Feiyue Ma | Execute EXPLAIN for Query 6; highlight ALL, ref, eq_ref. |
| 4:06–4:26 | Xinzhu Wang | Show the Task 6 cleaned-data import result and source reconciliation. |
| 4:26–4:53 | All four | Camera view showing four students; each speaks one sentence. |

## Full English script and screen instructions

### 0:00–0:30 — Zixuan Shen
**ON SCREEN:** Camera on + Cloudrest Wines title; open schema cloudrestwines.

**SAY:** Hello. Welcome to our Cloudrest Wines database demonstration. We selected the Human Resources, Workforce Planning and Wellbeing perspective. Our sustainability indicators are annual safety-and-sustainability training coverage and workplace incidents per one thousand actual labour hours. We will show the model and six management queries. The HR results here use assessment test records.

### 0:30–1:05 — Feiyue Ma
**ON SCREEN:** Open Cloudrest_Wines_Model.mwb; show trainingcourse, trainingsession, trainingattendance.

**SAY:** One important design choice was separating a course, its delivered sessions, and employees’ attendance. A single training table repeats course information and makes repeat sessions difficult to manage. Our three-table structure reduces update anomalies and allows training coverage to be measured correctly. It requires extra joins, but foreign keys preserve the relationships.

### 1:05–1:29 — Xinzhu Wang
**ON SCREEN:** Show a valid/invalid integrity test; execute Query 1 and highlight coveragePercent.

**SAY:** We also enforce rules through keys and database constraints, including variety-specific harvest links. This test shows an invalid relationship being rejected. Query One then measures completion of both mandatory training categories. Vineyard has fifty percent coverage, while Cellar and Administration each have zero percent in our sample.

### 1:29–1:55 — Xinzhu Wang
**ON SCREEN:** Execute Query 2; highlight labourHours and incidentsPer1000Hours.

**SAY:** Query Two calculates worked hours from actual start, end and break values, instead of manually storing conflicting hour totals. The resulting incident rates are twenty-two point seven three for Vineyard and eighteen point five two for Cellar per thousand labour hours. Managers can compare exposure-adjusted safety outcomes.

### 1:55–2:16 — Zixuan Shen
**ON SCREEN:** Execute Query 3; show before/after counts for EMP0008.

**SAY:** Query Three compares equal observation periods before and after training. Employee zero-zero-zero-eight has one affected incident before and zero afterward in the assessment data. This supports review, but the comparison alone does not prove causation.

### 2:16–2:37 — Zixuan Shen
**ON SCREEN:** Execute Query 4; highlight thirteen active employees and five flagged rows.

**SAY:** Query Four combines calculated overtime, incident involvement and wellbeing concerns. All thirteen active employees remain visible, and five are flagged for supervisor follow-up. It supports planning without displaying private wellbeing notes.

### 2:37–3:22 — Chengye Jiang
**ON SCREEN:** Execute CALL getExpiringQualifications(30); then CALL getExpiringQualifications(90).

**SAY:** Query Five uses our parameterized stored procedure. Here I run it first for thirty days, which returns the First Aid qualification. I run it again for ninety days, which additionally returns a Chemical Handling qualification. The same procedure therefore supports immediate renewals and longer-term planning.

### 3:22–3:48 — Chengye Jiang
**ON SCREEN:** Execute Query 6; highlight target dates, severity and daysOverdue.

**SAY:** Query Six reads our open-corrective-actions view. It lists two outstanding actions, with an overdue one first and another linked to a high-severity event. The result helps the Safety Officer prioritise follow-up.

### 3:48–4:06 — Feiyue Ma
**ON SCREEN:** Execute EXPLAIN for Query 6; highlight ALL, ref, eq_ref.

**SAY:** The EXPLAIN output shows a full scan of the small incident test table and indexed lookups for the related records. This is suitable for explaining the plan, although the sample is too small to demonstrate production performance.

### 4:06–4:26 — Xinzhu Wang
**ON SCREEN:** Show the Task 6 cleaned-data import result and source reconciliation.

**SAY:** For the supplied workbook, we normalized identifiers and text, excluded one exact duplicate and quarantined ambiguous rows. We imported one hundred and thirty-two cleaned order lines in seventy-nine complete orders, preserving a clear audit trail.

### 4:26–4:53 — All four
**ON SCREEN:** Camera view showing four students; each speaks one sentence.

**SAY:** Zixuan: I coordinated the report and risk register. Feiyue: I worked on the data model and dictionary. Xinzhu: I focused on cleaning and integrity rules. Chengye: I worked on the queries and stored procedure. Thank you for watching.

## MySQL Workbench execution order

1. Open the final `Cloudrest_Wines_Model.mwb` and connect to the populated `cloudrestwines` schema.
2. Execute Query 1 training coverage; show `coveragePercent`.
3. Execute Query 2 incident rate; show `labourHours` and `incidentsPer1000Hours`.
4. Execute Query 3 training impact; show `incidentsBefore` and `incidentsAfter`.
5. Execute Query 4 workload and wellbeing; show `SUPERVISOR REVIEW`.
6. Execute `CALL getExpiringQualifications(30);` followed by `CALL getExpiringQualifications(90);`; show that results differ.
7. Execute Query 6 open corrective actions from the view.
8. Execute Query 6 `EXPLAIN`; show access types `ALL`, `ref` and `eq_ref`.
9. Display Task 6 import evidence and end with four camera tiles.
