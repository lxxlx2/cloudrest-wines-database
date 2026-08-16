# Five Assessed Integrity Tests

| Test | Scenario | SQL file | Expected result | Explanation / genuine evidence |
|---|---|---|---|---|
| T01 | Insert a valid completed training outcome | `t01_validtraining.sql` | Accepted and rolled back | Confirms complete HR outcome fields are supported. `[PENDING STUDENT WORKBENCH SCREENSHOT]` |
| T02 | Role end precedes start | `t02_invalidroledate.sql` | CHECK rejection | Prevents impossible role history. `[PENDING STUDENT WORKBENCH SCREENSHOT]` |
| T03 | Reorder disabled without comment | `t03_missingreordercomment.sql` | CHECK rejection | Preserves the sourcing/quality reason. `[PENDING STUDENT WORKBENCH SCREENSHOT]` |
| T04 | Ship an unpaid order | `t04_unpaidshipment.sql` | Trigger rejection | Prevents dispatch before accounting confirmation. `[PENDING STUDENT WORKBENCH SCREENSHOT]` |
| T05 | Add overlapping supervisor period | `t05_overlappingsupervision.sql` | Trigger rejection | Enforces one supervisor at a point in time. `[PENDING STUDENT WORKBENCH SCREENSHOT]` |

Every invalid test is executed against a freshly rebuilt baseline. Additional legal-age, postal-shipment and percentage tests are retained outside the assessed five.
