USE cloudrestwines;
-- Assessed Test 4 (negative): an unpaid order cannot be shipped.
INSERT INTO customerorder VALUES ('CORD0998','CUST001',CURRENT_DATE,FALSE,'PENDING');
INSERT INTO shipment VALUES ('SHIP0998','CORD0998','ADDR0003',CURRENT_DATE);
