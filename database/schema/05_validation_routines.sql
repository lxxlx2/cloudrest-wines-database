USE cloudrestwines;
DELIMITER $$

-- Required-current-state checks are intentionally implemented as an explicit
-- validation routine. Row-level triggers enforce at-most-one primary period, while
-- this routine verifies that staged data has reached a complete operational state.
CREATE PROCEDURE validateRequiredCurrentState()
BEGIN
  IF EXISTS (
    SELECT e.employeeId
    FROM employee e
    WHERE (e.employmentEndDate IS NULL OR e.employmentEndDate>=CURRENT_DATE)
      AND (
        SELECT COUNT(*) FROM employeephone ep
        WHERE ep.employeeId=e.employeeId AND ep.isPrimary=TRUE
          AND ep.startDateTime<=NOW() AND (ep.endDateTime IS NULL OR ep.endDateTime>NOW())
      )<>1
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Every active employee must have exactly one current primary phone';
  END IF;

  IF EXISTS (
    SELECT e.employeeId
    FROM employee e
    WHERE (e.employmentEndDate IS NULL OR e.employmentEndDate>=CURRENT_DATE)
      AND (
        SELECT COUNT(*)
        FROM employeeaddress ea JOIN address a ON a.addressId=ea.addressId
        WHERE ea.employeeId=e.employeeId AND a.addressKind='PHYSICAL'
          AND ea.startDateTime<=NOW() AND (ea.endDateTime IS NULL OR ea.endDateTime>NOW())
      )<>1
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Every active employee must have exactly one current physical address';
  END IF;

  IF EXISTS (
    SELECT c.customerId
    FROM customer c
    WHERE c.isActive=TRUE
      AND (
        SELECT COUNT(*) FROM customerphone cp
        WHERE cp.customerId=c.customerId AND cp.isPrimary=TRUE
          AND cp.startDateTime<=NOW() AND (cp.endDateTime IS NULL OR cp.endDateTime>NOW())
      )<>1
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Every active customer must have exactly one current primary phone';
  END IF;

  IF EXISTS (
    SELECT c.customerId
    FROM customer c
    WHERE c.isActive=TRUE
      AND (
        SELECT COUNT(*)
        FROM customeraddress ca JOIN address a ON a.addressId=ca.addressId
        WHERE ca.customerId=c.customerId AND a.addressKind='PHYSICAL'
          AND ca.startDateTime<=NOW() AND (ca.endDateTime IS NULL OR ca.endDateTime>NOW())
      )<>1
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Every active customer must have exactly one current physical address';
  END IF;

  IF EXISTS (
    SELECT s.supplierId
    FROM supplier s
    WHERE (
      SELECT COUNT(*)
      FROM supplieraddress sa JOIN address a ON a.addressId=sa.addressId
      WHERE sa.supplierId=s.supplierId AND a.addressKind='PHYSICAL'
        AND sa.startDateTime<=NOW() AND (sa.endDateTime IS NULL OR sa.endDateTime>NOW())
    )<>1
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Every supplier must have exactly one current physical address';
  END IF;

  IF EXISTS (
    SELECT s.supplierId
    FROM supplier s
    WHERE (
      SELECT COUNT(*) FROM supplierphone sp
      WHERE sp.supplierId=s.supplierId AND sp.isPrimary=TRUE
        AND sp.startDateTime<=NOW() AND (sp.endDateTime IS NULL OR sp.endDateTime>NOW())
    )<>1
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Every supplier must have exactly one current primary phone';
  END IF;
END$$

DELIMITER ;
