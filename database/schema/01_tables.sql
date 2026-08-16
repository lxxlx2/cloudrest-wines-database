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
  employmentType ENUM('PERMANENT','CASUAL','SEASONAL') NOT NULL,
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
  CONSTRAINT chk_vineyard_area CHECK (areaHectares BETWEEN 2.00 AND 42.00),
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
  addressId CHAR(8) NOT NULL,
  phoneNumber VARCHAR(25) NOT NULL,
  contactFirstName VARCHAR(50) NOT NULL,
  contactLastName VARCHAR(50) NOT NULL,
  contactEmail VARCHAR(254) NOT NULL,
  CONSTRAINT fk_supplier_address FOREIGN KEY (addressId) REFERENCES address(addressId) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_supplier_email CHECK (contactEmail LIKE '%_@_%._%')
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
  CONSTRAINT chk_incident_losthours CHECK (totalLostHours >= 0),
  CONSTRAINT chk_incident_severity CHECK (severity NOT IN ('HIGH','CRITICAL') OR totalLostHours > 0)
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
