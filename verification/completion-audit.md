# Cloudrest Wines Finalisation Completion Audit

Updated 2026-10-08. Current evidence supersedes the earlier development audit.

- MySQL 8.4.11 empty-database rebuild: PASS.
- Development-mode repository verifier: PASS, 73/73 checks, zero required failures. This is not final course acceptance.
- Schema: 55 base tables, 1 view, 286 columns, 72 foreign keys, 50 CHECK constraints, 30 triggers, 3 routines.
- T01–T11 and five assessed business rules: expected outcomes verified. Clean rebuild removes standalone test setup rows before frozen query capture.
- Official v4 workbook: SHA-verified; 182 orders, 102 starting addresses, 53 history business rows imported into private staging. Workbook and raw exports are not published.
- Deterministic fixes: six IDs, 24 wine encoding values, nine address encoding values, three company whitespace values, one exact copy excluded from clean projection.
- Staging accounting: 182 = 1 exact copy + 15 ambiguous rows held in seven pairs + 166 other candidates. Candidates are not approved production records; production accepted/rejected reconciliation remains UNRESOLVED.
- Genuine Workbench captures and frozen six-query TSV outputs include final Query 6 EXPLAIN. Synthetic HR results do not describe real winery performance.
- Native revised UML model: 55 tables / 276 base attributes / 72 relationships / seven diagrams; the view adds ten dictionary attributes for 286 total. All submission copies match source bytes.
- Main Word report: 100 rendered pages; verification report: five. Every page visually inspected, no observed clipping or blank pages. Embedded images match current sources. Full ER overview is supplemented by six enlarged domain views.
- Package hashes: final-package-sha256.txt. Model audit: workbench-model-audit.json. Word QA: word-render-qa.json.

## Human items

Tutor/business disposition of ambiguous pairs, mixed statuses, address canonicalisation and shared phones; final production reconciliation; missing Week 11 scenario; alias-to-real-name mapping; genuine contribution dates/hours and submission date; student evidence review and recapture if course policy requires; genuine four-person video, RiPPlE prompt progression and peer reviews/Buddycheck.

The technical package passes development checks. Full submission readiness remains NO until mandatory human items are completed. The named responsibilities are prospective current-round work, not historical contribution claims.
