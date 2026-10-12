USE cloudrestwines;
-- Assessed Test 4 (negative): an unpaid order cannot be shipped.
INSERT INTO customerorder VALUES ('CORD0998','CUST001',CURRENT_DATE,FALSE,'PENDING');
INSERT INTO orderline (customerOrderId,productId,caseQuantity,agreedCasePrice)
VALUES ('CORD0998','PROD001',1,360.00);
INSERT INTO shipment (shipmentId,customerOrderId,productId,addressId,shippedDate)
VALUES ('SHIP0998','CORD0998','PROD001','ADDR0003',CURRENT_DATE);
