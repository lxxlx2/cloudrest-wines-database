# Task 5 — Data Dictionary and Build

The complete data dictionary is generated directly from the validated MySQL schema to prevent divergence between the ER model, Word report and build. It is organised by table and records attribute name, type/size, domain/default, nullability, uniqueness, primary-key status, foreign-key reference and business purpose.

Naming compliance:

- all table names are lowercase, singular, contain no spaces and contain no underscores;
- all attributes use lowerCamelCase;
- character-bearing identifiers (for example `EMP0001`, `WINE001`, `PROD001`) follow the owners' request;
- compound keys are demonstrated in relationship/history tables such as `winecomposition`, `orderline`, `trainingattendance` and `employeerole`;
- the clean build has been executed under MySQL 8.4.11 from an empty database.

The generated dictionary is stored in `docs/report/data-dictionary.md` and will also appear in the Word report appendix. Attribute purposes are initially derived from schema/table context and are subject to a final human wording pass before submission.
