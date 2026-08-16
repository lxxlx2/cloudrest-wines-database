# Cloudrest Wines — Delivery Instructions

## Important status

The authoritative source files have received an additional manual-audit correction pass. Generated submission artifacts must be rebuilt from those sources before final submission. Until that rebuild and the genuine student/course inputs are complete, do not treat the current files in `deliverables/final-submission/` as final-ready artifacts.

## Final submission components

1. `Cloudrest_Wines_Report.docx` — upload through the Turnitin report point after genuine evidence is inserted and final mode succeeds.
2. `Cloudrest_Wines_Database.sql` — complete portable MySQL build, constraints, data, reporting objects and six queries.
3. `Cloudrest_Wines_Video.mp4` — the team must record this after importing the database.
4. GenAI Reflection — submit separately through RiPPlE using genuine team prompt logs and tutor-confirmed peer-review requirements.

## Required regeneration sequence

1. Rebuild `Cloudrest_Wines_Database.sql` and `Cloudrest_Wines_Queries.sql` with `python3 tools/build_submission_sql.py`. The portable database must include `04_final_controls.sql` and `02_manual_audit_patch.sql`.
2. Import the rebuilt database SQL into an empty MySQL 8.4 environment.
3. Regenerate the Word-ready data dictionary from the live schema with `python3 tools/generate_data_dictionary.py`.
4. Run `python3 tools/verify_project.py` in development mode.
5. Run `python3 tools/verify_manual_audit_controls.py`. Both verification layers must pass before generated counts are treated as current.
6. Run `tools/workbench_build_model.py` inside MySQL Workbench to rebuild the editable model and diagrams.
7. Open the generated `.mwb` model, select **Model → Relationship Notation → UML**, arrange the complete model on a wide landscape canvas, save the model and re-export the complete ER PNG. Follow `docs/evidence/workbench-model-finalization.md`.
8. Re-run both verification layers after the final ER export.
9. Rebuild the Word reports with `python3 tools/build_word_reports.py`.
10. Render and visually inspect the Word report. Confirm real landscape sections, readable ER diagrams, complete tables and no layout defects.
11. Capture genuine MySQL Workbench screenshots following `docs/evidence/student-screenshot-checklist.md` and insert the evidence into the final report workflow.
12. After the fourth member name, all four student numbers, submission date, actual completion dates and genuine evidence are available, create the ignored `project-management/final-inputs.json` from the example and run the final-mode process. Final mode must fail while required genuine data or evidence remains incomplete.

The table/column/FK/CHECK structure was not changed by the latest cross-row-control pass. The authoritative trigger sources now contain 43 trigger definitions in total and the schema contains four stored routines when `getExpiringQualifications`, `validateCustomerSubtype`, `validateWineComposition` and `validatePickingPackRules` are included. These are expected source counts only. The live MySQL metadata produced after regeneration is the source of truth.

## Import into the student's MySQL Workbench

1. Open the student's `Local instance 3306` connection using their own MySQL account.
2. Choose **File → Open SQL Script** and open the regenerated `Cloudrest_Wines_Database.sql`.
3. Execute the complete script using the lightning icon.
4. Refresh **SCHEMAS** and expand `cloudrestwines`.
5. Review the fresh verification reports rather than relying on historical 55-table/15-trigger/64-check counts.
6. Open `Cloudrest_Wines_Queries.sql` and execute each numbered query separately.
7. Run the procedure with both `30` and `90` parameters during the video.

The database script intentionally drops and rebuilds `cloudrestwines`. Do not run it against a database containing irreplaceable work.

## Items requiring genuine students/course inputs

- Replace placeholder member `1` with the enrolled name and enter all four real student numbers.
- Fill actual completion dates and confirm genuine contribution allocation.
- Add official A2 spreadsheet error analysis, cleaning SQL and before/after screenshots.
- Complete the Week 11 assigned business scenario.
- Capture the final screenshots in the students' MySQL Workbench environment. Programmatically rendered CLI images are internal QA evidence only.
- Confirm UML relationship notation in the final Workbench model and save/re-export it.
- Record the four-person video.
- Complete genuine RiPPlE prompt progression and peer review according to the tutor-confirmed requirement.

## Tutor questions

See `docs/requirements/tutor-confirmations.md` before final submission, particularly the conflicting RiPPlE peer-review wording, query-count wording, concurrent-role interpretation and UML-notation confirmation.
