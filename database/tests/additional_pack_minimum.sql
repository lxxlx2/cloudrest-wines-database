USE cloudrestwines;
START TRANSACTION;
DELETE FROM packmember WHERE pickerPackId='PACK001' AND employeeId='EMP0013';
-- Expected failure: completed pack now has fewer than four current members.
CALL validatePickingPackRules();
ROLLBACK;
