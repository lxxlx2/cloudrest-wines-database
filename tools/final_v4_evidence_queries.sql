-- Public evidence uses source row IDs and aggregates; no customer contact values.
USE cloudreststaging;
-- E01 source reconciliation
SELECT 'orders' AS sourceSheet,COUNT(*) AS stagingRows FROM stg_v4_orders
UNION ALL SELECT 'starting address set',COUNT(*) FROM stg_v4_starting_address
UNION ALL SELECT 'customer/address history',COUNT(*) FROM stg_v4_customer_address_history;
-- E02 ID before / after
SELECT r.customerIdRaw AS beforeValue,c.customerId AS afterValue,COUNT(*) AS changedRows
FROM stg_v4_orders r JOIN v4_clean_orders c USING(sourceRowNumber)
WHERE r.customerIdRaw<>c.customerId GROUP BY 1,2;
-- E03 encoding before / after
SELECT r.wineNameRaw AS beforeValue,c.wineName AS afterValue,COUNT(*) AS changedRows
FROM stg_v4_orders r JOIN v4_clean_orders c USING(sourceRowNumber)
WHERE r.wineNameRaw<>c.wineName GROUP BY 1,2;
SELECT 'â€“' AS beforeMarker,'–' AS afterMarker,COUNT(*) AS changedAddressRows
FROM stg_v4_starting_address r JOIN v4_clean_addresses c USING(sourceRowNumber)
WHERE r.fullAddressRaw<>c.fullAddress;
-- E04 exact duplicate
SELECT sourceRowNumber,orderIdRaw,productIdRaw,exactCopyNumber
FROM v4_order_ranked WHERE exactCopyNumber>1;
-- E05 whitespace
SELECT companyNameRaw AS beforeValue,companyNameClean AS afterValue,COUNT(*) AS changedRows
FROM v4_clean_history WHERE companyNameRaw<>companyNameClean GROUP BY 1,2;
-- E06 ambiguity after exact deduplication
SELECT * FROM v4_ambiguous_order_pairs ORDER BY orderId,productId;
-- E07 mixed line status
SELECT orderId,COUNT(DISTINCT shipmentStatusRaw) AS shipmentVariants,
 COUNT(DISTINCT COALESCE(paymentStatusRaw,'<NULL>')) AS paymentVariants
FROM v4_clean_orders GROUP BY orderId HAVING shipmentVariants>1 OR paymentVariants>1 ORDER BY orderId;
-- E08 duplicate addresses: groups numbered, no address/contact publication
SELECT ROW_NUMBER() OVER(ORDER BY MIN(sourceRowNumber)) AS duplicateGroup,
 COUNT(*) AS addressIdCount,
 COUNT(DISTINCT CONCAT_WS('|',COALESCE(unitTypeNumberRaw,'<NULL>'),
 COALESCE(levelTypeNumberRaw,'<NULL>'),COALESCE(buildingPropertyNameRaw,'<NULL>'),
 COALESCE(placeNameRaw,'<NULL>'))) AS structuralVariants
FROM stg_v4_starting_address GROUP BY fullAddressRaw HAVING COUNT(*)>1;
-- E09 shared phones: aggregate and source IDs, no phone/contact publication
WITH phones AS (
 SELECT customerIdRaw AS customerId,phone1Raw AS phone FROM stg_v4_customer_address_history
 UNION ALL SELECT customerIdRaw,phone2Raw FROM stg_v4_customer_address_history
 UNION ALL SELECT customerIdRaw,phone3Raw FROM stg_v4_customer_address_history
), shared AS (
 SELECT TRIM(phone) AS phone,COUNT(DISTINCT customerId) AS customerCount
 FROM phones WHERE NULLIF(TRIM(phone),'') IS NOT NULL GROUP BY TRIM(phone)
 HAVING COUNT(DISTINCT customerId)>1
)
SELECT ROW_NUMBER() OVER(ORDER BY customerCount,phone) AS sharedPhoneGroup,customerCount FROM shared;
-- E10 staging accounting; production disposition still UNRESOLVED
SELECT (SELECT COUNT(*) FROM stg_v4_orders) AS sourceRows,
 (SELECT COUNT(*) FROM v4_order_ranked WHERE exactCopyNumber>1) AS exactCopiesExcluded,
 (SELECT COUNT(*) FROM v4_clean_orders c JOIN v4_ambiguous_order_pairs a USING(orderId,productId)) AS ambiguousRowsHeld,
 (SELECT COUNT(*) FROM v4_clean_orders c LEFT JOIN v4_ambiguous_order_pairs a USING(orderId,productId) WHERE a.orderId IS NULL) AS otherCandidateRows;
