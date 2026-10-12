USE cloudrestwines;
-- Additional evidence for the physical-address portion of assessed shipment Rule 3.
INSERT INTO shipment (shipmentId,customerOrderId,productId,addressId,shippedDate)
VALUES ('SHIP0999','CORD0001','PROD001','ADDR0004',CURRENT_DATE);
