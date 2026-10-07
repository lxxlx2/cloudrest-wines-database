-- Profiling and deterministic cleaning checks for the official A2 v4 workbook.
-- Run after 01_v4_staging.sql and CSV import. Do not guess ambiguous values.

USE cloudreststaging;

-- 1. Reconciliation counts expected from the supplied workbook.
SELECT COUNT(*) AS orderRows FROM stg_v4_orders;                    -- expected 182
SELECT COUNT(*) AS addressRows FROM stg_v4_starting_address;       -- expected 102
SELECT COUNT(*) AS historyRows
FROM stg_v4_customer_address_history
WHERE NULLIF(TRIM(customerIdRaw),'') IS NOT NULL;                  -- expected 53

-- 2. Deterministic Customer ID standardisation.
-- Verified source examples include cust018, cust015 and CUST 019.
SELECT sourceRowNumber, customerIdRaw,
       UPPER(REPLACE(TRIM(customerIdRaw),' ','')) AS proposedCustomerId
FROM stg_v4_orders
WHERE customerIdRaw <> UPPER(REPLACE(TRIM(customerIdRaw),' ',''));

-- 3. Known encoding damage. Corrections are mechanical mojibake repair only.
SELECT sourceRowNumber, wineNameRaw
FROM stg_v4_orders
WHERE wineNameRaw LIKE '%Ã%' OR wineNameRaw LIKE '%â%';

SELECT sourceRowNumber, addressIdRaw, fullAddressRaw
FROM stg_v4_starting_address
WHERE fullAddressRaw LIKE '%Ã%' OR fullAddressRaw LIKE '%â%';

-- 4. Exact duplicate raw order rows can be safely deduplicated.
WITH ranked AS (
  SELECT sourceRowNumber,
         ROW_NUMBER() OVER (
           PARTITION BY orderIdRaw,customerIdRaw,orderDateRaw,productIdRaw,wineNameRaw,
                        casesOrderedRaw,pricePerCaseRaw,totalPaidRaw,casesDamagedRaw,
                        refundAmountRaw,shipmentStatusRaw,paymentStatusRaw
           ORDER BY sourceRowNumber
         ) AS rn
  FROM stg_v4_orders
)
SELECT * FROM ranked WHERE rn > 1;
-- In the supplied workbook the duplicated ORD125/PROD001 row is exact.
-- Keep the first source row and record the later row as AUTOCORRECTED.

-- 5. Repeated (Order Id, Product Id) pairs that are not exact duplicates are
-- ambiguous. Do not aggregate them without tutor/business confirmation.
SELECT orderIdRaw, productIdRaw, COUNT(*) AS rowCount
FROM stg_v4_orders
GROUP BY orderIdRaw, productIdRaw
HAVING COUNT(*) > 1
ORDER BY orderIdRaw, productIdRaw;

-- 6. Order-level fields must agree across all lines belonging to one order.
SELECT orderIdRaw,
       COUNT(DISTINCT customerIdRaw) AS customerVariants,
       COUNT(DISTINCT orderDateRaw) AS dateVariants,
       COUNT(DISTINCT shipmentStatusRaw) AS shipmentStatusVariants,
       COUNT(DISTINCT COALESCE(paymentStatusRaw,'<NULL>')) AS paymentStatusVariants
FROM stg_v4_orders
GROUP BY orderIdRaw
HAVING customerVariants > 1
    OR dateVariants > 1
    OR shipmentStatusVariants > 1
    OR paymentStatusVariants > 1;

-- 7. Monetary identity. The supplied v4 data is expected to satisfy:
-- Cases ordered * Price per case = Total paid + Refund amount.
SELECT sourceRowNumber, orderIdRaw, productIdRaw
FROM stg_v4_orders
WHERE ABS(
  CAST(casesOrderedRaw AS DECIMAL(10,2)) * CAST(pricePerCaseRaw AS DECIMAL(10,2))
  - CAST(totalPaidRaw AS DECIMAL(10,2))
  - CAST(refundAmountRaw AS DECIMAL(10,2))
) > 0.01;

-- 8. Damaged cases cannot exceed ordered cases, and damage refund should match
-- damaged cases * line price when damage is recorded.
SELECT sourceRowNumber, orderIdRaw, productIdRaw
FROM stg_v4_orders
WHERE CAST(casesDamagedRaw AS UNSIGNED) > CAST(casesOrderedRaw AS UNSIGNED)
   OR (
        CAST(casesDamagedRaw AS UNSIGNED) > 0
        AND ABS(
          CAST(casesDamagedRaw AS DECIMAL(10,2)) * CAST(pricePerCaseRaw AS DECIMAL(10,2))
          - CAST(refundAmountRaw AS DECIMAL(10,2))
        ) > 0.01
      );

-- 9. Address duplication. Exact full-address duplicates need canonical mapping;
-- do not delete blindly because Unit/Level/Building metadata may differ.
SELECT fullAddressRaw, COUNT(*) AS addressIdCount
FROM stg_v4_starting_address
GROUP BY fullAddressRaw
HAVING COUNT(*) > 1
ORDER BY addressIdCount DESC, fullAddressRaw;

-- 10. Address-history overlap must be checked per customer and address purpose.
-- The v4 sheet legitimately contains concurrent Delivery and Billing rows.
-- Convert imported ISO date/time values to DATETIME for the overlap check.
WITH h AS (
  SELECT sourceRowNumber,
         UPPER(REPLACE(TRIM(customerIdRaw),' ','')) AS customerId,
         UPPER(TRIM(addressTypeRaw)) AS addressPurpose,
         TIMESTAMP(STR_TO_DATE(startDateRaw,'%Y-%m-%d'), COALESCE(STR_TO_DATE(startTimeRaw,'%H:%i:%s'),'00:00:00')) AS startDT,
         CASE WHEN NULLIF(TRIM(endDateRaw),'') IS NULL THEN NULL
              ELSE TIMESTAMP(STR_TO_DATE(endDateRaw,'%Y-%m-%d'), COALESCE(STR_TO_DATE(endTimeRaw,'%H:%i:%s'),'23:59:59'))
          END AS endDT
  FROM stg_v4_customer_address_history
  WHERE NULLIF(TRIM(customerIdRaw),'') IS NOT NULL
)
SELECT a.sourceRowNumber AS rowA, b.sourceRowNumber AS rowB,
       a.customerId, a.addressPurpose
FROM h a
JOIN h b
  ON a.customerId=b.customerId
 AND a.addressPurpose=b.addressPurpose
 AND a.sourceRowNumber < b.sourceRowNumber
 AND a.startDT <= COALESCE(b.endDT,'9999-12-31 23:59:59')
 AND COALESCE(a.endDT,'9999-12-31 23:59:59') >= b.startDT;

-- 11. Shared phone values across different customers require manual review.
WITH phones AS (
  SELECT UPPER(REPLACE(TRIM(customerIdRaw),' ','')) AS customerId, phone1Raw AS phone FROM stg_v4_customer_address_history
  UNION ALL
  SELECT UPPER(REPLACE(TRIM(customerIdRaw),' ','')), phone2Raw FROM stg_v4_customer_address_history
  UNION ALL
  SELECT UPPER(REPLACE(TRIM(customerIdRaw),' ','')), phone3Raw FROM stg_v4_customer_address_history
)
SELECT TRIM(phone) AS phone, COUNT(DISTINCT customerId) AS customerCount
FROM phones
WHERE NULLIF(TRIM(phone),'') IS NOT NULL
GROUP BY TRIM(phone)
HAVING COUNT(DISTINCT customerId) > 1;

-- 12. Whitespace standardisation can be applied deterministically after evidence.
SELECT sourceRowNumber, companyNameRaw,
       REGEXP_REPLACE(TRIM(companyNameRaw),'[[:space:]]+',' ') AS proposedCompanyName
FROM stg_v4_customer_address_history
WHERE companyNameRaw REGEXP '[[:space:]]{2,}';

-- The source note states that some current-customer start dates were reset during
-- export. Those dates are a source limitation. Do not invent the lost dates.

-- 13. Deterministic clean projections. Raw rows remain immutable; there is no
-- production import or automatic business disposition of ambiguous groups.
CREATE OR REPLACE VIEW v4_order_ranked AS
SELECT o.*,
       ROW_NUMBER() OVER (
         PARTITION BY orderIdRaw,customerIdRaw,orderDateRaw,productIdRaw,wineNameRaw,
                      casesOrderedRaw,pricePerCaseRaw,totalPaidRaw,casesDamagedRaw,
                      refundAmountRaw,shipmentStatusRaw,paymentStatusRaw
         ORDER BY sourceRowNumber
       ) AS exactCopyNumber
FROM stg_v4_orders o;

CREATE OR REPLACE VIEW v4_clean_orders AS
SELECT sourceRowNumber, orderIdRaw AS orderId,
       UPPER(REPLACE(TRIM(customerIdRaw),' ','')) AS customerId,
       orderDateRaw AS orderDate, productIdRaw AS productId,
       REPLACE(wineNameRaw,'RosÃ©','Rosé') AS wineName,
       casesOrderedRaw,pricePerCaseRaw,totalPaidRaw,casesDamagedRaw,
       refundAmountRaw,shipmentStatusRaw,paymentStatusRaw
FROM v4_order_ranked WHERE exactCopyNumber=1;

CREATE OR REPLACE VIEW v4_clean_addresses AS
SELECT sourceRowNumber,addressIdRaw,unitTypeNumberRaw,levelTypeNumberRaw,
       buildingPropertyNameRaw,placeNameRaw,
       REPLACE(fullAddressRaw,'â€“','–') AS fullAddress
FROM stg_v4_starting_address;

CREATE OR REPLACE VIEW v4_clean_history AS
SELECT h.*, REGEXP_REPLACE(TRIM(companyNameRaw),'[[:space:]]+',' ') AS companyNameClean
FROM stg_v4_customer_address_history h;

CREATE OR REPLACE VIEW v4_ambiguous_order_pairs AS
SELECT orderId,productId,COUNT(*) AS distinctSourceRows
FROM v4_clean_orders
GROUP BY orderId,productId HAVING COUNT(*)>1;

-- These are staging accounting buckets, NOT accepted/rejected production totals.
SELECT (SELECT COUNT(*) FROM stg_v4_orders) AS sourceRows,
       (SELECT COUNT(*) FROM v4_order_ranked WHERE exactCopyNumber>1) AS exactCopiesExcluded,
       (SELECT COUNT(*) FROM v4_clean_orders c JOIN v4_ambiguous_order_pairs a
         ON a.orderId=c.orderId AND a.productId=c.productId) AS ambiguousRowsHeld,
       (SELECT COUNT(*) FROM v4_clean_orders c LEFT JOIN v4_ambiguous_order_pairs a
         ON a.orderId=c.orderId AND a.productId=c.productId WHERE a.orderId IS NULL) AS otherCandidateRows,
       'UNRESOLVED: no production acceptance/rejection disposition' AS reconciliationStatus;
