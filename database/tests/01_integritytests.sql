USE cloudrestwines;

-- T1 positive: a valid completed training attendance row is accepted.
START TRANSACTION;
INSERT INTO trainingattendance VALUES
('TRSE0004','EMP0007','COMPLETED',DATE_SUB(CURRENT_DATE,INTERVAL 60 DAY),DATE_ADD(CURRENT_DATE,INTERVAL 670 DAY),'COMPETENT');
ROLLBACK;

-- T2 negative: an employee role cannot end before it starts (CHECK failure expected).
INSERT INTO employeerole VALUES
('EMP0007','ROLE07','AREA04','2026-06-01 09:00:00','2026-05-01 09:00:00','PARTTIME','PERMANENT');

-- T3 negative: reorder disabled without a comment (CHECK failure expected).
INSERT INTO bottletype VALUES
('BOTL099',750,'Test','GLASS','Green',0,1.00,FALSE,NULL);

-- T4 negative: a referenced course cannot be deleted (FK RESTRICT failure expected).
DELETE FROM trainingcourse WHERE trainingCourseId = 'TRCR001';

-- T5 negative: a paid order cannot be shipped to a PO Box (trigger failure expected).
INSERT INTO shipment VALUES
('SHIP0099','CORD0001','ADDR0004',CURRENT_DATE);

