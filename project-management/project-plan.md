# Project Plan

This is the working plan. Actual dates and genuine contributions must be updated as work progresses.

| Deliverable | Final owner | Review/support | Estimated hours | Target | Actual | Key risk | Mitigation | AI use |
|---|---|---|---:|---|---|---|---|---|
| Requirements traceability and stakeholder analysis | Mia | All | 8 | Week 4 | Pending | Base-case requirement omitted | Map every case statement to a table, attribute, constraint, query, assumption or exclusion | Extraction and completeness checking |
| HR perspective and sustainability initiative | Mia | Rianna | 5 | Week 4 | Pending | Measures cannot be calculated | Define numerator, denominator, period and required source data before schema freeze | Alternatives and critique |
| Base ER model | Zora | All | 18 | Week 7 | Pending | Cardinality or historical modelling errors | Formal peer review against traceability matrix | Challenge modelling alternatives |
| HR ER extension | Zora | Rianna | 10 | Week 7 | Pending | HR extension is disconnected from operations | Link training, shifts, incidents and wellbeing to employee role and operational area | Review completeness and query support |
| Design decision record | Mia | Zora | 10 | Week 8 | Pending | Decisions are descriptive rather than justified | Document alternatives, trade-offs and traceability to ER model | Critique only; final judgement retained by team |
| Functionality, privacy and security | Mia | 1 | 7 | Week 8 | Pending | Sensitive HR data is overexposed | Define least-privilege roles and de-identified reporting views | Draft review |
| MySQL schema and database build | 1 | Zora | 20 | Week 8 | Pending | Build order or FK errors | Maintain one clean, rerunnable build sequence | SQL review followed by execution tests |
| Five database business rules | 1 | Zora | 12 | Week 10 | Pending | Rule is not enforceable with selected mechanism | Prototype CHECK, FK or trigger before report inclusion | Generate alternatives; validate in MySQL |
| Complete data dictionary | Zora | 1 | 16 | Week 10 | Pending | Dictionary diverges from SQL | Run schema-to-dictionary consistency review | Mechanical consistency assistance |
| Supplied-data audit and cleaning | 1 | Mia | 23 | After A2 spreadsheet | Blocked on source file | Official spreadsheet unavailable | Build staging and validation framework now; preserve raw copy when received | Profiling assistance; all corrections reviewed |
| Synthetic test data | 1 | Rianna | 12 | Week 10 | Pending | Data produces trivial query results | Design scenarios backwards from rules and six management questions | Initial fictitious records with manual verification |
| Five integrity tests | 1 | Zora | 8 | Week 10 | Pending | Only negative tests are shown | Include positive and negative cases, with two linked to Task 3b | Test-case review |
| Six decision-support queries | Rianna | 1 | 18 | Week 11 | Pending | Queries become routine lookups | Start each query with a management decision and expected action | SQL alternatives; results independently validated |
| View, parameterised procedure and EXPLAIN | Rianna | 1 | 10 | Week 11 | Pending | Video execution differs from report | Use scripts from final export and rehearse two parameter values | Execution-plan interpretation support |
| GenAI reflection | All | Rianna coordinates | 10 | Week 12 | Pending | Prompt history is reconstructed after the fact | Preserve genuine prompts, outputs, revisions and validation evidence now | Subject of the reflection |
| Video | All | Rianna coordinates | 12 | Week 12 | Pending | Exceeds five minutes or queries fail | Timed rehearsal using a clean database and fixed Workbench tabs | Script timing assistance only |
| Final report integration and QA | Mia | All | 10 | Week 12 | Pending | ER, dictionary, SQL and screenshots conflict | Four-way consistency audit against rubric | Formatting and cross-checking assistance |

## Checkpoints

| Milestone | Due | Required evidence | Status |
|---|---|---|---|
| Team formation | Week 3 | Four members and shared contact process | Team names recorded; contact process to confirm |
| Checkpoint 1 | Week 4 | Case understanding, perspective and functionality plan | In progress |
| Checkpoint 2 | Week 7 | Draft ER diagram and early design decisions | Pending |
| Iteration submission | Week 8 Friday | Draft Tasks 1–7 | Pending |
| Checkpoint 3 | Week 10 | Normalisation, cleaning plan and business rules | Pending |
| Checkpoint 4 | Week 11 | Draft queries and assigned business scenario | Awaiting course input |
| Final submission | Week 12 | Report, SQL export, query evidence and video | Pending |
| Buddycheck | Week 13 + one week | Genuine peer contribution review | Awaiting team activity |

