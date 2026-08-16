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

## Assessment audit sources

Independent reviewers should start with:

- `source-materials/assessment/SOURCE_INDEX.md` — identifies the four authoritative student-supplied course documents
- `source-materials/assessment/AUDIT_STANDARD.md` — comprehensive requirement and High Distinction audit map derived from those documents
- `docs/requirements/tutor-confirmations.md` — unresolved source conflicts that should not be silently guessed
- `verification/external-audit-round-2-response.md` — disposition of the latest independent audit findings
- `verification/manual-fix-handoff.md` — current authoritative-source and regeneration status

The original course PDFs are intentionally not copied into this public repository by automation. If redistribution is permitted, or after the repository is made private, the students may place the four original PDFs beside the audit map so a reviewer can compare the project directly with the source documents.

## Repository structure

- `project-management/` — plan, risk register, responsibilities, checkpoints and progress
- `source-materials/assessment/` — authoritative-source index and independent audit standard
- `docs/requirements/` — requirement traceability, scope, assumptions, citation audit and tutor-confirmation questions
- `docs/report/` — report outline and written task content
- `docs/reflection/` — genuine GenAI prompt/validation logs and peer-review placeholders
- `docs/video/` — five-minute presentation plan and script
- `docs/evidence/` — student screenshot checklist, Workbench finalisation checklist and internal QA evidence
- `database/schema/` — tables, constraints, triggers, views and validation/reporting routines
- `database/data/` — synthetic test data and post-load alignment/validation
- `database/cleaning/` — staging, profiling and cleaning scripts
- `database/tests/` — assessed integrity/business-rule tests plus additional implementation controls
- `database/queries/` — six decision-support queries and EXPLAIN evidence
- `deliverables/final-submission/` — generated submission artifacts; rebuild these after authoritative source changes
- `diagrams/` — Workbench model and ER exports
- `.github/workflows/source-verification.yml` — MySQL 8.4 source-level CI that excludes genuine Workbench/student evidence

## Current status

The authoritative schema, report, query, dictionary-generator and verification sources have received two manual grading-oriented audit passes. The latest pass additionally addresses employee/customer address overlap, picking-pack validation, wine composition finalisation, customer subtype completeness before transaction, order-line finalisation, incident-KPI consistency, Query 2 reconciliation, Query 3/4 semantics, Data Dictionary uniqueness/domain quality, FINAL_MODE member/student metadata and expanded traceability.

A source-level GitHub Actions workflow now provides a current MySQL technical check independently of the stale historical generated package. It does not replace the required final MySQL Workbench UML/landscape confirmation, genuine screenshots, A2 cleaning, Week 11 scenario, video or RiPPlE work.

The generated database export, Word reports, verification reports, Data Dictionary and Workbench ER artifacts must be regenerated from the current authoritative sources before their historical counts or validation totals are treated as current. Follow `deliverables/final-submission/README_FIRST.md`.

The final Workbench model still requires manual confirmation of **Model → Relationship Notation → UML**, a landscape-oriented complete EER layout, save and fresh export.

Official spreadsheet cleaning, the Week 11 business scenario, genuine Workbench screenshots, RiPPlE work, final contribution records, fourth member identity/student numbers and the four-person video remain genuine course/student dependencies. They must not be fabricated.

## Review starting points

- `source-materials/assessment/AUDIT_STANDARD.md`
- `verification/external-audit-round-2-response.md`
- `verification/manual-fix-handoff.md`
- `deliverables/final-submission/README_FIRST.md`
- `docs/evidence/workbench-model-finalization.md`
- `docs/evidence/student-screenshot-checklist.md`
- `docs/requirements/citation-audit.md`
- `docs/requirements/tutor-confirmations.md`
- `tools/verify_project.py`
- `tools/verify_manual_audit_controls.py`
- `tools/ci_source_verify.py`

## Access

This is currently a public repository for progress visibility. Public visitors have read-only access by default. Only the owner and explicitly invited collaborators can push changes.

Before real assessment submission, consider making the repository private to reduce copying and plagiarism risk. Repository visibility has not been changed automatically.
