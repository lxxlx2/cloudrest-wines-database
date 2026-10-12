# Hint 11 — A2 v4 phone-number source audit (2026-10-12)

## Teacher's stated issue

The original `+` at the beginning of certain phone values was interpreted by Excel as a formula, and a CSV export can preserve only its evaluated numeric value. The teacher recommends converting phone columns to Text and replacing an initial formula `=` with `+` **when the original formula expression is still available**.

## What is actually recoverable from the supplied workbook

The supplied file `BISM2207 A2 Sem 2 2026 Data v4(1).xlsx` was inspected without changing the source:

- `customer and address history` has 53 business rows.
- `phone1`: 53 populated cells, all numeric integers, all nine digits.
- `phone2`: 16 populated cells, all numeric integers, all nine digits.
- No active formula cells were found in either phone column. The original expression including `+` is not present in this copy.
- Duplicate values across multiple customers remain distinct data-quality questions, not evidence of the formula conversion's correct solution.

**Consequences:** replacing `=` with `+` in this current workbook would not restore anything, because there are no such formulas to replace. Adding `+` or a country code to the surviving nine digits cannot be described as recovery of the original source string.

## Safe handling

1. Preserve the numeric source value as text without scientific notation or loss of leading digits during staging/CSV export.
2. The current normalized import puts surviving digits into `phone.phoneNumber` and uses `countryCode='+61'` as an explicit Australian test-data assumption. It is **not** a recovered source value.
3. Shared/ambiguous phone associations stay in quarantine.
4. If an earlier teacher-provided Excel revision still retains the `=...` formula strings, restore them there using the teacher's Format=Text / Find & Replace-in-formulas guidance, retain that file as source evidence, then compare each resulting phone to the v4 staging rows before approving any replacement.
5. Do not infer leading zeros, international prefixes, or contacts for missing/unresolvable rows.

The preceding audit distinguishes confirmed source facts from an address-based import assumption, rather than marking a data loss as fully repaired.
