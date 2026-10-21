USE cloudrestwines;
-- Positive Hint 8 regression: one paid order, two ordered products, two recipients
-- and two different physical shipment destinations. Unlike the customer contact
-- address, the saved orderline snapshots are independent and historical.
SELECT
  ol.customerOrderId, ol.productId, ol.deliveryRecipientName,
  ol.deliveryStreetAddress, ol.deliveryLocality,
  sh.shipmentId, a.addressKind, a.addressId
FROM orderline ol
JOIN shipment sh ON sh.customerOrderId=ol.customerOrderId AND sh.productId=ol.productId
JOIN address a ON a.addressId=sh.addressId
WHERE ol.customerOrderId='CORD0002'
ORDER BY ol.productId;

SELECT IF(
  COUNT(*)=2 AND COUNT(DISTINCT ol.deliveryRecipientName)=2
  AND COUNT(DISTINCT sh.addressId)=2
  AND MIN(co.orderStatus)='SHIPPED',
  'PASS: two distinct product deliveries', 'FAIL: delivery model regression'
) AS result
FROM orderline ol
JOIN shipment sh ON sh.customerOrderId=ol.customerOrderId AND sh.productId=ol.productId
JOIN customerorder co ON co.customerOrderId=ol.customerOrderId
WHERE ol.customerOrderId='CORD0002';
