# GenAI Reflection Capture Pack

This is a capture framework, not a fabricated final reflection. The team must preserve genuine prompts/outputs and write its own evaluation.

## Example A — Conceptual modelling

Use the actual problem of modelling employee role and supervisor history. Preserve:

1. Initial prompt and full output.
2. Evaluation identifying missing history, employment classifications or overlapping periods (minimum 100 words).
3. Revised prompt adding case constraints, 3NF, UML cardinality and MySQL feasibility (minimum 50 words explaining revision).
4. Improved output and evaluation (minimum 50 words).
5. Second revision asking for alternative keys, temporal-overlap handling and trade-offs.
6. Validation against the case, ER diagram and executed MySQL build.

## Example B — Constraint development

Use the actual PO Box shipment rule. A useful critical issue is that a MySQL row `CHECK` cannot query the related `address` and `customerorder` tables. Preserve the initial response, challenge an invalid cross-table CHECK if it occurs, revise toward a `BEFORE INSERT/UPDATE` trigger with `SIGNAL SQLSTATE '45000'`, and validate through the genuine rejection test.

## Required evidence per example

- Problem statement (minimum 20 words).
- Initial prompt and AI output.
- At least two revised prompts.
- Evaluation at every iteration, including disagreement and reasons.
- Final validation using course knowledge, schema documentation and execution evidence.
- Explanation of team changes to the AI output.

## Peer review placeholder

Do not pre-commit to a peer-review count or word limit in this framework. The supplied course documents conflict: the main assignment, separate RiPPlE instructions and HD rubric describe peer-feedback expectations differently. Follow the tutor/LMS-confirmed requirement recorded in `docs/requirements/tutor-confirmations.md` when RiPPlE opens.

Only after the real peer submission is visible should the required team member(s) provide the required number of specific, constructive comments. Preserve genuine comments and do not fabricate them in advance.
