USE cloudrestwines;

-- Align the synthetic picking-pack example with the case wording that seasonal
-- pickers report to the grape-farmer supervisor.
UPDATE supervision
SET supervisorId='EMP0003'
WHERE employeeId IN ('EMP0008','EMP0009','EMP0010','EMP0013')
  AND startDateTime <= NOW()
  AND (endDateTime IS NULL OR endDateTime > NOW());

UPDATE pickerpack
SET supervisorId='EMP0003'
WHERE pickerPackId='PACK001';

UPDATE seasonalrating
SET supervisorId='EMP0003'
WHERE employeeId IN ('EMP0008','EMP0009','EMP0010','EMP0013')
  AND seasonYear=YEAR(CURRENT_DATE);

-- Ensure every active synthetic customer has a current primary phone so the
-- current-state completeness validator tests the intended operational baseline.
INSERT INTO phone(phoneId,countryCode,phoneNumber,phoneType)
VALUES('PHON9001','+61','0390009001','WORK');
INSERT INTO customerphone(customerId,phoneId,startDateTime,endDateTime,isPrimary)
VALUES('CUST002','PHON9001','2025-01-01 00:00:00',NULL,TRUE);

-- Cross-row rules that cannot be represented by a single-row CHECK are validated
-- after the incremental fixture has been fully loaded.
CALL validatePickingPackRules();
CALL validateRequiredCurrentState();
