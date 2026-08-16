# Task 5 — Data Dictionary and Build

The complete data dictionary is presented as Word-ready tables and cross-checked against the validated MySQL schema to prevent divergence between the ER model, report and build. It is organised by table and records attribute name, type/size, domain/default, nullability, uniqueness, primary-key status, foreign-key reference and business purpose.

Naming compliance:

- all table names are lowercase, singular, contain no spaces and contain no underscores;
- all attributes use lowerCamelCase;
- character-bearing identifiers (for example `EMP0001`, `WINE001`, `PROD001`) follow the owners' request;
- compound keys are demonstrated in relationship/history tables such as `winecomposition`, `orderline`, `trainingattendance` and `employeerole`;
- the clean build has been executed under MySQL 8.4.11 from an empty database.

The data dictionary was prepared as Word-ready tables and cross-checked against the implemented MySQL schema for consistency. Every field has an explicit domain/default and a semantic business definition; automation is used internally to detect schema drift. The complete source is stored in `docs/report/data-dictionary.md` and appears in the Word report appendix.
