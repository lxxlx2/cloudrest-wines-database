# Task 6 — Data Quality Strategy and Validation

## 6a. Official A2 v4 source and controlled migration

The official workbook is now available as `BISM2207 A2 Sem 2 2026 Data v4(1).xlsx` (SHA-256 `88362589a519b6f9aeae031fe806bcf85f0d8b513c12b11f6a4e619ee855c4ac`). The workbook is preserved unchanged. Cleaning follows a raw-to-staging-to-production process so source errors remain reproducible and no ambiguous value is silently invented.

The three worksheets contain 182 order rows, 102 starting-address rows and 53 business rows of customer/address history. The history worksheet also contains two blank rows and one source note. Raw staging tables preserve an original Excel row number. Deterministic changes are documented separately from records that require manual or tutor confirmation.

### Verified defects and corrections

The workbook contains six order rows with non-canonical Customer Id text: lower-case `cust018`, lower-case `cust015`, and spaced `CUST 019`. These can be corrected deterministically by trimming, removing embedded spaces and converting to upper case. After this standardisation, all 50 customer identifiers referenced by orders match a customer in the history worksheet.

Encoding damage is also deterministic. `Rosewood Trail RosÃ©` occurs in 24 order rows and is mechanically repaired to `Rosewood Trail Rosé`. Nine starting-address rows contain the mojibake dash `â€“`; this is repaired as an encoding defect rather than treated as a business-data change. The company name `Vino Vibes  Wine Exporters` contains repeated whitespace in three history rows and can be normalised without changing its meaning.

One extra order row is an exact duplicate: the repeated `ORD125 / PROD001` record. The first source row is retained and the later exact copy is recorded as an autocorrected duplicate.

### Ambiguous records quarantined for review

The source also contains eight repeated `(Order Id, Product Id)` groups, representing nine extra rows. Most are not exact duplicates: quantities, prices, refund values or statuses differ. They must not be automatically summed or discarded because the workbook does not establish whether they are genuine repeated product lines, transaction events or source duplication.

Ten orders contain more than one Shipment Status across their product rows. `ORD056` also contains both a blank and `paid` Payment Status. These findings expose a source-grain ambiguity between order-level and line-level status. The rows are retained in staging and flagged rather than forced into one status.

The starting-address worksheet has 67 distinct Full Address strings across 102 Address Id records. Nineteen full-address groups are duplicated, accounting for 35 additional Address Id rows. Two duplicate groups also differ in structural metadata such as unit/building information, so canonicalisation cannot be based on Full Address text alone.

Three phone values are shared by more than one customer. These may represent a household or business contact, or they may be source errors. They require manual review and are not changed automatically.

The source itself states that an export reset some current-customer start dates. The lost original dates cannot be recovered from the workbook and are therefore disclosed as a source limitation rather than reconstructed.

### Consistency checks that pass

All 182 order rows satisfy `Cases ordered × Price per case = Total paid + Refund Amount` within one cent. No row has damaged cases greater than ordered cases. Where damaged cases are recorded, the damage refund equals damaged cases multiplied by the line price within one cent. Product Id consistently maps to one Wine Name, and Customer Id and Order Date are internally consistent within each Order Id after Customer Id normalisation.

Customer-address history contains no overlapping periods for the same customer and the same supplied address purpose. The source legitimately contains concurrent current Delivery and Billing rows for CUST050, which is why the revised database controls current history per address purpose rather than incorrectly allowing only one address of every kind.

Detailed profiling SQL and evidence counts are in `database/cleaning/01_v4_staging.sql`, `database/cleaning/02_v4_profile_and_clean.sql` and `docs/evidence/a2-v4-data-quality-audit.md`.

## 6b. Revised schema controls arising from the data-quality review

The cleaning exercise is connected to the production design rather than treated as a separate spreadsheet task. `customeraddress.addressPurpose` now represents Primary, Delivery, Billing and Correspondence uses. Current history is protected against overlapping periods for the same purpose. Employee and supplier address histories are protected by address kind, and employee/customer/supplier phone histories enforce one current primary phone where applicable.

Refund now identifies `productId` together with `customerOrderId`, with a foreign key to the actual order line. This prevents a refund from naming a product that was not purchased on that order.

## 6c. Test-data and integrity validation

Synthetic HR and operational data remains necessary because the official v4 workbook contains customer/order/address information and does not contain the HR training, shift, incident, qualification or wellbeing records needed for the selected perspective and Task 7 queries.

The revised test dataset additionally demonstrates:

- multiple grape varieties in the same vineyard and vintage;
- harvest linkage to the exact vineyard/vintage/grape-variety planting;
- picker leave/rejoin support through `joinedDate` in the Pack Member key;
- line-specific refund integrity;
- customer address purposes;
- actual shift assignment start/end times rather than duplicated manual hour totals;
- wine-composition validation before an active product is released.

The assessed five Task 3b rules remain separate from these extra regression controls.

## 6d. Evidence still requiring genuine student execution

The repository can provide the source-preserving staging design, verified workbook findings, cleaning SQL and regression tests. The following evidence must still be produced from the submitting students' MySQL Workbench environment:

1. raw staging import screenshots showing source row counts;
2. before/after screenshots for selected deterministic defects;
3. the final accepted/rejected reconciliation after ambiguous rows are resolved;
4. screenshots of revised integrity-rule failures;
5. any tutor response that clarifies the grain of repeated Order Id + Product Id rows.

Until the ambiguous source rows are resolved, no fabricated accepted/rejected total is reported.
