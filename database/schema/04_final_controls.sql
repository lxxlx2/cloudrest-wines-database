USE cloudrestwines;
DELIMITER $$

-- Employee and customer address history may include physical and postal rows at the
-- same time, but periods of the same address kind must not overlap for one owner.
CREATE TRIGGER trg_employeeaddress_samekind_insert
BEFORE INSERT ON employeeaddress
FOR EACH ROW
BEGIN
  DECLARE vAddressKind VARCHAR(10);
  SELECT addressKind INTO vAddressKind FROM address WHERE addressId = NEW.addressId;
  IF EXISTS (
    SELECT 1
    FROM employeeaddress ea
    JOIN address a ON a.addressId = ea.addressId
    WHERE ea.employeeId = NEW.employeeId
      AND a.addressKind = vAddressKind
      AND NEW.startDateTime <= COALESCE(ea.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= ea.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee address period overlaps an existing address of the same type';
  END IF;
END$$

CREATE TRIGGER trg_employeeaddress_samekind_update
BEFORE UPDATE ON employeeaddress
FOR EACH ROW
BEGIN
  DECLARE vAddressKind VARCHAR(10);
  SELECT addressKind INTO vAddressKind FROM address WHERE addressId = NEW.addressId;
  IF EXISTS (
    SELECT 1
    FROM employeeaddress ea
    JOIN address a ON a.addressId = ea.addressId
    WHERE ea.employeeId = NEW.employeeId
      AND a.addressKind = vAddressKind
      AND NOT (ea.employeeId=OLD.employeeId AND ea.addressId=OLD.addressId AND ea.startDateTime=OLD.startDateTime)
      AND NEW.startDateTime <= COALESCE(ea.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= ea.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Updated employee address period overlaps an existing address of the same type';
  END IF;
END$$

CREATE TRIGGER trg_customeraddress_samekind_insert
BEFORE INSERT ON customeraddress
FOR EACH ROW
BEGIN
  DECLARE vAddressKind VARCHAR(10);
  SELECT addressKind INTO vAddressKind FROM address WHERE addressId = NEW.addressId;
  IF EXISTS (
    SELECT 1
    FROM customeraddress ca
    JOIN address a ON a.addressId = ca.addressId
    WHERE ca.customerId = NEW.customerId
      AND a.addressKind = vAddressKind
      AND NEW.startDateTime <= COALESCE(ca.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= ca.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer address period overlaps an existing address of the same type';
  END IF;
END$$

CREATE TRIGGER trg_customeraddress_samekind_update
BEFORE UPDATE ON customeraddress
FOR EACH ROW
BEGIN
  DECLARE vAddressKind VARCHAR(10);
  SELECT addressKind INTO vAddressKind FROM address WHERE addressId = NEW.addressId;
  IF EXISTS (
    SELECT 1
    FROM customeraddress ca
    JOIN address a ON a.addressId = ca.addressId
    WHERE ca.customerId = NEW.customerId
      AND a.addressKind = vAddressKind
      AND NOT (ca.customerId=OLD.customerId AND ca.addressId=OLD.addressId AND ca.startDateTime=OLD.startDateTime)
      AND NEW.startDateTime <= COALESCE(ca.endDateTime,'9999-12-31 23:59:59')
      AND COALESCE(NEW.endDateTime,'9999-12-31 23:59:59') >= ca.startDateTime
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Updated customer address period overlaps an existing address of the same type';
  END IF;
END$$

-- A customer may be staged before its subtype is populated, but cannot transact
-- through an order until exactly one matching subtype exists.
CREATE PROCEDURE validateCustomerSubtype(IN pCustomerId CHAR(7))
BEGIN
  DECLARE vType VARCHAR(12);
  DECLARE vIndividual INT DEFAULT 0;
  DECLARE vBusiness INT DEFAULT 0;
  SELECT customerType INTO vType FROM customer WHERE customerId=pCustomerId;
  SELECT COUNT(*) INTO vIndividual FROM individualcustomer WHERE customerId=pCustomerId;
  SELECT COUNT(*) INTO vBusiness FROM businesscustomer WHERE customerId=pCustomerId;
  IF vType='INDIVIDUAL' AND NOT (vIndividual=1 AND vBusiness=0) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Individual customer must have exactly one matching individual subtype before transacting';
  END IF;
  IF vType='BUSINESS' AND NOT (vBusiness=1 AND vIndividual=0) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Business customer must have exactly one matching business subtype before transacting';
  END IF;
END$$

CREATE TRIGGER trg_customerorder_subtype_insert
BEFORE INSERT ON customerorder
FOR EACH ROW
BEGIN
  CALL validateCustomerSubtype(NEW.customerId);
END$$

CREATE TRIGGER trg_customerorder_subtype_update
BEFORE UPDATE ON customerorder
FOR EACH ROW
BEGIN
  CALL validateCustomerSubtype(NEW.customerId);
END$$

-- A wine recipe can be entered incrementally, but a sellable product may only be
-- created once the recipe contains at least one row and totals exactly 100 percent.
CREATE PROCEDURE validateWineComposition(IN pWineId CHAR(7))
BEGIN
  DECLARE vRows INT DEFAULT 0;
  DECLARE vTotal DECIMAL(7,2) DEFAULT 0;
  SELECT COUNT(*), COALESCE(SUM(proportionPercent),0)
    INTO vRows, vTotal
  FROM winecomposition
  WHERE wineId=pWineId;
  IF vRows=0 OR ABS(vTotal-100.00) > 0.001 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Wine composition must contain at least one variety and total exactly 100 percent before product release';
  END IF;
END$$

CREATE TRIGGER trg_wineproduct_composition_insert
BEFORE INSERT ON wineproduct
FOR EACH ROW
BEGIN
  CALL validateWineComposition(NEW.wineId);
END$$

CREATE TRIGGER trg_wineproduct_composition_update
BEFORE UPDATE ON wineproduct
FOR EACH ROW
BEGIN
  CALL validateWineComposition(NEW.wineId);
END$$

-- Vineyard values are cross-table business facts: the recorded manager must be an
-- active grape farmer and the vineyard address must be physical.
CREATE TRIGGER trg_vineyard_business_insert
BEFORE INSERT ON vineyard
FOR EACH ROW
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM employeerole er JOIN role r ON r.roleId=er.roleId
    WHERE er.employeeId=NEW.managerId AND r.roleName='Grape Farmer'
      AND er.startDateTime<=NOW() AND (er.endDateTime IS NULL OR er.endDateTime>NOW())
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Vineyard manager must have an active Grape Farmer role';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM address a WHERE a.addressId=NEW.addressId AND a.addressKind='PHYSICAL') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Vineyard address must be physical';
  END IF;
END$$

CREATE TRIGGER trg_vineyard_business_update
BEFORE UPDATE ON vineyard
FOR EACH ROW
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM employeerole er JOIN role r ON r.roleId=er.roleId
    WHERE er.employeeId=NEW.managerId AND r.roleName='Grape Farmer'
      AND er.startDateTime<=NOW() AND (er.endDateTime IS NULL OR er.endDateTime>NOW())
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Vineyard manager must have an active Grape Farmer role';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM address a WHERE a.addressId=NEW.addressId AND a.addressKind='PHYSICAL') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Vineyard address must be physical';
  END IF;
END$$

-- Shipment is the operational finalisation point for a customer order.
CREATE TRIGGER trg_shipment_order_complete_insert
BEFORE INSERT ON shipment
FOR EACH ROW
BEGIN
  DECLARE vReceivedDate DATE;
  SELECT receivedDate INTO vReceivedDate FROM customerorder WHERE customerOrderId=NEW.customerOrderId;
  IF NOT EXISTS (SELECT 1 FROM orderline ol WHERE ol.customerOrderId=NEW.customerOrderId) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Customer order must contain at least one order line before shipment';
  END IF;
  IF NEW.shippedDate < vReceivedDate THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shipment date cannot precede order received date';
  END IF;
END$$

CREATE TRIGGER trg_shipment_order_complete_update
BEFORE UPDATE ON shipment
FOR EACH ROW
BEGIN
  DECLARE vReceivedDate DATE;
  SELECT receivedDate INTO vReceivedDate FROM customerorder WHERE customerOrderId=NEW.customerOrderId;
  IF NOT EXISTS (SELECT 1 FROM orderline ol WHERE ol.customerOrderId=NEW.customerOrderId) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Customer order must contain at least one order line before shipment';
  END IF;
  IF NEW.shippedDate < vReceivedDate THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Shipment date cannot precede order received date';
  END IF;
END$$

CREATE TRIGGER trg_customerorder_shipped_state
BEFORE UPDATE ON customerorder
FOR EACH ROW
BEGIN
  IF NEW.orderStatus='SHIPPED' AND OLD.orderStatus<>'SHIPPED'
     AND NOT EXISTS (SELECT 1 FROM shipment s WHERE s.customerOrderId=NEW.customerOrderId) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Order cannot be marked SHIPPED without a shipment record';
  END IF;
END$$

-- Receipt chronology is checked against the purchase order date.
CREATE TRIGGER trg_receipt_chronology_insert
BEFORE INSERT ON receipt
FOR EACH ROW
BEGIN
  DECLARE vOrderedDate DATE;
  SELECT orderedDate INTO vOrderedDate FROM purchaseorder WHERE purchaseOrderId=NEW.purchaseOrderId;
  IF NEW.receivedDate < vOrderedDate THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Receipt date cannot precede purchase order date';
  END IF;
END$$

CREATE TRIGGER trg_receipt_chronology_update
BEFORE UPDATE ON receipt
FOR EACH ROW
BEGIN
  DECLARE vOrderedDate DATE;
  SELECT orderedDate INTO vOrderedDate FROM purchaseorder WHERE purchaseOrderId=NEW.purchaseOrderId;
  IF NEW.receivedDate < vOrderedDate THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Receipt date cannot precede purchase order date';
  END IF;
END$$

-- Picking-pack rules are cross-row and are therefore validated explicitly at the
-- point a completed pack is approved for operational use.
CREATE PROCEDURE validatePickingPackRules()
BEGIN
  IF EXISTS (
    SELECT pp.pickerPackId
    FROM pickerpack pp
    LEFT JOIN packmember pm ON pm.pickerPackId=pp.pickerPackId
      AND pm.joinedDate<=CURRENT_DATE AND (pm.leftDate IS NULL OR pm.leftDate>CURRENT_DATE)
    GROUP BY pp.pickerPackId
    HAVING COUNT(pm.employeeId)<4
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Every active picking pack must contain at least four current pickers';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pickerpack pp
    LEFT JOIN employeerole er ON er.employeeId=pp.supervisorId
      AND er.startDateTime<=NOW() AND (er.endDateTime IS NULL OR er.endDateTime>NOW())
    LEFT JOIN role r ON r.roleId=er.roleId
    WHERE r.roleName IS NULL OR r.roleName<>'Grape Farmer'
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Picking-pack supervisor must have an active Grape Farmer role';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM packmember pm
    JOIN pickerpack pp ON pp.pickerPackId=pm.pickerPackId
    WHERE pm.joinedDate<=CURRENT_DATE AND (pm.leftDate IS NULL OR pm.leftDate>CURRENT_DATE)
      AND NOT EXISTS (
        SELECT 1 FROM employeerole er JOIN role r ON r.roleId=er.roleId
        WHERE er.employeeId=pm.employeeId AND r.roleName='Seasonal Picker'
          AND er.employmentType='CASUAL' AND er.employmentPattern='SEASONAL'
          AND er.startDateTime<=NOW() AND (er.endDateTime IS NULL OR er.endDateTime>NOW())
      )
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Every current pack member must be an active casual seasonal picker';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM packmember pm
    JOIN pickerpack pp ON pp.pickerPackId=pm.pickerPackId
    WHERE pm.joinedDate<=CURRENT_DATE AND (pm.leftDate IS NULL OR pm.leftDate>CURRENT_DATE)
      AND NOT EXISTS (
        SELECT 1 FROM supervision s
        WHERE s.employeeId=pm.employeeId AND s.supervisorId=pp.supervisorId
          AND s.startDateTime<=NOW() AND (s.endDateTime IS NULL OR s.endDateTime>NOW())
      )
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='All current pack members must report to the pack grape-farmer supervisor';
  END IF;

  IF EXISTS (
    SELECT er.employeeId
    FROM employeerole er JOIN role r ON r.roleId=er.roleId
    WHERE r.roleName='Seasonal Picker'
      AND er.startDateTime<=NOW() AND (er.endDateTime IS NULL OR er.endDateTime>NOW())
      AND NOT EXISTS (
        SELECT 1 FROM packmember pm
        WHERE pm.employeeId=er.employeeId AND pm.joinedDate<=CURRENT_DATE
          AND (pm.leftDate IS NULL OR pm.leftDate>CURRENT_DATE)
      )
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Every active seasonal picker must belong to a current picking pack';
  END IF;

  IF EXISTS (
    SELECT pm.employeeId
    FROM packmember pm
    WHERE pm.joinedDate<=CURRENT_DATE AND (pm.leftDate IS NULL OR pm.leftDate>CURRENT_DATE)
    GROUP BY pm.employeeId HAVING COUNT(*)>1
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='A picker may belong to only one current picking pack';
  END IF;
END$$

DELIMITER ;
