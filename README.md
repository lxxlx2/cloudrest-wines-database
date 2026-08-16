# Cloudrest Wines Database Project

This repository tracks the BISM2207 database consulting project for **Cloudrest Wines**.

## Team

- Mia
- Zora
- Rianna
- 1

## Project direction

- Perspective: Human Resources, Workforce Planning and Wellbeing
- Sustainability initiative: Sustainable Workforce Safety, Training and Wellbeing Monitoring
- Database platform: MySQL 8.x and MySQL Workbench

## Repository structure

- `project-management/` — plan, risk register, responsibilities, checkpoints and progress
- `docs/requirements/` — requirement traceability, scope, assumptions, citation audit and tutor-confirmation questions
- `docs/report/` — report outline and written task content
- `docs/reflection/` — genuine GenAI prompt/validation logs and peer-review placeholders
- `docs/video/` — five-minute presentation plan and script
- `docs/evidence/` — student screenshot checklist, Workbench finalisation checklist and internal QA evidence
- `database/schema/` — database, tables, constraints, triggers, views and routines
- `database/data/` — verified synthetic test data
- `database/cleaning/` — staging, profiling and cleaning scripts
- `database/tests/` — assessed integrity/business-rule tests plus additional implementation controls
- `database/queries/` — six decision-support queries and EXPLAIN evidence
- `deliverables/final-submission/` — generated submission artifacts; rebuild these after authoritative source changes
- `diagrams/` — Workbench model and ER exports
- `source-materials/` — source inventory only; assessment PDFs and supplied datasets are not published unless redistribution is permitted

## Current status

The authoritative schema, report sources, query sources and verification tooling have received an additional independent manual-audit correction pass. This pass strengthens supplier physical/postal history, customer subtypes, receipt-line integrity, primary-phone controls, current-date shipment validation, product-price history and query semantics. It also corrects report citations, real Word section-orientation logic and Task 3 report ordering.

The generated database export, Word reports, verification reports and Workbench ER artifacts must now be regenerated from these authoritative sources before their counts or validation totals are treated as current. See `deliverables/final-submission/README_FIRST.md` for the exact sequence.

The final Workbench model additionally requires manual confirmation of **Model → Relationship Notation → UML**, a landscape-oriented complete EER layout and a fresh export. That manual step is explicit because MySQL Workbench session defaults can return to Crow's Foot notation.

Official spreadsheet cleaning, the Week 11 business scenario, genuine Workbench screenshots, RiPPlE work, final contribution records, fourth member identity and the four-person video still require course inputs or genuine student activity. They must not be fabricated.

## Review starting points

- `deliverables/final-submission/README_FIRST.md` — regeneration and student handoff sequence
- `docs/evidence/workbench-model-finalization.md` — required UML and ER-layout confirmation
- `docs/evidence/student-screenshot-checklist.md` — genuine evidence checklist
- `docs/requirements/citation-audit.md` — report citation cross-check
- `docs/requirements/tutor-confirmations.md` — unresolved course-material ambiguities
- `tools/verify_project.py` — expanded technical and document audit

## Access

This is a public repository for progress visibility. Public visitors have read-only access by default. Only the owner and explicitly invited collaborators can push changes.

Before real assessment submission, consider making the repository private to reduce copying and plagiarism risk. Repository visibility has not been changed automatically.
