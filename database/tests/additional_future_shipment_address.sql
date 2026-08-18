USE cloudrestwines;
START TRANSACTION;

-- Build an otherwise valid individual customer whose only physical address begins tomorrow.
-- This avoids triggering the separate same-kind address-overlap control first.
INSERT INTO customer(customerId,customerType,emailAddress,isActive)
VALUES('CUST098','INDIVIDUAL','future.address@example.test',TRUE);
INSERT INTO individualcustomer(customerId,firstName,lastName,dateOfBirth)
VALUES('CUST098','Future','Address','1990-01-01');
INSERT INTO address VALUES
('ADDR9003','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'55','Future Road','Richmond','VIC','3121');
INSERT INTO customeraddress(customerId,addressId,startDateTime,endDateTime)
VALUES('CUST098','ADDR9003',DATE_ADD(NOW(),INTERVAL 1 DAY),NULL);
INSERT INTO customerorder(customerOrderId,customerId,receivedDate,paidFlag,orderStatus)
VALUES('CORD9001','CUST098',CURRENT_DATE,TRUE,'PENDING');
INSERT INTO orderline(customerOrderId,productId,caseQuantity,agreedCasePrice)
VALUES('CORD9001','PROD001',1,360.00);

-- Expected failure from shipment current-address validation: tomorrow's address is not current today.
INSERT INTO shipment(shipmentId,customerOrderId,addressId,shippedDate)
VALUES('SHIP9001','CORD9001','ADDR9003',CURRENT_DATE);
ROLLBACK;
