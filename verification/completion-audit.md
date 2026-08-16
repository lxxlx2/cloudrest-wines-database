# Cloudrest Wines Completion and Handoff Audit

## Result

All locally completable technical work has been produced and independently rerun. The portable database build passes 31/31 automated checks on MySQL 8.4.11. The final Word report renders to 45 pages and the verification report to 3 pages without observed clipping, overlap, blank pages or section reordering. Both final DOCX files pass the packaged accessibility audit with zero high-, medium- or low-severity findings.

## Cross-artifact consistency

- Database: 53 base tables, 1 view, 274 columns, 69 foreign keys, 47 CHECK constraints, 11 triggers and 1 stored procedure.
- Business-rule evidence: one valid control and five expected failures; Rule 3 is the case-specific minimum-age rule.
- Analytics: six decision-support query scripts execute and return results; the package includes a view, parameterised procedure and EXPLAIN evidence.
- Model: native MySQL Workbench `.mwb`, full ER export and six readable domain views are generated from the schema.
- Dictionary: generated from `information_schema`, covering all 274 fields and the reporting view.
- Report: Tasks 1–7, evidence, references, complete dictionary and handoff checklist are integrated.
- Reproducibility: `tools/verify_project.py` rebuilds the database before checking structure, naming, invariants, queries and isolated rule tests.

## Deliberately incomplete external items

These cannot be truthfully fabricated and remain clearly marked:

1. Official A2 spreadsheet: not supplied, so real error rows, corrections and before/after screenshots are pending; a runnable staging/profiling/cleaning framework is included.
2. Week 11 assigned scenario: not supplied.
3. Four-person video: script and run order are supplied, but the students must record and submit it.
4. RiPPlE reflection and peer review: a capture pack is supplied; genuine prompts, individual reflection and peer feedback must be completed by the students.
5. Administrative fields: submission date, placeholder member `1`, actual hours/contribution percentages and any required student numbers must be completed by the group.

## Independent reproduction

1. Read `deliverables/README_FIRST.md`.
2. Run `deliverables/final-submission/Cloudrest_Wines_Database.sql` in MySQL 8.4+.
3. Run `python3 tools/verify_project.py`; expected result is `PASS`, 31/31.
4. Compare final package files against `verification/final-package-sha256.txt` using `shasum -a 256`.
5. Inspect `verification/verification-report.json` for machine-readable evidence and `verification/verification-report.md` for the human-readable audit.
