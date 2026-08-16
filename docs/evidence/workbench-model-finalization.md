# Final MySQL Workbench Model Confirmation

This is a required manual confirmation before final submission. The automated build can create the `.mwb` model and EER diagrams, but the final relationship-notation selection must be checked in MySQL Workbench.

## Required final steps

1. Open `deliverables/final-submission/Cloudrest_Wines_Model.mwb` in MySQL Workbench.
2. Open the complete EER diagram.
3. Select **Model → Relationship Notation → UML**.
4. Confirm the complete model uses UML relationship notation throughout.
5. Use **Model → Diagram Properties and Size** to provide a wide canvas.
6. Rearrange the complete model into a landscape-oriented multi-column layout so entity names, attributes, PK/FK markers and cardinalities are readable at report size.
7. Re-export `Cloudrest_Wines_ER_Diagram.png` from Workbench.
8. Save the `.mwb` model after selecting UML notation because Workbench saves the notation with the model.
9. Rebuild the Word report and visually inspect the full ER page at 100% zoom.

## Acceptance criteria

- Relationship notation: UML.
- Full ER export is landscape oriented, with width greater than height.
- Recommended export resolution: at least 3500 × 2000 pixels.
- The Word report uses a genuine landscape section and embeds the full ER near full-page width.
- The six domain views remain available for readable detail.

## Why this remains manual

MySQL Workbench defaults to Crow's Foot notation when a new Workbench session starts. The selected relationship notation is saved with the model, so the final `.mwb` and exported diagram must be checked after generation and before submission.
