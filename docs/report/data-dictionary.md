# Cloudrest Wines Data Dictionary

Generated from the validated MySQL 8.4 schema. Domain details and cross-row rules remain authoritative in the SQL build.

## `address`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| addressId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a address record. |
| addressKind | enum('PHYSICAL','POSTAL') | enum('PHYSICAL','POSTAL') | NO | N | N | — | Business attribute `addressKind` for the `address` record. |
| postalType | enum('POBOX','PRIVATEBAG','OTHER') | enum('POBOX','PRIVATEBAG','OTHER') | YES | N | N | — | Business attribute `postalType` for the `address` record. |
| unitType | varchar(20) | See schema constraints | YES | N | N | — | Business attribute `unitType` for the `address` record. |
| unitNumber | varchar(12) | See schema constraints | YES | N | N | — | Business attribute `unitNumber` for the `address` record. |
| levelType | varchar(20) | See schema constraints | YES | N | N | — | Business attribute `levelType` for the `address` record. |
| levelNumber | varchar(12) | See schema constraints | YES | N | N | — | Business attribute `levelNumber` for the `address` record. |
| buildingName | varchar(100) | See schema constraints | YES | N | N | — | Human-readable name used for the address record. |
| placeName | varchar(100) | See schema constraints | YES | N | N | — | Human-readable name used for the address record. |
| addressNumber | varchar(20) | See schema constraints | YES | N | N | — | Business attribute `addressNumber` for the `address` record. |
| streetName | varchar(120) | See schema constraints | YES | N | N | — | Human-readable name used for the address record. |
| locality | varchar(80) | See schema constraints | NO | N | N | — | Business attribute `locality` for the `address` record. |
| stateCode | enum('ACT','NSW','NT','QLD','SA','TAS','VIC','WA') | enum('ACT','NSW','NT','QLD','SA','TAS','VIC','WA') | NO | N | N | — | Business attribute `stateCode` for the `address` record. |
| postcode | char(4) | See schema constraints | NO | N | N | — | Business attribute `postcode` for the `address` record. |

## `bottletype`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| bottleTypeId | char(7) | See schema constraints | NO | Y | Y | — | Stable identifier for a bottletype record. |
| capacityMl | smallint unsigned | See schema constraints | NO | N | N | — | Business attribute `capacityMl` for the `bottletype` record. |
| bottleShape | varchar(40) | See schema constraints | NO | N | N | — | Business attribute `bottleShape` for the `bottletype` record. |
| material | enum('GLASS','PLASTIC') | enum('GLASS','PLASTIC') | NO | N | N | — | Business attribute `material` for the `bottletype` record. |
| bottleColour | varchar(40) | See schema constraints | NO | N | N | — | Business attribute `bottleColour` for the `bottletype` record. |
| inventoryQuantity | int unsigned | 0 | NO | N | N | — | Quantity recorded for the bottletype transaction or inventory fact. |
| usualUnitCost | decimal(8,2) | See schema constraints | NO | N | N | — | Monetary value recorded for the bottletype fact in Australian dollars. |
| reorderFlag | tinyint(1) | 1 | NO | N | N | — | Indicates whether this bottle type may be reordered. |
| reorderComment | varchar(500) | See schema constraints | YES | N | N | — | Required explanation when a bottle type will not be reordered. |

## `businesscustomer`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | See schema constraints | NO | Y | Y | customer.customerId | Identifies the related customer record. |
| companyName | varchar(120) | See schema constraints | NO | N | N | — | Human-readable name used for the businesscustomer record. |
| australianBusinessNumber | char(11) | See schema constraints | NO | Y | N | — | Eleven-digit ABN identifying an Australian business customer. |
| contactFirstName | varchar(50) | See schema constraints | NO | N | N | — | Human-readable name used for the businesscustomer record. |
| contactLastName | varchar(50) | See schema constraints | NO | N | N | — | Human-readable name used for the businesscustomer record. |
| businessType | enum('RESTAURANT','WINESHOP','EXPORTCOMPANY','OTHER') | enum('RESTAURANT','WINESHOP','EXPORTCOMPANY','OTHER') | NO | N | N | — | Business attribute `businessType` for the `businesscustomer` record. |

## `checkintopic`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wellbeingCheckinId | char(8) | See schema constraints | NO | Y | Y | wellbeingcheckin.wellbeingCheckinId | Identifies the related wellbeingcheckin record. |
| wellbeingTopicId | char(6) | See schema constraints | NO | Y | Y | wellbeingtopic.wellbeingTopicId | Identifies the related wellbeingtopic record. |

## `correctiveaction`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| correctiveActionId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a correctiveaction record. |
| incidentId | char(8) | See schema constraints | NO | N | N | incident.incidentId | Identifies the related incident record. |
| actionDescription | varchar(500) | See schema constraints | NO | N | N | — | Business description of the correctiveaction record. |
| responsibleEmployeeId | char(7) | See schema constraints | NO | N | N | employee.employeeId | Identifies the related employee record. |
| targetDate | date | See schema constraints | NO | N | N | — | Date associated with the correctiveaction record or validity period. |
| completedDate | date | See schema constraints | YES | N | N | — | Date associated with the correctiveaction record or validity period. |
| actionStatus | enum('OPEN','INPROGRESS','COMPLETED','CANCELLED') | enum('OPEN','INPROGRESS','COMPLETED','CANCELLED') | NO | N | N | — | Business attribute `actionStatus` for the `correctiveaction` record. |

## `customer`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | See schema constraints | NO | Y | Y | — | Stable identifier for a customer record. |
| customerType | enum('INDIVIDUAL','BUSINESS') | enum('INDIVIDUAL','BUSINESS') | NO | N | N | — | Business attribute `customerType` for the `customer` record. |
| emailAddress | varchar(254) | See schema constraints | NO | Y | N | — | Business attribute `emailAddress` for the `customer` record. |
| isActive | tinyint(1) | 1 | NO | N | N | — | Boolean control/indicator for customer.isActive. |

## `customeraddress`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | See schema constraints | NO | Y | Y | customer.customerId | Identifies the related customer record. |
| addressId | char(8) | See schema constraints | NO | Y | Y | address.addressId | Identifies the related address record. |
| startDateTime | datetime | See schema constraints | NO | Y | Y | — | Date and time associated with the customeraddress event or validity period. |
| endDateTime | datetime | See schema constraints | YES | N | N | — | Date and time associated with the customeraddress event or validity period. |

## `customerorder`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerOrderId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a customerorder record. |
| customerId | char(7) | See schema constraints | NO | N | N | customer.customerId | Identifies the related customer record. |
| receivedDate | date | See schema constraints | NO | N | N | — | Date associated with the customerorder record or validity period. |
| paidFlag | tinyint(1) | 0 | NO | N | N | — | Indicates accounting confirmation that shipment may proceed. |
| orderStatus | enum('PENDING','SHIPPED','CANCELLED') | enum('PENDING','SHIPPED','CANCELLED') | NO | N | N | — | Business attribute `orderStatus` for the `customerorder` record. |

## `customerphone`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | See schema constraints | NO | Y | Y | customer.customerId | Identifies the related customer record. |
| phoneId | char(8) | See schema constraints | NO | Y | Y | phone.phoneId | Identifies the related phone record. |
| startDateTime | datetime | See schema constraints | NO | Y | Y | — | Date and time associated with the customerphone event or validity period. |
| endDateTime | datetime | See schema constraints | YES | N | N | — | Date and time associated with the customerphone event or validity period. |
| isPrimary | tinyint(1) | 0 | NO | N | N | — | Boolean control/indicator for customerphone.isPrimary. |

## `employee`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | See schema constraints | NO | Y | Y | — | Stable identifier for a employee record. |
| firstName | varchar(50) | See schema constraints | NO | N | N | — | Human-readable name used for the employee record. |
| lastName | varchar(50) | See schema constraints | NO | N | N | — | Human-readable name used for the employee record. |
| taxFileNumber | char(9) | See schema constraints | NO | Y | N | — | Australian tax file number; sensitive HR identifier. |
| employmentStartDate | date | See schema constraints | NO | N | N | — | Date associated with the employee record or validity period. |
| employmentEndDate | date | See schema constraints | YES | N | N | — | Date associated with the employee record or validity period. |

## `employeeaddress`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | See schema constraints | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| addressId | char(8) | See schema constraints | NO | Y | Y | address.addressId | Identifies the related address record. |
| startDateTime | datetime | See schema constraints | NO | Y | Y | — | Date and time associated with the employeeaddress event or validity period. |
| endDateTime | datetime | See schema constraints | YES | N | N | — | Date and time associated with the employeeaddress event or validity period. |

## `employeephone`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | See schema constraints | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| phoneId | char(8) | See schema constraints | NO | Y | Y | phone.phoneId | Identifies the related phone record. |
| startDateTime | datetime | See schema constraints | NO | Y | Y | — | Date and time associated with the employeephone event or validity period. |
| endDateTime | datetime | See schema constraints | YES | N | N | — | Date and time associated with the employeephone event or validity period. |
| isPrimary | tinyint(1) | 0 | NO | N | N | — | Boolean control/indicator for employeephone.isPrimary. |

## `employeequalification`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | See schema constraints | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| qualificationId | char(7) | See schema constraints | NO | Y | Y | qualification.qualificationId | Identifies the related qualification record. |
| awardedDate | date | See schema constraints | NO | Y | Y | — | Date associated with the employeequalification record or validity period. |
| expiryDate | date | See schema constraints | YES | N | N | — | Date associated with the employeequalification record or validity period. |
| certificateReference | varchar(80) | See schema constraints | YES | Y | N | — | Business attribute `certificateReference` for the `employeequalification` record. |

## `employeerole`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | See schema constraints | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| roleId | char(6) | See schema constraints | NO | Y | Y | role.roleId | Identifies the related role record. |
| operationalAreaId | char(6) | See schema constraints | NO | N | N | operationalarea.operationalAreaId | Identifies the related operationalarea record. |
| startDateTime | datetime | See schema constraints | NO | Y | Y | — | Date and time associated with the employeerole event or validity period. |
| endDateTime | datetime | See schema constraints | YES | N | N | — | Date and time associated with the employeerole event or validity period. |
| workTimeType | enum('FULLTIME','PARTTIME') | enum('FULLTIME','PARTTIME') | NO | N | N | — | Business attribute `workTimeType` for the `employeerole` record. |
| employmentType | enum('PERMANENT','CASUAL','SEASONAL') | enum('PERMANENT','CASUAL','SEASONAL') | NO | N | N | — | Business attribute `employmentType` for the `employeerole` record. |

## `grapevariety`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| grapeVarietyId | char(7) | See schema constraints | NO | Y | Y | — | Stable identifier for a grapevariety record. |
| varietyName | varchar(80) | See schema constraints | NO | Y | N | — | Human-readable name used for the grapevariety record. |
| juiceConversionPercent | decimal(5,2) | See schema constraints | NO | N | N | — | Expected percentage of grape weight converted to juice. |
| storageContainer | enum('STAINLESSSTEEL','OAKBARREL','OTHER') | enum('STAINLESSSTEEL','OAKBARREL','OTHER') | NO | N | N | — | Business attribute `storageContainer` for the `grapevariety` record. |
| agingDays | smallint unsigned | See schema constraints | NO | N | N | — | Business attribute `agingDays` for the `grapevariety` record. |

## `harvest`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| harvestId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a harvest record. |
| vineyardId | char(7) | See schema constraints | NO | N | N | vineyardplanting.vineyardId | Identifies the related vineyardplanting record. |
| vintageYear | year | See schema constraints | NO | N | N | vineyardplanting.vintageYear | Business attribute `vintageYear` for the `harvest` record. |
| harvestedDate | date | See schema constraints | NO | N | N | — | Date associated with the harvest record or validity period. |
| weightKg | decimal(12,2) | See schema constraints | NO | N | N | — | Business attribute `weightKg` for the `harvest` record. |
| ripenessSugarPercent | decimal(5,2) | See schema constraints | NO | N | N | — | Harvest ripeness expressed as percentage sugar. |

## `incident`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| incidentId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a incident record. |
| incidentDateTime | datetime | See schema constraints | NO | N | N | — | Date and time associated with the incident event or validity period. |
| operationalAreaId | char(6) | See schema constraints | NO | N | N | operationalarea.operationalAreaId | Identifies the related operationalarea record. |
| incidentType | enum('INJURY','NEARMISS','ILLNESS','EQUIPMENT','ENVIRONMENTAL','OTHER') | enum('INJURY','NEARMISS','ILLNESS','EQUIPMENT','ENVIRONMENTAL','OTHER') | NO | N | N | — | Business attribute `incidentType` for the `incident` record. |
| severity | enum('LOW','MODERATE','HIGH','CRITICAL') | enum('LOW','MODERATE','HIGH','CRITICAL') | NO | N | N | — | Business attribute `severity` for the `incident` record. |
| incidentDescription | varchar(1000) | See schema constraints | NO | N | N | — | Business description of the incident record. |
| totalLostHours | decimal(7,2) | 0.00 | NO | N | N | — | Total labour hours lost because of an incident. |
| reportableFlag | tinyint(1) | 0 | NO | N | N | — | Boolean control/indicator for incident.reportableFlag. |

## `incidentemployee`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| incidentId | char(8) | See schema constraints | NO | Y | Y | incident.incidentId | Identifies the related incident record. |
| employeeId | char(7) | See schema constraints | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| involvementRole | enum('AFFECTED','WITNESS','REPORTER') | enum('AFFECTED','WITNESS','REPORTER') | NO | N | N | — | Business attribute `involvementRole` for the `incidentemployee` record. |
| employeeLostHours | decimal(7,2) | 0.00 | NO | N | N | — | Business attribute `employeeLostHours` for the `incidentemployee` record. |

## `individualcustomer`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | See schema constraints | NO | Y | Y | customer.customerId | Identifies the related customer record. |
| firstName | varchar(50) | See schema constraints | NO | N | N | — | Human-readable name used for the individualcustomer record. |
| lastName | varchar(50) | See schema constraints | NO | N | N | — | Human-readable name used for the individualcustomer record. |
| dateOfBirth | date | See schema constraints | NO | N | N | — | Birth date retained to demonstrate an individual customer's legal age. |

## `medal`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| medalId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a medal record. |
| wineId | char(7) | See schema constraints | NO | Y | N | wine.wineId | Identifies the related wine record. |
| medalType | enum('BRONZE','SILVER','GOLD','TROPHY') | enum('BRONZE','SILVER','GOLD','TROPHY') | NO | Y | N | — | Business attribute `medalType` for the `medal` record. |
| awardYear | year | See schema constraints | NO | Y | N | — | Business attribute `awardYear` for the `medal` record. |
| awardingOrganisation | varchar(120) | See schema constraints | NO | Y | N | — | Business attribute `awardingOrganisation` for the `medal` record. |

## `openincidentaction`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| correctiveActionId | char(8) | See schema constraints | NO | N | N | — | Stable identifier for a openincidentaction record. |
| incidentId | char(8) | See schema constraints | NO | N | N | — | Stable identifier for a openincidentaction record. |
| incidentDateTime | datetime | See schema constraints | NO | N | N | — | Date and time associated with the openincidentaction event or validity period. |
| severity | enum('LOW','MODERATE','HIGH','CRITICAL') | enum('LOW','MODERATE','HIGH','CRITICAL') | NO | N | N | — | Business attribute `severity` for the `openincidentaction` record. |
| areaName | varchar(60) | See schema constraints | NO | N | N | — | Human-readable name used for the openincidentaction record. |
| actionDescription | varchar(500) | See schema constraints | NO | N | N | — | Business description of the openincidentaction record. |
| targetDate | date | See schema constraints | NO | N | N | — | Date associated with the openincidentaction record or validity period. |
| actionStatus | enum('OPEN','INPROGRESS','COMPLETED','CANCELLED') | enum('OPEN','INPROGRESS','COMPLETED','CANCELLED') | NO | N | N | — | Business attribute `actionStatus` for the `openincidentaction` record. |
| responsibleEmployee | varchar(101) | See schema constraints | YES | N | N | — | Business attribute `responsibleEmployee` for the `openincidentaction` record. |
| daysOverdue | int | See schema constraints | YES | N | N | — | Business attribute `daysOverdue` for the `openincidentaction` record. |

## `operationalarea`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| operationalAreaId | char(6) | See schema constraints | NO | Y | Y | — | Stable identifier for a operationalarea record. |
| areaName | varchar(60) | See schema constraints | NO | Y | N | — | Human-readable name used for the operationalarea record. |
| areaDescription | varchar(255) | See schema constraints | YES | N | N | — | Business description of the operationalarea record. |

## `orderline`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerOrderId | char(8) | See schema constraints | NO | Y | Y | customerorder.customerOrderId | Identifies the related customerorder record. |
| productId | char(7) | See schema constraints | NO | Y | Y | wineproduct.productId | Identifies the related wineproduct record. |
| caseQuantity | int unsigned | See schema constraints | NO | N | N | — | Quantity recorded for the orderline transaction or inventory fact. |
| agreedCasePrice | decimal(10,2) | See schema constraints | NO | N | N | — | Monetary value recorded for the orderline fact in Australian dollars. |

## `packmember`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| pickerPackId | char(7) | See schema constraints | NO | Y | Y | pickerpack.pickerPackId | Identifies the related pickerpack record. |
| employeeId | char(7) | See schema constraints | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| joinedDate | date | See schema constraints | NO | N | N | — | Date associated with the packmember record or validity period. |
| leftDate | date | See schema constraints | YES | N | N | — | Date associated with the packmember record or validity period. |

## `phone`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| phoneId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a phone record. |
| countryCode | varchar(4) | +61 | NO | Y | N | — | Business attribute `countryCode` for the `phone` record. |
| phoneNumber | varchar(20) | See schema constraints | NO | Y | N | — | Business attribute `phoneNumber` for the `phone` record. |
| phoneType | enum('MOBILE','WORK','HOME','OTHER') | enum('MOBILE','WORK','HOME','OTHER') | NO | N | N | — | Business attribute `phoneType` for the `phone` record. |

## `pickerpack`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| pickerPackId | char(7) | See schema constraints | NO | Y | Y | — | Stable identifier for a pickerpack record. |
| packName | varchar(60) | See schema constraints | NO | Y | N | — | Human-readable name used for the pickerpack record. |
| supervisorId | char(7) | See schema constraints | NO | N | N | employee.employeeId | Identifies the related employee record. |
| seasonYear | year | See schema constraints | NO | N | N | — | Business attribute `seasonYear` for the `pickerpack` record. |

## `productprice`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| productId | char(7) | See schema constraints | NO | Y | Y | wineproduct.productId | Identifies the related wineproduct record. |
| effectiveDate | date | See schema constraints | NO | Y | Y | — | Date associated with the productprice record or validity period. |
| endDate | date | See schema constraints | YES | N | N | — | Date associated with the productprice record or validity period. |
| casePrice | decimal(10,2) | See schema constraints | NO | N | N | — | Monetary value recorded for the productprice fact in Australian dollars. |

## `purchaseorder`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| purchaseOrderId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a purchaseorder record. |
| supplierId | char(7) | See schema constraints | NO | N | N | supplier.supplierId | Identifies the related supplier record. |
| orderedDate | date | See schema constraints | NO | N | N | — | Date associated with the purchaseorder record or validity period. |
| orderStatus | enum('PLACED','PARTRECEIVED','RECEIVED','CANCELLED') | enum('PLACED','PARTRECEIVED','RECEIVED','CANCELLED') | NO | N | N | — | Business attribute `orderStatus` for the `purchaseorder` record. |

## `purchaseorderline`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| purchaseOrderId | char(8) | See schema constraints | NO | Y | Y | purchaseorder.purchaseOrderId | Identifies the related purchaseorder record. |
| bottleTypeId | char(7) | See schema constraints | NO | Y | Y | bottletype.bottleTypeId | Identifies the related bottletype record. |
| orderedQuantity | int unsigned | See schema constraints | NO | N | N | — | Quantity recorded for the purchaseorderline transaction or inventory fact. |
| quotedUnitPrice | decimal(8,2) | See schema constraints | YES | N | N | — | Monetary value recorded for the purchaseorderline fact in Australian dollars. |

## `qualification`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| qualificationId | char(7) | See schema constraints | NO | Y | Y | — | Stable identifier for a qualification record. |
| qualificationName | varchar(120) | See schema constraints | NO | Y | N | — | Human-readable name used for the qualification record. |
| issuingAuthority | varchar(120) | See schema constraints | NO | N | N | — | Boolean control/indicator for qualification.issuingAuthority. |
| defaultValidityMonths | smallint unsigned | See schema constraints | YES | N | N | — | Business attribute `defaultValidityMonths` for the `qualification` record. |
| isSafetyCritical | tinyint(1) | 0 | NO | N | N | — | Boolean control/indicator for qualification.isSafetyCritical. |

## `receipt`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| receiptId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a receipt record. |
| purchaseOrderId | char(8) | See schema constraints | NO | N | N | purchaseorder.purchaseOrderId | Identifies the related purchaseorder record. |
| receivedDate | date | See schema constraints | NO | N | N | — | Date associated with the receipt record or validity period. |

## `receiptline`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| receiptId | char(8) | See schema constraints | NO | Y | Y | receipt.receiptId | Identifies the related receipt record. |
| bottleTypeId | char(7) | See schema constraints | NO | Y | Y | bottletype.bottleTypeId | Identifies the related bottletype record. |
| receivedQuantity | int unsigned | See schema constraints | NO | N | N | — | Quantity recorded for the receiptline transaction or inventory fact. |
| actualUnitPrice | decimal(8,2) | See schema constraints | NO | N | N | — | Monetary value recorded for the receiptline fact in Australian dollars. |

## `refund`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| refundId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a refund record. |
| customerOrderId | char(8) | See schema constraints | NO | N | N | customerorder.customerOrderId | Identifies the related customerorder record. |
| refundDate | date | See schema constraints | NO | N | N | — | Date associated with the refund record or validity period. |
| refundReason | enum('SHORTSUPPLY','TRANSITDAMAGE') | enum('SHORTSUPPLY','TRANSITDAMAGE') | NO | N | N | — | Business attribute `refundReason` for the `refund` record. |
| verifiedFlag | tinyint(1) | See schema constraints | NO | N | N | — | Boolean control/indicator for refund.verifiedFlag. |
| refundAmount | decimal(10,2) | See schema constraints | NO | N | N | — | Monetary value recorded for the refund fact in Australian dollars. |

## `role`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| roleId | char(6) | See schema constraints | NO | Y | Y | — | Stable identifier for a role record. |
| roleName | varchar(80) | See schema constraints | NO | Y | N | — | Human-readable name used for the role record. |
| roleDescription | varchar(255) | See schema constraints | NO | N | N | — | Business description of the role record. |

## `seasonalrating`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | See schema constraints | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| seasonYear | year | See schema constraints | NO | Y | Y | — | Business attribute `seasonYear` for the `seasonalrating` record. |
| supervisorId | char(7) | See schema constraints | NO | N | N | employee.employeeId | Identifies the related employee record. |
| ratingValue | tinyint | See schema constraints | NO | N | N | — | Business attribute `ratingValue` for the `seasonalrating` record. |
| recommendReemployment | tinyint(1) | See schema constraints | NO | N | N | — | Business attribute `recommendReemployment` for the `seasonalrating` record. |
| ratingComment | varchar(500) | See schema constraints | YES | N | N | — | Business attribute `ratingComment` for the `seasonalrating` record. |

## `shift`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| shiftId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a shift record. |
| shiftDate | date | See schema constraints | NO | N | N | — | Date associated with the shift record or validity period. |
| startTime | time | See schema constraints | NO | N | N | — | Business attribute `startTime` for the `shift` record. |
| endTime | time | See schema constraints | NO | N | N | — | Business attribute `endTime` for the `shift` record. |
| operationalAreaId | char(6) | See schema constraints | NO | N | N | operationalarea.operationalAreaId | Identifies the related operationalarea record. |
| taskCategoryId | char(6) | See schema constraints | NO | N | N | taskcategory.taskCategoryId | Identifies the related taskcategory record. |
| supervisorId | char(7) | See schema constraints | NO | N | N | employee.employeeId | Identifies the related employee record. |

## `shiftassignment`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| shiftId | char(8) | See schema constraints | NO | Y | Y | shift.shiftId | Identifies the related shift record. |
| employeeId | char(7) | See schema constraints | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| regularHours | decimal(4,2) | See schema constraints | NO | N | N | — | Regular labour hours worked on the assigned shift. |
| overtimeHours | decimal(4,2) | 0.00 | NO | N | N | — | Overtime hours used in workload and safety analysis. |

## `shipment`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| shipmentId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a shipment record. |
| customerOrderId | char(8) | See schema constraints | NO | Y | N | customerorder.customerOrderId | Identifies the related customerorder record. |
| addressId | char(8) | See schema constraints | NO | N | N | address.addressId | Identifies the related address record. |
| shippedDate | date | See schema constraints | NO | N | N | — | Date associated with the shipment record or validity period. |

## `supervision`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | See schema constraints | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| supervisorId | char(7) | See schema constraints | NO | N | N | employee.employeeId | Identifies the related employee record. |
| startDateTime | datetime | See schema constraints | NO | Y | Y | — | Date and time associated with the supervision event or validity period. |
| endDateTime | datetime | See schema constraints | YES | N | N | — | Date and time associated with the supervision event or validity period. |

## `supplier`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| supplierId | char(7) | See schema constraints | NO | Y | Y | — | Stable identifier for a supplier record. |
| supplierName | varchar(120) | See schema constraints | NO | Y | N | — | Human-readable name used for the supplier record. |
| addressId | char(8) | See schema constraints | NO | N | N | address.addressId | Identifies the related address record. |
| phoneNumber | varchar(25) | See schema constraints | NO | N | N | — | Business attribute `phoneNumber` for the `supplier` record. |
| contactFirstName | varchar(50) | See schema constraints | NO | N | N | — | Human-readable name used for the supplier record. |
| contactLastName | varchar(50) | See schema constraints | NO | N | N | — | Human-readable name used for the supplier record. |
| contactEmail | varchar(254) | See schema constraints | NO | N | N | — | Business attribute `contactEmail` for the `supplier` record. |

## `supplierbottle`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| supplierId | char(7) | See schema constraints | NO | Y | Y | supplier.supplierId | Identifies the related supplier record. |
| bottleTypeId | char(7) | See schema constraints | NO | Y | Y | bottletype.bottleTypeId | Identifies the related bottletype record. |
| supplierBottleCode | varchar(40) | See schema constraints | YES | N | N | — | Business attribute `supplierBottleCode` for the `supplierbottle` record. |
| isAvailable | tinyint(1) | 1 | NO | N | N | — | Boolean control/indicator for supplierbottle.isAvailable. |

## `taskcategory`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| taskCategoryId | char(6) | See schema constraints | NO | Y | Y | — | Stable identifier for a taskcategory record. |
| categoryName | varchar(60) | See schema constraints | NO | Y | N | — | Human-readable name used for the taskcategory record. |

## `trainingattendance`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| trainingSessionId | char(8) | See schema constraints | NO | Y | Y | trainingsession.trainingSessionId | Identifies the related trainingsession record. |
| employeeId | char(7) | See schema constraints | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| attendanceStatus | enum('REGISTERED','COMPLETED','FAILED','ABSENT') | enum('REGISTERED','COMPLETED','FAILED','ABSENT') | NO | N | N | — | Business attribute `attendanceStatus` for the `trainingattendance` record. |
| completionDate | date | See schema constraints | YES | N | N | — | Date associated with the trainingattendance record or validity period. |
| renewalDate | date | See schema constraints | YES | N | N | — | Date associated with the trainingattendance record or validity period. |
| competencyLevel | enum('AWARENESS','COMPETENT','ADVANCED') | enum('AWARENESS','COMPETENT','ADVANCED') | YES | N | N | — | Business attribute `competencyLevel` for the `trainingattendance` record. |

## `trainingcourse`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| trainingCourseId | char(7) | See schema constraints | NO | Y | Y | — | Stable identifier for a trainingcourse record. |
| courseName | varchar(120) | See schema constraints | NO | Y | N | — | Human-readable name used for the trainingcourse record. |
| courseProvider | varchar(120) | See schema constraints | NO | N | N | — | Business attribute `courseProvider` for the `trainingcourse` record. |
| trainingCategory | enum('SAFETY','SUSTAINABILITY','TECHNICAL','WELLBEING','OTHER') | enum('SAFETY','SUSTAINABILITY','TECHNICAL','WELLBEING','OTHER') | NO | N | N | — | Business attribute `trainingCategory` for the `trainingcourse` record. |
| renewalMonths | smallint unsigned | See schema constraints | YES | N | N | — | Business attribute `renewalMonths` for the `trainingcourse` record. |
| isMandatory | tinyint(1) | 0 | NO | N | N | — | Boolean control/indicator for trainingcourse.isMandatory. |

## `trainingsession`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| trainingSessionId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a trainingsession record. |
| trainingCourseId | char(7) | See schema constraints | NO | N | N | trainingcourse.trainingCourseId | Identifies the related trainingcourse record. |
| sessionDate | date | See schema constraints | NO | N | N | — | Date associated with the trainingsession record or validity period. |
| operationalAreaId | char(6) | See schema constraints | YES | N | N | operationalarea.operationalAreaId | Identifies the related operationalarea record. |
| trainerName | varchar(100) | See schema constraints | NO | N | N | — | Human-readable name used for the trainingsession record. |
| deliveryMode | enum('INPERSON','ONLINE','BLENDED') | enum('INPERSON','ONLINE','BLENDED') | NO | N | N | — | Business attribute `deliveryMode` for the `trainingsession` record. |

## `vineyard`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| vineyardId | char(7) | See schema constraints | NO | Y | Y | — | Stable identifier for a vineyard record. |
| vineyardName | varchar(80) | See schema constraints | NO | Y | N | — | Human-readable name used for the vineyard record. |
| areaHectares | decimal(6,2) | See schema constraints | NO | N | N | — | Business attribute `areaHectares` for the `vineyard` record. |
| latitude | decimal(9,6) | See schema constraints | NO | N | N | — | Business attribute `latitude` for the `vineyard` record. |
| longitude | decimal(9,6) | See schema constraints | NO | N | N | — | Business attribute `longitude` for the `vineyard` record. |
| managerId | char(7) | See schema constraints | NO | Y | N | employee.employeeId | Identifies the related employee record. |
| addressId | char(8) | See schema constraints | NO | Y | N | address.addressId | Identifies the related address record. |

## `vineyardplanting`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| vineyardId | char(7) | See schema constraints | NO | Y | Y | vineyard.vineyardId | Identifies the related vineyard record. |
| vintageYear | year | See schema constraints | NO | Y | Y | — | Business attribute `vintageYear` for the `vineyardplanting` record. |
| grapeVarietyId | char(7) | See schema constraints | NO | N | N | grapevariety.grapeVarietyId | Identifies the related grapevariety record. |
| plantedDate | date | See schema constraints | YES | N | N | — | Date associated with the vineyardplanting record or validity period. |

## `wellbeingaction`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wellbeingActionId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a wellbeingaction record. |
| wellbeingCheckinId | char(8) | See schema constraints | NO | N | N | wellbeingcheckin.wellbeingCheckinId | Identifies the related wellbeingcheckin record. |
| actionDescription | varchar(500) | See schema constraints | NO | N | N | — | Business description of the wellbeingaction record. |
| targetDate | date | See schema constraints | NO | N | N | — | Date associated with the wellbeingaction record or validity period. |
| completedDate | date | See schema constraints | YES | N | N | — | Date associated with the wellbeingaction record or validity period. |
| actionStatus | enum('OPEN','INPROGRESS','COMPLETED','CANCELLED') | enum('OPEN','INPROGRESS','COMPLETED','CANCELLED') | NO | N | N | — | Business attribute `actionStatus` for the `wellbeingaction` record. |

## `wellbeingcheckin`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wellbeingCheckinId | char(8) | See schema constraints | NO | Y | Y | — | Stable identifier for a wellbeingcheckin record. |
| employeeId | char(7) | See schema constraints | NO | N | N | employee.employeeId | Identifies the related employee record. |
| managerId | char(7) | See schema constraints | NO | N | N | employee.employeeId | Identifies the related employee record. |
| checkinDate | date | See schema constraints | NO | N | N | — | Date associated with the wellbeingcheckin record or validity period. |
| concernRaisedFlag | tinyint(1) | See schema constraints | NO | N | N | — | Boolean control/indicator for wellbeingcheckin.concernRaisedFlag. |
| confidentialNote | varchar(1000) | See schema constraints | YES | N | N | — | Restricted wellbeing note; excluded from routine management reporting. |

## `wellbeingtopic`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wellbeingTopicId | char(6) | See schema constraints | NO | Y | Y | — | Stable identifier for a wellbeingtopic record. |
| topicName | varchar(80) | See schema constraints | NO | Y | N | — | Human-readable name used for the wellbeingtopic record. |

## `wine`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wineId | char(7) | See schema constraints | NO | Y | Y | — | Stable identifier for a wine record. |
| wineName | varchar(100) | See schema constraints | NO | Y | N | — | Human-readable name used for the wine record. |
| vintageYear | year | See schema constraints | NO | Y | N | — | Business attribute `vintageYear` for the `wine` record. |
| wineCategoryId | char(5) | See schema constraints | NO | N | N | winecategory.wineCategoryId | Identifies the related winecategory record. |
| alcoholPercent | decimal(4,2) | See schema constraints | NO | N | N | — | Business attribute `alcoholPercent` for the `wine` record. |
| winemakerId | char(7) | See schema constraints | NO | N | N | employee.employeeId | Identifies the related employee record. |

## `winecategory`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wineCategoryId | char(5) | See schema constraints | NO | Y | Y | — | Stable identifier for a winecategory record. |
| categoryName | varchar(40) | See schema constraints | NO | Y | N | — | Human-readable name used for the winecategory record. |

## `winecomposition`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wineId | char(7) | See schema constraints | NO | Y | Y | wine.wineId | Identifies the related wine record. |
| grapeVarietyId | char(7) | See schema constraints | NO | Y | Y | grapevariety.grapeVarietyId | Identifies the related grapevariety record. |
| proportionPercent | decimal(5,2) | See schema constraints | NO | N | N | — | Percentage contribution of a grape variety to a wine composition. |

## `wineproduct`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| productId | char(7) | See schema constraints | NO | Y | Y | — | Stable identifier for a wineproduct record. |
| wineId | char(7) | See schema constraints | NO | Y | N | wine.wineId | Identifies the related wine record. |
| bottleTypeId | char(7) | See schema constraints | NO | Y | N | bottletype.bottleTypeId | Identifies the related bottletype record. |
| caseQuantity | smallint unsigned | See schema constraints | NO | Y | N | — | Quantity recorded for the wineproduct transaction or inventory fact. |
| isActive | tinyint(1) | 1 | NO | N | N | — | Boolean control/indicator for wineproduct.isActive. |
