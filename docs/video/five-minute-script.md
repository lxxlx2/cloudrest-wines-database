# Five-Minute Video Run Sheet

The team should speak naturally and rehearse to 4:40–4:55. Do not read the report verbatim.

| Time | Speaker | Content/action |
|---|---|---|
| 0:00–0:35 | Mia | Introduce Cloudrest Wines, spreadsheet/Word problem, HR perspective and two sustainability measures. |
| 0:35–1:10 | Zora | Show the Workbench EER model and explain the course/session/attendance design decision plus its trade-off. |
| 1:10–1:40 | Jason | Demonstrate one valid integrity test and the PO Box trigger failure; explain database-level protection. |
| 1:40–2:05 | Rianna | Run Query 1 and state the verified coverage: Vineyard 50%, Cellar 0%, Administration 0%. |
| 2:05–2:30 | Rianna | Run Query 2 and explain the verified rates: Vineyard 22.73 and Cellar 18.52 incidents per 1,000 actual labour hours. |
| 2:30–2:55 | Mia | Run Query 3; explain that the synthetic pre/post result demonstrates capability, not causation. |
| 2:55–3:20 | Zora | Run Query 4; explain privacy-aware workload triage. |
| 3:20–3:50 | Jason | Call `getExpiringQualifications(30)` and `(90)` and compare results. |
| 3:50–4:20 | Rianna | Run Query 6 and show the open-action priority output. |
| 4:20–4:40 | Rianna | Briefly show the final Workbench EXPLAIN. In the latest standalone CI execution, `correctiveaction` used the status/date index with `range` access, the remaining joins used `eq_ref` primary-key lookups, and the priority ordering used temporary/filesort. |
| 4:40–4:58 | All | Each member states their genuine contribution in one short sentence; close with management/public-value benefit. |

## Workbench preparation checklist

- Import the final database SQL on the student's machine.
- Pre-open six query tabs plus integrity-test and EER-model tabs.
- Increase SQL/result-grid font for video readability.
- Clear unrelated tabs and personal information.
- Test both procedure parameters.
- Record at 1080p and ensure the Action Output/error text is readable.
- Never claim the fictitious test results are real winery performance.


## Final speaker-name gate

Mia, Zora, Rianna and Jason are responsibility aliases retained from the earlier planning draft. Before recording, replace each alias with the correct signed Team Charter member after the group confirms the one-to-one mapping. Do not infer the mapping from name order.

## Current finalisation run sheet (prospective)

Chengye Jiang coordinates the final demonstration sequence. This assigns work for this round and does not replace or retrospectively identify the earlier alias speakers. NEEDS HUMAN CONFIRMATION: alias → real-name mapping.

1. Zixuan Shen: opening, integrated requirements, Risk Register, tutor-feedback traceability and outstanding inputs.
2. Feiyue Ma: revised full UML model and domain views; demonstrate the planting key, refund product, membership dates and actual shift attributes.
3. Xinzhu Wang: raw v4 source counts, deterministic clean projections, exceptions and integrity tests. Explain that 166 candidates are not approved production imports.
4. Chengye Jiang: demonstrate the six query outputs, 30/90-day procedure calls and the actual final EXPLAIN.
5. Zixuan Shen: close with package QA and explicit remaining human items.

Use the frozen 2026-10-07 results and local Workbench evidence. HR figures are synthetic assessment results, not real winery performance. Query 6 final EXPLAIN uses incident ALL, correctiveaction ref and two eq_ref lookups after ANALYZE TABLE. Record a genuine four-person video and confirm timing in rehearsal; no recording is claimed here.
