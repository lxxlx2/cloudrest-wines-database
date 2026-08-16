USE cloudrestwines;
START TRANSACTION;
INSERT INTO customerorder(customerOrderId,customerId,receivedDate,paidFlag,orderStatus)
VALUES('ORDR0999','CUST001',CURRENT_DATE,TRUE,'PENDING');
-- Expected database rejection because no orderline exists for ORDR0999.
INSERT INTO shipment(shipmentId,customerOrderId,addressId,shippedDate)
VALUES('SHIP0999','ORDR0999','ADDR0003',CURRENT_DATE);
ROLLBACK;
