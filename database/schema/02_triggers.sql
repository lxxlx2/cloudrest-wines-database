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

CREATE TRIGGER trg_employeephone_primary_insert
BEFORE INSERT ON employeephone
FOR EACH ROW
BEGIN
  IF NEW.isPrimary AND EXISTS (
    SELECT 1 FROM employeephone ep
    WHERE ep.employeeId = NEW.employeeId
      AND ep.isPrimary = TRUE
      AND NEW.startDateTime <= COALESCE(ep.endDateTime, '9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime, '9999-12-31 23:59:59') >= ep.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee may have only one primary phone during a period';
  END IF;
END$$

CREATE TRIGGER trg_employeephone_primary_update
BEFORE UPDATE ON employeephone
FOR EACH ROW
BEGIN
  IF NEW.isPrimary AND EXISTS (
    SELECT 1 FROM employeephone ep
    WHERE ep.employeeId = NEW.employeeId
      AND ep.isPrimary = TRUE
      AND NOT (ep.employeeId = OLD.employeeId AND ep.phoneId = OLD.phoneId AND ep.startDateTime = OLD.startDateTime)
      AND NEW.startDateTime <= COALESCE(ep.endDateTime, '9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime, '9999-12-31 23:59:59') >= ep.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee may have only one primary phone during a period';
  END IF;
END$$

CREATE TRIGGER trg_customerphone_primary_insert
BEFORE INSERT ON customerphone
FOR EACH ROW
BEGIN
  IF NEW.isPrimary AND EXISTS (
    SELECT 1 FROM customerphone cp
    WHERE cp.customerId = NEW.customerId
      AND cp.isPrimary = TRUE
      AND NEW.startDateTime <= COALESCE(cp.endDateTime, '9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime, '9999-12-31 23:59:59') >= cp.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer may have only one primary phone during a period';
  END IF;
END$$

CREATE TRIGGER trg_customerphone_primary_update
BEFORE UPDATE ON customerphone
FOR EACH ROW
BEGIN
  IF NEW.isPrimary AND EXISTS (
    SELECT 1 FROM customerphone cp
    WHERE cp.customerId = NEW.customerId
      AND cp.isPrimary = TRUE
      AND NOT (cp.customerId = OLD.customerId AND cp.phoneId = OLD.phoneId AND cp.startDateTime = OLD.startDateTime)
      AND NEW.startDateTime <= COALESCE(cp.endDateTime, '9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime, '9999-12-31 23:59:59') >= cp.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer may have only one primary phone during a period';
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
  WHERE customerId = vCustomer
    AND addressId = NEW.addressId
    AND startDateTime <= NOW()
    AND (endDateTime IS NULL OR endDateTime > NOW());

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
  WHERE customerId = vCustomer
    AND addressId = NEW.addressId
    AND startDateTime <= NOW()
    AND (endDateTime IS NULL OR endDateTime > NOW());

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

CREATE TRIGGER trg_individualcustomer_subtype_insert
BEFORE INSERT ON individualcustomer
FOR EACH ROW
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM customer c
    WHERE c.customerId = NEW.customerId AND c.customerType = 'INDIVIDUAL'
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Individual customer subtype must match parent customerType';
  END IF;
  IF EXISTS (SELECT 1 FROM businesscustomer b WHERE b.customerId = NEW.customerId) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer cannot belong to both individual and business subtypes';
  END IF;
END$$

CREATE TRIGGER trg_individualcustomer_subtype_update
BEFORE UPDATE ON individualcustomer
FOR EACH ROW
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM customer c
    WHERE c.customerId = NEW.customerId AND c.customerType = 'INDIVIDUAL'
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Individual customer subtype must match parent customerType';
  END IF;
  IF EXISTS (SELECT 1 FROM businesscustomer b WHERE b.customerId = NEW.customerId) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer cannot belong to both individual and business subtypes';
  END IF;
END$$

CREATE TRIGGER trg_businesscustomer_subtype_insert
BEFORE INSERT ON businesscustomer
FOR EACH ROW
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM customer c
    WHERE c.customerId = NEW.customerId AND c.customerType = 'BUSINESS'
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Business customer subtype must match parent customerType';
  END IF;
  IF EXISTS (SELECT 1 FROM individualcustomer i WHERE i.customerId = NEW.customerId) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer cannot belong to both individual and business subtypes';
  END IF;
END$$

CREATE TRIGGER trg_businesscustomer_subtype_update
BEFORE UPDATE ON businesscustomer
FOR EACH ROW
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM customer c
    WHERE c.customerId = NEW.customerId AND c.customerType = 'BUSINESS'
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Business customer subtype must match parent customerType';
  END IF;
  IF EXISTS (SELECT 1 FROM individualcustomer i WHERE i.customerId = NEW.customerId) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer cannot belong to both individual and business subtypes';
  END IF;
END$$

CREATE TRIGGER trg_customer_type_update
BEFORE UPDATE ON customer
FOR EACH ROW
BEGIN
  IF NEW.customerType <> OLD.customerType THEN
    IF NEW.customerType = 'INDIVIDUAL' AND EXISTS (
      SELECT 1 FROM businesscustomer b WHERE b.customerId = OLD.customerId
    ) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Parent customerType conflicts with existing business subtype';
    END IF;
    IF NEW.customerType = 'BUSINESS' AND EXISTS (
      SELECT 1 FROM individualcustomer i WHERE i.customerId = OLD.customerId
    ) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Parent customerType conflicts with existing individual subtype';
    END IF;
  END IF;
END$$

CREATE TRIGGER trg_supplieraddress_nooverlap_insert
BEFORE INSERT ON supplieraddress
FOR EACH ROW
BEGIN
  DECLARE vAddressKind VARCHAR(10);
  SELECT addressKind INTO vAddressKind FROM address WHERE addressId = NEW.addressId;
  IF EXISTS (
    SELECT 1
    FROM supplieraddress sa
    JOIN address a ON a.addressId = sa.addressId
    WHERE sa.supplierId = NEW.supplierId
      AND a.addressKind = vAddressKind
      AND NEW.startDateTime <= COALESCE(sa.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= sa.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Supplier address period overlaps an existing address of the same type';
  END IF;
END$$

CREATE TRIGGER trg_supplieraddress_nooverlap_update
BEFORE UPDATE ON supplieraddress
FOR EACH ROW
BEGIN
  DECLARE vAddressKind VARCHAR(10);
  SELECT addressKind INTO vAddressKind FROM address WHERE addressId = NEW.addressId;
  IF EXISTS (
    SELECT 1
    FROM supplieraddress sa
    JOIN address a ON a.addressId = sa.addressId
    WHERE sa.supplierId = NEW.supplierId
      AND a.addressKind = vAddressKind
      AND NOT (sa.supplierId = OLD.supplierId AND sa.addressId = OLD.addressId AND sa.startDateTime = OLD.startDateTime)
      AND NEW.startDateTime <= COALESCE(sa.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= sa.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Updated supplier address period overlaps an existing address of the same type';
  END IF;
END$$

CREATE TRIGGER trg_supplierphone_nooverlap_insert
BEFORE INSERT ON supplierphone
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM supplierphone sp
    WHERE sp.supplierId = NEW.supplierId
      AND sp.phoneId = NEW.phoneId
      AND NEW.startDateTime <= COALESCE(sp.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= sp.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Supplier phone period overlaps an existing period for the same phone';
  END IF;
  IF NEW.isPrimary AND EXISTS (
    SELECT 1 FROM supplierphone sp
    WHERE sp.supplierId = NEW.supplierId
      AND sp.isPrimary = TRUE
      AND NEW.startDateTime <= COALESCE(sp.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= sp.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Supplier may have only one primary phone during a period';
  END IF;
END$$

CREATE TRIGGER trg_supplierphone_nooverlap_update
BEFORE UPDATE ON supplierphone
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM supplierphone sp
    WHERE sp.supplierId = NEW.supplierId
      AND sp.phoneId = NEW.phoneId
      AND NOT (sp.supplierId = OLD.supplierId AND sp.phoneId = OLD.phoneId AND sp.startDateTime = OLD.startDateTime)
      AND NEW.startDateTime <= COALESCE(sp.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= sp.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Updated supplier phone period overlaps an existing period for the same phone';
  END IF;
  IF NEW.isPrimary AND EXISTS (
    SELECT 1 FROM supplierphone sp
    WHERE sp.supplierId = NEW.supplierId
      AND sp.isPrimary = TRUE
      AND NOT (sp.supplierId = OLD.supplierId AND sp.phoneId = OLD.phoneId AND sp.startDateTime = OLD.startDateTime)
      AND NEW.startDateTime <= COALESCE(sp.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= sp.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Supplier may have only one primary phone during a period';
  END IF;
END$$

CREATE TRIGGER trg_receiptline_ordered_insert
BEFORE INSERT ON receiptline
FOR EACH ROW
BEGIN
  DECLARE vPurchaseOrderId CHAR(8);
  SELECT purchaseOrderId INTO vPurchaseOrderId
  FROM receipt WHERE receiptId = NEW.receiptId;

  IF NOT EXISTS (
    SELECT 1 FROM purchaseorderline pol
    WHERE pol.purchaseOrderId = vPurchaseOrderId
      AND pol.bottleTypeId = NEW.bottleTypeId
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Received bottle type must exist on the related purchase order';
  END IF;
END$$

CREATE TRIGGER trg_receiptline_ordered_update
BEFORE UPDATE ON receiptline
FOR EACH ROW
BEGIN
  DECLARE vPurchaseOrderId CHAR(8);
  SELECT purchaseOrderId INTO vPurchaseOrderId
  FROM receipt WHERE receiptId = NEW.receiptId;

  IF NOT EXISTS (
    SELECT 1 FROM purchaseorderline pol
    WHERE pol.purchaseOrderId = vPurchaseOrderId
      AND pol.bottleTypeId = NEW.bottleTypeId
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Received bottle type must exist on the related purchase order';
  END IF;
END$$

CREATE TRIGGER trg_productprice_nooverlap_insert
BEFORE INSERT ON productprice
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM productprice pp
    WHERE pp.productId = NEW.productId
      AND NEW.effectiveDate <= COALESCE(pp.endDate, '9999-12-31')
      AND COALESCE(NEW.endDate, '9999-12-31') >= pp.effectiveDate
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product price period overlaps an existing price period';
  END IF;
END$$

CREATE TRIGGER trg_productprice_nooverlap_update
BEFORE UPDATE ON productprice
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM productprice pp
    WHERE pp.productId = NEW.productId
      AND NOT (pp.productId = OLD.productId AND pp.effectiveDate = OLD.effectiveDate)
      AND NEW.effectiveDate <= COALESCE(pp.endDate, '9999-12-31')
      AND COALESCE(NEW.endDate, '9999-12-31') >= pp.effectiveDate
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Updated product price period overlaps an existing price period';
  END IF;
END$$

DELIMITER ;
