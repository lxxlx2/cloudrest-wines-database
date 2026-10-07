-- Official A2 workbook v4 staging schema.
-- Source: BISM2207 A2 Sem 2 2026 Data v4(1).xlsx
-- SHA-256: 88362589a519b6f9aeae031fe806bcf85f0d8b513c12b11f6a4e619ee855c4ac
--
-- Export each worksheet to UTF-8 CSV without editing the workbook. Render Excel
-- dates as YYYY-MM-DD and times as HH:MM:SS before import so source values remain
-- auditable. sourceRowNumber is the original Excel row number.

CREATE DATABASE IF NOT EXISTS cloudreststaging
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE cloudreststaging;

DROP TABLE IF EXISTS stg_v4_orders;
CREATE TABLE stg_v4_orders (
  sourceRowNumber INT UNSIGNED PRIMARY KEY,
  orderIdRaw VARCHAR(40) NULL,
  customerIdRaw VARCHAR(40) NULL,
  orderDateRaw VARCHAR(40) NULL,
  productIdRaw VARCHAR(40) NULL,
  wineNameRaw VARCHAR(200) NULL,
  casesOrderedRaw VARCHAR(40) NULL,
  pricePerCaseRaw VARCHAR(40) NULL,
  totalPaidRaw VARCHAR(40) NULL,
  casesDamagedRaw VARCHAR(40) NULL,
  refundAmountRaw VARCHAR(40) NULL,
  shipmentStatusRaw VARCHAR(80) NULL,
  paymentStatusRaw VARCHAR(80) NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_bin;

DROP TABLE IF EXISTS stg_v4_starting_address;
CREATE TABLE stg_v4_starting_address (
  sourceRowNumber INT UNSIGNED PRIMARY KEY,
  addressIdRaw VARCHAR(40) NULL,
  unitTypeNumberRaw VARCHAR(120) NULL,
  levelTypeNumberRaw VARCHAR(120) NULL,
  buildingPropertyNameRaw VARCHAR(200) NULL,
  placeNameRaw VARCHAR(200) NULL,
  fullAddressRaw VARCHAR(500) NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_bin;

DROP TABLE IF EXISTS stg_v4_customer_address_history;
CREATE TABLE stg_v4_customer_address_history (
  sourceRowNumber INT UNSIGNED PRIMARY KEY,
  customerIdRaw VARCHAR(40) NULL,
  addressIdRaw VARCHAR(40) NULL,
  startDateRaw VARCHAR(40) NULL,
  startTimeRaw VARCHAR(40) NULL,
  endDateRaw VARCHAR(40) NULL,
  endTimeRaw VARCHAR(40) NULL,
  addressTypeRaw VARCHAR(80) NULL,
  commentsRaw VARCHAR(500) NULL,
  customerTypeRaw VARCHAR(80) NULL,
  companyNameRaw VARCHAR(200) NULL,
  abnRaw VARCHAR(80) NULL,
  firstNameRaw VARCHAR(120) NULL,
  lastNameRaw VARCHAR(120) NULL,
  dateOfBirthRaw VARCHAR(40) NULL,
  emailRaw VARCHAR(254) NULL,
  phone1Raw VARCHAR(80) NULL,
  phone2Raw VARCHAR(80) NULL,
  phone3Raw VARCHAR(80) NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_bin;

-- Import commands are intentionally not hard-coded here because local CSV paths
-- differ by student machine. Preserve sourceRowNumber during import.
