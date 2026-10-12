USE cloudrestwines;
-- Expected failure: CUST001 already has a current primary phone.
INSERT INTO customerphone(customerId,phoneId,startDateTime,endDateTime,isPrimary)
VALUES('CUST001','PHON0001',NOW(),NULL,TRUE);
