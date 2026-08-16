# Cloudrest Wines — Delivery Instructions

## Important status

The authoritative source files have received a final manual-audit correction pass. Generated submission artifacts must be rebuilt from those sources before final submission. Until that rebuild and the genuine student/course inputs are complete, do not treat the current files in `deliverables/final-submission/` as final-ready artifacts.

## Final submission components

1. `Cloudrest_Wines_Report.docx` — upload through the Turnitin report point after genuine evidence is inserted and final mode succeeds.
2. `Cloudrest_Wines_Database.sql` — complete portable MySQL build, constraints, data, reporting objects and six queries.
3. `Cloudrest_Wines_Video.mp4` — the team must record this after importing the database.
4. GenAI Reflection — submit separately through RiPPlE using genuine team prompt logs and peer reviews.

## Required regeneration sequence

1. Rebuild `Cloudrest_Wines_Database.sql` and `Cloudrest_Wines_Queries.sql` from the authoritative schema/query sources with `python3 tools/build_submission_sql.py`.
2. Import the rebuilt database SQL into MySQL 8.4 and run `python3 tools/verify_project.py` in development mode.
3. Run `tools/workbench_build_model.py` inside MySQL Workbench to rebuild the editable model and diagrams.
4. Open the generated `.mwb` model, select **Model → Relationship Notation → UML**, arrange the complete model on a wide landscape canvas, save the model and re-export the complete ER PNG. Follow `docs/evidence/workbench-model-finalization.md`.
5. Re-run verification after the final ER export.
6. Rebuild the Word reports with `python3 tools/build_word_reports.py`.
7. Render and visually inspect the Word report. Confirm real landscape sections, readable ER diagrams, complete tables and no layout defects.
8. Capture genuine MySQL Workbench screenshots following `docs/evidence/student-screenshot-checklist.md` and insert them into the report.
9. After the fourth member name, submission date, actual completion dates and genuine evidence are available, supply the final inputs and run the project final-mode process. Final mode must fail while placeholders or draft labels remain.

After the updated trigger source is regenerated, the schema should contain 55 base tables, 1 view and 28 triggers; the verification tool reads final metrics dynamically and should be treated as the source of truth after a clean rebuild.

## Import into the student's MySQL Workbench

1. Open the student's `Local instance 3306` connection using their own MySQL account.
2. Choose **File → Open SQL Script** and open the regenerated `Cloudrest_Wines_Database.sql`.
3. Execute the complete script using the lightning icon.
4. Refresh **SCHEMAS** and expand `cloudrestwines`.
5. Review the verification summary rather than relying on hard-coded historical counts.
6. Open `Cloudrest_Wines_Queries.sql` and execute each numbered query separately.
7. Run the procedure with both `30` and `90` parameters during the video.

The database script intentionally drops and rebuilds `cloudrestwines`. Do not run it against a database containing irreplaceable work.

## Items requiring genuine students/course inputs

- Replace placeholder member `1` with the enrolled name and add required student numbers.
- Fill actual completion dates and confirm genuine contribution allocation.
- Add official A2 spreadsheet error analysis, cleaning SQL and before/after screenshots.
- Complete the Week 11 assigned business scenario.
- Capture the final screenshots in the students' MySQL Workbench environment. Programmatically rendered CLI images are internal QA evidence only.
- Confirm UML relationship notation in the final Workbench model and save/re-export it.
- Record the four-person video.
- Complete genuine RiPPlE prompt progression and peer review according to the tutor-confirmed requirement.

## Tutor questions

See `docs/requirements/tutor-confirmations.md` before final submission, particularly the conflicting RiPPlE peer-review wording, query-count wording and UML-notation confirmation.
