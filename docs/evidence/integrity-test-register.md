# Integrity Test Register

| Test | Scenario | Expected | Rule link |
|---|---|---|---|
| T01 | Insert a completed training outcome with completion, renewal and competency | Accepted, then rolled back | Positive test of HR training structure |
| T02 | Insert an employee role whose end precedes its start | Rejected by `chk_employeerole_dates` | Task 3b historical-date rule |
| T03 | Disable bottle reorder without recording a comment | Rejected by `chk_bottletype_reorder` | Task 3b bottle-sourcing rule |
| T04 | Delete a training course used by sessions | Rejected by FK `ON DELETE RESTRICT` | Task 3b referential-integrity rule |
| T05 | Ship a paid order to a current PO Box address | Rejected by `trg_shipment_validate_insert` | Task 3b physical-address rule |

Each final report entry will include the executed SQL, captured MySQL output and a one-sentence interpretation. T05 inserts a dedicated order before attempting shipment so the expected error is specifically the postal-address rule rather than the one-shipment-per-order key.

