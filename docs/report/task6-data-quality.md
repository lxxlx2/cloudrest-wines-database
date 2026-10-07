# Task 6 — Data Quality Strategy and Validation

## 6a. Official A2 v4 source and controlled migration

The official workbook `BISM2207 A2 Sem 2 2026 Data v4(1).xlsx` was independently SHA-verified and re-imported from the supplied local file on 2026-10-07. SHA-256: `88362589a519b6f9aeae031fe806bcf85f0d8b513c12b11f6a4e619ee855c4ac`. Raw CSV/SQL exports remain in the ignored private `database/local/v4` directory. The unchanged workbook is not included in the public repository. Cleaning follows a raw-to-staging-to-production process so source errors remain reproducible and no ambiguous value is silently invented.

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

## 6d. Final cleaned supplied-data import — 2026-10-08

The final portable SQL includes `database/data/02_cleaned_v4_data.sql` after the additional test dataset. `tools/build_cleaned_v4_data.py` reads the preserved private staging CSVs and produces accepted INSERTs and ID-only disposition ledgers. Existing before/after Workbench evidence remains unchanged. Final import and six-query captures are in `docs/evidence/combined-database`.

Source IDs map one-to-one into separate namespaces: CUST001 → VCUS001, PROD001 → VPRD001, ORD001 → VORD001 and ADDR001 → VADR0001. This preserves supplied identity without colliding with synthetic fixtures. No production schema or order-line primary key was changed.

### Tables imported and verified

| Table | Supplied or supplemental records | Import and verification |
|---|---:|---|
| customer | 50 | Standardised IDs; email and source type retained; subtype/FK checks pass. Active state is an import assumption. |
| individualcustomer | 25 | Source names and birth dates; one subtype row per individual. |
| businesscustomer | 25 | Source ABN/contact names; whitespace-normalised company; OTHER means subtype unspecified. Unique ABNs pass. |
| address | 102 | Deterministic physical-address parsing and dash repair; retain every source ID and structured Unit/Level metadata; no canonical merge. |
| customeraddress | 53 | Source purposes and date/time periods preserved; foreign keys and non-overlap controls pass. |
| phone | 66 | Unshared source values; OTHER means unspecified type. +61 is an explicit Australian-address country assumption. |
| customerphone | 66 | Unshared associations only; earliest supplied customer-history start is an explicit effective-start assumption; no primary rank guessed. |
| winecategory | 1 | Supplemental test category CTV4, explicitly labelled. |
| wine | 10 | Source wine names; mandatory missing wine attributes are explicitly supplemental test values. |
| winecomposition | 10 | Supplemental test recipe, validated to 100%; not a factual source recipe. |
| wineproduct | 10 | Source Product IDs; supplemental bottle, case size and active-state attributes. |
| customerorder | 79 | Complete accepted orders only; consistent customer/date/header status, all source lines present. |
| orderline | 132 | Exact source quantities and negotiated prices; no sum, averaging or partial-order import. Live readback matches accepted source rows. |

All table INSERTs passed MySQL 8.4.11 foreign-key, CHECK and trigger enforcement in an empty-database portable rebuild. Namespace row counts and source quantity/price/header readback are recorded in `docs/evidence/v4-final-import-results.tsv`. Existing verifier passes 73/73; no new verifier checks were added.

### Explicit import assumptions and supplemental test values

The workbook omits attributes required by the stable wine/product schema. Separate supplied-product records therefore use vintage 2026, 13.5% alcohol, synthetic winemaker EMP0004, supplemental category CTV4, a 100% GRAPE01 test recipe, BOTL001 bottles and 12 bottles per case. These are added test attributes, not recovered workbook facts, actual wine recipes or factual packaging specifications. The original synthetic products and HR fixtures remain available for integrity and Task 7 demonstrations. A synthetic business ABN was changed to avoid a collision with a supplied ABN; the supplied ABN is unchanged.

Source shipped/pending values map directly to order status. A blank payment value maps to FALSE as “no confirmed payment”, not a claim of verified non-payment. Shipment dates and order-specific delivery addresses are absent, so 72 accepted shipped-order shipment-detail facts are quarantined; no shipment detail or refund date/verification is invented. Source negotiated prices belong to order lines, not an invented product price history.

### Final reconciliation and quarantine

**182 source order rows = 132 accepted/imported cleaned rows + 1 rejected exact copy + 15 ambiguous-pair rows quarantined + 34 other rows quarantined.** Each original source row has exactly one disposition in `docs/evidence/v4-import-dispositions.csv`. The accepted rows form 79 complete orders; the other 24 source orders are held. Quarantine is a completed import decision, not an unresolved accounting total.

Seven non-exact repeated pairs contain 15 rows. An order containing any ambiguous pair is held as a whole, including its otherwise unique lines, to avoid presenting partial totals. Mixed shipment/payment headers and shipment statuses such as damaged, returned or partially refunded cannot safely map into the stable order enum; affected whole orders are held. The 34 other rows include this order-level closure and unsupported/mixed-status records; reasons may overlap and are listed per row rather than added as independent totals. No ambiguous lines are summed or silently deleted.

All 102 address IDs are retained separately, including the 19 repeated full-address groups; ID-specific structured metadata is preserved, so no canonical identity is guessed. Three shared phone values representing seven customer/phone associations are quarantined. The ID-only dependent-fact ledger is `docs/evidence/v4-dependent-facts-quarantine.csv`.

### Source limitation

Export-reset customer-history starts remain exactly as supplied. Lost original dates are not reconstructed. Student-only video, RiPPlE, Buddycheck and genuine contribution confirmation remain separate from report/code readiness. Task 8 awaits the Week 11 scenario supplied by the tutor.
