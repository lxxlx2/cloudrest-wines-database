# Cloudrest Wines Data Dictionary

The data dictionary was prepared as Word-ready tables and cross-checked against the implemented MySQL schema for consistency. Automation is used internally to prevent schema drift. `Unique = Y` means the attribute is individually unique; membership in a composite primary/unique key does not make each component individually unique.

## `address`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| addressId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a address record. |
| addressKind | enum('PHYSICAL','POSTAL') | Permitted values: physical, postal. | NO | N | N | — | Records address kind required for the address business record. |
| postalType | enum('POBOX','PRIVATEBAG','OTHER') | Permitted values: pobox, privatebag, other. | YES | N | N | — | Records postal type required for the address business record. |
| unitType | varchar(20) | Text within the implemented varchar(20) length. | YES | N | N | — | Records unit type required for the address business record. |
| unitNumber | varchar(12) | Text within the implemented varchar(12) length. | YES | N | N | — | Records unit number required for the address business record. |
| levelType | varchar(20) | Text within the implemented varchar(20) length. | YES | N | N | — | Records level type required for the address business record. |
| levelNumber | varchar(12) | Text within the implemented varchar(12) length. | YES | N | N | — | Records level number required for the address business record. |
| buildingName | varchar(100) | Text within the implemented varchar(100) length. | YES | N | N | — | Human-readable business name of the address. |
| placeName | varchar(100) | Text within the implemented varchar(100) length. | YES | N | N | — | Human-readable business name of the address. |
| addressNumber | varchar(20) | Text within the implemented varchar(20) length. | YES | N | N | — | Records address number required for the address business record. |
| streetName | varchar(120) | Text within the implemented varchar(120) length. | YES | N | N | — | Human-readable business name of the address. |
| locality | varchar(80) | Text within the implemented varchar(80) length. | NO | N | N | — | Records locality required for the address business record. |
| stateCode | enum('ACT','NSW','NT','QLD','SA','TAS','VIC','WA') | Permitted values: act, nsw, nt, qld, sa, tas, vic, wa. | NO | N | N | — | Records state code required for the address business record. |
| postcode | char(4) | Exactly 4 numeric digits. | NO | N | N | — | Records postcode required for the address business record. |

## `bottletype`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| bottleTypeId | char(7) | Text within the implemented char(7) length. | NO | Y | Y | — | Stable business identifier for a bottletype record. |
| capacityMl | smallint unsigned | Positive whole-number millilitres (> 0). | NO | N | N | — | Nominal bottle capacity in millilitres. |
| bottleShape | varchar(40) | Text within the implemented varchar(40) length. | NO | N | N | — | Records bottle shape required for the bottletype business record. |
| material | enum('GLASS','PLASTIC') | Permitted values: glass, plastic. | NO | N | N | — | Records material required for the bottletype business record. |
| bottleColour | varchar(40) | Text within the implemented varchar(40) length. | NO | N | N | — | Records bottle colour required for the bottletype business record. |
| inventoryQuantity | int unsigned | Non-negative whole-number bottle quantity (>= 0). | NO | N | N | — | Current number of bottles of this type held in inventory. |
| usualUnitCost | decimal(8,2) | Non-negative numeric value. | NO | N | N | — | Usual expected procurement cost for one bottle of this type. |
| reorderFlag | tinyint(1) | TRUE/FALSE; default 1. | NO | N | N | — | Indicates whether the winery intends to reorder the bottle type. |
| reorderComment | varchar(500) | Text within the implemented varchar(500) length. | YES | N | N | — | Records the required explanation when a bottle type will not be reordered. |

## `businesscustomer`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | Text within the implemented char(7) length. | NO | Y | Y | customer.customerId | References the related customer record required for this businesscustomer fact. |
| companyName | varchar(120) | Text within the implemented varchar(120) length. | NO | N | N | — | Human-readable business name of the businesscustomer. |
| australianBusinessNumber | char(11) | Exactly 11 numeric digits. | NO | Y | N | — | Australian Business Number identifying a business customer. |
| contactFirstName | varchar(50) | Text within the implemented varchar(50) length. | NO | N | N | — | Human-readable business name of the businesscustomer. |
| contactLastName | varchar(50) | Text within the implemented varchar(50) length. | NO | N | N | — | Human-readable business name of the businesscustomer. |
| businessType | enum('RESTAURANT','WINESHOP','EXPORTCOMPANY','OTHER') | Permitted values: restaurant, wineshop, exportcompany, other. | NO | N | N | — | Records business type required for the businesscustomer business record. |

## `checkintopic`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wellbeingCheckinId | char(8) | Text within the implemented char(8) length. | NO | N | Y | wellbeingcheckin.wellbeingCheckinId | References the related wellbeingcheckin record required for this checkintopic fact. |
| wellbeingTopicId | char(6) | Text within the implemented char(6) length. | NO | N | Y | wellbeingtopic.wellbeingTopicId | References the related wellbeingtopic record required for this checkintopic fact. |

## `correctiveaction`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| correctiveActionId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a correctiveaction record. |
| incidentId | char(8) | Text within the implemented char(8) length. | NO | N | N | incident.incidentId | References the related incident record required for this correctiveaction fact. |
| actionDescription | varchar(500) | Text within the implemented varchar(500) length. | NO | N | N | — | Business description used to explain the correctiveaction. |
| responsibleEmployeeId | char(7) | Text within the implemented char(7) length. | NO | N | N | employee.employeeId | References the related employee record required for this correctiveaction fact. |
| targetDate | date | Valid MySQL date value. | NO | N | N | — | Business date associated with the correctiveaction event or validity period. |
| completedDate | date | Valid MySQL date value. | YES | N | N | — | Business date associated with the correctiveaction event or validity period. |
| actionStatus | enum('OPEN','INPROGRESS','COMPLETED','CANCELLED') | Permitted values: open, inprogress, completed, cancelled. | NO | N | N | — | Records action status required for the correctiveaction business record. |

## `customer`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | Text within the implemented char(7) length. | NO | Y | Y | — | Stable business identifier for a customer record. |
| customerType | enum('INDIVIDUAL','BUSINESS') | Permitted values: individual, business. | NO | N | N | — | Records customer type required for the customer business record. |
| emailAddress | varchar(254) | Text within the implemented varchar(254) length. | NO | Y | N | — | Records email address required for the customer business record. |
| isActive | tinyint(1) | TRUE/FALSE; default 1. | NO | N | N | — | TRUE/FALSE business indicator for is active. |

## `customeraddress`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | Text within the implemented char(7) length. | NO | N | Y | customer.customerId | References the related customer record required for this customeraddress fact. |
| addressId | char(8) | Text within the implemented char(8) length. | NO | N | Y | address.addressId | References the related address record required for this customeraddress fact. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | N | Y | — | Inclusive start date/time of the customeraddress history period. |
| endDateTime | datetime | NULL/open-ended or a value not earlier than the corresponding startDateTime. | YES | N | N | — | Optional end date/time of the customeraddress history period; NULL represents an open-ended period. |

## `customerorder`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerOrderId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a customerorder record. |
| customerId | char(7) | Text within the implemented char(7) length. | NO | N | N | customer.customerId | References the related customer record required for this customerorder fact. |
| receivedDate | date | Valid MySQL date value. | NO | N | N | — | Business date associated with the customerorder event or validity period. |
| paidFlag | tinyint(1) | TRUE/FALSE; default 0. | NO | N | N | — | Accounting confirmation used by the shipment control to determine whether dispatch may proceed. |
| orderStatus | enum('PENDING','SHIPPED','CANCELLED') | Permitted values: pending, shipped, cancelled. | NO | N | N | — | Records order status required for the customerorder business record. |

## `customerphone`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | Text within the implemented char(7) length. | NO | N | Y | customer.customerId | References the related customer record required for this customerphone fact. |
| phoneId | char(8) | Text within the implemented char(8) length. | NO | N | Y | phone.phoneId | References the related phone record required for this customerphone fact. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | N | Y | — | Inclusive start date/time of the customerphone history period. |
| endDateTime | datetime | NULL/open-ended or a value not earlier than the corresponding startDateTime. | YES | N | N | — | Optional end date/time of the customerphone history period; NULL represents an open-ended period. |
| isPrimary | tinyint(1) | TRUE/FALSE; default 0. | NO | N | N | — | TRUE/FALSE business indicator for is primary. |

## `employee`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | Text within the implemented char(7) length. | NO | Y | Y | — | Stable business identifier for a employee record. |
| firstName | varchar(50) | Text within the implemented varchar(50) length. | NO | N | N | — | Human-readable business name of the employee. |
| lastName | varchar(50) | Text within the implemented varchar(50) length. | NO | N | N | — | Human-readable business name of the employee. |
| taxFileNumber | char(9) | Exactly 9 numeric digits. | NO | Y | N | — | Australian tax file number retained as a sensitive HR identifier for authorised administration. |
| employmentStartDate | date | Valid MySQL date value. | NO | N | N | — | Business date associated with the employee event or validity period. |
| employmentEndDate | date | Valid MySQL date value. | YES | N | N | — | Business date associated with the employee event or validity period. |

## `employeeaddress`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | Text within the implemented char(7) length. | NO | N | Y | employee.employeeId | References the related employee record required for this employeeaddress fact. |
| addressId | char(8) | Text within the implemented char(8) length. | NO | N | Y | address.addressId | References the related address record required for this employeeaddress fact. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | N | Y | — | Inclusive start date/time of the employeeaddress history period. |
| endDateTime | datetime | NULL/open-ended or a value not earlier than the corresponding startDateTime. | YES | N | N | — | Optional end date/time of the employeeaddress history period; NULL represents an open-ended period. |

## `employeephone`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | Text within the implemented char(7) length. | NO | N | Y | employee.employeeId | References the related employee record required for this employeephone fact. |
| phoneId | char(8) | Text within the implemented char(8) length. | NO | N | Y | phone.phoneId | References the related phone record required for this employeephone fact. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | N | Y | — | Inclusive start date/time of the employeephone history period. |
| endDateTime | datetime | NULL/open-ended or a value not earlier than the corresponding startDateTime. | YES | N | N | — | Optional end date/time of the employeephone history period; NULL represents an open-ended period. |
| isPrimary | tinyint(1) | TRUE/FALSE; default 0. | NO | N | N | — | TRUE/FALSE business indicator for is primary. |

## `employeequalification`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | Text within the implemented char(7) length. | NO | N | Y | employee.employeeId | References the related employee record required for this employeequalification fact. |
| qualificationId | char(7) | Text within the implemented char(7) length. | NO | N | Y | qualification.qualificationId | References the related qualification record required for this employeequalification fact. |
| awardedDate | date | Valid MySQL date value. | NO | N | Y | — | Business date associated with the employeequalification event or validity period. |
| expiryDate | date | Valid MySQL date value. | YES | N | N | — | Business date associated with the employeequalification event or validity period. |
| certificateReference | varchar(80) | Text within the implemented varchar(80) length. | YES | Y | N | — | Records certificate reference required for the employeequalification business record. |

## `employeerole`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | Text within the implemented char(7) length. | NO | N | Y | employee.employeeId | References the related employee record required for this employeerole fact. |
| roleId | char(6) | Text within the implemented char(6) length. | NO | N | Y | role.roleId | References the related role record required for this employeerole fact. |
| operationalAreaId | char(6) | Text within the implemented char(6) length. | NO | N | N | operationalarea.operationalAreaId | References the related operationalarea record required for this employeerole fact. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | N | Y | — | Inclusive start date/time of the employeerole history period. |
| endDateTime | datetime | NULL/open-ended or a value not earlier than the corresponding startDateTime. | YES | N | N | — | Optional end date/time of the employeerole history period; NULL represents an open-ended period. |
| workTimeType | enum('FULLTIME','PARTTIME') | Permitted values: fulltime, parttime. | NO | N | N | — | Full-time or part-time work-time classification for the role period. |
| employmentType | enum('PERMANENT','CASUAL') | Permitted values: permanent, casual. | NO | N | N | — | Employment engagement category, kept separately from work-time and seasonal pattern. |
| employmentPattern | enum('ONGOING','SEASONAL') | Permitted values: ongoing, seasonal. | NO | N | N | — | Ongoing or seasonal work pattern, independent of permanent/casual engagement. |

## `grapevariety`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| grapeVarietyId | char(7) | Text within the implemented char(7) length. | NO | Y | Y | — | Stable business identifier for a grapevariety record. |
| varietyName | varchar(80) | Text within the implemented varchar(80) length. | NO | Y | N | — | Human-readable business name of the grapevariety. |
| juiceConversionPercent | decimal(5,2) | Percentage greater than 0 and no more than 100. | NO | N | N | — | Expected percentage of harvested grape weight converted to juice for the variety. |
| storageContainer | enum('STAINLESSSTEEL','OAKBARREL','OTHER') | Permitted values: stainlesssteel, oakbarrel, other. | NO | N | N | — | Records storage container required for the grapevariety business record. |
| agingDays | smallint unsigned | Unsigned whole-number days (>= 0). | NO | N | N | — | Usual ageing duration in days for wine made from the grape variety. |

## `harvest`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| harvestId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a harvest record. |
| vineyardId | char(7) | Text within the implemented char(7) length. | NO | N | N | vineyardplanting.vineyardId | References the related vineyardplanting record required for this harvest fact. |
| vintageYear | year | Valid MySQL year value. | NO | N | N | vineyardplanting.vintageYear | Records vintage year required for the harvest business record. |
| harvestedDate | date | Valid MySQL date value. | NO | N | N | — | Business date associated with the harvest event or validity period. |
| weightKg | decimal(12,2) | Positive numeric value. | NO | N | N | — | Records weight kg required for the harvest business record. |
| ripenessSugarPercent | decimal(5,2) | Percentage from 0 to 100 inclusive. | NO | N | N | — | Sugar percentage recorded at harvest as the grape-ripeness measure. |

## `incident`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| incidentId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a incident record. |
| incidentDateTime | datetime | Valid MySQL datetime value. | NO | N | N | — | Records incident date time required for the incident business record. |
| operationalAreaId | char(6) | Text within the implemented char(6) length. | NO | N | N | operationalarea.operationalAreaId | References the related operationalarea record required for this incident fact. |
| incidentType | enum('INJURY','NEARMISS','ILLNESS','EQUIPMENT','ENVIRONMENTAL','OTHER') | Permitted values: injury, nearmiss, illness, equipment, environmental, other. | NO | N | N | — | Records incident type required for the incident business record. |
| severity | enum('LOW','MODERATE','HIGH','CRITICAL') | Permitted values: low, moderate, high, critical. | NO | N | N | — | Incident seriousness classification used for safety follow-up and corrective-action priority. |
| incidentDescription | varchar(1000) | Text within the implemented varchar(1000) length. | NO | N | N | — | Business description used to explain the incident. |
| totalLostHours | decimal(7,2) | Non-negative numeric value. | NO | N | N | — | Labour hours lost because of an incident; zero remains valid for a near miss. |
| reportableFlag | tinyint(1) | TRUE/FALSE; default 0. | NO | N | N | — | Indicates whether the safety incident is classified as reportable; retained separately from the all-incident management KPI. |

## `incidentemployee`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| incidentId | char(8) | Text within the implemented char(8) length. | NO | N | Y | incident.incidentId | References the related incident record required for this incidentemployee fact. |
| employeeId | char(7) | Text within the implemented char(7) length. | NO | N | Y | employee.employeeId | References the related employee record required for this incidentemployee fact. |
| involvementRole | enum('AFFECTED','WITNESS','REPORTER') | Permitted values: affected, witness, reporter. | NO | N | N | — | Records involvement role required for the incidentemployee business record. |
| employeeLostHours | decimal(7,2) | Decimal value within the implemented precision/scale; default 0.00. | NO | N | N | — | Records employee lost hours required for the incidentemployee business record. |

## `individualcustomer`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerId | char(7) | Text within the implemented char(7) length. | NO | Y | Y | customer.customerId | References the related customer record required for this individualcustomer fact. |
| firstName | varchar(50) | Text within the implemented varchar(50) length. | NO | N | N | — | Human-readable business name of the individualcustomer. |
| lastName | varchar(50) | Text within the implemented varchar(50) length. | NO | N | N | — | Human-readable business name of the individualcustomer. |
| dateOfBirth | date | Valid MySQL date value. | NO | N | N | — | Birth date used to demonstrate that an individual customer satisfies the legal-age requirement. |

## `medal`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| medalId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a medal record. |
| wineId | char(7) | Text within the implemented char(7) length. | NO | N | N | wine.wineId | References the related wine record required for this medal fact. |
| medalType | enum('BRONZE','SILVER','GOLD','TROPHY') | Permitted values: bronze, silver, gold, trophy. | NO | N | N | — | Records medal type required for the medal business record. |
| awardYear | year | Valid MySQL year value. | NO | N | N | — | Records award year required for the medal business record. |
| awardingOrganisation | varchar(120) | Text within the implemented varchar(120) length. | NO | N | N | — | Records awarding organisation required for the medal business record. |

## `openincidentaction`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| correctiveActionId | char(8) | Text within the implemented char(8) length. | NO | N | N | — | Stable business identifier for a openincidentaction record. |
| incidentId | char(8) | Text within the implemented char(8) length. | NO | N | N | — | Stable business identifier for a openincidentaction record. |
| incidentDateTime | datetime | Valid MySQL datetime value. | NO | N | N | — | Records incident date time required for the openincidentaction business record. |
| severity | enum('LOW','MODERATE','HIGH','CRITICAL') | Permitted values: low, moderate, high, critical. | NO | N | N | — | Incident seriousness classification used for safety follow-up and corrective-action priority. |
| areaName | varchar(60) | Text within the implemented varchar(60) length. | NO | N | N | — | Human-readable business name of the openincidentaction. |
| actionDescription | varchar(500) | Text within the implemented varchar(500) length. | NO | N | N | — | Business description used to explain the openincidentaction. |
| targetDate | date | Valid MySQL date value. | NO | N | N | — | Business date associated with the openincidentaction event or validity period. |
| actionStatus | enum('OPEN','INPROGRESS','COMPLETED','CANCELLED') | Permitted values: open, inprogress, completed, cancelled. | NO | N | N | — | Records action status required for the openincidentaction business record. |
| responsibleEmployee | varchar(101) | Text within the implemented varchar(101) length. | YES | N | N | — | Records responsible employee required for the openincidentaction business record. |
| daysOverdue | int | Whole number within the implemented MySQL type. | YES | N | N | — | Records days overdue required for the openincidentaction business record. |

## `operationalarea`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| operationalAreaId | char(6) | Text within the implemented char(6) length. | NO | Y | Y | — | Stable business identifier for a operationalarea record. |
| areaName | varchar(60) | Text within the implemented varchar(60) length. | NO | Y | N | — | Human-readable business name of the operationalarea. |
| areaDescription | varchar(255) | Text within the implemented varchar(255) length. | YES | N | N | — | Business description used to explain the operationalarea. |

## `orderline`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| customerOrderId | char(8) | Text within the implemented char(8) length. | NO | N | Y | customerorder.customerOrderId | References the related customerorder record required for this orderline fact. |
| productId | char(7) | Text within the implemented char(7) length. | NO | N | Y | wineproduct.productId | References the related wineproduct record required for this orderline fact. |
| caseQuantity | int unsigned | Positive whole-number case quantity (> 0). | NO | N | N | — | Number of cases of the product requested on the customer order line. |
| agreedCasePrice | decimal(10,2) | Positive numeric value. | NO | N | N | — | Case price agreed for the product when the customer order was placed. |

## `packmember`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| pickerPackId | char(7) | Text within the implemented char(7) length. | NO | N | Y | pickerpack.pickerPackId | References the related pickerpack record required for this packmember fact. |
| employeeId | char(7) | Text within the implemented char(7) length. | NO | N | Y | employee.employeeId | References the related employee record required for this packmember fact. |
| joinedDate | date | Valid MySQL date value. | NO | N | N | — | Business date associated with the packmember event or validity period. |
| leftDate | date | Valid MySQL date value. | YES | N | N | — | Business date associated with the packmember event or validity period. |

## `phone`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| phoneId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a phone record. |
| countryCode | varchar(4) | Text within the implemented varchar(4) length; default +61. | NO | N | N | — | Records country code required for the phone business record. |
| phoneNumber | varchar(20) | Text within the implemented varchar(20) length. | NO | N | N | — | Records phone number required for the phone business record. |
| phoneType | enum('MOBILE','WORK','HOME','OTHER') | Permitted values: mobile, work, home, other. | NO | N | N | — | Records phone type required for the phone business record. |

## `pickerpack`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| pickerPackId | char(7) | Text within the implemented char(7) length. | NO | Y | Y | — | Stable business identifier for a pickerpack record. |
| packName | varchar(60) | Text within the implemented varchar(60) length. | NO | Y | N | — | Human-readable business name of the pickerpack. |
| supervisorId | char(7) | Text within the implemented char(7) length. | NO | N | N | employee.employeeId | Grape-farmer employee responsible for supervising the picking pack during the season. |
| seasonYear | year | Valid MySQL year value. | NO | N | N | — | Records season year required for the pickerpack business record. |

## `productprice`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| productId | char(7) | Text within the implemented char(7) length. | NO | N | Y | wineproduct.productId | References the related wineproduct record required for this productprice fact. |
| effectiveDate | date | Valid MySQL date value. | NO | N | Y | — | Date on which the productprice value becomes effective. |
| endDate | date | NULL/open-ended or a value not earlier than the corresponding start/effective date. | YES | N | N | — | Optional final effective date for the productprice value; NULL represents an open-ended period. |
| casePrice | decimal(10,2) | Positive numeric value. | NO | N | N | — | Sale price for one case of the product during the effective date period. |

## `purchaseorder`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| purchaseOrderId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a purchaseorder record. |
| supplierId | char(7) | Text within the implemented char(7) length. | NO | N | N | supplier.supplierId | References the related supplier record required for this purchaseorder fact. |
| orderedDate | date | Valid MySQL date value. | NO | N | N | — | Business date associated with the purchaseorder event or validity period. |
| orderStatus | enum('PLACED','PARTRECEIVED','RECEIVED','CANCELLED') | Permitted values: placed, partreceived, received, cancelled. | NO | N | N | — | Records order status required for the purchaseorder business record. |

## `purchaseorderline`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| purchaseOrderId | char(8) | Text within the implemented char(8) length. | NO | N | Y | purchaseorder.purchaseOrderId | References the related purchaseorder record required for this purchaseorderline fact. |
| bottleTypeId | char(7) | Text within the implemented char(7) length. | NO | N | Y | bottletype.bottleTypeId | References the related bottletype record required for this purchaseorderline fact. |
| orderedQuantity | int unsigned | Positive whole-number quantity (> 0). | NO | N | N | — | Number of bottle units ordered on the purchase-order line. |
| quotedUnitPrice | decimal(8,2) | Non-negative numeric value. | YES | N | N | — | Supplier quoted unit price for the bottle type on the purchase order. |

## `qualification`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| qualificationId | char(7) | Text within the implemented char(7) length. | NO | Y | Y | — | Stable business identifier for a qualification record. |
| qualificationName | varchar(120) | Text within the implemented varchar(120) length. | NO | Y | N | — | Human-readable business name of the qualification. |
| issuingAuthority | varchar(120) | Text within the implemented varchar(120) length. | NO | N | N | — | TRUE/FALSE business indicator for issuing authority. |
| defaultValidityMonths | smallint unsigned | Non-negative whole number within the implemented unsigned MySQL type. | YES | N | N | — | Records default validity months required for the qualification business record. |
| isSafetyCritical | tinyint(1) | TRUE/FALSE; default 0. | NO | N | N | — | TRUE/FALSE business indicator for is safety critical. |

## `receipt`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| receiptId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a receipt record. |
| purchaseOrderId | char(8) | Text within the implemented char(8) length. | NO | N | N | purchaseorder.purchaseOrderId | References the related purchaseorder record required for this receipt fact. |
| receivedDate | date | Valid MySQL date value. | NO | N | N | — | Business date associated with the receipt event or validity period. |

## `receiptline`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| receiptId | char(8) | Text within the implemented char(8) length. | NO | N | Y | receipt.receiptId | References the related receipt record required for this receiptline fact. |
| bottleTypeId | char(7) | Text within the implemented char(7) length. | NO | N | Y | bottletype.bottleTypeId | References the related bottletype record required for this receiptline fact. |
| receivedQuantity | int unsigned | Positive whole-number quantity (> 0). | NO | N | N | — | Number of bottle units actually received on the receipt line. |
| actualUnitPrice | decimal(8,2) | Non-negative numeric value. | NO | N | N | — | Actual unit price paid/recorded for the bottle type on this receipt. |

## `refund`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| refundId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a refund record. |
| customerOrderId | char(8) | Text within the implemented char(8) length. | NO | N | N | customerorder.customerOrderId | References the related customerorder record required for this refund fact. |
| refundDate | date | Valid MySQL date value. | NO | N | N | — | Business date associated with the refund event or validity period. |
| refundReason | enum('SHORTSUPPLY','TRANSITDAMAGE') | Permitted values: shortsupply, transitdamage. | NO | N | N | — | Records refund reason required for the refund business record. |
| verifiedFlag | tinyint(1) | TRUE/FALSE. | NO | N | N | — | TRUE/FALSE business indicator for verified flag. |
| refundAmount | decimal(10,2) | Non-negative numeric value. | NO | N | N | — | Monetary amount recorded for the refund fact in Australian dollars. |

## `role`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| roleId | char(6) | Text within the implemented char(6) length. | NO | Y | Y | — | Stable business identifier for a role record. |
| roleName | varchar(80) | Text within the implemented varchar(80) length. | NO | Y | N | — | Human-readable business name of the role. |
| roleDescription | varchar(255) | Text within the implemented varchar(255) length. | NO | N | N | — | Business description used to explain the role. |

## `seasonalrating`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | Text within the implemented char(7) length. | NO | N | Y | employee.employeeId | References the related employee record required for this seasonalrating fact. |
| seasonYear | year | Valid MySQL year value. | NO | N | Y | — | Records season year required for the seasonalrating business record. |
| supervisorId | char(7) | Text within the implemented char(7) length. | NO | N | N | employee.employeeId | References the related employee record required for this seasonalrating fact. |
| ratingValue | tinyint | Integer from 1 to 5 inclusive. | NO | N | N | — | Records rating value required for the seasonalrating business record. |
| recommendReemployment | tinyint(1) | TRUE/FALSE. | NO | N | N | — | Records recommend reemployment required for the seasonalrating business record. |
| ratingComment | varchar(500) | Text within the implemented varchar(500) length. | YES | N | N | — | Records rating comment required for the seasonalrating business record. |

## `shift`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| shiftId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a shift record. |
| shiftDate | date | Valid MySQL date value. | NO | N | N | — | Business date associated with the shift event or validity period. |
| startTime | time | Valid MySQL time value. | NO | N | N | — | Records start time required for the shift business record. |
| endTime | time | Valid MySQL time value. | NO | N | N | — | Records end time required for the shift business record. |
| operationalAreaId | char(6) | Text within the implemented char(6) length. | NO | N | N | operationalarea.operationalAreaId | References the related operationalarea record required for this shift fact. |
| taskCategoryId | char(6) | Text within the implemented char(6) length. | NO | N | N | taskcategory.taskCategoryId | References the related taskcategory record required for this shift fact. |
| supervisorId | char(7) | Text within the implemented char(7) length. | NO | N | N | employee.employeeId | References the related employee record required for this shift fact. |

## `shiftassignment`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| shiftId | char(8) | Text within the implemented char(8) length. | NO | N | Y | shift.shiftId | References the related shift record required for this shiftassignment fact. |
| employeeId | char(7) | Text within the implemented char(7) length. | NO | N | Y | employee.employeeId | References the related employee record required for this shiftassignment fact. |
| regularHours | decimal(4,2) | Hours greater than 0 and no more than 16; combined regular plus overtime hours no more than 18. | NO | N | N | — | Regular labour hours worked by an employee on the assigned shift. |
| overtimeHours | decimal(4,2) | Non-negative hours; combined regular plus overtime hours no more than 18. | NO | N | N | — | Overtime labour hours used for workload and safety exposure analysis. |

## `shipment`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| shipmentId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a shipment record. |
| customerOrderId | char(8) | Text within the implemented char(8) length. | NO | Y | N | customerorder.customerOrderId | References the related customerorder record required for this shipment fact. |
| addressId | char(8) | Text within the implemented char(8) length. | NO | N | N | address.addressId | Physical customer address actually used for the shipment after current-address validation. |
| shippedDate | date | Valid MySQL date value. | NO | N | N | — | Business date associated with the shipment event or validity period. |

## `supervision`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| employeeId | char(7) | Text within the implemented char(7) length. | NO | N | Y | employee.employeeId | References the related employee record required for this supervision fact. |
| supervisorId | char(7) | Text within the implemented char(7) length. | NO | N | N | employee.employeeId | References the related employee record required for this supervision fact. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | N | Y | — | Inclusive start date/time of the supervision history period. |
| endDateTime | datetime | NULL/open-ended or a value not earlier than the corresponding startDateTime. | YES | N | N | — | Optional end date/time of the supervision history period; NULL represents an open-ended period. |

## `supplier`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| supplierId | char(7) | Text within the implemented char(7) length. | NO | Y | Y | — | Stable business identifier for a supplier record. |
| supplierName | varchar(120) | Text within the implemented varchar(120) length. | NO | Y | N | — | Human-readable business name of the supplier. |
| contactFirstName | varchar(50) | Text within the implemented varchar(50) length. | NO | N | N | — | Human-readable business name of the supplier. |
| contactLastName | varchar(50) | Text within the implemented varchar(50) length. | NO | N | N | — | Human-readable business name of the supplier. |
| contactEmail | varchar(254) | Text within the implemented varchar(254) length. | NO | N | N | — | Records contact email required for the supplier business record. |

## `supplieraddress`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| supplierId | char(7) | Text within the implemented char(7) length. | NO | N | Y | supplier.supplierId | References the related supplier record required for this supplieraddress fact. |
| addressId | char(8) | Text within the implemented char(8) length. | NO | N | Y | address.addressId | References the related address record required for this supplieraddress fact. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | N | Y | — | Inclusive start date/time of the supplieraddress history period. |
| endDateTime | datetime | NULL/open-ended or a value not earlier than the corresponding startDateTime. | YES | N | N | — | Optional end date/time of the supplieraddress history period; NULL represents an open-ended period. |

## `supplierbottle`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| supplierId | char(7) | Text within the implemented char(7) length. | NO | N | Y | supplier.supplierId | References the related supplier record required for this supplierbottle fact. |
| bottleTypeId | char(7) | Text within the implemented char(7) length. | NO | N | Y | bottletype.bottleTypeId | References the related bottletype record required for this supplierbottle fact. |
| supplierBottleCode | varchar(40) | Text within the implemented varchar(40) length. | YES | N | N | — | Records supplier bottle code required for the supplierbottle business record. |
| isAvailable | tinyint(1) | TRUE/FALSE; default 1. | NO | N | N | — | TRUE/FALSE business indicator for is available. |

## `supplierphone`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| supplierId | char(7) | Text within the implemented char(7) length. | NO | N | Y | supplier.supplierId | References the related supplier record required for this supplierphone fact. |
| phoneId | char(8) | Text within the implemented char(8) length. | NO | N | Y | phone.phoneId | References the related phone record required for this supplierphone fact. |
| startDateTime | datetime | Valid MySQL datetime value. | NO | N | Y | — | Inclusive start date/time of the supplierphone history period. |
| endDateTime | datetime | NULL/open-ended or a value not earlier than the corresponding startDateTime. | YES | N | N | — | Optional end date/time of the supplierphone history period; NULL represents an open-ended period. |
| isPrimary | tinyint(1) | TRUE/FALSE; default 0. | NO | N | N | — | TRUE/FALSE business indicator for is primary. |

## `taskcategory`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| taskCategoryId | char(6) | Text within the implemented char(6) length. | NO | Y | Y | — | Stable business identifier for a taskcategory record. |
| categoryName | varchar(60) | Text within the implemented varchar(60) length. | NO | Y | N | — | Human-readable business name of the taskcategory. |

## `trainingattendance`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| trainingSessionId | char(8) | Text within the implemented char(8) length. | NO | N | Y | trainingsession.trainingSessionId | References the related trainingsession record required for this trainingattendance fact. |
| employeeId | char(7) | Text within the implemented char(7) length. | NO | N | Y | employee.employeeId | References the related employee record required for this trainingattendance fact. |
| attendanceStatus | enum('REGISTERED','COMPLETED','FAILED','ABSENT') | Permitted values: registered, completed, failed, absent. | NO | N | N | — | Records attendance status required for the trainingattendance business record. |
| completionDate | date | Valid MySQL date value. | YES | N | N | — | Business date associated with the trainingattendance event or validity period. |
| renewalDate | date | Valid MySQL date value. | YES | N | N | — | Business date associated with the trainingattendance event or validity period. |
| competencyLevel | enum('AWARENESS','COMPETENT','ADVANCED') | Permitted values: awareness, competent, advanced. | YES | N | N | — | Records competency level required for the trainingattendance business record. |

## `trainingcourse`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| trainingCourseId | char(7) | Text within the implemented char(7) length. | NO | Y | Y | — | Stable business identifier for a trainingcourse record. |
| courseName | varchar(120) | Text within the implemented varchar(120) length. | NO | Y | N | — | Human-readable business name of the trainingcourse. |
| courseProvider | varchar(120) | Text within the implemented varchar(120) length. | NO | N | N | — | Records course provider required for the trainingcourse business record. |
| trainingCategory | enum('SAFETY','SUSTAINABILITY','TECHNICAL','WELLBEING','OTHER') | Permitted values: safety, sustainability, technical, wellbeing, other. | NO | N | N | — | Records training category required for the trainingcourse business record. |
| renewalMonths | smallint unsigned | Non-negative whole number within the implemented unsigned MySQL type. | YES | N | N | — | Records renewal months required for the trainingcourse business record. |
| isMandatory | tinyint(1) | TRUE/FALSE; default 0. | NO | N | N | — | TRUE/FALSE business indicator for is mandatory. |

## `trainingsession`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| trainingSessionId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a trainingsession record. |
| trainingCourseId | char(7) | Text within the implemented char(7) length. | NO | N | N | trainingcourse.trainingCourseId | References the related trainingcourse record required for this trainingsession fact. |
| sessionDate | date | Valid MySQL date value. | NO | N | N | — | Business date associated with the trainingsession event or validity period. |
| operationalAreaId | char(6) | Text within the implemented char(6) length. | YES | N | N | operationalarea.operationalAreaId | References the related operationalarea record required for this trainingsession fact. |
| trainerName | varchar(100) | Text within the implemented varchar(100) length. | NO | N | N | — | Human-readable business name of the trainingsession. |
| deliveryMode | enum('INPERSON','ONLINE','BLENDED') | Permitted values: inperson, online, blended. | NO | N | N | — | Records delivery mode required for the trainingsession business record. |

## `vineyard`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| vineyardId | char(7) | Text within the implemented char(7) length. | NO | Y | Y | — | Stable business identifier for a vineyard record. |
| vineyardName | varchar(80) | Text within the implemented varchar(80) length. | NO | Y | N | — | Human-readable business name of the vineyard. |
| areaHectares | decimal(6,2) | Positive decimal hectares (> 0). | NO | N | N | — | Records area hectares required for the vineyard business record. |
| latitude | decimal(9,6) | Decimal latitude from -90 to 90 inclusive. | NO | N | N | — | Records latitude required for the vineyard business record. |
| longitude | decimal(9,6) | Decimal longitude from -180 to 180 inclusive. | NO | N | N | — | Records longitude required for the vineyard business record. |
| managerId | char(7) | Text within the implemented char(7) length. | NO | Y | N | employee.employeeId | Current grape-farmer employee responsible for managing the vineyard. |
| addressId | char(8) | Text within the implemented char(8) length. | NO | Y | N | address.addressId | References the related address record required for this vineyard fact. |

## `vineyardplanting`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| vineyardId | char(7) | Text within the implemented char(7) length. | NO | N | Y | vineyard.vineyardId | References the related vineyard record required for this vineyardplanting fact. |
| vintageYear | year | Valid MySQL year value. | NO | N | Y | — | Records vintage year required for the vineyardplanting business record. |
| grapeVarietyId | char(7) | Text within the implemented char(7) length. | NO | N | N | grapevariety.grapeVarietyId | References the related grapevariety record required for this vineyardplanting fact. |
| plantedDate | date | Valid MySQL date value. | YES | N | N | — | Business date associated with the vineyardplanting event or validity period. |

## `wellbeingaction`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wellbeingActionId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a wellbeingaction record. |
| wellbeingCheckinId | char(8) | Text within the implemented char(8) length. | NO | N | N | wellbeingcheckin.wellbeingCheckinId | References the related wellbeingcheckin record required for this wellbeingaction fact. |
| actionDescription | varchar(500) | Text within the implemented varchar(500) length. | NO | N | N | — | Business description used to explain the wellbeingaction. |
| targetDate | date | Valid MySQL date value. | NO | N | N | — | Business date associated with the wellbeingaction event or validity period. |
| completedDate | date | Valid MySQL date value. | YES | N | N | — | Business date associated with the wellbeingaction event or validity period. |
| actionStatus | enum('OPEN','INPROGRESS','COMPLETED','CANCELLED') | Permitted values: open, inprogress, completed, cancelled. | NO | N | N | — | Records action status required for the wellbeingaction business record. |

## `wellbeingcheckin`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wellbeingCheckinId | char(8) | Text within the implemented char(8) length. | NO | Y | Y | — | Stable business identifier for a wellbeingcheckin record. |
| employeeId | char(7) | Text within the implemented char(7) length. | NO | N | N | employee.employeeId | References the related employee record required for this wellbeingcheckin fact. |
| managerId | char(7) | Text within the implemented char(7) length. | NO | N | N | employee.employeeId | References the related employee record required for this wellbeingcheckin fact. |
| checkinDate | date | Valid MySQL date value. | NO | N | N | — | Business date associated with the wellbeingcheckin event or validity period. |
| concernRaisedFlag | tinyint(1) | TRUE/FALSE. | NO | N | N | — | TRUE/FALSE business indicator for concern raised flag. |
| confidentialNote | varchar(1000) | Text within the implemented varchar(1000) length. | YES | N | N | — | Restricted wellbeing note excluded from routine management query output. |

## `wellbeingtopic`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wellbeingTopicId | char(6) | Text within the implemented char(6) length. | NO | Y | Y | — | Stable business identifier for a wellbeingtopic record. |
| topicName | varchar(80) | Text within the implemented varchar(80) length. | NO | Y | N | — | Human-readable business name of the wellbeingtopic. |

## `wine`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wineId | char(7) | Text within the implemented char(7) length. | NO | Y | Y | — | Stable business identifier for a wine record. |
| wineName | varchar(100) | Text within the implemented varchar(100) length. | NO | N | N | — | Human-readable business name of the wine. |
| vintageYear | year | Valid MySQL year value. | NO | N | N | — | Records vintage year required for the wine business record. |
| wineCategoryId | char(5) | Text within the implemented char(5) length. | NO | N | N | winecategory.wineCategoryId | References the related winecategory record required for this wine fact. |
| alcoholPercent | decimal(4,2) | Percentage greater than 0 and no more than 25. | NO | N | N | — | Records alcohol percent required for the wine business record. |
| winemakerId | char(7) | Text within the implemented char(7) length. | NO | N | N | employee.employeeId | References the related employee record required for this wine fact. |

## `winecategory`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wineCategoryId | char(5) | Text within the implemented char(5) length. | NO | Y | Y | — | Stable business identifier for a winecategory record. |
| categoryName | varchar(40) | Text within the implemented varchar(40) length. | NO | Y | N | — | Human-readable business name of the winecategory. |

## `winecomposition`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| wineId | char(7) | Text within the implemented char(7) length. | NO | N | Y | wine.wineId | References the related wine record required for this winecomposition fact. |
| grapeVarietyId | char(7) | Text within the implemented char(7) length. | NO | N | Y | grapevariety.grapeVarietyId | References the related grapevariety record required for this winecomposition fact. |
| proportionPercent | decimal(5,2) | Percentage greater than 0 and no more than 100. | NO | N | N | — | Percentage contribution of a grape variety to a wine recipe. |

## `wineproduct`

| Attribute | Type/size | Domain/default | Null | Unique | PK | FK reference | Definition/business purpose |
|---|---|---|:---:|:---:|:---:|---|---|
| productId | char(7) | Text within the implemented char(7) length. | NO | Y | Y | — | Stable business identifier for a wineproduct record. |
| wineId | char(7) | Text within the implemented char(7) length. | NO | N | N | wine.wineId | References the related wine record required for this wineproduct fact. |
| bottleTypeId | char(7) | Text within the implemented char(7) length. | NO | N | N | bottletype.bottleTypeId | References the related bottletype record required for this wineproduct fact. |
| caseQuantity | smallint unsigned | Positive whole-number bottles per case (> 0). | NO | N | N | — | Number of bottles packaged in one saleable case of this wine product. |
| isActive | tinyint(1) | TRUE/FALSE; default 1. | NO | N | N | — | TRUE/FALSE business indicator for is active. |
