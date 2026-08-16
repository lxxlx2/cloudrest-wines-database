-- Cloudrest Wines — Task 3b business-rule violation demonstrations.
-- Run each numbered block separately in MySQL Workbench so each expected error is visible.
USE cloudrestwines;

-- RULE 1: an employee role end date/time cannot precede its start date/time.
INSERT INTO employee VALUES ('EMP9999','Test','InvalidDate','998877665','2026-01-01',NULL);
INSERT INTO employeerole VALUES
('EMP9999','ROLE07','AREA04','2026-06-01 09:00:00','2026-05-01 09:00:00','PARTTIME','PERMANENT');
-- Expected: Error 3819, chk_employeerole_dates is violated.

-- RULE 2: a bottle that will not be reordered must include a comment.
INSERT INTO bottletype VALUES
('BOTL099',750,'Test','GLASS','Green',0,1.00,FALSE,NULL);
-- Expected: Error 3819, chk_bottletype_reorder is violated.

-- RULE 3: an individual customer must be at least 18 years old.
INSERT INTO customer VALUES ('CUST099','INDIVIDUAL','underage@example.test',TRUE);
INSERT INTO individualcustomer VALUES
('CUST099','Test','Underage',DATE_SUB(CURRENT_DATE,INTERVAL 17 YEAR));
-- Expected: Error 1644 from trg_individualcustomer_legalage_insert.

-- RULE 4: an order cannot be shipped to a PO Box/private bag.
INSERT INTO customerorder VALUES ('CORD0099','CUST001',CURRENT_DATE,TRUE,'PENDING');
INSERT INTO orderline VALUES ('CORD0099','PROD001',1,360.00);
INSERT INTO shipment VALUES ('SHIP0099','CORD0099','ADDR0004',CURRENT_DATE);
-- Expected: Error 1644 from trg_shipment_validate_insert.

-- RULE 5: grape juice conversion is a percentage in the range above 0 through 100.
INSERT INTO grapevariety VALUES
('GRAP099','Invalid Test Variety',120.00,'STAINLESSSTEEL',30);
-- Expected: Error 3819, chk_grapevariety_conversion is violated.
