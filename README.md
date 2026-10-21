# Cloudrest Wines Database Project

This repository tracks the BISM2207 database consulting project for **Cloudrest Wines**.

## Team

- Zixuan Shen
- Feiyue Ma
- Xinzhu Wang
- Chengye Jiang

The older report sources use working responsibility aliases Mia, Zora, Rianna and Jason. Their one-to-one mapping to the signed Team Charter members has not been confirmed and must not be guessed.

## Project direction

- Perspective: Human Resources, Workforce Planning and Wellbeing
- Sustainability initiative: Sustainable Workforce Safety, Training and Wellbeing Monitoring
- Database platform: MySQL 8.x and MySQL Workbench

## Repository structure

- `project-management/` — plan, risk register, responsibilities, checkpoints and progress
- `docs/requirements/` — requirement traceability, scope, assumptions and stakeholders
- `docs/report/` — report outline and written task content
- `docs/reflection/` — genuine GenAI prompt/validation logs and peer-review placeholders
- `docs/video/` — five-minute presentation plan and script
- `docs/evidence/` — evidence index for screenshots; generated screenshots will be added here
- `database/schema/` — database, tables, constraints, triggers, views and routines
- `database/data/` — cleaned supplied data and verified additional test data
- `database/cleaning/` — staging, profiling and cleaning scripts
- `database/tests/` — integrity and business-rule tests
- `database/queries/` — six decision-support queries and EXPLAIN evidence
- `database/exports/` — reproducible final SQL export
- `diagrams/` — ER diagram source and exported image
- `source-materials/` — source inventory only; assessment PDFs and supplied datasets are not published unless redistribution is permitted

## Current status

The submitted iteration has been superseded by the tutor-feedback revision on `revision/tutor-feedback-v4-20261007`. The revised schema now covers multi-variety vineyard planting/harvest, product-level refunds, picker rejoin history, current contact-history controls, 100% wine-composition release validation, and derived labour/overtime from actual assignment times. The portable database, regression tests and all six decision-support queries have been rebuilt successfully under MySQL 8.4.11.

The official A2 v4 workbook is now cleaned and imported into the final portable build: 132 accepted order lines in 79 complete orders, 50 customers, 102 addresses and 53 address histories. Reconciliation is complete: 182 = 132 imported + 1 exact duplicate rejected + 15 ambiguous-pair rows quarantined + 34 other rows quarantined. Added HR test data remains. Task 6 states all supplemental attributes and assumptions. The current report, SQL and model package is ready; student-only video, RiPPlE, Buddycheck and contribution confirmation remain. Task 8 waits for the tutor-supplied Week 11 scenario.

## Ready-to-review package

Start with `deliverables/README_FIRST.md`. The `deliverables/final-submission/` directory contains the Word report, verification report, portable database SQL, query SQL, rule-violation SQL, native Workbench model and full ER export. Generated deliverables should be rebuilt from the authoritative source scripts after material source changes.

## Access

This is a public repository for progress visibility. Public visitors have read-only access by default. Only the owner and explicitly invited collaborators can push changes.

Before real assessment submission, consider making the repository private to reduce copying and plagiarism risk. Repository visibility has not been changed automatically.
