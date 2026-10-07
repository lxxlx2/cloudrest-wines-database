USE cloudrestwines;
DELIMITER $$

-- Tutor feedback: historical address rows must not produce two simultaneous
-- current rows for the same business meaning.
CREATE TRIGGER trg_employeeaddress_samekind_insert
BEFORE INSERT ON employeeaddress
FOR EACH ROW
BEGIN
  DECLARE vAddressKind VARCHAR(10);
  SELECT addressKind INTO vAddressKind FROM address WHERE addressId=NEW.addressId;
  IF EXISTS (
    SELECT 1
    FROM employeeaddress ea
    JOIN address a ON a.addressId=ea.addressId
    WHERE ea.employeeId=NEW.employeeId
      AND a.addressKind=vAddressKind
      AND NEW.startDateTime <= COALESCE(ea.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= ea.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Employee address period overlaps an existing address of the same kind';
  END IF;
END$$

CREATE TRIGGER trg_employeeaddress_samekind_update
BEFORE UPDATE ON employeeaddress
FOR EACH ROW
BEGIN
  DECLARE vAddressKind VARCHAR(10);
  SELECT addressKind INTO vAddressKind FROM address WHERE addressId=NEW.addressId;
  IF EXISTS (
    SELECT 1
    FROM employeeaddress ea
    JOIN address a ON a.addressId=ea.addressId
    WHERE ea.employeeId=NEW.employeeId
      AND a.addressKind=vAddressKind
      AND NOT (
        ea.employeeId=OLD.employeeId
        AND ea.addressId=OLD.addressId
        AND ea.startDateTime=OLD.startDateTime
      )
      AND NEW.startDateTime <= COALESCE(ea.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= ea.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Updated employee address period overlaps an existing address of the same kind';
  END IF;
END$$

-- Customer addresses may legitimately have concurrent Delivery and Billing rows
-- in the supplied v4 workbook. The non-overlap rule is therefore per purpose.
CREATE TRIGGER trg_customeraddress_purpose_insert
BEFORE INSERT ON customeraddress
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1
    FROM customeraddress ca
    WHERE ca.customerId=NEW.customerId
      AND ca.addressPurpose=NEW.addressPurpose
      AND NEW.startDateTime <= COALESCE(ca.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= ca.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Customer address period overlaps an existing address with the same purpose';
  END IF;
END$$

CREATE TRIGGER trg_customeraddress_purpose_update
BEFORE UPDATE ON customeraddress
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1
    FROM customeraddress ca
    WHERE ca.customerId=NEW.customerId
      AND ca.addressPurpose=NEW.addressPurpose
      AND NOT (
        ca.customerId=OLD.customerId
        AND ca.addressId=OLD.addressId
        AND ca.startDateTime=OLD.startDateTime
      )
      AND NEW.startDateTime <= COALESCE(ca.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= ca.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Updated customer address period overlaps an existing address with the same purpose';
  END IF;
END$$

-- Multiple phone numbers may be retained, but only one current primary number
-- may exist for an employee/customer at a time.
CREATE TRIGGER trg_employeephone_primary_insert
BEFORE INSERT ON employeephone
FOR EACH ROW
BEGIN
  IF NEW.endDateTime IS NULL AND NEW.isPrimary AND EXISTS (
    SELECT 1 FROM employeephone ep
    WHERE ep.employeeId=NEW.employeeId
      AND ep.endDateTime IS NULL
      AND ep.isPrimary
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Employee may have only one current primary phone';
  END IF;
END$$

CREATE TRIGGER trg_employeephone_primary_update
BEFORE UPDATE ON employeephone
FOR EACH ROW
BEGIN
  IF NEW.endDateTime IS NULL AND NEW.isPrimary AND EXISTS (
    SELECT 1 FROM employeephone ep
    WHERE ep.employeeId=NEW.employeeId
      AND ep.endDateTime IS NULL
      AND ep.isPrimary
      AND NOT (
        ep.employeeId=OLD.employeeId
        AND ep.phoneId=OLD.phoneId
        AND ep.startDateTime=OLD.startDateTime
      )
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Employee may have only one current primary phone';
  END IF;
END$$

CREATE TRIGGER trg_customerphone_primary_insert
BEFORE INSERT ON customerphone
FOR EACH ROW
BEGIN
  IF NEW.endDateTime IS NULL AND NEW.isPrimary AND EXISTS (
    SELECT 1 FROM customerphone cp
    WHERE cp.customerId=NEW.customerId
      AND cp.endDateTime IS NULL
      AND cp.isPrimary
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Customer may have only one current primary phone';
  END IF;
END$$

CREATE TRIGGER trg_customerphone_primary_update
BEFORE UPDATE ON customerphone
FOR EACH ROW
BEGIN
  IF NEW.endDateTime IS NULL AND NEW.isPrimary AND EXISTS (
    SELECT 1 FROM customerphone cp
    WHERE cp.customerId=NEW.customerId
      AND cp.endDateTime IS NULL
      AND cp.isPrimary
      AND NOT (
        cp.customerId=OLD.customerId
        AND cp.phoneId=OLD.phoneId
        AND cp.startDateTime=OLD.startDateTime
      )
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Customer may have only one current primary phone';
  END IF;
END$$

-- joinedDate is part of the PK so a picker can leave and later rejoin the same
-- pack. Membership periods for one picker still cannot overlap.
CREATE TRIGGER trg_packmember_nooverlap_insert
BEFORE INSERT ON packmember
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM packmember pm
    WHERE pm.employeeId=NEW.employeeId
      AND NEW.joinedDate <= COALESCE(pm.leftDate,'9999-12-31')
      AND COALESCE(NEW.leftDate,'9999-12-31') >= pm.joinedDate
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Picker membership period overlaps an existing pack membership';
  END IF;
END$$

CREATE TRIGGER trg_packmember_nooverlap_update
BEFORE UPDATE ON packmember
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM packmember pm
    WHERE pm.employeeId=NEW.employeeId
      AND NOT (
        pm.pickerPackId=OLD.pickerPackId
        AND pm.employeeId=OLD.employeeId
        AND pm.joinedDate=OLD.joinedDate
      )
      AND NEW.joinedDate <= COALESCE(pm.leftDate,'9999-12-31')
      AND COALESCE(NEW.leftDate,'9999-12-31') >= pm.joinedDate
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Updated picker membership period overlaps an existing pack membership';
  END IF;
END$$

-- MySQL has no deferred cross-row CHECK. Composition is therefore validated at
-- the release boundary. An active product cannot exist unless its wine recipe
-- has at least one row and totals exactly 100 percent.
CREATE PROCEDURE validateWineComposition(IN pWineId CHAR(7))
BEGIN
  DECLARE vRows INT DEFAULT 0;
  DECLARE vTotal DECIMAL(8,2) DEFAULT 0;
  SELECT COUNT(*), COALESCE(SUM(proportionPercent),0)
    INTO vRows, vTotal
  FROM winecomposition
  WHERE wineId=pWineId;

  IF vRows=0 OR ABS(vTotal-100.00) > 0.001 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Wine composition must contain at least one variety and total exactly 100 percent';
  END IF;
END$$

CREATE PROCEDURE validateAllWineComposition()
BEGIN
  IF EXISTS (
    SELECT w.wineId
    FROM wine w
    LEFT JOIN winecomposition wc ON wc.wineId=w.wineId
    GROUP BY w.wineId
    HAVING COUNT(wc.grapeVarietyId)=0
       OR ABS(COALESCE(SUM(wc.proportionPercent),0)-100.00) > 0.001
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='At least one wine has an incomplete composition total';
  END IF;
END$$

CREATE TRIGGER trg_wineproduct_composition_insert
BEFORE INSERT ON wineproduct
FOR EACH ROW
BEGIN
  IF NEW.isActive THEN
    CALL validateWineComposition(NEW.wineId);
  END IF;
END$$

CREATE TRIGGER trg_wineproduct_composition_update
BEFORE UPDATE ON wineproduct
FOR EACH ROW
BEGIN
  IF NEW.isActive THEN
    CALL validateWineComposition(NEW.wineId);
  END IF;
END$$

CREATE TRIGGER trg_winecomposition_locked_insert
BEFORE INSERT ON winecomposition
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM wineproduct wp
    WHERE wp.wineId=NEW.wineId AND wp.isActive
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Deactivate wine products before changing a released wine composition';
  END IF;
END$$

CREATE TRIGGER trg_winecomposition_locked_update
BEFORE UPDATE ON winecomposition
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM wineproduct wp
    WHERE wp.wineId IN (OLD.wineId,NEW.wineId) AND wp.isActive
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Deactivate wine products before changing a released wine composition';
  END IF;
END$$

CREATE TRIGGER trg_winecomposition_locked_delete
BEFORE DELETE ON winecomposition
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM wineproduct wp
    WHERE wp.wineId=OLD.wineId AND wp.isActive
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='Deactivate wine products before changing a released wine composition';
  END IF;
END$$

DELIMITER ;
