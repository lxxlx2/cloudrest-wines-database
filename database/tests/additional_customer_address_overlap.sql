USE cloudrestwines;
-- Expected failure: CUST001 already has a current PHYSICAL address.
INSERT INTO customeraddress(customerId,addressId,startDateTime,endDateTime)
VALUES('CUST001','ADDR0008',NOW(),NULL);
