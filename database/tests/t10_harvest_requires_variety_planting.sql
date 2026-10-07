USE cloudrestwines;
-- Expected failure: no vineyardplanting row exists for GRAPE99.
INSERT INTO harvest
(harvestId,vineyardId,vintageYear,grapeVarietyId,harvestedDate,weightKg,ripenessSugarPercent)
VALUES('HARV0099','VINE001',YEAR(CURRENT_DATE),'GRAPE99',CURRENT_DATE,100.00,20.00);
