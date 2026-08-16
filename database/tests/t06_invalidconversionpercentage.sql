USE cloudrestwines;
-- Expected failure: the juice conversion ratio is a percentage and cannot exceed 100%.
INSERT INTO grapevariety VALUES
('GRAP099','Invalid Test Variety',120.00,'STAINLESSSTEEL',30);
