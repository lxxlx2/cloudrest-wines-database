USE cloudrestwines;
-- Additional control, not one of the five assessed Task 3b rules.
INSERT INTO customer VALUES ('CUST099','INDIVIDUAL','underage@example.test',TRUE);
INSERT INTO individualcustomer VALUES ('CUST099','Test','Minor',DATE_SUB(CURRENT_DATE,INTERVAL 17 YEAR));
