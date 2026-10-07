# Codex Finalisation Handoff

Historical handoff checklist. Finalisation execution on 2026-10-07 is recorded in `verification/finalization-report-20261007.md`; completed model, local Workbench captures and source import are superseded by that report. Remaining business/student inputs are still required.

This handoff contains only work that requires the student's local MySQL Workbench environment, genuine course/team input, or a tutor decision. Do not redesign the schema unless a new course requirement contradicts the current revision.

## Authoritative Git state

- Base: `main` at `ae0b6d65bffcfb048218d09f660191d59136cec1`
- Working branch: `revision/tutor-feedback-v4-20261007`
- Draft PR: #2
- MySQL target: 8.4.x
- The official A2 v4 workbook has been received and profiled.
- The revised portable SQL has already passed a clean MySQL 8.4.11 rebuild and the six-query/regression CI. Re-run CI after any further source change.

## Do not guess these two inputs

1. The old responsibility aliases `Mia / Zora / Rianna / Jason` are not yet mapped one-to-one to the signed Team Charter members:
   - Zixuan Shen
   - Feiyue Ma
   - Xinzhu Wang
   - Chengye Jiang

   Ask the team for the mapping before replacing ownership/speaker labels.

2. The official v4 workbook contains repeated `(Order Id, Product Id)` groups whose rows are not exact duplicates. Their business grain is not established. Keep them in staging/exception output until the tutor/team confirms whether they are separate order lines, records to aggregate, or erroneous duplicates.

## Local Workbench tasks

1. Pull the working branch.
2. Open and execute `deliverables/final-submission/Cloudrest_Wines_Database.sql` from an empty local MySQL 8.4 schema.
3. Run all scripts in `database/tests/` according to `docs/evidence/student-screenshot-checklist.md`.
4. Export the official v4 workbook sheets to source-preserving UTF-8 CSVs and load them into the staging tables from `database/cleaning/01_v4_staging.sql`.
5. Run `database/cleaning/02_v4_profile_and_clean.sql`; capture genuine before/after and exception screenshots.
6. Resolve only the ambiguous rows for which a real tutor/team decision exists. Record the accepted/rejected reconciliation. Do not invent reset historical dates.
7. In MySQL Workbench, run `tools/workbench_build_model.py` after setting its project root to the local clone. Set **Model > Relationship Notation > UML**, arrange the complete model on a readable landscape canvas, save the final `.mwb`, and export the full ER PNG plus domain views.
8. Replace the repository's old `Cloudrest_Wines_Model.mwb` / ER images only after confirming they show:
   - vineyard planting PK `(vineyardId, vintageYear, grapeVarietyId)`
   - `harvest.grapeVarietyId`
   - `refund.productId`
   - `packmember.joinedDate` in the PK
   - `customeraddress.addressPurpose`
   - `shiftassignment.actualStartTime / actualEndTime / breakMinutes`

## Final report build

After the alias mapping, Workbench evidence and any tutor decision are supplied:

1. Update genuine completion dates/hours/contributions.
2. Run `python3 tools/verify_project.py` against the final local MySQL build.
3. Regenerate the data dictionary if schema changed:
   `python3 tools/generate_data_dictionary.py`.
4. Run `python3 tools/build_submission_sql.py`.
5. Run `python3 tools/build_word_reports.py`.
6. Insert/replace genuine Workbench evidence in the report as required by the current report workflow.
7. Visually inspect every report page at 100% zoom for clipping, unreadable tables, stale screenshots and alias placeholders.
8. Re-run all six Task 7 queries and Query 6 EXPLAIN on the same frozen build used for screenshots/video.
9. Record the four-person video using `docs/video/five-minute-script.md`, after replacing responsibility aliases with confirmed real names.
10. Complete genuine RiPPlE prompt progression/peer feedback and final contribution records.

## Stop conditions

Do not merge PR #2 if CI is red, the Workbench ER still represents the old schema, the report still says the official workbook is missing, Task 6 lacks genuine evidence, or the responsibility aliases have been replaced by guessed real names.
