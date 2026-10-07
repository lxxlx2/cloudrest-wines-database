# Task 4 — ER Diagram and Annotated Design Alternatives

## Complete model

The Cloudrest Wines model contains 55 base tables organised into six connected domains: personnel/history; HR training and qualifications; shifts, safety and wellbeing; vineyard and wine production; products and procurement; and customers, orders and addresses. The report embeds a dedicated landscape full-model image followed immediately by assumptions, then enlarged domain views so attributes, keys and UML cardinalities remain legible. The regenerated editable Workbench model is delivered as `Cloudrest_Wines_Model.mwb`.

The complete list of assumptions is maintained in `docs/requirements/assumptions.md`. Those assumptions resolve ambiguity without removing a stated case requirement.

## Annotated design alternatives

| Design element | Alternative considered | Reason for selected design |
|---|---|---|
| Customer supertype/subtypes | One wide `customer` table with nullable DOB, ABN and company fields | `customer` plus `individualcustomer`/`businesscustomer` eliminates type-inapplicable NULLs, preserves a common order key and supports subtype-specific constraints. |
| Dated address associations | Copy address columns into each owner table, or use a polymorphic owner type/ID | Shared `address` plus typed history associations avoids repeated structure and gives MySQL enforceable FKs. A shipment retains its actual physical address key. |
| Training course/session/attendance | One employee-training table repeating provider and course text | Three levels distinguish reusable definition, dated delivery and employee outcome, supporting annual coverage and renewal queries without update anomalies. |

## Normalisation/OLTP review

- Repeating attributes (phones, addresses, order items, wine varieties and training participants) are rows in dependent or associative tables.
- Every associative fact has a compound key or an explicit unique business constraint.
- Derived indicators such as coverage rate, incident rate and days overdue are calculated by queries/views, not redundantly stored.
- Historical facts are appended with effective dates rather than overwritten.
- Foreign keys use explicit delete/update behaviour and prevent orphaned operational history.


## Tutor-feedback ERD refresh

The editable Workbench model must be regenerated from the revised schema before final submission. The final diagram must visibly show:

- `vineyardplanting` PK `(vineyardId, vintageYear, grapeVarietyId)`;
- `harvest.grapeVarietyId` and the three-column FK to `vineyardplanting`;
- `refund.productId` and its order-line relationship;
- `packmember` PK including `joinedDate`;
- `customeraddress.addressPurpose`;
- revised `shiftassignment(actualStartTime, actualEndTime, breakMinutes)` with the old regular/overtime attributes removed;
- the unchanged one-active-role temporal design;
- the two measurable sustainability reporting paths: training coverage and incidents per 1,000 labour hours.

The existing PNG and `.mwb` in the repository predate these changes and must not be presented as the final ER evidence until they are regenerated in MySQL Workbench.
