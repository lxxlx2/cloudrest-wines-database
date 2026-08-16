USE cloudrestwines;
-- Execute each assessed violation separately after rebuilding the clean database.

-- Rule 1: role end cannot precede start (expect CHECK 3819).
INSERT INTO employeerole VALUES
('EMP0007','ROLE07','AREA04','2026-06-01 09:00:00','2026-05-01 09:00:00','PARTTIME','PERMANENT','ONGOING');

-- Rule 2: reorder FALSE requires a nonblank comment (expect CHECK 3819).
INSERT INTO bottletype VALUES
('BOTL099',750,'Test','GLASS','Green',0,1.00,FALSE,NULL);

-- Rule 3: shipment must use the customer's current physical address (expect Error 1644).
INSERT INTO shipment VALUES ('SHIP0999','CORD0001','ADDR0004',CURRENT_DATE);

-- Rule 4: order must be paid before shipment (expect Error 1644).
INSERT INTO customerorder VALUES ('CORD0998','CUST001',CURRENT_DATE,FALSE,'PENDING');
INSERT INTO shipment VALUES ('SHIP0998','CORD0998','ADDR0003',CURRENT_DATE);

-- Rule 5: supervised employee has only one supervisor at a point in time (expect Error 1644).
INSERT INTO supervision VALUES ('EMP0008','EMP0001','2026-02-01 09:00:00',NULL);
