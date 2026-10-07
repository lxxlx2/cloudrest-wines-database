# Official A2 v4 Data Quality Audit

Source workbook: `BISM2207 A2 Sem 2 2026 Data v4(1).xlsx`  
SHA-256: `88362589a519b6f9aeae031fe806bcf85f0d8b513c12b11f6a4e619ee855c4ac`

This audit records findings verified directly from the supplied workbook. It separates deterministic corrections from ambiguous records that require manual/tutor confirmation.

## Source reconciliation

| Worksheet | Source data rows | Notes |
|---|---:|---|
| orders | 182 | 103 distinct Order Id values; 10 Product Id values |
| starting address set | 102 | 102 Address Id values |
| customer and address history | 53 business rows | 50 distinct customers; two blank rows plus one source note are excluded |

The workbook note states: “Export of some current customers has caused a start date reset.” The original dates cannot be reconstructed from this file and must not be invented.

## Verified deterministic defects

| Finding | Verified count | Treatment |
|---|---:|---|
| Non-canonical Customer Id text in orders | 6 rows | trim/remove embedded spaces and uppercase |
| Affected malformed customer forms | 3 forms | `cust018`, `cust015`, `CUST 019` |
| Mojibake wine name `Rosewood Trail RosÃ©` | 24 rows | mechanical UTF-8 repair to `Rosewood Trail Rosé` |
| Mojibake address dash `â€“` | 9 rows | mechanical encoding repair |
| Exact duplicate order row | 1 extra row | keep first occurrence; record duplicate as autocorrected |
| Company-name repeated whitespace | 3 history rows for CUST050 | collapse repeated whitespace |

All 50 customer IDs referenced by orders exist in customer history after deterministic ID normalisation.

## Verified ambiguity / manual-review findings

| Finding | Verified count | Why it is not auto-corrected |
|---|---:|---|
| Repeated `(Order Id, Product Id)` groups | 8 groups / 9 extra rows | most rows differ in quantity, price, refund or status; aggregation would invent semantics |
| Orders with mixed Shipment Status across their product rows | 10 orders | source does not establish whether status is line-level or order-level |
| Orders with mixed Payment Status | 1 order (ORD056) | source does not establish authoritative order-level payment state |
| Duplicate Full Address strings | 19 groups / 35 extra Address Id rows | IDs may be historical aliases; two groups also have conflicting unit/building metadata |
| Duplicate full-address groups with conflicting structural metadata | 2 groups | canonical record cannot be chosen safely without business confirmation |
| Phone values shared by multiple customers | 3 phone values | may be households/business contacts or source errors; requires manual review |

The eight repeated order/product groups are `ORD046/PROD010`, `ORD110/PROD005`, `ORD066/PROD005`, `ORD054/PROD008`, `ORD042/PROD003`, `ORD143/PROD003`, `ORD125/PROD001`, and `ORD056/PROD008`. Only the duplicated `ORD125/PROD001` row is an exact duplicate.

## Verified consistency checks that pass

Across all 182 order rows:

* `Cases ordered × Price per case = Total paid + Refund Amount` within one cent.
* No row has `Cases Damaged > Cases ordered`.
* Where damaged cases are recorded, `Cases Damaged × Price per case = Refund Amount` within one cent.
* Product Id maps consistently to one Wine Name.
* Customer and order date are internally consistent within each Order Id.

Customer-address history has no overlapping periods for the same customer and the same supplied address purpose. CUST050 has concurrent current Delivery and Billing addresses; this is valid when address history is constrained per purpose instead of globally.

## Schema implications

The tutor feedback and v4 workbook together require:

1. `customeraddress.addressPurpose` so Primary, Delivery and Billing histories are distinguishable.
2. Current-address overlap protection per purpose, rather than prohibiting legitimate concurrent purposes.
3. Refund identification at product/order-line level.
4. Staging/exception handling for repeated order/product records instead of silently altering ambiguous source rows.

## Finalisation execution — 2026-10-07

The supplied local workbook was re-verified against the SHA-256 above and imported without editing into private binary-collated staging under MySQL 8.4.11. The row counts and deterministic defect counts above were reproduced. Raw rows and dates remain unchanged; cleaned views hold the corrected projections. Genuine local Workbench captures cover all requested source counts, before/after repairs and exception classes.

After excluding source row 160 as an exact copy, the seven non-exact repeated pairs contain 15 retained rows. Staging accounting is 182 = 1 exact copy + 15 ambiguous rows + 166 other candidates. No production accepted/rejected reconciliation or ambiguous business disposition is claimed.

See `verification/v4-final-audit.json`, `verification/final-query-results/task6-v4-evidence.tsv` and `docs/evidence/final-workbench/README.md`. Tutor/business decisions, student review and any course-specific own-account evidence requirements remain outstanding. The raw workbook and raw CSV/SQL exports are not included in the public repository.
