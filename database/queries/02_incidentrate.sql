USE cloudrestwines;
-- Sustainability measure: incidents per 1,000 labour hours during the last 12 months.
-- operationalarea is the driver so areas with incidents but no recorded labour are still visible.
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
SELECT oa.areaName,
       COALESCE(h.labourHours,0) AS labourHours,
       COALESCE(i.incidentCount,0) AS incidentCount,
       COALESCE(i.lostHours,0) AS lostHours,
       CASE WHEN COALESCE(h.labourHours,0) = 0 THEN NULL
            ELSE ROUND(COALESCE(i.incidentCount,0) * 1000.0 / h.labourHours, 2)
       END AS incidentsPer1000Hours
FROM operationalarea oa
LEFT JOIN hoursbyarea h ON h.operationalAreaId = oa.operationalAreaId
LEFT JOIN incidentsbyarea i ON i.operationalAreaId = oa.operationalAreaId
ORDER BY incidentsPer1000Hours DESC, oa.areaName;
