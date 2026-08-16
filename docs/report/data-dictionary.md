# Cloudrest Wines Data Dictionary

The data dictionary was prepared as Word-ready tables and cross-checked against the implemented MySQL schema for consistency. Automation is used internally to prevent schema drift.

## `address`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| addressId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a address record. |
| addressKind | enum('PHYSICAL','POSTAL') | Permitted values: physical, postal. | NO | N | N | — | Records the address kind of the address. |
| postalType | enum('POBOX','PRIVATEBAG','OTHER') | Permitted values: pobox, privatebag, other. | YES | N | N | — | Records the postal type of the address. |
| unitType | varchar(20) | Text up to the implemented varchar(20) size. | YES | N | N | — | Records the unit type of the address. |
| unitNumber | varchar(12) | Text up to the implemented varchar(12) size. | YES | N | N | — | Records the unit number of the address. |
| levelType | varchar(20) | Text up to the implemented varchar(20) size. | YES | N | N | — | Records the level type of the address. |
| levelNumber | varchar(12) | Text up to the implemented varchar(12) size. | YES | N | N | — | Records the level number of the address. |
| buildingName | varchar(100) | Text up to the implemented varchar(100) size. | YES | N | N | — | Human-readable name used for the address record. |
| placeName | varchar(100) | Text up to the implemented varchar(100) size. | YES | N | N | — | Human-readable name used for the address record. |
| addressNumber | varchar(20) | Text up to the implemented varchar(20) size. | YES | N | N | — | Records the address number of the address. |
| streetName | varchar(120) | Text up to the implemented varchar(120) size. | YES | N | N | — | Human-readable name used for the address record. |
| locality | varchar(80) | Text up to the implemented varchar(80) size. | NO | N | N | — | Records the locality of the address. |
| stateCode | enum('ACT','NSW','NT','QLD','SA','TAS','VIC','WA') | Permitted values: act, nsw, nt, qld, sa, tas, vic, wa. | NO | N | N | — | Records the state code of the address. |
| postcode | char(4) | Exactly 4 numeric digits. | NO | N | N | — | Records the postcode of the address. |

## `bottletype`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| bottleTypeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | — | Stable identifier for a bottletype record. |
| capacityMl | smallint unsigned | Numeric value within the implemented MySQL type. | NO | N | N | — | Records the capacity ml of the bottletype. |
| bottleShape | varchar(40) | Text up to the implemented varchar(40) size. | NO | N | N | — | Records the bottle shape of the bottletype. |
| material | enum('GLASS','PLASTIC') | Permitted values: glass, plastic. | NO | N | N | — | Records the material of the bottletype. |
| bottleColour | varchar(40) | Text up to the implemented varchar(40) size. | NO | N | N | — | Records the bottle colour of the bottletype. |
| inventoryQuantity | int unsigned | Positive numeric value. | NO | N | N | — | Quantity recorded for the bottletype transaction or inventory fact. |
| usualUnitCost | decimal(8,2) | Non-negative numeric value. | NO | N | N | — | Monetary value recorded for the bottletype fact in Australian dollars. |
| reorderFlag | tinyint(1) | TRUE/FALSE; default 1. | NO | N | N | — | Indicates whether this bottle type may be reordered. |
| reorderComment | varchar(500) | Text up to the implemented varchar(500) size. | YES | N | N | — | Required explanation when a bottle type will not be reordered. |

## `businesscustomer`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | customer.customerId | Identifies the related customer record. |
| companyName | varchar(120) | Text up to the implemented varchar(120) size. | NO | N | N | — | Human-readable name used for the businesscustomer record. |
| australianBusinessNumber | char(11) | Exactly 11 numeric digits. | NO | Y | N | — | Eleven-digit ABN identifying an Australian business customer. |
| contactFirstName | varchar(50) | Text up to the implemented varchar(50) size. | NO | N | N | — | Human-readable name used for the businesscustomer record. |
| contactLastName | varchar(50) | Text up to the implemented varchar(50) size. | NO | N | N | — | Human-readable name used for the businesscustomer record. |
| businessType | enum('RESTAURANT','WINESHOP','EXPORTCOMPANY','OTHER') | Permitted values: restaurant, wineshop, exportcompany, other. | NO | N | N | — | Records the business type of the businesscustomer. |

## `checkintopic`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wellbeingCheckinId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | wellbeingcheckin.wellbeingCheckinId | Identifies the related wellbeingcheckin record. |
| wellbeingTopicId | char(6) | Text up to the implemented char(6) size. | NO | Y | Y | wellbeingtopic.wellbeingTopicId | Identifies the related wellbeingtopic record. |

## `correctiveaction`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| correctiveActionId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a correctiveaction record. |
| incidentId | char(8) | Text up to the implemented char(8) size. | NO | N | N | incident.incidentId | Identifies the related incident record. |
| actionDescription | varchar(500) | Text up to the implemented varchar(500) size. | NO | N | N | — | Business description of the correctiveaction record. |
| responsibleEmployeeId | char(7) | Text up to the implemented char(7) size. | NO | N | N | employee.employeeId | Identifies the related employee record. |
| targetDate | date | Valid MySQL date value. | NO | N | N | — | Date associated with the correctiveaction record or validity period. |
| completedDate | date | Valid MySQL date value. | YES | N | N | — | Date associated with the correctiveaction record or validity period. |
| actionStatus | enum('OPEN','INPROGRESS','COMPLETED','CANCELLED') | Permitted values: open, inprogress, completed, cancelled. | NO | N | N | — | Records the action status of the correctiveaction. |

## `customer`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | — | Stable identifier for a customer record. |
| customerType | enum('INDIVIDUAL','BUSINESS') | Permitted values: individual, business. | NO | N | N | — | Records the customer type of the customer. |
| emailAddress | varchar(254) | Text up to the implemented varchar(254) size. | NO | Y | N | — | Records the email address of the customer. |
| isActive | tinyint(1) | TRUE/FALSE; default 1. | NO | N | N | — | TRUE/FALSE indicator for is active on the customer record. |

## `customeraddress`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | customer.customerId | Identifies the related customer record. |
| addressId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | address.addressId | Identifies the related address record. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | Y | Y | — | Inclusive start date/time of the customeraddress history period. |
| endDateTime | datetime | NULL for current, otherwise not earlier than startDateTime. | YES | N | N | — | Optional end date/time of the customeraddress history period; NULL identifies the current row. |

## `customerorder`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerOrderId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a customerorder record. |
| customerId | char(7) | Text up to the implemented char(7) size. | NO | N | N | customer.customerId | Identifies the related customer record. |
| receivedDate | date | Valid MySQL date value. | NO | N | N | — | Date associated with the customerorder record or validity period. |
| paidFlag | tinyint(1) | TRUE/FALSE; default 0. | NO | N | N | — | Indicates accounting confirmation that shipment may proceed. |
| orderStatus | enum('PENDING','SHIPPED','CANCELLED') | Permitted values: pending, shipped, cancelled. | NO | N | N | — | Records the order status of the customerorder. |

## `customerphone`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | customer.customerId | Identifies the related customer record. |
| phoneId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | phone.phoneId | Identifies the related phone record. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | Y | Y | — | Inclusive start date/time of the customerphone history period. |
| endDateTime | datetime | NULL for current, otherwise not earlier than startDateTime. | YES | N | N | — | Optional end date/time of the customerphone history period; NULL identifies the current row. |
| isPrimary | tinyint(1) | TRUE/FALSE; default 0. | NO | N | N | — | TRUE/FALSE indicator for is primary on the customerphone record. |

## `employee`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | — | Stable identifier for a employee record. |
| firstName | varchar(50) | Text up to the implemented varchar(50) size. | NO | N | N | — | Human-readable name used for the employee record. |
| lastName | varchar(50) | Text up to the implemented varchar(50) size. | NO | N | N | — | Human-readable name used for the employee record. |
| taxFileNumber | char(9) | Exactly 9 numeric digits. | NO | Y | N | — | Australian tax file number; sensitive HR identifier. |
| employmentStartDate | date | Valid MySQL date value. | NO | N | N | — | Date associated with the employee record or validity period. |
| employmentEndDate | date | Valid MySQL date value. | YES | N | N | — | Date associated with the employee record or validity period. |

## `employeeaddress`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| addressId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | address.addressId | Identifies the related address record. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | Y | Y | — | Inclusive start date/time of the employeeaddress history period. |
| endDateTime | datetime | NULL for current, otherwise not earlier than startDateTime. | YES | N | N | — | Optional end date/time of the employeeaddress history period; NULL identifies the current row. |

## `employeephone`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| phoneId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | phone.phoneId | Identifies the related phone record. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | Y | Y | — | Inclusive start date/time of the employeephone history period. |
| endDateTime | datetime | NULL for current, otherwise not earlier than startDateTime. | YES | N | N | — | Optional end date/time of the employeephone history period; NULL identifies the current row. |
| isPrimary | tinyint(1) | TRUE/FALSE; default 0. | NO | N | N | — | TRUE/FALSE indicator for is primary on the employeephone record. |

## `employeequalification`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| qualificationId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | qualification.qualificationId | Identifies the related qualification record. |
| awardedDate | date | Valid MySQL date value. | NO | Y | Y | — | Date associated with the employeequalification record or validity period. |
| expiryDate | date | Valid MySQL date value. | YES | N | N | — | Date associated with the employeequalification record or validity period. |
| certificateReference | varchar(80) | Text up to the implemented varchar(80) size. | YES | Y | N | — | Records the certificate reference of the employeequalification. |

## `employeerole`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| roleId | char(6) | Text up to the implemented char(6) size. | NO | Y | Y | role.roleId | Identifies the related role record. |
| operationalAreaId | char(6) | Text up to the implemented char(6) size. | NO | N | N | operationalarea.operationalAreaId | Identifies the related operationalarea record. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | Y | Y | — | Inclusive start date/time of the employeerole history period. |
| endDateTime | datetime | NULL for current, otherwise not earlier than startDateTime. | YES | N | N | — | Optional end date/time of the employeerole history period; NULL identifies the current row. |
| workTimeType | enum('FULLTIME','PARTTIME') | Permitted values: fulltime, parttime. | NO | N | N | — | Indicates whether the appointment is full-time or part-time. |
| employmentType | enum('PERMANENT','CASUAL') | Permitted values: permanent, casual. | NO | N | N | — | Legal engagement category: permanent or casual. |
| employmentPattern | enum('ONGOING','SEASONAL') | Permitted values: ongoing, seasonal. | NO | N | N | — | Indicates ongoing or seasonal work pattern independently of employment type. |

## `grapevariety`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| grapeVarietyId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | — | Stable identifier for a grapevariety record. |
| varietyName | varchar(80) | Text up to the implemented varchar(80) size. | NO | Y | N | — | Human-readable name used for the grapevariety record. |
| juiceConversionPercent | decimal(5,2) | Numeric percentage greater than 0 and no more than 100, except alcohol is capped at 25 as implemented. | NO | N | N | — | Expected percentage of grape weight converted to juice. |
| storageContainer | enum('STAINLESSSTEEL','OAKBARREL','OTHER') | Permitted values: stainlesssteel, oakbarrel, other. | NO | N | N | — | Records the storage container of the grapevariety. |
| agingDays | smallint unsigned | Numeric value within the implemented MySQL type. | NO | N | N | — | Records the aging days of the grapevariety. |

## `harvest`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| harvestId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a harvest record. |
| vineyardId | char(7) | Text up to the implemented char(7) size. | NO | N | N | vineyardplanting.vineyardId | Identifies the related vineyardplanting record. |
| vintageYear | year | Valid MySQL year value. | NO | N | N | vineyardplanting.vintageYear | Records the vintage year of the harvest. |
| harvestedDate | date | Valid MySQL date value. | NO | N | N | — | Date associated with the harvest record or validity period. |
| weightKg | decimal(12,2) | Positive numeric value. | NO | N | N | — | Records the weight kg of the harvest. |
| ripenessSugarPercent | decimal(5,2) | Numeric percentage greater than 0 and no more than 100, except alcohol is capped at 25 as implemented. | NO | N | N | — | Harvest ripeness expressed as percentage sugar. |

## `incident`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| incidentId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a incident record. |
| incidentDateTime | datetime | Valid MySQL datetime value. | NO | N | N | — | Records the incident date time of the incident. |
| operationalAreaId | char(6) | Text up to the implemented char(6) size. | NO | N | N | operationalarea.operationalAreaId | Identifies the related operationalarea record. |
| incidentType | enum('INJURY','NEARMISS','ILLNESS','EQUIPMENT','ENVIRONMENTAL','OTHER') | Permitted values: injury, nearmiss, illness, equipment, environmental, other. | NO | N | N | — | Records the incident type of the incident. |
| severity | enum('LOW','MODERATE','HIGH','CRITICAL') | Permitted values: low, moderate, high, critical. | NO | N | N | — | Classifies incident seriousness for safety follow-up and reporting. |
| incidentDescription | varchar(1000) | Text up to the implemented varchar(1000) size. | NO | N | N | — | Business description of the incident record. |
| totalLostHours | decimal(7,2) | Non-negative numeric value. | NO | N | N | — | Non-negative total labour hours lost because of an incident; may be zero for a serious near miss. |
| reportableFlag | tinyint(1) | TRUE/FALSE; default 0. | NO | N | N | — | TRUE/FALSE indicator for reportable flag on the incident record. |

## `incidentemployee`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| incidentId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | incident.incidentId | Identifies the related incident record. |
| employeeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| involvementRole | enum('AFFECTED','WITNESS','REPORTER') | Permitted values: affected, witness, reporter. | NO | N | N | — | Records the involvement role of the incidentemployee. |
| employeeLostHours | decimal(7,2) | Numeric value within the implemented MySQL type; default 0.00. | NO | N | N | — | Records the employee lost hours of the incidentemployee. |

## `individualcustomer`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | customer.customerId | Identifies the related customer record. |
| firstName | varchar(50) | Text up to the implemented varchar(50) size. | NO | N | N | — | Human-readable name used for the individualcustomer record. |
| lastName | varchar(50) | Text up to the implemented varchar(50) size. | NO | N | N | — | Human-readable name used for the individualcustomer record. |
| dateOfBirth | date | Valid MySQL date value. | NO | N | N | — | Birth date retained to demonstrate an individual customer's legal age. |

## `medal`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| medalId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a medal record. |
| wineId | char(7) | Text up to the implemented char(7) size. | NO | Y | N | wine.wineId | Identifies the related wine record. |
| medalType | enum('BRONZE','SILVER','GOLD','TROPHY') | Permitted values: bronze, silver, gold, trophy. | NO | Y | N | — | Records the medal type of the medal. |
| awardYear | year | Valid MySQL year value. | NO | Y | N | — | Records the award year of the medal. |
| awardingOrganisation | varchar(120) | Text up to the implemented varchar(120) size. | NO | Y | N | — | Records the awarding organisation of the medal. |

## `openincidentaction`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| correctiveActionId | char(8) | Text up to the implemented char(8) size. | NO | N | N | — | Stable identifier for a openincidentaction record. |
| incidentId | char(8) | Text up to the implemented char(8) size. | NO | N | N | — | Stable identifier for a openincidentaction record. |
| incidentDateTime | datetime | Valid MySQL datetime value. | NO | N | N | — | Records the incident date time of the openincidentaction. |
| severity | enum('LOW','MODERATE','HIGH','CRITICAL') | Permitted values: low, moderate, high, critical. | NO | N | N | — | Classifies incident seriousness for safety follow-up and reporting. |
| areaName | varchar(60) | Text up to the implemented varchar(60) size. | NO | N | N | — | Human-readable name used for the openincidentaction record. |
| actionDescription | varchar(500) | Text up to the implemented varchar(500) size. | NO | N | N | — | Business description of the openincidentaction record. |
| targetDate | date | Valid MySQL date value. | NO | N | N | — | Date associated with the openincidentaction record or validity period. |
| actionStatus | enum('OPEN','INPROGRESS','COMPLETED','CANCELLED') | Permitted values: open, inprogress, completed, cancelled. | NO | N | N | — | Records the action status of the openincidentaction. |
| responsibleEmployee | varchar(101) | Text up to the implemented varchar(101) size. | YES | N | N | — | Records the responsible employee of the openincidentaction. |
| daysOverdue | int | Numeric value within the implemented MySQL type. | YES | N | N | — | Records the days overdue of the openincidentaction. |

## `operationalarea`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| operationalAreaId | char(6) | Text up to the implemented char(6) size. | NO | Y | Y | — | Stable identifier for a operationalarea record. |
| areaName | varchar(60) | Text up to the implemented varchar(60) size. | NO | Y | N | — | Human-readable name used for the operationalarea record. |
| areaDescription | varchar(255) | Text up to the implemented varchar(255) size. | YES | N | N | — | Business description of the operationalarea record. |

## `orderline`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerOrderId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | customerorder.customerOrderId | Identifies the related customerorder record. |
| productId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | wineproduct.productId | Identifies the related wineproduct record. |
| caseQuantity | int unsigned | Positive numeric value. | NO | N | N | — | Quantity recorded for the orderline transaction or inventory fact. |
| agreedCasePrice | decimal(10,2) | Numeric value within the implemented MySQL type. | NO | N | N | — | Monetary value recorded for the orderline fact in Australian dollars. |

## `packmember`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| pickerPackId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | pickerpack.pickerPackId | Identifies the related pickerpack record. |
| employeeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| joinedDate | date | Valid MySQL date value. | NO | N | N | — | Date associated with the packmember record or validity period. |
| leftDate | date | Valid MySQL date value. | YES | N | N | — | Date associated with the packmember record or validity period. |

## `phone`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| phoneId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a phone record. |
| countryCode | varchar(4) | Text up to the implemented varchar(4) size; default +61. | NO | Y | N | — | Records the country code of the phone. |
| phoneNumber | varchar(20) | Text up to the implemented varchar(20) size. | NO | Y | N | — | Records the phone number of the phone. |
| phoneType | enum('MOBILE','WORK','HOME','OTHER') | Permitted values: mobile, work, home, other. | NO | N | N | — | Records the phone type of the phone. |

## `pickerpack`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| pickerPackId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | — | Stable identifier for a pickerpack record. |
| packName | varchar(60) | Text up to the implemented varchar(60) size. | NO | Y | N | — | Human-readable name used for the pickerpack record. |
| supervisorId | char(7) | Text up to the implemented char(7) size. | NO | N | N | employee.employeeId | Identifies the related employee record. |
| seasonYear | year | Valid MySQL year value. | NO | N | N | — | Records the season year of the pickerpack. |

## `productprice`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| productId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | wineproduct.productId | Identifies the related wineproduct record. |
| effectiveDate | date | Valid MySQL date value. | NO | Y | Y | — | Date associated with the productprice record or validity period. |
| endDate | date | NULL for current, otherwise not earlier than the corresponding start/effective date. | YES | N | N | — | Date associated with the productprice record or validity period. |
| casePrice | decimal(10,2) | Positive numeric value. | NO | N | N | — | Monetary value recorded for the productprice fact in Australian dollars. |

## `purchaseorder`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| purchaseOrderId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a purchaseorder record. |
| supplierId | char(7) | Text up to the implemented char(7) size. | NO | N | N | supplier.supplierId | Identifies the related supplier record. |
| orderedDate | date | Valid MySQL date value. | NO | N | N | — | Date associated with the purchaseorder record or validity period. |
| orderStatus | enum('PLACED','PARTRECEIVED','RECEIVED','CANCELLED') | Permitted values: placed, partreceived, received, cancelled. | NO | N | N | — | Records the order status of the purchaseorder. |

## `purchaseorderline`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| purchaseOrderId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | purchaseorder.purchaseOrderId | Identifies the related purchaseorder record. |
| bottleTypeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | bottletype.bottleTypeId | Identifies the related bottletype record. |
| orderedQuantity | int unsigned | Positive numeric value. | NO | N | N | — | Quantity recorded for the purchaseorderline transaction or inventory fact. |
| quotedUnitPrice | decimal(8,2) | Non-negative numeric value. | YES | N | N | — | Monetary value recorded for the purchaseorderline fact in Australian dollars. |

## `qualification`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| qualificationId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | — | Stable identifier for a qualification record. |
| qualificationName | varchar(120) | Text up to the implemented varchar(120) size. | NO | Y | N | — | Human-readable name used for the qualification record. |
| issuingAuthority | varchar(120) | Text up to the implemented varchar(120) size. | NO | N | N | — | TRUE/FALSE indicator for issuing authority on the qualification record. |
| defaultValidityMonths | smallint unsigned | Numeric value within the implemented MySQL type. | YES | N | N | — | Records the default validity months of the qualification. |
| isSafetyCritical | tinyint(1) | TRUE/FALSE; default 0. | NO | N | N | — | TRUE/FALSE indicator for is safety critical on the qualification record. |

## `receipt`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| receiptId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a receipt record. |
| purchaseOrderId | char(8) | Text up to the implemented char(8) size. | NO | N | N | purchaseorder.purchaseOrderId | Identifies the related purchaseorder record. |
| receivedDate | date | Valid MySQL date value. | NO | N | N | — | Date associated with the receipt record or validity period. |

## `receiptline`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| receiptId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | receipt.receiptId | Identifies the related receipt record. |
| bottleTypeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | bottletype.bottleTypeId | Identifies the related bottletype record. |
| receivedQuantity | int unsigned | Positive numeric value. | NO | N | N | — | Quantity recorded for the receiptline transaction or inventory fact. |
| actualUnitPrice | decimal(8,2) | Non-negative numeric value. | NO | N | N | — | Monetary value recorded for the receiptline fact in Australian dollars. |

## `refund`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| refundId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a refund record. |
| customerOrderId | char(8) | Text up to the implemented char(8) size. | NO | N | N | customerorder.customerOrderId | Identifies the related customerorder record. |
| refundDate | date | Valid MySQL date value. | NO | N | N | — | Date associated with the refund record or validity period. |
| refundReason | enum('SHORTSUPPLY','TRANSITDAMAGE') | Permitted values: shortsupply, transitdamage. | NO | N | N | — | Records the refund reason of the refund. |
| verifiedFlag | tinyint(1) | TRUE/FALSE. | NO | N | N | — | TRUE/FALSE indicator for verified flag on the refund record. |
| refundAmount | decimal(10,2) | Non-negative numeric value. | NO | N | N | — | Monetary value recorded for the refund fact in Australian dollars. |

## `role`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| roleId | char(6) | Text up to the implemented char(6) size. | NO | Y | Y | — | Stable identifier for a role record. |
| roleName | varchar(80) | Text up to the implemented varchar(80) size. | NO | Y | N | — | Human-readable name used for the role record. |
| roleDescription | varchar(255) | Text up to the implemented varchar(255) size. | NO | N | N | — | Business description of the role record. |

## `seasonalrating`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| seasonYear | year | Valid MySQL year value. | NO | Y | Y | — | Records the season year of the seasonalrating. |
| supervisorId | char(7) | Text up to the implemented char(7) size. | NO | N | N | employee.employeeId | Identifies the related employee record. |
| ratingValue | tinyint | Integer from 1 to 5. | NO | N | N | — | Records the rating value of the seasonalrating. |
| recommendReemployment | tinyint(1) | TRUE/FALSE. | NO | N | N | — | Records the recommend reemployment of the seasonalrating. |
| ratingComment | varchar(500) | Text up to the implemented varchar(500) size. | YES | N | N | — | Records the rating comment of the seasonalrating. |

## `shift`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| shiftId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a shift record. |
| shiftDate | date | Valid MySQL date value. | NO | N | N | — | Date associated with the shift record or validity period. |
| startTime | time | Valid MySQL time value. | NO | N | N | — | Records the start time of the shift. |
| endTime | time | Valid MySQL time value. | NO | N | N | — | Records the end time of the shift. |
| operationalAreaId | char(6) | Text up to the implemented char(6) size. | NO | N | N | operationalarea.operationalAreaId | Identifies the related operationalarea record. |
| taskCategoryId | char(6) | Text up to the implemented char(6) size. | NO | N | N | taskcategory.taskCategoryId | Identifies the related taskcategory record. |
| supervisorId | char(7) | Text up to the implemented char(7) size. | NO | N | N | employee.employeeId | Identifies the related employee record. |

## `shiftassignment`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| shiftId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | shift.shiftId | Identifies the related shift record. |
| employeeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| regularHours | decimal(4,2) | Non-negative numeric value. | NO | N | N | — | Regular labour hours worked on the assigned shift. |
| overtimeHours | decimal(4,2) | Non-negative numeric value. | NO | N | N | — | Overtime hours used in workload and safety analysis. |

## `shipment`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| shipmentId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a shipment record. |
| customerOrderId | char(8) | Text up to the implemented char(8) size. | NO | Y | N | customerorder.customerOrderId | Identifies the related customerorder record. |
| addressId | char(8) | Text up to the implemented char(8) size. | NO | N | N | address.addressId | Identifies the related address record. |
| shippedDate | date | Valid MySQL date value. | NO | N | N | — | Date associated with the shipment record or validity period. |

## `supervision`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| supervisorId | char(7) | Text up to the implemented char(7) size. | NO | N | N | employee.employeeId | Identifies the related employee record. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | Y | Y | — | Inclusive start date/time of the supervision history period. |
| endDateTime | datetime | NULL for current, otherwise not earlier than startDateTime. | YES | N | N | — | Optional end date/time of the supervision history period; NULL identifies the current row. |

## `supplier`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| supplierId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | — | Stable identifier for a supplier record. |
| supplierName | varchar(120) | Text up to the implemented varchar(120) size. | NO | Y | N | — | Human-readable name used for the supplier record. |
| contactFirstName | varchar(50) | Text up to the implemented varchar(50) size. | NO | N | N | — | Human-readable name used for the supplier record. |
| contactLastName | varchar(50) | Text up to the implemented varchar(50) size. | NO | N | N | — | Human-readable name used for the supplier record. |
| contactEmail | varchar(254) | Text up to the implemented varchar(254) size. | NO | N | N | — | Records the contact email of the supplier. |

## `supplieraddress`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| supplierId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | supplier.supplierId | Identifies the related supplier record. |
| addressId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | address.addressId | Identifies the related address record. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | Y | Y | — | Inclusive start date/time of the supplieraddress history period. |
| endDateTime | datetime | NULL for current, otherwise not earlier than startDateTime. | YES | N | N | — | Optional end date/time of the supplieraddress history period; NULL identifies the current row. |

## `supplierbottle`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| supplierId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | supplier.supplierId | Identifies the related supplier record. |
| bottleTypeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | bottletype.bottleTypeId | Identifies the related bottletype record. |
| supplierBottleCode | varchar(40) | Text up to the implemented varchar(40) size. | YES | N | N | — | Records the supplier bottle code of the supplierbottle. |
| isAvailable | tinyint(1) | TRUE/FALSE; default 1. | NO | N | N | — | TRUE/FALSE indicator for is available on the supplierbottle record. |

## `supplierphone`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| supplierId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | supplier.supplierId | Identifies the related supplier record. |
| phoneId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | phone.phoneId | Identifies the related phone record. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | Y | Y | — | Inclusive start date/time of the supplierphone history period. |
| endDateTime | datetime | NULL for current, otherwise not earlier than startDateTime. | YES | N | N | — | Optional end date/time of the supplierphone history period; NULL identifies the current row. |
| isPrimary | tinyint(1) | TRUE/FALSE; default 0. | NO | N | N | — | TRUE/FALSE indicator for is primary on the supplierphone record. |

## `taskcategory`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| taskCategoryId | char(6) | Text up to the implemented char(6) size. | NO | Y | Y | — | Stable identifier for a taskcategory record. |
| categoryName | varchar(60) | Text up to the implemented varchar(60) size. | NO | Y | N | — | Human-readable name used for the taskcategory record. |

## `trainingattendance`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| trainingSessionId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | trainingsession.trainingSessionId | Identifies the related trainingsession record. |
| employeeId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | employee.employeeId | Identifies the related employee record. |
| attendanceStatus | enum('REGISTERED','COMPLETED','FAILED','ABSENT') | Permitted values: registered, completed, failed, absent. | NO | N | N | — | Records the attendance status of the trainingattendance. |
| completionDate | date | Valid MySQL date value. | YES | N | N | — | Date associated with the trainingattendance record or validity period. |
| renewalDate | date | Valid MySQL date value. | YES | N | N | — | Date associated with the trainingattendance record or validity period. |
| competencyLevel | enum('AWARENESS','COMPETENT','ADVANCED') | Permitted values: awareness, competent, advanced. | YES | N | N | — | Records the competency level of the trainingattendance. |

## `trainingcourse`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| trainingCourseId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | — | Stable identifier for a trainingcourse record. |
| courseName | varchar(120) | Text up to the implemented varchar(120) size. | NO | Y | N | — | Human-readable name used for the trainingcourse record. |
| courseProvider | varchar(120) | Text up to the implemented varchar(120) size. | NO | N | N | — | Records the course provider of the trainingcourse. |
| trainingCategory | enum('SAFETY','SUSTAINABILITY','TECHNICAL','WELLBEING','OTHER') | Permitted values: safety, sustainability, technical, wellbeing, other. | NO | N | N | — | Records the training category of the trainingcourse. |
| renewalMonths | smallint unsigned | Numeric value within the implemented MySQL type. | YES | N | N | — | Records the renewal months of the trainingcourse. |
| isMandatory | tinyint(1) | TRUE/FALSE; default 0. | NO | N | N | — | TRUE/FALSE indicator for is mandatory on the trainingcourse record. |

## `trainingsession`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| trainingSessionId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a trainingsession record. |
| trainingCourseId | char(7) | Text up to the implemented char(7) size. | NO | N | N | trainingcourse.trainingCourseId | Identifies the related trainingcourse record. |
| sessionDate | date | Valid MySQL date value. | NO | N | N | — | Date associated with the trainingsession record or validity period. |
| operationalAreaId | char(6) | Text up to the implemented char(6) size. | YES | N | N | operationalarea.operationalAreaId | Identifies the related operationalarea record. |
| trainerName | varchar(100) | Text up to the implemented varchar(100) size. | NO | N | N | — | Human-readable name used for the trainingsession record. |
| deliveryMode | enum('INPERSON','ONLINE','BLENDED') | Permitted values: inperson, online, blended. | NO | N | N | — | Records the delivery mode of the trainingsession. |

## `vineyard`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| vineyardId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | — | Stable identifier for a vineyard record. |
| vineyardName | varchar(80) | Text up to the implemented varchar(80) size. | NO | Y | N | — | Human-readable name used for the vineyard record. |
| areaHectares | decimal(6,2) | Positive decimal hectares. | NO | N | N | — | Records the area hectares of the vineyard. |
| latitude | decimal(9,6) | Decimal latitude from -90 to 90. | NO | N | N | — | Records the latitude of the vineyard. |
| longitude | decimal(9,6) | Decimal longitude from -180 to 180. | NO | N | N | — | Records the longitude of the vineyard. |
| managerId | char(7) | Text up to the implemented char(7) size. | NO | Y | N | employee.employeeId | Identifies the related employee record. |
| addressId | char(8) | Text up to the implemented char(8) size. | NO | Y | N | address.addressId | Identifies the related address record. |

## `vineyardplanting`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| vineyardId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | vineyard.vineyardId | Identifies the related vineyard record. |
| vintageYear | year | Valid MySQL year value. | NO | Y | Y | — | Records the vintage year of the vineyardplanting. |
| grapeVarietyId | char(7) | Text up to the implemented char(7) size. | NO | N | N | grapevariety.grapeVarietyId | Identifies the related grapevariety record. |
| plantedDate | date | Valid MySQL date value. | YES | N | N | — | Date associated with the vineyardplanting record or validity period. |

## `wellbeingaction`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wellbeingActionId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a wellbeingaction record. |
| wellbeingCheckinId | char(8) | Text up to the implemented char(8) size. | NO | N | N | wellbeingcheckin.wellbeingCheckinId | Identifies the related wellbeingcheckin record. |
| actionDescription | varchar(500) | Text up to the implemented varchar(500) size. | NO | N | N | — | Business description of the wellbeingaction record. |
| targetDate | date | Valid MySQL date value. | NO | N | N | — | Date associated with the wellbeingaction record or validity period. |
| completedDate | date | Valid MySQL date value. | YES | N | N | — | Date associated with the wellbeingaction record or validity period. |
| actionStatus | enum('OPEN','INPROGRESS','COMPLETED','CANCELLED') | Permitted values: open, inprogress, completed, cancelled. | NO | N | N | — | Records the action status of the wellbeingaction. |

## `wellbeingcheckin`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wellbeingCheckinId | char(8) | Text up to the implemented char(8) size. | NO | Y | Y | — | Stable identifier for a wellbeingcheckin record. |
| employeeId | char(7) | Text up to the implemented char(7) size. | NO | N | N | employee.employeeId | Identifies the related employee record. |
| managerId | char(7) | Text up to the implemented char(7) size. | NO | N | N | employee.employeeId | Identifies the related employee record. |
| checkinDate | date | Valid MySQL date value. | NO | N | N | — | Date associated with the wellbeingcheckin record or validity period. |
| concernRaisedFlag | tinyint(1) | TRUE/FALSE. | NO | N | N | — | TRUE/FALSE indicator for concern raised flag on the wellbeingcheckin record. |
| confidentialNote | varchar(1000) | Text up to the implemented varchar(1000) size. | YES | N | N | — | Restricted wellbeing note; excluded from routine management reporting. |

## `wellbeingtopic`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wellbeingTopicId | char(6) | Text up to the implemented char(6) size. | NO | Y | Y | — | Stable identifier for a wellbeingtopic record. |
| topicName | varchar(80) | Text up to the implemented varchar(80) size. | NO | Y | N | — | Human-readable name used for the wellbeingtopic record. |

## `wine`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wineId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | — | Stable identifier for a wine record. |
| wineName | varchar(100) | Text up to the implemented varchar(100) size. | NO | Y | N | — | Human-readable name used for the wine record. |
| vintageYear | year | Valid MySQL year value. | NO | Y | N | — | Records the vintage year of the wine. |
| wineCategoryId | char(5) | Text up to the implemented char(5) size. | NO | N | N | winecategory.wineCategoryId | Identifies the related winecategory record. |
| alcoholPercent | decimal(4,2) | Numeric percentage greater than 0 and no more than 100, except alcohol is capped at 25 as implemented. | NO | N | N | — | Records the alcohol percent of the wine. |
| winemakerId | char(7) | Text up to the implemented char(7) size. | NO | N | N | employee.employeeId | Identifies the related employee record. |

## `winecategory`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wineCategoryId | char(5) | Text up to the implemented char(5) size. | NO | Y | Y | — | Stable identifier for a winecategory record. |
| categoryName | varchar(40) | Text up to the implemented varchar(40) size. | NO | Y | N | — | Human-readable name used for the winecategory record. |

## `winecomposition`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wineId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | wine.wineId | Identifies the related wine record. |
| grapeVarietyId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | grapevariety.grapeVarietyId | Identifies the related grapevariety record. |
| proportionPercent | decimal(5,2) | Numeric percentage greater than 0 and no more than 100, except alcohol is capped at 25 as implemented. | NO | N | N | — | Percentage contribution of a grape variety to a wine composition. |

## `wineproduct`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| productId | char(7) | Text up to the implemented char(7) size. | NO | Y | Y | — | Stable identifier for a wineproduct record. |
| wineId | char(7) | Text up to the implemented char(7) size. | NO | Y | N | wine.wineId | Identifies the related wine record. |
| bottleTypeId | char(7) | Text up to the implemented char(7) size. | NO | Y | N | bottletype.bottleTypeId | Identifies the related bottletype record. |
| caseQuantity | smallint unsigned | Positive numeric value. | NO | Y | N | — | Quantity recorded for the wineproduct transaction or inventory fact. |
| isActive | tinyint(1) | TRUE/FALSE; default 1. | NO | N | N | — | TRUE/FALSE indicator for is active on the wineproduct record. |
