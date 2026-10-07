USE cloudrestwines;
START TRANSACTION;
UPDATE packmember
SET leftDate=DATE_SUB(CURRENT_DATE,INTERVAL 1 DAY)
WHERE pickerPackId='PACK001' AND employeeId='EMP0008' AND leftDate IS NULL;
INSERT INTO packmember(pickerPackId,employeeId,joinedDate,leftDate)
VALUES('PACK001','EMP0008',CURRENT_DATE,NULL);
SELECT 'PASS: picker can rejoin the same pack after leaving' AS testResult;
ROLLBACK;
