# Tutor Confirmation Questions

These points are ambiguous or internally inconsistent across the supplied course materials and should be confirmed before final submission. Existing database controls remain provisional project decisions until any tutor answer is recorded.

1. **Concurrent employee roles**
   - Current model allows one active role period per employee.
   - Does the case permit an employee to hold multiple active roles at the same time?

2. **Picking pack minimum of four and common grape-farmer supervisor**
   - Current design provides executable `validatePickingPackRules()` validation after a pack has been assembled. It checks at least four current members, active casual-seasonal Picker classification, one current pack per picker, an active Grape Farmer pack supervisor and matching supervision.
   - A row trigger is deliberately not used for the four-member minimum because it would reject the first three incremental member inserts.
   - Is this explicit finalisation/validation-procedure approach acceptable for the case rule?

3. **Wine composition totals**
   - Composition rows may be entered incrementally.
   - Before a saleable `wineproduct` is inserted or changed, a trigger calls `validateWineComposition()` and requires at least one composition row totalling exactly 100%.
   - Is the product-creation boundary an acceptable interpretation of “before release” for this assignment?

4. **Vineyard manager history**
   - Current design stores the current vineyard manager, enforces one vineyard per manager, and validates an active Grape Farmer manager plus physical vineyard address.
   - Does the assignment also require dated vineyard-manager history?

5. **Final Workbench screenshots**
   - Must screenshots visibly show the submitting student's MySQL account/Workbench environment, or is genuine execution in the student's Workbench sufficient?

6. **RiPPlE peer-review conflict**
   - The main assessment specification states a group reflection with two peer reviews in total and an overall review length under 100 words.
   - The separate RiPPlE document states each student must provide at least two constructive comments.
   - The rubric's HD wording refers to more than two constructive peer comments.
   - Which requirement governs the actual RiPPlE submission?

7. **UML relationship notation**
   - The assignment requires UML class diagram notation.
   - Please confirm that the final MySQL Workbench EER model should explicitly use **Model → Relationship Notation → UML**, even if tutorial examples use a different Workbench notation.

8. **Query count conflict**
   - Some parts of the specification say five queries while the overview/video requirements refer to six.
   - The project currently supplies six. Please confirm that six is acceptable.
