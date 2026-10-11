# Cloudrest Wines — GenAI Reflection

## 1. Problem statement

Our group designed a MySQL 8.x database for Cloudrest Wines, covering winery operations and a Human Resources sustainability perspective. Two challenging tasks were correcting the relationship between vineyard planting and harvest records, and enforcing the rule that a wine’s grape proportions total 100%. We used iterative prompts to frame candidate designs, challenged them with counterexamples, and evaluated the resulting SQL against relational modelling principles, tutor feedback and executable database tests.

## 2. Example A — Conceptual data modelling: Vineyard Planting and Harvest

### Problem and initial design

The original VineyardPlanting design treated the combination of vineyardId and vintageYear as unique, and Harvest did not identify the corresponding grape variety. This representation prevented a vineyard from recording two grape varieties in the same vintage year, even though such plantings are legitimate. The tutor explicitly identified both deficiencies, providing a concrete counterexample that became the basis of the revised model.

### Initial prompt (V0)

Design normalized VineyardPlanting and Harvest entities for a winery. Include their attributes, primary keys and foreign keys. A vineyard has planting information for each vintage year, and each harvest records the weight and ripeness of grapes collected.

### Initial design output and its limitation

The starting model could be expressed with VineyardPlanting(vineyardId, vintageYear) as its composite key and a Harvest reference to that vineyard-year. This representation linked harvests to a vineyard and season but omitted grape variety from their identity. It was therefore incomplete for a vineyard that grows more than one variety during the same vintage.

### Critical evaluation of V0

The weakness was not a SQL syntax problem but a mistaken definition of the business key. The pair (vineyardId, vintageYear) identifies a location and year, not one distinct planting when more than one grape variety can occur in that vineyard-year. A unique or primary-key constraint on those two columns would reject a valid second planting row. It could also allow a harvest record to be associated with the wrong grape variety, because the relationship would not say which variety was harvested. Simply describing the table as normalized would not solve this issue: normalization assumes that the underlying functional dependencies and candidate keys are correct. We compared the proposed relationship with a concrete positive example containing two grape varieties for VINE001 in one year. That example required two planting rows, and it exposed the missing determinant immediately. We therefore revised the key and made the variety component of the foreign key from Harvest. The final judgement rested on the business cardinality, the matching SQL definition and actual insertion tests, rather than the plausibility of the first diagram.

### First revised prompt (V1)

The same vineyard can contain multiple grape varieties in the same vintage year. Revise VineyardPlanting and Harvest so that two varieties can be planted in one vineyard-year, and a harvest must identify exactly which variety was collected. Explain the functional dependencies, candidate key and new relationship.

### Why V1 was necessary

The first question did not explicitly describe multi-variety planting. V1 removed that ambiguity by supplying a business counterexample and asking for the key dependency behind the design. It shifted the focus from selecting reasonable-looking columns to ensuring that the database could represent every permitted vineyard-year-variety combination. The improvement was judged by whether the model could store both varieties and connect each harvest to the correct planting.

### Intermediate improvement

The revised relationship identifies a planting by vineyardId, vintageYear and grapeVarietyId. Harvest retains its own harvestId but must also store those same three attributes to reference the exact planting row. This permits repeated harvest events when appropriate and prevents a harvest from silently losing the grape-variety context. The remaining requirement was to demonstrate that these relationships were enforced in MySQL, not just drawn in an ER diagram.

### Second revised prompt (V2)

Target MySQL 8.x. Produce executable CREATE TABLE definitions that use (vineyardId, vintageYear, grapeVarietyId) as VineyardPlanting’s composite primary key and as the referenced key in a three-column foreign key from Harvest. Include a positive insertion test for two varieties in one vineyard-year and a negative test attempting a harvest for a variety not planted there.

### Why V2 was necessary

V2 turned the conceptual correction into a measurable implementation criterion. Specifying executable MySQL DDL exposed any mismatch between referenced and referencing column types or key order. Requiring both a successful multi-variety example and a rejected unplanted-variety example also checked two independent properties: that legitimate data is not constrained too tightly, and that invalid harvest relationships are actually blocked by the database. This was more informative than treating a successful schema build as sufficient evidence.

### Final result and independent validation

The final schema defines VineyardPlanting with PRIMARY KEY (vineyardId, vintageYear, grapeVarietyId). Harvest has a three-column foreign key to that exact key. The final dataset includes two varieties for one vineyard-year. The negative test t10_harvest_requires_variety_planting.sql attempts to insert a harvest for an unplanted variety and is rejected as expected. This implements tutor feedback items 1 and 2 and preserves relational integrity without adding an unnecessary synthetic planting identifier.

## 3. Example B — SQL constraint development: Wine Composition

### Problem and initial design

The WineComposition table associates wine products with grape varieties and stores each variety’s proportionPercent. A row-level CHECK can restrict one value to 0–100%, but it cannot, on its own, require all rows for one wine to add up to exactly 100%. The tutor requested an enforceable aggregate rule. A practical complication is that a multi-row recipe must be entered in stages before the total becomes complete.

### Initial prompt (V0)

Add a SQL constraint that guarantees the proportions of all grape varieties in one wine add up to exactly 100 percent. Use MySQL 8.x and retain a normalized WineComposition table.

### Initial design output and its limitation

The initial design already enforced an individual-row proportion range with CHECK (proportionPercent > 0 AND proportionPercent <= 100). That is necessary but insufficient for the aggregate business rule. A proposal to place SUM(proportionPercent) directly in a table CHECK would not be valid MySQL row-level constraint logic. Likewise, rejecting every insert that temporarily leaves the sum below 100 would prevent an operator from entering a valid 60/40 recipe one row at a time.

### Critical evaluation of V0

The problem is a cross-row invariant, so it cannot be solved by extending the numerical range of a single-column CHECK. MySQL checks each inserted or updated row individually; a wine with two rows of 60% and 60% would pass a 0–100 range test even though its final recipe totals 120%. At the same time, requiring the sum to be exactly 100 after each individual insert would make normal data entry difficult. When the first 60% row is entered, the remaining 40% row may not exist yet. We separated the life cycle into recipe construction and product release. Before release, draft composition rows can be accumulated and corrected. When a related wineproduct becomes active, the total must already be 100%, and the composition must not be changed while active products depend on it. This solution enforces the commercially meaningful boundary but adds trigger and procedure complexity. We assessed it through the actual release path and negative tests, not simply by checking whether an aggregate query could calculate a total.

### First revised prompt (V1)

MySQL CHECK constraints cannot aggregate across composition rows, and a valid wine recipe may be entered gradually as 60% of one variety followed by 40% of another. Design a database-level rule that allows draft rows but prevents activation of an incomplete wine product. Explain which workflow boundary should enforce the total.

### Why V1 was necessary

V1 clarified that the rule is not a restriction on every intermediate state. It also removed an invalid implementation route by identifying MySQL’s cross-row CHECK limitation. By requiring an explicit release boundary, it directed the solution toward an operation whose failure could be tested reliably: activating a product with an incomplete recipe. This kept legitimate multi-step entry possible while protecting downstream inventory and sales records from incomplete compositions.

### Intermediate improvement

The intermediate design validates the sum when an active wineproduct is inserted or updated. A reusable validateWineComposition(wineId) procedure can count the composition rows and calculate SUM(proportionPercent), signalling an error unless at least one row exists and the total is 100.00. This prevents the first release of an incomplete wine recipe, but a remaining loophole would exist if a previously released recipe could later be changed freely.

### Second revised prompt (V2)

Implement the full MySQL 8.x release lifecycle. Validate every INSERT or UPDATE that makes a wineproduct active. Reject INSERT, UPDATE or DELETE of WineComposition rows while any associated product is active; permit changes after deactivation. Add a global validateAllWineComposition() procedure and show a negative test that attempts to release a product with only 60% recorded.

### Why V2 was necessary

Checking composition at first activation is not enough to protect its future consistency. A later deletion or percentage edit could invalidate a released product after the initial check passed. V2 therefore added protection for the complete update lifecycle and a global review operation. Requiring a specific 60% negative test tied the design to observable database behavior, while controlled deactivation supplied a legitimate route for editing a recipe. This balances integrity with practical maintainability.

### Final result and independent validation

The final integrity script defines validateWineComposition(wineId), validateAllWineComposition(), wineproduct release triggers and composition-locking triggers. The T09 negative test creates a wine with one 60% grape component and attempts to insert an active product. MySQL rejects that activation with a clear error message. A complete 100% composition is accepted, and released recipes cannot be modified before the associated product is deactivated. This fulfills the release-stage integrity requirement while acknowledging that incomplete drafts can exist before activation.

## 4. Technical evidence used to validate the two cases

### Evidence A

The revised vineyard and harvest definitions are in database/schema/01_tables.sql. The final insert fixtures contain a multi-variety vineyard-year. The invalid-variety test is database/tests/t10_harvest_requires_variety_planting.sql. These checks demonstrate both representational capacity and referential integrity.

### Evidence B

The per-row percentage CHECK is in database/schema/01_tables.sql. Cross-row validation and release protection are in database/schema/04_integrity_controls.sql. The incomplete-release negative test is database/tests/t09_incomplete_wine_composition.sql. These checks demonstrate why a staged release boundary is needed in MySQL 8.x.

## 5. Peer review

### Comment A

The example explains the business scenario and improves the candidate-key reasoning. The strongest improvement would be to add one positive record with two grape varieties for the same vineyard-year and one rejected harvest using an unplanted variety. Those tests would make the proposed model easier to validate independently.

### Comment B

The reflection recognises MySQL’s aggregate constraint limitation and presents a practical release boundary. It would be stronger if it discussed what happens when composition rows are edited after activation, then showed a failing 60% release test and a successful complete-recipe test. This would demonstrate a full lifecycle rather than only initial validation.

