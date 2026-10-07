# Task 5 — Data Dictionary and Build

The complete data dictionary is presented as Word-ready tables and cross-checked against the validated MySQL schema to prevent divergence between the ER model, report and build. It is organised by table and records attribute name, type/size, domain/default, nullability, uniqueness, primary-key status, foreign-key reference and business purpose.

Naming compliance:

- all table names are lowercase, singular, contain no spaces and contain no underscores;
- all attributes use lowerCamelCase;
- character-bearing identifiers (for example `EMP0001`, `WINE001`, `PROD001`) follow the owners' request;
- compound keys are demonstrated in relationship/history tables such as `winecomposition`, `orderline`, `trainingattendance` and `employeerole`;
- the clean build has been executed under MySQL 8.4.11 from an empty database.

The data dictionary was prepared as Word-ready tables and cross-checked against the implemented MySQL schema for consistency. Every field has an explicit domain/default and a semantic business definition; automation is used internally to detect schema drift. The complete source is stored in `docs/report/data-dictionary.md` and appears in the Word report appendix.


## Revised build verification

The final tutor-feedback build was verified under MySQL 8.4.11 on 2026-10-07: **55 base tables, 1 view, 286 columns, 72 foreign keys, 50 CHECK constraints, 30 triggers and 3 routines**. The 286-row dictionary was regenerated from that live schema. The Workbench model contains 276 base-table attributes; the reporting view contributes the remaining 10 dictionary attributes. All modeled column names and primary keys match the regenerated dictionary.
