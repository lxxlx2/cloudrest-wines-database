USE cloudrestwines;
DELIMITER $$

CREATE TRIGGER trg_employeerole_nooverlap_insert
BEFORE INSERT ON employeerole
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM employeerole er
    WHERE er.employeeId = NEW.employeeId
      AND NEW.startDateTime <= COALESCE(er.endDateTime, '9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime, '9999-12-31 23:59:59') >= er.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee role period overlaps an existing role period';
  END IF;
END$$

CREATE TRIGGER trg_employeerole_nooverlap_update
BEFORE UPDATE ON employeerole
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM employeerole er
    WHERE er.employeeId = NEW.employeeId
      AND NOT (er.employeeId = OLD.employeeId AND er.roleId = OLD.roleId AND er.startDateTime = OLD.startDateTime)
      AND NEW.startDateTime <= COALESCE(er.endDateTime, '9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime, '9999-12-31 23:59:59') >= er.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Updated employee role period overlaps an existing role period';
  END IF;
END$$

CREATE TRIGGER trg_supervision_nooverlap_insert
BEFORE INSERT ON supervision
FOR EACH ROW
BEGIN
  IF NEW.employeeId = NEW.supervisorId THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'An employee cannot supervise themselves';
  END IF;
  IF EXISTS (
    SELECT 1 FROM supervision s
    WHERE s.employeeId = NEW.employeeId
      AND NEW.startDateTime <= COALESCE(s.endDateTime, '9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime, '9999-12-31 23:59:59') >= s.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee already has a supervisor during this period';
  END IF;
END$$

CREATE TRIGGER trg_supervision_nooverlap_update
BEFORE UPDATE ON supervision
FOR EACH ROW
BEGIN
  IF NEW.employeeId = NEW.supervisorId THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'An employee cannot supervise themselves';
  END IF;
  IF EXISTS (
    SELECT 1 FROM supervision s
    WHERE s.employeeId = NEW.employeeId
      AND NOT (s.employeeId = OLD.employeeId AND s.startDateTime = OLD.startDateTime)
      AND NEW.startDateTime <= COALESCE(s.endDateTime, '9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime, '9999-12-31 23:59:59') >= s.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Updated supervision period overlaps an existing period';
  END IF;
END$$

CREATE TRIGGER trg_shipment_validate_insert
BEFORE INSERT ON shipment
FOR EACH ROW
BEGIN
  DECLARE vPaid BOOLEAN;
  DECLARE vCustomer CHAR(7);
  DECLARE vAddressKind VARCHAR(10);
  DECLARE vPostalType VARCHAR(12);
  DECLARE vIsCurrentAddress INT DEFAULT 0;

  SELECT paidFlag, customerId INTO vPaid, vCustomer
  FROM customerorder WHERE customerOrderId = NEW.customerOrderId;

  SELECT addressKind, postalType INTO vAddressKind, vPostalType
  FROM address WHERE addressId = NEW.addressId;

  SELECT COUNT(*) INTO vIsCurrentAddress
  FROM customeraddress
  WHERE customerId = vCustomer AND addressId = NEW.addressId AND endDateTime IS NULL;

  IF vPaid = FALSE THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order must be paid before shipment';
  END IF;
  IF vAddressKind <> 'PHYSICAL' OR vPostalType IN ('POBOX','PRIVATEBAG') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Shipment address must be a physical address, not PO Box or Private Bag';
  END IF;
  IF vIsCurrentAddress = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Shipment address must be the customer current address';
  END IF;
END$$

CREATE TRIGGER trg_shipment_validate_update
BEFORE UPDATE ON shipment
FOR EACH ROW
BEGIN
  DECLARE vPaid BOOLEAN;
  DECLARE vCustomer CHAR(7);
  DECLARE vAddressKind VARCHAR(10);
  DECLARE vPostalType VARCHAR(12);
  DECLARE vIsCurrentAddress INT DEFAULT 0;

  SELECT paidFlag, customerId INTO vPaid, vCustomer
  FROM customerorder WHERE customerOrderId = NEW.customerOrderId;
  SELECT addressKind, postalType INTO vAddressKind, vPostalType
  FROM address WHERE addressId = NEW.addressId;
  SELECT COUNT(*) INTO vIsCurrentAddress
  FROM customeraddress
  WHERE customerId = vCustomer AND addressId = NEW.addressId AND endDateTime IS NULL;

  IF vPaid = FALSE THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order must be paid before shipment';
  END IF;
  IF vAddressKind <> 'PHYSICAL' OR vPostalType IN ('POBOX','PRIVATEBAG') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Shipment address must be a physical address, not PO Box or Private Bag';
  END IF;
  IF vIsCurrentAddress = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Shipment address must be the customer current address';
  END IF;
END$$

CREATE TRIGGER trg_shipment_mark_shipped
AFTER INSERT ON shipment
FOR EACH ROW
BEGIN
  UPDATE customerorder SET orderStatus = 'SHIPPED' WHERE customerOrderId = NEW.customerOrderId;
END$$

CREATE TRIGGER trg_wellbeingcheckin_notself
BEFORE INSERT ON wellbeingcheckin
FOR EACH ROW
BEGIN
  IF NEW.employeeId = NEW.managerId THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A manager cannot conduct their own wellbeing check-in';
  END IF;
END$$

CREATE TRIGGER trg_wellbeingcheckin_notself_update
BEFORE UPDATE ON wellbeingcheckin
FOR EACH ROW
BEGIN
  IF NEW.employeeId = NEW.managerId THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A manager cannot conduct their own wellbeing check-in';
  END IF;
END$$

CREATE TRIGGER trg_individualcustomer_legalage_insert
BEFORE INSERT ON individualcustomer
FOR EACH ROW
BEGIN
  IF NEW.dateOfBirth > DATE_SUB(CURRENT_DATE, INTERVAL 18 YEAR) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Individual customer must be at least 18 years old';
  END IF;
END$$

CREATE TRIGGER trg_individualcustomer_legalage_update
BEFORE UPDATE ON individualcustomer
FOR EACH ROW
BEGIN
  IF NEW.dateOfBirth > DATE_SUB(CURRENT_DATE, INTERVAL 18 YEAR) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Individual customer must be at least 18 years old';
  END IF;
END$$

CREATE TRIGGER trg_supplieraddress_nooverlap_insert
BEFORE INSERT ON supplieraddress
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM supplieraddress sa
    WHERE sa.supplierId = NEW.supplierId
      AND NEW.startDateTime <= COALESCE(sa.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= sa.startDateTime) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Supplier address period overlaps an existing period';
  END IF;
END$$

CREATE TRIGGER trg_supplieraddress_nooverlap_update
BEFORE UPDATE ON supplieraddress
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM supplieraddress sa
    WHERE sa.supplierId = NEW.supplierId
      AND NOT (sa.supplierId=OLD.supplierId AND sa.addressId=OLD.addressId AND sa.startDateTime=OLD.startDateTime)
      AND NEW.startDateTime <= COALESCE(sa.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= sa.startDateTime) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Updated supplier address period overlaps an existing period';
  END IF;
END$$

CREATE TRIGGER trg_supplierphone_nooverlap_insert
BEFORE INSERT ON supplierphone
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM supplierphone sp
    WHERE sp.supplierId = NEW.supplierId
      AND NEW.startDateTime <= COALESCE(sp.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= sp.startDateTime) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Supplier phone period overlaps an existing period';
  END IF;
  IF NEW.endDateTime IS NULL AND NEW.isPrimary AND EXISTS (
    SELECT 1 FROM supplierphone sp WHERE sp.supplierId=NEW.supplierId AND sp.endDateTime IS NULL AND sp.isPrimary
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Supplier may have only one current primary phone';
  END IF;
END$$

CREATE TRIGGER trg_supplierphone_nooverlap_update
BEFORE UPDATE ON supplierphone
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM supplierphone sp
    WHERE sp.supplierId = NEW.supplierId
      AND NOT (sp.supplierId=OLD.supplierId AND sp.phoneId=OLD.phoneId AND sp.startDateTime=OLD.startDateTime)
      AND NEW.startDateTime <= COALESCE(sp.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= sp.startDateTime) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Updated supplier phone period overlaps an existing period';
  END IF;
  IF NEW.endDateTime IS NULL AND NEW.isPrimary AND EXISTS (
    SELECT 1 FROM supplierphone sp WHERE sp.supplierId=NEW.supplierId AND sp.endDateTime IS NULL AND sp.isPrimary
      AND NOT (sp.supplierId=OLD.supplierId AND sp.phoneId=OLD.phoneId AND sp.startDateTime=OLD.startDateTime)
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Supplier may have only one current primary phone';
  END IF;
END$$

DELIMITER ;
