USE cloudrestwines;
-- Expected failure: EMP0003 already has a current PHYSICAL address.
INSERT INTO employeeaddress(employeeId,addressId,startDateTime,endDateTime)
VALUES('EMP0003','ADDR0008',NOW(),NULL);
