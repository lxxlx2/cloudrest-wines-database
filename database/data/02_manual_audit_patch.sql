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

-- This procedure contains the cross-row pack rules that cannot be enforced while
-- incrementally inserting the first, second and third member of a new pack.
CALL validatePickingPackRules();
