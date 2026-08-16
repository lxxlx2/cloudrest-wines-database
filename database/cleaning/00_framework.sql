-- Cloudrest Wines supplied-data cleaning framework.
-- Do not invent source columns: create staging tables only after the official A2 workbook is received.
CREATE DATABASE IF NOT EXISTS cloudreststaging CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

-- Required workflow for each supplied worksheet:
-- 1. CREATE TABLE cloudreststaging.stg<table> using VARCHAR/TEXT source-preserving columns.
-- 2. Record source row count and file/sheet metadata.
-- 3. Detect blanks, duplicates, invalid formats/domains/dates and orphan references.
-- 4. Write deterministic corrections as explicit UPDATE statements.
-- 5. Insert ambiguous rows into an exception table; never guess.
-- 6. Load accepted rows into cloudrestwines in FK dependency order.
-- 7. Reconcile source = accepted + rejected and capture before/after evidence.

CREATE TABLE IF NOT EXISTS cloudreststaging.importaudit (
  importAuditId BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  sourceFileName VARCHAR(255) NOT NULL,
  sourceSheetName VARCHAR(120) NOT NULL,
  fileHashSha256 CHAR(64) NOT NULL,
  importedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  sourceRowCount INT UNSIGNED NOT NULL,
  acceptedRowCount INT UNSIGNED NULL,
  rejectedRowCount INT UNSIGNED NULL,
  notes VARCHAR(1000) NULL,
  CONSTRAINT chk_importaudit_reconciliation CHECK (
    acceptedRowCount IS NULL OR rejectedRowCount IS NULL
    OR sourceRowCount = acceptedRowCount + rejectedRowCount
  )
);
CREATE TABLE IF NOT EXISTS cloudreststaging.dataexception (
  dataExceptionId BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  importAuditId BIGINT UNSIGNED NOT NULL,
  sourceRowNumber INT UNSIGNED NOT NULL,
  sourceIdentifier VARCHAR(120) NULL,
  errorCategory ENUM('COMPLETENESS','UNIQUENESS','VALIDITY','CONSISTENCY','ACCURACY','REFERENTIAL') NOT NULL,
  fieldName VARCHAR(120) NULL,
  sourceValue TEXT NULL,
  issueDescription VARCHAR(500) NOT NULL,
  resolutionStatus ENUM('OPEN','AUTOCORRECTED','MANUALLYCORRECTED','REJECTED') NOT NULL DEFAULT 'OPEN',
  resolutionNote VARCHAR(500) NULL,
  CONSTRAINT fk_dataexception_audit FOREIGN KEY (importAuditId)
    REFERENCES cloudreststaging.importaudit(importAuditId)
    ON UPDATE CASCADE ON DELETE CASCADE
);
