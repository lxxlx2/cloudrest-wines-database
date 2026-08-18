USE cloudrestwines;
INSERT INTO phone VALUES ('PHON9101','+61','0400999101','MOBILE');
-- Expected failure from employee primary-phone period trigger, not from a phone PK collision.
INSERT INTO employeephone VALUES ('EMP0003','PHON9101',NOW(),NULL,TRUE);
