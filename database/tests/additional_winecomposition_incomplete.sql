USE cloudrestwines;
START TRANSACTION;
INSERT INTO wine(wineId,wineName,vintageYear,wineCategoryId,alcoholPercent,winemakerId)
VALUES('WINE099','Incomplete Test Wine',YEAR(CURRENT_DATE),'CAT01',12.50,'EMP0004');
INSERT INTO winecomposition(wineId,grapeVarietyId,proportionPercent)
VALUES('WINE099','GRAPE01',60.00);
-- Expected failure: product release requires a recipe totalling exactly 100 percent.
INSERT INTO wineproduct(productId,wineId,bottleTypeId,caseQuantity,isActive)
VALUES('PROD099','WINE099','BOTL001',12,TRUE);
ROLLBACK;
