-- Cloudrest Wines Database — portable MySQL 8.x build
-- Team: Mia, Zora, Rianna, 1
-- Perspective: Human Resources, Workforce Planning and Wellbeing
-- Open this file in MySQL Workbench and execute the full script.
-- All data is fictitious and intended only for assessment/testing.


-- ===== BEGIN database/schema/01_tables.sql =====
DROP DATABASE IF EXISTS cloudrestwines;
CREATE DATABASE cloudrestwines CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE cloudrestwines;

CREATE TABLE operationalarea (
  operationalAreaId CHAR(6) PRIMARY KEY,
  areaName VARCHAR(60) NOT NULL UNIQUE,
  areaDescription VARCHAR(255) NULL
);

CREATE TABLE role (
  roleId CHAR(6) PRIMARY KEY,
  roleName VARCHAR(80) NOT NULL UNIQUE,
  roleDescription VARCHAR(255) NOT NULL
);

CREATE TABLE employee (
  employeeId CHAR(7) PRIMARY KEY,
  firstName VARCHAR(50) NOT NULL,
  lastName VARCHAR(50) NOT NULL,
  taxFileNumber CHAR(9) NOT NULL UNIQUE,
  employmentStartDate DATE NOT NULL,
  employmentEndDate DATE NULL,
  CONSTRAINT chk_employee_dates CHECK (employmentEndDate IS NULL OR employmentEndDate >= employmentStartDate),
  CONSTRAINT chk_employee_tfn CHECK (taxFileNumber REGEXP '^[0-9]{9}$')
);

CREATE TABLE employeerole (
  employeeId CHAR(7) NOT NULL,
  roleId CHAR(6) NOT NULL,
  operationalAreaId CHAR(6) NOT NULL,
  startDateTime DATETIME NOT NULL,
  endDateTime DATETIME NULL,
  workTimeType ENUM('FULLTIME','PARTTIME') NOT NULL,
  employmentType ENUM('PERMANENT','CASUAL') NOT NULL,
  employmentPattern ENUM('ONGOING','SEASONAL') NOT NULL,
  PRIMARY KEY (employeeId, roleId, startDateTime),
  CONSTRAINT fk_employeerole_employee FOREIGN KEY (employeeId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_employeerole_role FOREIGN KEY (roleId) REFERENCES role(roleId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_employeerole_area FOREIGN KEY (operationalAreaId) REFERENCES operationalarea(operationalAreaId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_employeerole_dates CHECK (endDateTime IS NULL OR endDateTime >= startDateTime)
);

CREATE TABLE supervision (
  employeeId CHAR(7) NOT NULL,
  supervisorId CHAR(7) NOT NULL,
  startDateTime DATETIME NOT NULL,
  endDateTime DATETIME NULL,
  PRIMARY KEY (employeeId, startDateTime),
  CONSTRAINT fk_supervision_employee FOREIGN KEY (employeeId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_supervision_supervisor FOREIGN KEY (supervisorId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_supervision_dates CHECK (endDateTime IS NULL OR endDateTime >= startDateTime)
);

CREATE TABLE phone (
  phoneId CHAR(8) PRIMARY KEY,
  countryCode VARCHAR(4) NOT NULL DEFAULT '+61',
  phoneNumber VARCHAR(20) NOT NULL,
  phoneType ENUM('MOBILE','WORK','HOME','OTHER') NOT NULL,
  UNIQUE (countryCode, phoneNumber)
);

CREATE TABLE employeephone (
  employeeId CHAR(7) NOT NULL,
  phoneId CHAR(8) NOT NULL,
  startDateTime DATETIME NOT NULL,
  endDateTime DATETIME NULL,
  isPrimary BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (employeeId, phoneId, startDateTime),
  CONSTRAINT fk_employeephone_employee FOREIGN KEY (employeeId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_employeephone_phone FOREIGN KEY (phoneId) REFERENCES phone(phoneId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_employeephone_dates CHECK (endDateTime IS NULL OR endDateTime >= startDateTime)
);

CREATE TABLE address (
  addressId CHAR(8) PRIMARY KEY,
  addressKind ENUM('PHYSICAL','POSTAL') NOT NULL,
  postalType ENUM('POBOX','PRIVATEBAG','OTHER') NULL,
  unitType VARCHAR(20) NULL,
  unitNumber VARCHAR(12) NULL,
  levelType VARCHAR(20) NULL,
  levelNumber VARCHAR(12) NULL,
  buildingName VARCHAR(100) NULL,
  placeName VARCHAR(100) NULL,
  addressNumber VARCHAR(20) NULL,
  streetName VARCHAR(120) NULL,
  locality VARCHAR(80) NOT NULL,
  stateCode ENUM('ACT','NSW','NT','QLD','SA','TAS','VIC','WA') NOT NULL,
  postcode CHAR(4) NOT NULL,
  CONSTRAINT chk_address_postcode CHECK (postcode REGEXP '^[0-9]{4}$'),
  CONSTRAINT chk_address_kind CHECK (
    (addressKind = 'PHYSICAL' AND postalType IS NULL AND addressNumber IS NOT NULL AND streetName IS NOT NULL)
    OR (addressKind = 'POSTAL')
  )
);

CREATE TABLE employeeaddress (
  employeeId CHAR(7) NOT NULL,
  addressId CHAR(8) NOT NULL,
  startDateTime DATETIME NOT NULL,
  endDateTime DATETIME NULL,
  PRIMARY KEY (employeeId, addressId, startDateTime),
  CONSTRAINT fk_employeeaddress_employee FOREIGN KEY (employeeId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_employeeaddress_address FOREIGN KEY (addressId) REFERENCES address(addressId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_employeeaddress_dates CHECK (endDateTime IS NULL OR endDateTime >= startDateTime)
);

CREATE TABLE pickerpack (
  pickerPackId CHAR(7) PRIMARY KEY,
  packName VARCHAR(60) NOT NULL UNIQUE,
  supervisorId CHAR(7) NOT NULL,
  seasonYear YEAR NOT NULL,
  CONSTRAINT fk_pickerpack_supervisor FOREIGN KEY (supervisorId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE packmember (
  pickerPackId CHAR(7) NOT NULL,
  employeeId CHAR(7) NOT NULL,
  joinedDate DATE NOT NULL,
  leftDate DATE NULL,
  PRIMARY KEY (pickerPackId, employeeId),
  CONSTRAINT fk_packmember_pack FOREIGN KEY (pickerPackId) REFERENCES pickerpack(pickerPackId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_packmember_employee FOREIGN KEY (employeeId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_packmember_dates CHECK (leftDate IS NULL OR leftDate >= joinedDate)
);

CREATE TABLE seasonalrating (
  employeeId CHAR(7) NOT NULL,
  seasonYear YEAR NOT NULL,
  supervisorId CHAR(7) NOT NULL,
  ratingValue TINYINT NOT NULL,
  recommendReemployment BOOLEAN NOT NULL,
  ratingComment VARCHAR(500) NULL,
  PRIMARY KEY (employeeId, seasonYear),
  CONSTRAINT fk_seasonalrating_employee FOREIGN KEY (employeeId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_seasonalrating_supervisor FOREIGN KEY (supervisorId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_seasonalrating_value CHECK (ratingValue BETWEEN 1 AND 5)
);

CREATE TABLE vineyard (
  vineyardId CHAR(7) PRIMARY KEY,
  vineyardName VARCHAR(80) NOT NULL UNIQUE,
  areaHectares DECIMAL(6,2) NOT NULL,
  latitude DECIMAL(9,6) NOT NULL,
  longitude DECIMAL(9,6) NOT NULL,
  managerId CHAR(7) NOT NULL UNIQUE,
  addressId CHAR(8) NOT NULL UNIQUE,
  CONSTRAINT fk_vineyard_manager FOREIGN KEY (managerId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_vineyard_address FOREIGN KEY (addressId) REFERENCES address(addressId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_vineyard_area CHECK (areaHectares > 0),
  CONSTRAINT chk_vineyard_latitude CHECK (latitude BETWEEN -90 AND 90),
  CONSTRAINT chk_vineyard_longitude CHECK (longitude BETWEEN -180 AND 180)
);

CREATE TABLE grapevariety (
  grapeVarietyId CHAR(7) PRIMARY KEY,
  varietyName VARCHAR(80) NOT NULL UNIQUE,
  juiceConversionPercent DECIMAL(5,2) NOT NULL,
  storageContainer ENUM('STAINLESSSTEEL','OAKBARREL','OTHER') NOT NULL,
  agingDays SMALLINT UNSIGNED NOT NULL,
  CONSTRAINT chk_grapevariety_conversion CHECK (juiceConversionPercent > 0 AND juiceConversionPercent <= 100)
);

CREATE TABLE vineyardplanting (
  vineyardId CHAR(7) NOT NULL,
  vintageYear YEAR NOT NULL,
  grapeVarietyId CHAR(7) NOT NULL,
  plantedDate DATE NULL,
  PRIMARY KEY (vineyardId, vintageYear),
  CONSTRAINT fk_planting_vineyard FOREIGN KEY (vineyardId) REFERENCES vineyard(vineyardId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_planting_variety FOREIGN KEY (grapeVarietyId) REFERENCES grapevariety(grapeVarietyId) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE harvest (
  harvestId CHAR(8) PRIMARY KEY,
  vineyardId CHAR(7) NOT NULL,
  vintageYear YEAR NOT NULL,
  harvestedDate DATE NOT NULL,
  weightKg DECIMAL(12,2) NOT NULL,
  ripenessSugarPercent DECIMAL(5,2) NOT NULL,
  CONSTRAINT fk_harvest_planting FOREIGN KEY (vineyardId, vintageYear) REFERENCES vineyardplanting(vineyardId, vintageYear) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_harvest_weight CHECK (weightKg > 0),
  CONSTRAINT chk_harvest_ripeness CHECK (ripenessSugarPercent BETWEEN 0 AND 100)
);

CREATE TABLE winecategory (
  wineCategoryId CHAR(5) PRIMARY KEY,
  categoryName VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE wine (
  wineId CHAR(7) PRIMARY KEY,
  wineName VARCHAR(100) NOT NULL,
  vintageYear YEAR NOT NULL,
  wineCategoryId CHAR(5) NOT NULL,
  alcoholPercent DECIMAL(4,2) NOT NULL,
  winemakerId CHAR(7) NOT NULL,
  UNIQUE (wineName, vintageYear),
  CONSTRAINT fk_wine_category FOREIGN KEY (wineCategoryId) REFERENCES winecategory(wineCategoryId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_wine_winemaker FOREIGN KEY (winemakerId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_wine_alcohol CHECK (alcoholPercent > 0 AND alcoholPercent <= 25)
);

CREATE TABLE winecomposition (
  wineId CHAR(7) NOT NULL,
  grapeVarietyId CHAR(7) NOT NULL,
  proportionPercent DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (wineId, grapeVarietyId),
  CONSTRAINT fk_winecomposition_wine FOREIGN KEY (wineId) REFERENCES wine(wineId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_winecomposition_variety FOREIGN KEY (grapeVarietyId) REFERENCES grapevariety(grapeVarietyId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_winecomposition_proportion CHECK (proportionPercent > 0 AND proportionPercent <= 100)
);

CREATE TABLE medal (
  medalId CHAR(8) PRIMARY KEY,
  wineId CHAR(7) NOT NULL,
  medalType ENUM('BRONZE','SILVER','GOLD','TROPHY') NOT NULL,
  awardYear YEAR NOT NULL,
  awardingOrganisation VARCHAR(120) NOT NULL,
  UNIQUE (wineId, medalType, awardYear, awardingOrganisation),
  CONSTRAINT fk_medal_wine FOREIGN KEY (wineId) REFERENCES wine(wineId) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE bottletype (
  bottleTypeId CHAR(7) PRIMARY KEY,
  capacityMl SMALLINT UNSIGNED NOT NULL,
  bottleShape VARCHAR(40) NOT NULL,
  material ENUM('GLASS','PLASTIC') NOT NULL,
  bottleColour VARCHAR(40) NOT NULL,
  inventoryQuantity INT UNSIGNED NOT NULL DEFAULT 0,
  usualUnitCost DECIMAL(8,2) NOT NULL,
  reorderFlag BOOLEAN NOT NULL DEFAULT TRUE,
  reorderComment VARCHAR(500) NULL,
  CONSTRAINT chk_bottletype_capacity CHECK (capacityMl > 0),
  CONSTRAINT chk_bottletype_cost CHECK (usualUnitCost >= 0),
  CONSTRAINT chk_bottletype_reorder CHECK (reorderFlag = TRUE OR NULLIF(TRIM(reorderComment), '') IS NOT NULL)
);

CREATE TABLE wineproduct (
  productId CHAR(7) PRIMARY KEY,
  wineId CHAR(7) NOT NULL,
  bottleTypeId CHAR(7) NOT NULL,
  caseQuantity SMALLINT UNSIGNED NOT NULL,
  isActive BOOLEAN NOT NULL DEFAULT TRUE,
  UNIQUE (wineId, bottleTypeId, caseQuantity),
  CONSTRAINT fk_product_wine FOREIGN KEY (wineId) REFERENCES wine(wineId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_product_bottle FOREIGN KEY (bottleTypeId) REFERENCES bottletype(bottleTypeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_product_case CHECK (caseQuantity > 0)
);

CREATE TABLE productprice (
  productId CHAR(7) NOT NULL,
  effectiveDate DATE NOT NULL,
  endDate DATE NULL,
  casePrice DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (productId, effectiveDate),
  CONSTRAINT fk_productprice_product FOREIGN KEY (productId) REFERENCES wineproduct(productId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT chk_productprice_dates CHECK (endDate IS NULL OR endDate >= effectiveDate),
  CONSTRAINT chk_productprice_amount CHECK (casePrice > 0)
);

CREATE TABLE supplier (
  supplierId CHAR(7) PRIMARY KEY,
  supplierName VARCHAR(120) NOT NULL UNIQUE,
  contactFirstName VARCHAR(50) NOT NULL,
  contactLastName VARCHAR(50) NOT NULL,
  contactEmail VARCHAR(254) NOT NULL,
  CONSTRAINT chk_supplier_email CHECK (contactEmail LIKE '%_@_%._%')
);

CREATE TABLE supplieraddress (
  supplierId CHAR(7) NOT NULL,
  addressId CHAR(8) NOT NULL,
  startDateTime DATETIME NOT NULL,
  endDateTime DATETIME NULL,
  PRIMARY KEY (supplierId, addressId, startDateTime),
  CONSTRAINT fk_supplieraddress_supplier FOREIGN KEY (supplierId) REFERENCES supplier(supplierId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_supplieraddress_address FOREIGN KEY (addressId) REFERENCES address(addressId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_supplieraddress_dates CHECK (endDateTime IS NULL OR endDateTime >= startDateTime)
);

CREATE TABLE supplierphone (
  supplierId CHAR(7) NOT NULL,
  phoneId CHAR(8) NOT NULL,
  startDateTime DATETIME NOT NULL,
  endDateTime DATETIME NULL,
  isPrimary BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (supplierId, phoneId, startDateTime),
  CONSTRAINT fk_supplierphone_supplier FOREIGN KEY (supplierId) REFERENCES supplier(supplierId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_supplierphone_phone FOREIGN KEY (phoneId) REFERENCES phone(phoneId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_supplierphone_dates CHECK (endDateTime IS NULL OR endDateTime >= startDateTime)
);

CREATE TABLE supplierbottle (
  supplierId CHAR(7) NOT NULL,
  bottleTypeId CHAR(7) NOT NULL,
  supplierBottleCode VARCHAR(40) NULL,
  isAvailable BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (supplierId, bottleTypeId),
  CONSTRAINT fk_supplierbottle_supplier FOREIGN KEY (supplierId) REFERENCES supplier(supplierId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_supplierbottle_bottle FOREIGN KEY (bottleTypeId) REFERENCES bottletype(bottleTypeId) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE purchaseorder (
  purchaseOrderId CHAR(8) PRIMARY KEY,
  supplierId CHAR(7) NOT NULL,
  orderedDate DATE NOT NULL,
  orderStatus ENUM('PLACED','PARTRECEIVED','RECEIVED','CANCELLED') NOT NULL DEFAULT 'PLACED',
  CONSTRAINT fk_purchaseorder_supplier FOREIGN KEY (supplierId) REFERENCES supplier(supplierId) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE purchaseorderline (
  purchaseOrderId CHAR(8) NOT NULL,
  bottleTypeId CHAR(7) NOT NULL,
  orderedQuantity INT UNSIGNED NOT NULL,
  quotedUnitPrice DECIMAL(8,2) NULL,
  PRIMARY KEY (purchaseOrderId, bottleTypeId),
  CONSTRAINT fk_pol_order FOREIGN KEY (purchaseOrderId) REFERENCES purchaseorder(purchaseOrderId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_pol_bottle FOREIGN KEY (bottleTypeId) REFERENCES bottletype(bottleTypeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_pol_quantity CHECK (orderedQuantity > 0),
  CONSTRAINT chk_pol_price CHECK (quotedUnitPrice IS NULL OR quotedUnitPrice >= 0)
);

CREATE TABLE receipt (
  receiptId CHAR(8) PRIMARY KEY,
  purchaseOrderId CHAR(8) NOT NULL,
  receivedDate DATE NOT NULL,
  CONSTRAINT fk_receipt_order FOREIGN KEY (purchaseOrderId) REFERENCES purchaseorder(purchaseOrderId) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE receiptline (
  receiptId CHAR(8) NOT NULL,
  bottleTypeId CHAR(7) NOT NULL,
  receivedQuantity INT UNSIGNED NOT NULL,
  actualUnitPrice DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (receiptId, bottleTypeId),
  CONSTRAINT fk_receiptline_receipt FOREIGN KEY (receiptId) REFERENCES receipt(receiptId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_receiptline_bottle FOREIGN KEY (bottleTypeId) REFERENCES bottletype(bottleTypeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_receiptline_quantity CHECK (receivedQuantity > 0),
  CONSTRAINT chk_receiptline_price CHECK (actualUnitPrice >= 0)
);

CREATE TABLE customer (
  customerId CHAR(7) PRIMARY KEY,
  customerType ENUM('INDIVIDUAL','BUSINESS') NOT NULL,
  emailAddress VARCHAR(254) NOT NULL UNIQUE,
  isActive BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT chk_customer_email CHECK (emailAddress LIKE '%_@_%._%')
);

CREATE TABLE individualcustomer (
  customerId CHAR(7) PRIMARY KEY,
  firstName VARCHAR(50) NOT NULL,
  lastName VARCHAR(50) NOT NULL,
  dateOfBirth DATE NOT NULL,
  CONSTRAINT fk_individual_customer FOREIGN KEY (customerId) REFERENCES customer(customerId) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE businesscustomer (
  customerId CHAR(7) PRIMARY KEY,
  companyName VARCHAR(120) NOT NULL,
  australianBusinessNumber CHAR(11) NOT NULL UNIQUE,
  contactFirstName VARCHAR(50) NOT NULL,
  contactLastName VARCHAR(50) NOT NULL,
  businessType ENUM('RESTAURANT','WINESHOP','EXPORTCOMPANY','OTHER') NOT NULL,
  CONSTRAINT fk_business_customer FOREIGN KEY (customerId) REFERENCES customer(customerId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT chk_business_abn CHECK (australianBusinessNumber REGEXP '^[0-9]{11}$')
);

CREATE TABLE customerphone (
  customerId CHAR(7) NOT NULL,
  phoneId CHAR(8) NOT NULL,
  startDateTime DATETIME NOT NULL,
  endDateTime DATETIME NULL,
  isPrimary BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (customerId, phoneId, startDateTime),
  CONSTRAINT fk_customerphone_customer FOREIGN KEY (customerId) REFERENCES customer(customerId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_customerphone_phone FOREIGN KEY (phoneId) REFERENCES phone(phoneId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_customerphone_dates CHECK (endDateTime IS NULL OR endDateTime >= startDateTime)
);

CREATE TABLE customeraddress (
  customerId CHAR(7) NOT NULL,
  addressId CHAR(8) NOT NULL,
  startDateTime DATETIME NOT NULL,
  endDateTime DATETIME NULL,
  PRIMARY KEY (customerId, addressId, startDateTime),
  CONSTRAINT fk_customeraddress_customer FOREIGN KEY (customerId) REFERENCES customer(customerId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_customeraddress_address FOREIGN KEY (addressId) REFERENCES address(addressId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_customeraddress_dates CHECK (endDateTime IS NULL OR endDateTime >= startDateTime)
);

CREATE TABLE customerorder (
  customerOrderId CHAR(8) PRIMARY KEY,
  customerId CHAR(7) NOT NULL,
  receivedDate DATE NOT NULL,
  paidFlag BOOLEAN NOT NULL DEFAULT FALSE,
  orderStatus ENUM('PENDING','SHIPPED','CANCELLED') NOT NULL DEFAULT 'PENDING',
  CONSTRAINT fk_customerorder_customer FOREIGN KEY (customerId) REFERENCES customer(customerId) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE orderline (
  customerOrderId CHAR(8) NOT NULL,
  productId CHAR(7) NOT NULL,
  caseQuantity INT UNSIGNED NOT NULL,
  agreedCasePrice DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (customerOrderId, productId),
  CONSTRAINT fk_orderline_order FOREIGN KEY (customerOrderId) REFERENCES customerorder(customerOrderId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_orderline_product FOREIGN KEY (productId) REFERENCES wineproduct(productId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_orderline_quantity CHECK (caseQuantity > 0),
  CONSTRAINT chk_orderline_price CHECK (agreedCasePrice > 0)
);

CREATE TABLE shipment (
  shipmentId CHAR(8) PRIMARY KEY,
  customerOrderId CHAR(8) NOT NULL UNIQUE,
  addressId CHAR(8) NOT NULL,
  shippedDate DATE NOT NULL,
  CONSTRAINT fk_shipment_order FOREIGN KEY (customerOrderId) REFERENCES customerorder(customerOrderId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_shipment_address FOREIGN KEY (addressId) REFERENCES address(addressId) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE refund (
  refundId CHAR(8) PRIMARY KEY,
  customerOrderId CHAR(8) NOT NULL,
  refundDate DATE NOT NULL,
  refundReason ENUM('SHORTSUPPLY','TRANSITDAMAGE') NOT NULL,
  verifiedFlag BOOLEAN NOT NULL,
  refundAmount DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_refund_order FOREIGN KEY (customerOrderId) REFERENCES customerorder(customerOrderId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_refund_amount CHECK (refundAmount > 0),
  CONSTRAINT chk_refund_verified CHECK (refundReason <> 'TRANSITDAMAGE' OR verifiedFlag = TRUE)
);

-- HR perspective extension
CREATE TABLE qualification (
  qualificationId CHAR(7) PRIMARY KEY,
  qualificationName VARCHAR(120) NOT NULL UNIQUE,
  issuingAuthority VARCHAR(120) NOT NULL,
  defaultValidityMonths SMALLINT UNSIGNED NULL,
  isSafetyCritical BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE employeequalification (
  employeeId CHAR(7) NOT NULL,
  qualificationId CHAR(7) NOT NULL,
  awardedDate DATE NOT NULL,
  expiryDate DATE NULL,
  certificateReference VARCHAR(80) NULL UNIQUE,
  PRIMARY KEY (employeeId, qualificationId, awardedDate),
  CONSTRAINT fk_employeequalification_employee FOREIGN KEY (employeeId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_employeequalification_qualification FOREIGN KEY (qualificationId) REFERENCES qualification(qualificationId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_employeequalification_dates CHECK (expiryDate IS NULL OR expiryDate >= awardedDate)
);

CREATE TABLE trainingcourse (
  trainingCourseId CHAR(7) PRIMARY KEY,
  courseName VARCHAR(120) NOT NULL UNIQUE,
  courseProvider VARCHAR(120) NOT NULL,
  trainingCategory ENUM('SAFETY','SUSTAINABILITY','TECHNICAL','WELLBEING','OTHER') NOT NULL,
  renewalMonths SMALLINT UNSIGNED NULL,
  isMandatory BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE trainingsession (
  trainingSessionId CHAR(8) PRIMARY KEY,
  trainingCourseId CHAR(7) NOT NULL,
  sessionDate DATE NOT NULL,
  operationalAreaId CHAR(6) NULL,
  trainerName VARCHAR(100) NOT NULL,
  deliveryMode ENUM('INPERSON','ONLINE','BLENDED') NOT NULL,
  CONSTRAINT fk_trainingsession_course FOREIGN KEY (trainingCourseId) REFERENCES trainingcourse(trainingCourseId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_trainingsession_area FOREIGN KEY (operationalAreaId) REFERENCES operationalarea(operationalAreaId) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE trainingattendance (
  trainingSessionId CHAR(8) NOT NULL,
  employeeId CHAR(7) NOT NULL,
  attendanceStatus ENUM('REGISTERED','COMPLETED','FAILED','ABSENT') NOT NULL,
  completionDate DATE NULL,
  renewalDate DATE NULL,
  competencyLevel ENUM('AWARENESS','COMPETENT','ADVANCED') NULL,
  PRIMARY KEY (trainingSessionId, employeeId),
  CONSTRAINT fk_trainingattendance_session FOREIGN KEY (trainingSessionId) REFERENCES trainingsession(trainingSessionId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_trainingattendance_employee FOREIGN KEY (employeeId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_trainingattendance_completion CHECK (
    (attendanceStatus = 'COMPLETED' AND completionDate IS NOT NULL AND competencyLevel IS NOT NULL)
    OR (attendanceStatus <> 'COMPLETED')
  ),
  CONSTRAINT chk_trainingattendance_renewal CHECK (renewalDate IS NULL OR (completionDate IS NOT NULL AND renewalDate >= completionDate))
);

CREATE TABLE taskcategory (
  taskCategoryId CHAR(6) PRIMARY KEY,
  categoryName VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE shift (
  shiftId CHAR(8) PRIMARY KEY,
  shiftDate DATE NOT NULL,
  startTime TIME NOT NULL,
  endTime TIME NOT NULL,
  operationalAreaId CHAR(6) NOT NULL,
  taskCategoryId CHAR(6) NOT NULL,
  supervisorId CHAR(7) NOT NULL,
  CONSTRAINT fk_shift_area FOREIGN KEY (operationalAreaId) REFERENCES operationalarea(operationalAreaId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_shift_task FOREIGN KEY (taskCategoryId) REFERENCES taskcategory(taskCategoryId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_shift_supervisor FOREIGN KEY (supervisorId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_shift_time CHECK (endTime > startTime)
);

CREATE TABLE shiftassignment (
  shiftId CHAR(8) NOT NULL,
  employeeId CHAR(7) NOT NULL,
  regularHours DECIMAL(4,2) NOT NULL,
  overtimeHours DECIMAL(4,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (shiftId, employeeId),
  CONSTRAINT fk_shiftassignment_shift FOREIGN KEY (shiftId) REFERENCES shift(shiftId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_shiftassignment_employee FOREIGN KEY (employeeId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_shiftassignment_hours CHECK (regularHours > 0 AND regularHours <= 16 AND overtimeHours >= 0 AND regularHours + overtimeHours <= 18)
);

CREATE TABLE incident (
  incidentId CHAR(8) PRIMARY KEY,
  incidentDateTime DATETIME NOT NULL,
  operationalAreaId CHAR(6) NOT NULL,
  incidentType ENUM('INJURY','NEARMISS','ILLNESS','EQUIPMENT','ENVIRONMENTAL','OTHER') NOT NULL,
  severity ENUM('LOW','MODERATE','HIGH','CRITICAL') NOT NULL,
  incidentDescription VARCHAR(1000) NOT NULL,
  totalLostHours DECIMAL(7,2) NOT NULL DEFAULT 0,
  reportableFlag BOOLEAN NOT NULL DEFAULT FALSE,
  CONSTRAINT fk_incident_area FOREIGN KEY (operationalAreaId) REFERENCES operationalarea(operationalAreaId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_incident_losthours CHECK (totalLostHours >= 0)
);

CREATE TABLE incidentemployee (
  incidentId CHAR(8) NOT NULL,
  employeeId CHAR(7) NOT NULL,
  involvementRole ENUM('AFFECTED','WITNESS','REPORTER') NOT NULL,
  employeeLostHours DECIMAL(7,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (incidentId, employeeId),
  CONSTRAINT fk_incidentemployee_incident FOREIGN KEY (incidentId) REFERENCES incident(incidentId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_incidentemployee_employee FOREIGN KEY (employeeId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_incidentemployee_hours CHECK (employeeLostHours >= 0)
);

CREATE TABLE correctiveaction (
  correctiveActionId CHAR(8) PRIMARY KEY,
  incidentId CHAR(8) NOT NULL,
  actionDescription VARCHAR(500) NOT NULL,
  responsibleEmployeeId CHAR(7) NOT NULL,
  targetDate DATE NOT NULL,
  completedDate DATE NULL,
  actionStatus ENUM('OPEN','INPROGRESS','COMPLETED','CANCELLED') NOT NULL,
  CONSTRAINT fk_action_incident FOREIGN KEY (incidentId) REFERENCES incident(incidentId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_action_employee FOREIGN KEY (responsibleEmployeeId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_action_completion CHECK (
    (actionStatus = 'COMPLETED' AND completedDate IS NOT NULL)
    OR (actionStatus <> 'COMPLETED' AND completedDate IS NULL)
  )
);

CREATE TABLE wellbeingcheckin (
  wellbeingCheckinId CHAR(8) PRIMARY KEY,
  employeeId CHAR(7) NOT NULL,
  managerId CHAR(7) NOT NULL,
  checkinDate DATE NOT NULL,
  concernRaisedFlag BOOLEAN NOT NULL,
  confidentialNote VARCHAR(1000) NULL,
  CONSTRAINT fk_checkin_employee FOREIGN KEY (employeeId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_checkin_manager FOREIGN KEY (managerId) REFERENCES employee(employeeId) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE wellbeingtopic (
  wellbeingTopicId CHAR(6) PRIMARY KEY,
  topicName VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE checkintopic (
  wellbeingCheckinId CHAR(8) NOT NULL,
  wellbeingTopicId CHAR(6) NOT NULL,
  PRIMARY KEY (wellbeingCheckinId, wellbeingTopicId),
  CONSTRAINT fk_checkintopic_checkin FOREIGN KEY (wellbeingCheckinId) REFERENCES wellbeingcheckin(wellbeingCheckinId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_checkintopic_topic FOREIGN KEY (wellbeingTopicId) REFERENCES wellbeingtopic(wellbeingTopicId) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE wellbeingaction (
  wellbeingActionId CHAR(8) PRIMARY KEY,
  wellbeingCheckinId CHAR(8) NOT NULL,
  actionDescription VARCHAR(500) NOT NULL,
  targetDate DATE NOT NULL,
  completedDate DATE NULL,
  actionStatus ENUM('OPEN','INPROGRESS','COMPLETED','CANCELLED') NOT NULL,
  CONSTRAINT fk_wellbeingaction_checkin FOREIGN KEY (wellbeingCheckinId) REFERENCES wellbeingcheckin(wellbeingCheckinId) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT chk_wellbeingaction_completion CHECK (
    (actionStatus = 'COMPLETED' AND completedDate IS NOT NULL)
    OR (actionStatus <> 'COMPLETED' AND completedDate IS NULL)
  )
);

CREATE INDEX idx_employeerole_current ON employeerole(employeeId, endDateTime, startDateTime);
CREATE INDEX idx_training_date ON trainingsession(sessionDate, trainingCourseId);
CREATE INDEX idx_shift_date_area ON shift(shiftDate, operationalAreaId);
CREATE INDEX idx_incident_date_area ON incident(incidentDateTime, operationalAreaId);
CREATE INDEX idx_action_status_date ON correctiveaction(actionStatus, targetDate);
-- ===== END database/schema/01_tables.sql =====

-- ===== BEGIN database/schema/02_triggers.sql =====
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
-- ===== END database/schema/02_triggers.sql =====

-- ===== BEGIN database/schema/03_reporting.sql =====
USE cloudrestwines;

DROP VIEW IF EXISTS openincidentaction;
CREATE VIEW openincidentaction AS
SELECT
  ca.correctiveActionId,
  i.incidentId,
  i.incidentDateTime,
  i.severity,
  oa.areaName,
  ca.actionDescription,
  ca.targetDate,
  ca.actionStatus,
  CONCAT(e.firstName, ' ', e.lastName) AS responsibleEmployee,
  GREATEST(DATEDIFF(CURRENT_DATE, ca.targetDate), 0) AS daysOverdue
FROM correctiveaction ca
JOIN incident i ON i.incidentId = ca.incidentId
JOIN operationalarea oa ON oa.operationalAreaId = i.operationalAreaId
JOIN employee e ON e.employeeId = ca.responsibleEmployeeId
WHERE ca.actionStatus IN ('OPEN','INPROGRESS');

DROP PROCEDURE IF EXISTS getExpiringQualifications;
DELIMITER $$
CREATE PROCEDURE getExpiringQualifications(IN daysAhead INT)
BEGIN
  IF daysAhead < 0 OR daysAhead > 730 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'daysAhead must be between 0 and 730';
  END IF;

  SELECT
    eq.employeeId,
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
    q.qualificationName,
    q.isSafetyCritical,
    eq.expiryDate,
    DATEDIFF(eq.expiryDate, CURRENT_DATE) AS daysUntilExpiry
  FROM employeequalification eq
  JOIN employee e ON e.employeeId = eq.employeeId
  JOIN qualification q ON q.qualificationId = eq.qualificationId
  WHERE eq.expiryDate BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL daysAhead DAY)
  ORDER BY eq.expiryDate, employeeName;
END$$
DELIMITER ;
-- ===== END database/schema/03_reporting.sql =====

-- ===== BEGIN database/data/01_testdata.sql =====
USE cloudrestwines;

INSERT INTO operationalarea VALUES
('AREA01','Vineyard','Grape growing and harvest'),('AREA02','Cellar','Wine production and bottling'),
('AREA03','Hospitality','Restaurant and visitor service'),('AREA04','Administration','Business administration');

INSERT INTO role VALUES
('ROLE01','Owner','Winery owner'),('ROLE02','Vineyard Supervisor','Supervises vineyard teams'),
('ROLE03','Grape Farmer','Manages vineyards'),('ROLE04','Seasonal Picker','Harvest worker'),
('ROLE05','Winemaker','Responsible for wine production'),('ROLE06','Cellar Hand','Supports production'),
('ROLE07','HR Manager','Manages workforce records'),('ROLE08','Safety Officer','Manages safety programme');

INSERT INTO employee VALUES
('EMP0001','Christine','Cloud','123456789','2020-01-01',NULL),
('EMP0002','Amelia','Hart','234567890','2021-02-01',NULL),
('EMP0003','Noah','Reed','345678901','2022-03-01',NULL),
('EMP0004','Isla','Chen','456789012','2023-01-15',NULL),
('EMP0005','Liam','Singh','567890123','2024-02-01',NULL),
('EMP0006','Ava','Martin','678901234','2024-05-01',NULL),
('EMP0007','Ethan','Brown','789012345','2025-01-05',NULL),
('EMP0008','Mia','Taylor','890123456','2025-01-05',NULL),
('EMP0009','Leo','Wilson','901234567','2025-06-01',NULL),
('EMP0010','Zoe','Davis','112233445','2025-06-01',NULL),
('EMP0011','Jack','Moore','223344556','2025-06-01',NULL),
('EMP0012','Ruby','Thomas','334455667','2025-06-01',NULL),
('EMP0013','Finn','Walker','445566778','2026-01-05',NULL);

INSERT INTO employeerole VALUES
('EMP0001','ROLE01','AREA04','2020-01-01 09:00:00',NULL,'FULLTIME','PERMANENT','ONGOING'),
('EMP0002','ROLE02','AREA01','2021-02-01 09:00:00',NULL,'FULLTIME','PERMANENT','ONGOING'),
('EMP0003','ROLE03','AREA01','2022-03-01 09:00:00',NULL,'FULLTIME','PERMANENT','ONGOING'),
('EMP0004','ROLE05','AREA02','2023-01-15 09:00:00',NULL,'FULLTIME','PERMANENT','ONGOING'),
('EMP0005','ROLE06','AREA02','2024-02-01 09:00:00','2024-12-31 17:00:00','FULLTIME','PERMANENT','ONGOING'),
('EMP0005','ROLE05','AREA02','2025-01-01 09:00:00',NULL,'FULLTIME','PERMANENT','ONGOING'),
('EMP0006','ROLE07','AREA04','2024-05-01 09:00:00',NULL,'FULLTIME','PERMANENT','ONGOING'),
('EMP0007','ROLE08','AREA04','2025-01-05 09:00:00',NULL,'PARTTIME','PERMANENT','ONGOING'),
('EMP0008','ROLE04','AREA01','2025-01-05 09:00:00',NULL,'FULLTIME','CASUAL','SEASONAL'),
('EMP0009','ROLE04','AREA01','2025-06-01 09:00:00',NULL,'FULLTIME','CASUAL','SEASONAL'),
('EMP0010','ROLE04','AREA01','2025-06-01 09:00:00',NULL,'PARTTIME','CASUAL','SEASONAL'),
('EMP0011','ROLE06','AREA02','2025-06-01 09:00:00',NULL,'FULLTIME','CASUAL','ONGOING'),
('EMP0012','ROLE06','AREA02','2025-06-01 09:00:00',NULL,'PARTTIME','CASUAL','ONGOING'),
('EMP0013','ROLE04','AREA01','2026-01-05 09:00:00',NULL,'FULLTIME','CASUAL','SEASONAL');

INSERT INTO supervision VALUES
('EMP0002','EMP0001','2021-02-01 09:00:00',NULL),('EMP0003','EMP0002','2022-03-01 09:00:00',NULL),
('EMP0004','EMP0001','2023-01-15 09:00:00',NULL),('EMP0005','EMP0004','2024-02-01 09:00:00',NULL),
('EMP0006','EMP0001','2024-05-01 09:00:00',NULL),('EMP0007','EMP0001','2025-01-05 09:00:00','2025-12-31 17:00:00'),
('EMP0007','EMP0006','2026-01-01 09:00:00',NULL),
('EMP0008','EMP0002','2025-01-05 09:00:00',NULL),('EMP0009','EMP0002','2025-06-01 09:00:00',NULL),
('EMP0010','EMP0002','2025-06-01 09:00:00',NULL),('EMP0011','EMP0004','2025-06-01 09:00:00',NULL),
('EMP0012','EMP0004','2025-06-01 09:00:00',NULL),('EMP0013','EMP0002','2026-01-05 09:00:00',NULL);

INSERT INTO phone VALUES
('PHON0001','+61','0400000001','MOBILE'),('PHON0002','+61','0400000002','MOBILE'),
('PHON0003','+61','0390000000','WORK'),('PHON0004','+61','0400000013','MOBILE'),
('PHON0005','+61','0400000102','MOBILE'),('PHON0006','+61','0400000101','MOBILE'),
('PHON0007','+61','0400000104','MOBILE'),('PHON0008','+61','0400000105','MOBILE'),
('PHON0009','+61','0400000106','MOBILE'),('PHON0010','+61','0400000107','MOBILE'),
('PHON0011','+61','0400000108','MOBILE'),('PHON0012','+61','0400000109','MOBILE'),
('PHON0013','+61','0400000110','MOBILE'),('PHON0014','+61','0400000111','MOBILE'),
('PHON0015','+61','0400000112','MOBILE'),('PHON0016','+61','0399990000','WORK'),
('PHON0017','+61','0399990001','WORK');
INSERT INTO employeephone VALUES
('EMP0001','PHON0006','2020-01-01 09:00:00',NULL,TRUE),
('EMP0002','PHON0001','2021-02-01 09:00:00','2024-12-31 17:00:00',TRUE),
('EMP0002','PHON0005','2025-01-01 09:00:00',NULL,TRUE),
('EMP0003','PHON0002','2022-03-01 09:00:00',NULL,TRUE),
('EMP0004','PHON0007','2023-01-15 09:00:00',NULL,TRUE),
('EMP0005','PHON0008','2024-02-01 09:00:00',NULL,TRUE),
('EMP0006','PHON0009','2024-05-01 09:00:00',NULL,TRUE),
('EMP0007','PHON0010','2025-01-05 09:00:00',NULL,TRUE),
('EMP0008','PHON0011','2025-01-05 09:00:00',NULL,TRUE),
('EMP0009','PHON0012','2025-06-01 09:00:00',NULL,TRUE),
('EMP0010','PHON0013','2025-06-01 09:00:00',NULL,TRUE),
('EMP0011','PHON0014','2025-06-01 09:00:00',NULL,TRUE),
('EMP0012','PHON0015','2025-06-01 09:00:00',NULL,TRUE),
('EMP0013','PHON0004','2026-01-05 09:00:00',NULL,TRUE);

INSERT INTO address VALUES
('ADDR0001','PHYSICAL',NULL,NULL,NULL,NULL,NULL,'Cloudrest Estate',NULL,'88','Valley Road','Healesville','VIC','3777'),
('ADDR0002','PHYSICAL',NULL,NULL,NULL,NULL,NULL,'Misty View',NULL,'12','Hill Road','Yarra Glen','VIC','3775'),
('ADDR0003','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'10','Main Street','Richmond','VIC','3121'),
('ADDR0004','POSTAL','POBOX',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Richmond','VIC','3121'),
('ADDR0005','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'42','Supply Avenue','Dandenong','VIC','3175'),
('ADDR0006','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'17','Orchard Lane','Healesville','VIC','3777'),
('ADDR0007','PHYSICAL',NULL,'UNIT','2',NULL,NULL,NULL,NULL,'9','Station Street','Lilydale','VIC','3140'),
('ADDR0008','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'21','River Road','Healesville','VIC','3777'),
('ADDR0009','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'31','Oak Street','Healesville','VIC','3777'),
('ADDR0010','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'32','Oak Street','Healesville','VIC','3777'),
('ADDR0011','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'33','Oak Street','Healesville','VIC','3777'),
('ADDR0012','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'34','Oak Street','Healesville','VIC','3777'),
('ADDR0013','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'35','Oak Street','Healesville','VIC','3777'),
('ADDR0014','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'36','Oak Street','Healesville','VIC','3777'),
('ADDR0015','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'37','Oak Street','Healesville','VIC','3777'),
('ADDR0016','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'38','Oak Street','Healesville','VIC','3777'),
('ADDR0017','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'39','Oak Street','Healesville','VIC','3777'),
('ADDR0018','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'40','Oak Street','Healesville','VIC','3777'),
('ADDR0019','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'41','Oak Street','Healesville','VIC','3777'),
('ADDR0020','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6','Old Supply Road','Dandenong','VIC','3175'),
('ADDR0021','PHYSICAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'88','New Supply Road','Dandenong','VIC','3175');

INSERT INTO employeeaddress VALUES
('EMP0001','ADDR0009','2020-01-01 09:00:00',NULL),
('EMP0002','ADDR0006','2021-02-01 09:00:00','2024-12-31 17:00:00'),
('EMP0002','ADDR0008','2025-01-01 09:00:00',NULL),
('EMP0003','ADDR0007','2022-03-01 09:00:00',NULL),
('EMP0004','ADDR0010','2023-01-15 09:00:00',NULL),
('EMP0005','ADDR0011','2024-02-01 09:00:00',NULL),
('EMP0006','ADDR0012','2024-05-01 09:00:00',NULL),
('EMP0007','ADDR0013','2025-01-05 09:00:00',NULL),
('EMP0008','ADDR0014','2025-01-05 09:00:00',NULL),
('EMP0009','ADDR0015','2025-06-01 09:00:00',NULL),
('EMP0010','ADDR0016','2025-06-01 09:00:00',NULL),
('EMP0011','ADDR0017','2025-06-01 09:00:00',NULL),
('EMP0012','ADDR0018','2025-06-01 09:00:00',NULL),
('EMP0013','ADDR0006','2026-01-05 09:00:00',NULL);

INSERT INTO pickerpack VALUES ('PACK001','Cloud Chasers','EMP0002',YEAR(CURRENT_DATE));
INSERT INTO packmember VALUES
('PACK001','EMP0008',MAKEDATE(YEAR(CURRENT_DATE),1),NULL),
('PACK001','EMP0009',MAKEDATE(YEAR(CURRENT_DATE),1),NULL),
('PACK001','EMP0010',MAKEDATE(YEAR(CURRENT_DATE),1),NULL),
('PACK001','EMP0013',MAKEDATE(YEAR(CURRENT_DATE),1),NULL);
INSERT INTO seasonalrating VALUES
('EMP0008',YEAR(CURRENT_DATE),'EMP0002',5,TRUE,'Reliable and safety conscious'),
('EMP0009',YEAR(CURRENT_DATE),'EMP0002',3,TRUE,'Re-employ with fatigue controls'),
('EMP0010',YEAR(CURRENT_DATE),'EMP0002',4,TRUE,'Strong team contribution'),
('EMP0013',YEAR(CURRENT_DATE),'EMP0002',4,TRUE,'Good first season performance');

INSERT INTO vineyard VALUES ('VINE001','Misty View',18.50,-37.650100,145.374200,'EMP0003','ADDR0002');
INSERT INTO grapevariety VALUES
('GRAPE01','Pinot Noir',72.50,'OAKBARREL',270),('GRAPE02','Chardonnay',74.00,'STAINLESSSTEEL',180);
INSERT INTO vineyardplanting VALUES ('VINE001',YEAR(CURRENT_DATE),'GRAPE01',MAKEDATE(YEAR(CURRENT_DATE),1));
INSERT INTO harvest VALUES ('HARV0001','VINE001',YEAR(CURRENT_DATE),DATE_SUB(CURRENT_DATE,INTERVAL 120 DAY),14500.00,23.50);
INSERT INTO winecategory VALUES ('CAT01','Dry Red'),('CAT02','Dry White');
INSERT INTO wine VALUES ('WINE001','Cloudrest Pinot',YEAR(CURRENT_DATE),'CAT01',13.50,'EMP0004');
INSERT INTO winecomposition VALUES ('WINE001','GRAPE01',100.00);
INSERT INTO medal VALUES ('MEDL0001','WINE001','GOLD',YEAR(CURRENT_DATE),'Yarra Valley Wine Show');
INSERT INTO bottletype VALUES
('BOTL001',750,'Burgundy','GLASS','Green',5000,1.20,TRUE,NULL),
('BOTL002',750,'Bordeaux','GLASS','Clear',200,1.10,FALSE,'Supplier quality inconsistency documented');
INSERT INTO wineproduct VALUES ('PROD001','WINE001','BOTL001',12,TRUE);
INSERT INTO productprice VALUES ('PROD001',DATE_SUB(CURRENT_DATE,INTERVAL 180 DAY),NULL,360.00);
INSERT INTO supplier VALUES ('SUPP001','Valley Glass Supply','Sam','Lee','sam@valleyglass.example');
INSERT INTO supplieraddress VALUES
('SUPP001','ADDR0020','2020-01-01 09:00:00','2024-12-31 17:00:00'),
('SUPP001','ADDR0021','2025-01-01 09:00:00',NULL);
INSERT INTO supplierphone VALUES
('SUPP001','PHON0016','2020-01-01 09:00:00','2024-12-31 17:00:00',TRUE),
('SUPP001','PHON0017','2025-01-01 09:00:00',NULL,TRUE);
INSERT INTO supplierbottle VALUES ('SUPP001','BOTL001','VG-750-BURG',TRUE);
INSERT INTO purchaseorder VALUES ('PURC0001','SUPP001',DATE_SUB(CURRENT_DATE,INTERVAL 90 DAY),'RECEIVED');
INSERT INTO purchaseorderline VALUES ('PURC0001','BOTL001',2000,1.15);
INSERT INTO receipt VALUES ('RECP0001','PURC0001',DATE_SUB(CURRENT_DATE,INTERVAL 80 DAY));
INSERT INTO receiptline VALUES ('RECP0001','BOTL001',2000,1.16);

INSERT INTO customer VALUES
('CUST001','INDIVIDUAL','alex@example.test',TRUE),('CUST002','BUSINESS','orders@restaurant.example',TRUE);
INSERT INTO individualcustomer VALUES ('CUST001','Alex','Green','1990-06-01');
INSERT INTO businesscustomer VALUES ('CUST002','Yarra Table Pty Ltd','12345678901','Grace','King','RESTAURANT');
INSERT INTO customeraddress VALUES
('CUST001','ADDR0003','2025-01-01 00:00:00',NULL),('CUST001','ADDR0004','2025-01-01 00:00:00',NULL),
('CUST002','ADDR0001','2025-01-01 00:00:00',NULL);
INSERT INTO customerphone VALUES
('CUST001','PHON0003','2025-01-01 00:00:00',NULL,TRUE);
INSERT INTO customerorder VALUES ('CORD0001','CUST001',DATE_SUB(CURRENT_DATE,INTERVAL 10 DAY),TRUE,'PENDING');
INSERT INTO orderline VALUES ('CORD0001','PROD001',2,360.00);
INSERT INTO shipment VALUES ('SHIP0001','CORD0001','ADDR0003',DATE_SUB(CURRENT_DATE,INTERVAL 8 DAY));

INSERT INTO qualification VALUES
('QUAL001','First Aid Certificate','Australian Red Cross',36,TRUE),
('QUAL002','Chemical Handling Permit','Agriculture Victoria',24,TRUE),
('QUAL003','Responsible Service of Alcohol','Victorian Government',36,FALSE);
INSERT INTO employeequalification VALUES
('EMP0002','QUAL001',DATE_SUB(CURRENT_DATE,INTERVAL 1000 DAY),DATE_ADD(CURRENT_DATE,INTERVAL 25 DAY),'CERT-FA-2002'),
('EMP0003','QUAL002',DATE_SUB(CURRENT_DATE,INTERVAL 700 DAY),DATE_ADD(CURRENT_DATE,INTERVAL 80 DAY),'CERT-CH-3003'),
('EMP0006','QUAL001',DATE_SUB(CURRENT_DATE,INTERVAL 900 DAY),DATE_ADD(CURRENT_DATE,INTERVAL 150 DAY),'CERT-FA-6006');

INSERT INTO trainingcourse VALUES
('TRCR001','Annual Winery Safety','SafeWork Training','SAFETY',12,TRUE),
('TRCR002','Sustainable Vineyard Practices','Wine Sustainability Institute','SUSTAINABILITY',12,TRUE),
('TRCR003','Mental Health Awareness','Wellbeing Victoria','WELLBEING',24,FALSE);
INSERT INTO trainingsession VALUES
('TRSE0001','TRCR001',DATE_SUB(CURRENT_DATE,INTERVAL 100 DAY),'AREA01','Morgan Hale','INPERSON'),
('TRSE0002','TRCR002',DATE_SUB(CURRENT_DATE,INTERVAL 90 DAY),'AREA01','Avery Stone','BLENDED'),
('TRSE0003','TRCR001',DATE_SUB(CURRENT_DATE,INTERVAL 70 DAY),'AREA02','Morgan Hale','INPERSON'),
('TRSE0004','TRCR003',DATE_SUB(CURRENT_DATE,INTERVAL 60 DAY),NULL,'Jamie Cole','ONLINE');
INSERT INTO trainingattendance VALUES
('TRSE0001','EMP0002','COMPLETED',DATE_SUB(CURRENT_DATE,INTERVAL 100 DAY),DATE_ADD(CURRENT_DATE,INTERVAL 265 DAY),'ADVANCED'),
('TRSE0001','EMP0003','COMPLETED',DATE_SUB(CURRENT_DATE,INTERVAL 100 DAY),DATE_ADD(CURRENT_DATE,INTERVAL 265 DAY),'COMPETENT'),
('TRSE0001','EMP0008','COMPLETED',DATE_SUB(CURRENT_DATE,INTERVAL 100 DAY),DATE_ADD(CURRENT_DATE,INTERVAL 265 DAY),'COMPETENT'),
('TRSE0001','EMP0009','ABSENT',NULL,NULL,NULL),
('TRSE0002','EMP0002','COMPLETED',DATE_SUB(CURRENT_DATE,INTERVAL 90 DAY),DATE_ADD(CURRENT_DATE,INTERVAL 275 DAY),'ADVANCED'),
('TRSE0002','EMP0003','COMPLETED',DATE_SUB(CURRENT_DATE,INTERVAL 90 DAY),DATE_ADD(CURRENT_DATE,INTERVAL 275 DAY),'COMPETENT'),
('TRSE0002','EMP0008','COMPLETED',DATE_SUB(CURRENT_DATE,INTERVAL 90 DAY),DATE_ADD(CURRENT_DATE,INTERVAL 275 DAY),'COMPETENT'),
('TRSE0003','EMP0004','COMPLETED',DATE_SUB(CURRENT_DATE,INTERVAL 70 DAY),DATE_ADD(CURRENT_DATE,INTERVAL 295 DAY),'ADVANCED'),
('TRSE0003','EMP0005','COMPLETED',DATE_SUB(CURRENT_DATE,INTERVAL 70 DAY),DATE_ADD(CURRENT_DATE,INTERVAL 295 DAY),'COMPETENT'),
('TRSE0003','EMP0011','FAILED',NULL,NULL,NULL),
('TRSE0004','EMP0006','COMPLETED',DATE_SUB(CURRENT_DATE,INTERVAL 60 DAY),DATE_ADD(CURRENT_DATE,INTERVAL 670 DAY),'COMPETENT');

INSERT INTO taskcategory VALUES
('TASK01','Harvest'),('TASK02','Bottling'),('TASK03','Cellar operations'),('TASK04','Administration');
INSERT INTO shift VALUES
('SHFT0001',DATE_SUB(CURRENT_DATE,INTERVAL 25 DAY),'06:00:00','14:00:00','AREA01','TASK01','EMP0002'),
('SHFT0002',DATE_SUB(CURRENT_DATE,INTERVAL 18 DAY),'06:00:00','14:00:00','AREA01','TASK01','EMP0002'),
('SHFT0003',DATE_SUB(CURRENT_DATE,INTERVAL 12 DAY),'07:00:00','15:00:00','AREA02','TASK02','EMP0004'),
('SHFT0004',DATE_SUB(CURRENT_DATE,INTERVAL 5 DAY),'07:00:00','15:00:00','AREA02','TASK03','EMP0004'),
('SHFT0005',DATE_SUB(CURRENT_DATE,INTERVAL 200 DAY),'06:00:00','14:00:00','AREA01','TASK01','EMP0002');
INSERT INTO shiftassignment VALUES
('SHFT0001','EMP0008',8,2),('SHFT0001','EMP0009',8,3),('SHFT0001','EMP0010',6,1),
('SHFT0001','EMP0013',8,1),
('SHFT0002','EMP0008',8,1),('SHFT0002','EMP0009',8,4),('SHFT0002','EMP0010',6,0),
('SHFT0002','EMP0013',8,0),
('SHFT0003','EMP0005',8,2),('SHFT0003','EMP0011',8,3),('SHFT0003','EMP0012',6,0),
('SHFT0004','EMP0005',8,1),('SHFT0004','EMP0011',8,4),('SHFT0004','EMP0012',6,0),
('SHFT0005','EMP0008',8,0),('SHFT0005','EMP0009',8,0);

INSERT INTO incident VALUES
('INCD0001',DATE_SUB(NOW(),INTERVAL 20 DAY),'AREA01','NEARMISS','LOW','Slip hazard identified during harvest',0,FALSE),
('INCD0002',DATE_SUB(NOW(),INTERVAL 10 DAY),'AREA02','INJURY','HIGH','Manual handling injury during bottling',16,TRUE),
('INCD0003',DATE_SUB(NOW(),INTERVAL 190 DAY),'AREA01','INJURY','MODERATE','Minor hand injury before annual training',2,FALSE);
INSERT INTO incidentemployee VALUES
('INCD0001','EMP0009','REPORTER',0),('INCD0002','EMP0011','AFFECTED',16),('INCD0003','EMP0008','AFFECTED',2);
INSERT INTO correctiveaction VALUES
('ACTN0001','INCD0001','Install anti-slip surface and revise harvest briefing','EMP0007',DATE_SUB(CURRENT_DATE,INTERVAL 5 DAY),NULL,'INPROGRESS'),
('ACTN0002','INCD0002','Introduce mechanical lifting aid and refresher training','EMP0007',DATE_ADD(CURRENT_DATE,INTERVAL 14 DAY),NULL,'OPEN'),
('ACTN0003','INCD0003','Issue cut-resistant gloves','EMP0002',DATE_SUB(CURRENT_DATE,INTERVAL 170 DAY),DATE_SUB(CURRENT_DATE,INTERVAL 175 DAY),'COMPLETED');

INSERT INTO wellbeingtopic VALUES ('WTOP01','Workload'),('WTOP02','Fatigue'),('WTOP03','Team support');
INSERT INTO wellbeingcheckin VALUES
('WBCK0001','EMP0009','EMP0002',DATE_SUB(CURRENT_DATE,INTERVAL 8 DAY),TRUE,'Employee reported harvest fatigue; restricted HR access'),
('WBCK0002','EMP0011','EMP0004',DATE_SUB(CURRENT_DATE,INTERVAL 6 DAY),TRUE,'Follow-up after incident; restricted HR access');
INSERT INTO checkintopic VALUES ('WBCK0001','WTOP02'),('WBCK0001','WTOP01'),('WBCK0002','WTOP03');
INSERT INTO wellbeingaction VALUES
('WACT0001','WBCK0001','Review next fortnight roster and overtime allocation',DATE_ADD(CURRENT_DATE,INTERVAL 3 DAY),NULL,'INPROGRESS'),
('WACT0002','WBCK0002','Schedule supported return-to-work discussion',DATE_ADD(CURRENT_DATE,INTERVAL 5 DAY),NULL,'OPEN');
-- ===== END database/data/01_testdata.sql =====

-- ===== SIX DECISION-SUPPORT QUERIES =====
USE cloudrestwines;
-- Management question: Which operational areas have gaps in annual mandatory safety/sustainability training?
WITH activeworkforce AS (
  SELECT er.employeeId, er.operationalAreaId
  FROM employeerole er
  WHERE er.startDateTime <= NOW() AND (er.endDateTime IS NULL OR er.endDateTime > NOW())
), completion AS (
  SELECT ta.employeeId
  FROM trainingattendance ta
  JOIN trainingsession ts ON ts.trainingSessionId = ta.trainingSessionId
  JOIN trainingcourse tc ON tc.trainingCourseId = ts.trainingCourseId
  JOIN activeworkforce aw ON aw.employeeId = ta.employeeId
  WHERE ta.attendanceStatus = 'COMPLETED'
    AND tc.trainingCategory IN ('SAFETY','SUSTAINABILITY')
    AND ts.sessionDate >= MAKEDATE(YEAR(CURRENT_DATE), 1)
    AND (ts.operationalAreaId IS NULL OR ts.operationalAreaId = aw.operationalAreaId)
  GROUP BY ta.employeeId
  HAVING COUNT(DISTINCT tc.trainingCategory) = 2
)
SELECT oa.areaName,
       COUNT(DISTINCT aw.employeeId) AS activeEmployees,
       COUNT(DISTINCT c.employeeId) AS employeesTrained,
       ROUND(100.0 * COUNT(DISTINCT c.employeeId) / NULLIF(COUNT(DISTINCT aw.employeeId),0), 1) AS coveragePercent
FROM activeworkforce aw
JOIN operationalarea oa ON oa.operationalAreaId = aw.operationalAreaId
LEFT JOIN completion c ON c.employeeId = aw.employeeId
GROUP BY oa.operationalAreaId, oa.areaName
ORDER BY coveragePercent, oa.areaName;
USE cloudrestwines;
-- Sustainability measure: incidents per 1,000 labour hours during the last 12 months.
WITH hoursbyarea AS (
  SELECT s.operationalAreaId, SUM(sa.regularHours + sa.overtimeHours) AS labourHours
  FROM shift s JOIN shiftassignment sa ON sa.shiftId = s.shiftId
  WHERE s.shiftDate >= DATE_SUB(CURRENT_DATE, INTERVAL 12 MONTH)
  GROUP BY s.operationalAreaId
), incidentsbyarea AS (
  SELECT operationalAreaId, COUNT(*) AS incidentCount, SUM(totalLostHours) AS lostHours
  FROM incident
  WHERE incidentDateTime >= DATE_SUB(CURRENT_DATE, INTERVAL 12 MONTH)
  GROUP BY operationalAreaId
)
SELECT oa.areaName, h.labourHours, COALESCE(i.incidentCount,0) AS incidentCount,
       COALESCE(i.lostHours,0) AS lostHours,
       ROUND(COALESCE(i.incidentCount,0) * 1000.0 / NULLIF(h.labourHours,0), 2) AS incidentsPer1000Hours
FROM hoursbyarea h
JOIN operationalarea oa ON oa.operationalAreaId = h.operationalAreaId
LEFT JOIN incidentsbyarea i ON i.operationalAreaId = h.operationalAreaId
ORDER BY incidentsPer1000Hours DESC;
USE cloudrestwines;
-- Compare employee incidents in the 180 days before and after completed annual safety training.
WITH completion AS (
  SELECT ta.employeeId, MIN(ta.completionDate) AS completionDate
  FROM trainingattendance ta
  JOIN trainingsession ts ON ts.trainingSessionId = ta.trainingSessionId
  JOIN trainingcourse tc ON tc.trainingCourseId = ts.trainingCourseId
  WHERE ta.attendanceStatus = 'COMPLETED' AND tc.trainingCategory = 'SAFETY'
  GROUP BY ta.employeeId
)
SELECT c.employeeId, CONCAT(e.firstName,' ',e.lastName) AS employeeName, c.completionDate,
       SUM(CASE WHEN i.incidentDateTime >= DATE_SUB(c.completionDate, INTERVAL 180 DAY)
                 AND i.incidentDateTime < c.completionDate THEN 1 ELSE 0 END) AS incidentsBefore,
       SUM(CASE WHEN i.incidentDateTime >= c.completionDate
                 AND i.incidentDateTime < DATE_ADD(c.completionDate, INTERVAL 180 DAY) THEN 1 ELSE 0 END) AS incidentsAfter
FROM completion c
JOIN employee e ON e.employeeId = c.employeeId
LEFT JOIN incidentemployee ie ON ie.employeeId = c.employeeId AND ie.involvementRole = 'AFFECTED'
LEFT JOIN incident i ON i.incidentId = ie.incidentId
GROUP BY c.employeeId, e.firstName, e.lastName, c.completionDate
ORDER BY incidentsBefore DESC, incidentsAfter DESC;
USE cloudrestwines;
-- Identify people for supervisor review without exposing confidential wellbeing notes.
WITH workload AS (
  SELECT sa.employeeId, SUM(sa.regularHours) AS regularHours, SUM(sa.overtimeHours) AS overtimeHours
  FROM shiftassignment sa JOIN shift s ON s.shiftId = sa.shiftId
  WHERE s.shiftDate >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
  GROUP BY sa.employeeId
), recentincident AS (
  SELECT ie.employeeId, COUNT(DISTINCT ie.incidentId) AS incidentCount
  FROM incidentemployee ie JOIN incident i ON i.incidentId = ie.incidentId
  WHERE i.incidentDateTime >= DATE_SUB(NOW(), INTERVAL 30 DAY)
  GROUP BY ie.employeeId
), recentconcern AS (
  SELECT employeeId, COUNT(*) AS concernCount
  FROM wellbeingcheckin
  WHERE checkinDate >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) AND concernRaisedFlag = TRUE
  GROUP BY employeeId
)
SELECT w.employeeId, CONCAT(e.firstName,' ',e.lastName) AS employeeName,
       w.regularHours, w.overtimeHours, COALESCE(ri.incidentCount,0) AS recentIncidents,
       COALESCE(rc.concernCount,0) AS wellbeingConcernCount,
       CASE WHEN w.overtimeHours >= 4 OR ri.incidentCount > 0 OR rc.concernCount > 0 THEN 'SUPERVISOR REVIEW' ELSE 'MONITOR' END AS recommendedAction
FROM workload w
JOIN employee e ON e.employeeId = w.employeeId
LEFT JOIN recentincident ri ON ri.employeeId = w.employeeId
LEFT JOIN recentconcern rc ON rc.employeeId = w.employeeId
ORDER BY (w.overtimeHours + COALESCE(ri.incidentCount,0) * 5 + COALESCE(rc.concernCount,0) * 5) DESC;
USE cloudrestwines;
-- Video demonstration must call both parameter values.
CALL getExpiringQualifications(30);
CALL getExpiringQualifications(90);
USE cloudrestwines;
-- View-based management query: prioritise overdue and high-severity corrective actions.
SELECT correctiveActionId, incidentId, incidentDateTime, severity, areaName,
       actionDescription, responsibleEmployee, targetDate, daysOverdue, actionStatus
FROM openincidentaction
ORDER BY (daysOverdue > 0) DESC,
         FIELD(severity,'CRITICAL','HIGH','MODERATE','LOW'),
         daysOverdue DESC, targetDate;

EXPLAIN
SELECT correctiveActionId, incidentId, incidentDateTime, severity, areaName,
       actionDescription, responsibleEmployee, targetDate, daysOverdue, actionStatus
FROM openincidentaction
ORDER BY (daysOverdue > 0) DESC,
         FIELD(severity,'CRITICAL','HIGH','MODERATE','LOW'),
         daysOverdue DESC, targetDate;

-- Import verification summary
SELECT COUNT(*) AS baseTableCount
FROM information_schema.tables
WHERE table_schema='cloudrestwines' AND table_type='BASE TABLE';
SELECT COUNT(*) AS viewCount
FROM information_schema.views WHERE table_schema='cloudrestwines';
SELECT COUNT(*) AS triggerCount
FROM information_schema.triggers WHERE trigger_schema='cloudrestwines';
SELECT COUNT(*) AS routineCount
FROM information_schema.routines WHERE routine_schema='cloudrestwines';
