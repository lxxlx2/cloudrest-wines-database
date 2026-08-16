# Tutor Confirmation Questions

These points are ambiguous or internally inconsistent across the supplied course materials and should be confirmed before final submission.

1. **Concurrent employee roles**
   - Current model allows one active role period per employee.
   - Does the case permit an employee to hold multiple active roles at the same time?

2. **Picking pack minimum of four**
   - Current design validates the minimum when a pack is activated/finalised rather than on each membership insert, because a row trigger would prevent incremental construction.
   - Is this acceptable?

3. **Wine composition totals**
   - Composition rows must total 100% before release, but this is treated as an end-of-transaction/release validation rather than a row trigger.
   - Is this acceptable?

4. **Vineyard manager history**
   - Current design stores the current vineyard manager and enforces one vineyard per manager.
   - Does the assignment require dated vineyard-manager history?

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
