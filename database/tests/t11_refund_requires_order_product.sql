USE cloudrestwines;
-- Expected failure: CORD0001 has no PROD999 order line.
INSERT INTO refund
(refundId,customerOrderId,productId,refundDate,refundReason,verifiedFlag,refundAmount)
VALUES('RFND0099','CORD0001','PROD999',CURRENT_DATE,'SHORTSUPPLY',FALSE,10.00);
