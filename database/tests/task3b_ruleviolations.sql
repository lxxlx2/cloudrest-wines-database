USE cloudrestwines;
-- Execute each assessed violation separately after rebuilding the clean database.
-- The cleanup statements make each block safe to repeat for screenshots.

-- =========================================================
-- Rule 1: role end cannot precede start (expect CHECK 3819).
-- =========================================================
DELETE FROM employeerole WHERE employeeId = 'EMP9999';
DELETE FROM employee WHERE employeeId = 'EMP9999';
INSERT INTO employee
(employeeId, firstName, lastName, taxFileNumber, employmentStartDate, employmentEndDate)
VALUES ('EMP9999','Test','InvalidDate','998877665','2026-01-01',NULL);
INSERT INTO employeerole
(employeeId, roleId, operationalAreaId, startDateTime, endDateTime,
 workTimeType, employmentType, employmentPattern)
VALUES
('EMP9999','ROLE07','AREA04','2026-06-01 09:00:00','2026-05-01 09:00:00',
 'PARTTIME','PERMANENT','ONGOING');

-- =========================================================
-- Rule 2: reorder FALSE requires a nonblank comment (expect CHECK 3819).
-- =========================================================
DELETE FROM bottletype WHERE bottleTypeId = 'BOTL099';
INSERT INTO bottletype
(bottleTypeId, capacityMl, bottleShape, material, bottleColour,
 inventoryQuantity, usualUnitCost, reorderFlag, reorderComment)
VALUES ('BOTL099',750,'Test','GLASS','Green',0,1.00,FALSE,NULL);

-- =========================================================
-- Rule 3: shipment must use the customer's current physical address (expect Error 1644).
-- =========================================================
DELETE FROM shipment WHERE shipmentId = 'SHIP0999';
INSERT INTO shipment
(shipmentId, customerOrderId, addressId, shippedDate)
VALUES ('SHIP0999','CORD0001','ADDR0004',CURRENT_DATE);

-- =========================================================
-- Rule 4: order must be paid before shipment (expect Error 1644).
-- =========================================================
DELETE FROM shipment WHERE shipmentId = 'SHIP0998';
DELETE FROM customerorder WHERE customerOrderId = 'CORD0998';
INSERT INTO customerorder
(customerOrderId, customerId, orderDate, paidFlag, orderStatus)
VALUES ('CORD0998','CUST001',CURRENT_DATE,FALSE,'PENDING');
INSERT INTO shipment
(shipmentId, customerOrderId, addressId, shippedDate)
VALUES ('SHIP0998','CORD0998','ADDR0003',CURRENT_DATE);

-- =========================================================
-- Rule 5: supervised employee has only one supervisor at a point in time (expect Error 1644).
-- =========================================================
DELETE FROM supervision
WHERE employeeId='EMP0008' AND supervisorId='EMP0001'
  AND startDateTime='2026-02-01 09:00:00';
INSERT INTO supervision
(employeeId, supervisorId, startDateTime, endDateTime)
VALUES ('EMP0008','EMP0001','2026-02-01 09:00:00',NULL);
