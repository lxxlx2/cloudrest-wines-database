USE cloudrestwines;
START TRANSACTION;
INSERT INTO customer(customerId,customerType,emailAddress,isActive)
VALUES('CUST099','INDIVIDUAL','incomplete.customer@example.test',TRUE);
-- Expected failure: a staged parent cannot transact until exactly one matching subtype exists.
INSERT INTO customerorder(customerOrderId,customerId,receivedDate,paidFlag,orderStatus)
VALUES('ORDR0998','CUST099',CURRENT_DATE,TRUE,'PENDING');
ROLLBACK;
