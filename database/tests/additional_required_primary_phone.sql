USE cloudrestwines;
START TRANSACTION;
DELETE FROM customerphone WHERE customerId='CUST002';
-- Expected failure: active customers require exactly one current primary phone at operational validation.
CALL validateRequiredCurrentState();
ROLLBACK;
