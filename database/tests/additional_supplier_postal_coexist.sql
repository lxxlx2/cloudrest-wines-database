USE cloudrestwines;
START TRANSACTION;
INSERT INTO address VALUES
('ADDR9001','POSTAL','POBOX',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Dandenong','VIC','3175');
INSERT INTO supplieraddress VALUES
('SUPP001','ADDR9001',NOW(),NULL);
SELECT 'PASS: supplier physical and postal addresses coexist' AS testResult;
ROLLBACK;
