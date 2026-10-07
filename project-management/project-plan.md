# Project Plan

Planning assignments are agreed directions only. Genuine actual completion dates and contribution evidence remain pending student confirmation.

| Task Description | Responsible Team Member(s) | Final Deliverable Owner | Estimated Hours | Target Completion Date | Actual Completion Date | Expected Output / Evidence | Risk or Challenge | Mitigation Strategy | AI Used / How Used |
|---|---|---|---:|---|---|---|---|---|---|
| Requirements, traceability and planning | Mia / All | Mia | 8 | Week 4 | Pending | Traceability matrix and checkpoints | Case omission | Cross-check every case section | Extraction and completeness checking |
| HR perspective and sustainability measures | Mia / Rianna | Mia | 5 | Week 4 | Pending | Defined HR scope and measures | Measures not calculable | Define sources, numerator and denominator | Alternatives and critique |
| Base and HR ER model | Zora / All | Zora | 28 | Week 7 | Pending | Complete Workbench model and domain views | Cardinality/history errors | Peer review against case | Modelling alternatives |
| Four design decisions | Mia / Zora | Mia | 10 | Week 8 | Pending | Cited decisions, alternatives and trade-offs | Descriptive rationale | Trace each choice to ER | Draft and critique |
| Schema and five assessed rules | Jason / Zora | Jason | 32 | Week 10 | Pending | Clean SQL, constraints and violations | Build or rule failure | Rebuild from empty database | SQL review and tests |
| Data dictionary | Zora / Jason | Zora | 16 | Week 10 | Pending | Complete Word tables | Schema drift | Automated consistency cross-check | Mechanical QA |
| Official A2 cleaning | Jason / Mia | Jason | 23 | Week 10–11 | In progress | v4 audit, staging, corrections, exceptions, reconciliation and evidence | Ambiguous duplicate order/product rows and reset history dates | Preserve raw source; auto-correct only deterministic defects; quarantine ambiguity | Profiling, consistency checks and draft SQL |
| Synthetic data and integrity tests | Jason / Rianna | Jason | 20 | Week 10 | Pending | Histories and five assessed tests | Trivial/invalid baseline | Scenario coverage and isolated negatives | Coverage critique |
| Six analytical queries | Rianna / Jason | Rianna | 28 | Week 11 | Pending | Queries, view, procedure and EXPLAIN | Join inflation/incorrect metric | Manual reconciliation | SQL alternatives and review |
| RiPPlE reflection | All | Rianna | 10 | Week 12 | Pending | Genuine prompt progression and peer review | Fabrication | Preserve real prompt evidence | Subject of reflection |
| Video | All | Rianna | 12 | Week 12 | Pending | Five-minute four-person demonstration | Timing/understanding | Timed rehearsal | Structure and timing support |
| Final integration and QA | Mia / All | Mia | 10 | Week 12 | Pending | Report, SQL and independent audit | Cross-file mismatch | Automated and human review | Consistency checking |

## Checkpoints

| Milestone | Due | Required evidence | Status |
|---|---|---|---|
| Team formation | Week 3 | Four members and shared contact process | Team names recorded; contact process to confirm |
| Checkpoint 1 | Week 4 | Case understanding, perspective and functionality plan | Technical draft prepared; student confirmation pending |
| Checkpoint 2 | Week 7 | Draft ER diagram and design decisions | Technical draft prepared; tutor feedback pending |
| Iteration submission | Week 8 Friday | Draft Tasks 1–7 | Student submission pending |
| Checkpoint 3 | Week 10 | Normalisation, cleaning plan and rules | Official v4 workbook received and profiled; final Workbench evidence pending |
| Checkpoint 4 | Week 11 | Draft queries and assigned scenario | Scenario allocation pending |
| Final submission | Week 12 | Report, SQL, evidence and video | Genuine student inputs pending |
| Buddycheck | Week 13 + one week | Genuine contribution review | Student activity pending |


## Expanded risk register

This section expands the short Risk / Challenge and Mitigation cells above in response to tutor feedback. It records cause, affected work, prevention and contingency separately.

| Risk | Why it may occur | Tasks affected | Likelihood | Impact | Prevention | Contingency / response | Owner |
|---|---|---|---|---|---|---|---|
| Schema drift after tutor feedback | PK/FK changes to planting, harvest, refund, pack membership, customer address and shift records affect many downstream files | Tasks 3–7, ERD, dictionary, SQL, video | High | High | Treat schema SQL as the source of truth; regenerate derived deliverables only after a clean rebuild | Freeze further model changes, rerun all regression tests, regenerate dictionary/ERD/report before submission | Zora / Jason |
| Ambiguous v4 duplicate order/product rows | The workbook contains repeated Order Id + Product Id combinations with different quantities, prices or statuses | Task 6, customer/order migration | High | High | Preserve raw staging rows and source row numbers; automatically correct only exact duplicates | Quarantine ambiguous groups and obtain tutor/business confirmation before aggregation or schema redesign | Jason / Mia |
| Lost historical start dates | The source workbook explicitly states some current-customer start dates were reset during export | Task 6, address history | Medium | Medium | Record the source limitation and keep raw values unchanged | Do not invent dates; disclose the limitation and use only confirmed history in analysis | Jason / Mia |
| Multiple simultaneous current history rows | Date-range associations can accidentally create two current addresses/phones/roles | Tasks 3–5 | Medium | High | Database triggers enforce non-overlap by business meaning and one current primary phone | Reject conflicting writes, correct source periods in staging, rerun history integrity queries | Jason / Zora |
| Wine composition does not total 100% | Percentage rows are a cross-row rule that a normal CHECK cannot enforce | Tasks 3–5 | Medium | High | Validate composition at active product release and lock released recipes; global validation routine checks all wines | Deactivate product, correct composition in a controlled transaction, rerun validation before release | Jason / Zora |
| Labour-hour inconsistency | Storing shift start/end plus manually entered regular/overtime totals creates two facts that can disagree | Tasks 3, 7 | Medium | High | Store actual assignment start/end/break and derive labour/overtime in queries | Reject invalid time ranges; recompute all workforce metrics after correction | Jason / Rianna |
| Query interpretation diverges from final schema/data | Late schema/data changes can make Task 7 results or explanations stale | Task 7, report, video | High | High | Run all six queries only against the final clean build; reconcile key totals manually | Replace screenshots/result text, document changed numbers, and repeat EXPLAIN on the final build | Rianna / Jason |
| Final evidence cannot be reproduced | Screenshots or video may come from a different database build than submitted SQL | Tasks 3, 6, 7 and video | Medium | High | Rebuild from the final portable SQL immediately before evidence capture | Recapture evidence from the final build; never reuse stale screenshots | All / Mia |
