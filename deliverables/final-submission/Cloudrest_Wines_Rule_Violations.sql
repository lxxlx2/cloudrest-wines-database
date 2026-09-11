USE cloudrestwines;

-- Run each assessed rule separately for Workbench evidence.
-- Each block starts by rolling back any unfinished prior test, then opens a new transaction.
-- After capturing the expected error, execute the ROLLBACK immediately below that block.
-- This keeps the clean baseline unchanged between screenshots.

-- =========================================================
-- Rule 1: role end cannot precede start
-- Expected: Error 3819 naming chk_employeerole_dates
-- =========================================================
ROLLBACK;
START TRANSACTION;
INSERT INTO employee
(employeeId, firstName, lastName, taxFileNumber, employmentStartDate, employmentEndDate)
VALUES
('EMP9999', 'Rule', 'Test', '998877665', '2026-01-01', NULL);

INSERT INTO employeerole
(employeeId, roleId, operationalAreaId, startDateTime, endDateTime,
 workTimeType, employmentType, employmentPattern)
VALUES
('EMP9999', 'ROLE07', 'AREA04', '2026-06-01 09:00:00', '2026-05-01 09:00:00',
 'PARTTIME', 'PERMANENT', 'ONGOING');
-- After screenshot, run this line alone:
ROLLBACK;

-- =========================================================
-- Rule 2: reorder FALSE requires a nonblank comment
-- Expected: Error 3819 naming chk_bottletype_reorder
-- =========================================================
ROLLBACK;
START TRANSACTION;
INSERT INTO bottletype
(bottleTypeId, capacityMl, bottleShape, material, bottleColour,
 inventoryQuantity, usualUnitCost, reorderFlag, reorderComment)
VALUES
('BOTL099', 750, 'Test', 'GLASS', 'Green', 0, 1.00, FALSE, NULL);
-- After screenshot, run this line alone:
ROLLBACK;

-- =========================================================
-- Rule 3: shipment must use the customer's current physical address
-- Expected: Error 1644 with the physical-address message
-- =========================================================
ROLLBACK;
START TRANSACTION;
INSERT INTO shipment
(shipmentId, customerOrderId, addressId, shippedDate)
VALUES
('SHIP0999', 'CORD0001', 'ADDR0004', CURRENT_DATE);
-- After screenshot, run this line alone:
ROLLBACK;

-- =========================================================
-- Rule 4: order must be paid before shipment
-- Expected: Error 1644, Order must be paid before shipment
-- =========================================================
ROLLBACK;
START TRANSACTION;
INSERT INTO customerorder
(customerOrderId, customerId, receivedDate, paidFlag, orderStatus)
VALUES
('CORD0998', 'CUST001', CURRENT_DATE, FALSE, 'PENDING');

INSERT INTO shipment
(shipmentId, customerOrderId, addressId, shippedDate)
VALUES
('SHIP0998', 'CORD0998', 'ADDR0003', CURRENT_DATE);
-- After screenshot, run this line alone:
ROLLBACK;

-- =========================================================
-- Rule 5: supervised employee has only one supervisor at a point in time
-- Expected: Error 1644 with the overlapping-supervision message
-- =========================================================
ROLLBACK;
START TRANSACTION;
INSERT INTO supervision
(employeeId, supervisorId, startDateTime, endDateTime)
VALUES
('EMP0008', 'EMP0001', '2026-02-01 09:00:00', NULL);
-- After screenshot, run this line alone:
ROLLBACK;
