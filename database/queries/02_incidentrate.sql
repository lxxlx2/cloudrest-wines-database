USE cloudrestwines;
-- Sustainability measure: incidents per 1,000 labour hours during the last 12 months.
WITH hoursbyarea AS (
  SELECT s.operationalAreaId, SUM(sa.regularHours + sa.overtimeHours) AS labourHours
  FROM shift s JOIN shiftassignment sa ON sa.shiftId = s.shiftId
  WHERE s.shiftDate >= DATE_SUB(CURRENT_DATE, INTERVAL 12 MONTH)
  GROUP BY s.operationalAreaId
), incidentsbyarea AS (
  SELECT operationalAreaId, COUNT(*) AS incidentCount, SUM(totalLostHours) AS lostHours
  FROM incident
  WHERE incidentDateTime >= DATE_SUB(CURRENT_DATE, INTERVAL 12 MONTH)
  GROUP BY operationalAreaId
)
SELECT oa.areaName, h.labourHours, COALESCE(i.incidentCount,0) AS incidentCount,
       COALESCE(i.lostHours,0) AS lostHours,
       ROUND(COALESCE(i.incidentCount,0) * 1000.0 / NULLIF(h.labourHours,0), 2) AS incidentsPer1000Hours
FROM hoursbyarea h
JOIN operationalarea oa ON oa.operationalAreaId = h.operationalAreaId
LEFT JOIN incidentsbyarea i ON i.operationalAreaId = h.operationalAreaId
ORDER BY incidentsPer1000Hours DESC;

