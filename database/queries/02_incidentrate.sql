USE cloudrestwines;
-- Sustainability measure: incidents per 1,000 labour hours during the last 12 months.
-- Operational area is the driver so an area with incidents but no recorded hours is still visible.
WITH hoursbyarea AS (
  SELECT s.operationalAreaId, SUM(sa.regularHours + sa.overtimeHours) AS labourHours
  FROM shift s
  JOIN shiftassignment sa ON sa.shiftId = s.shiftId
  WHERE s.shiftDate >= DATE_SUB(CURRENT_DATE, INTERVAL 12 MONTH)
  GROUP BY s.operationalAreaId
), incidentloss AS (
  SELECT i.incidentId,
         i.operationalAreaId,
         COALESCE(SUM(ie.employeeLostHours), 0) AS lostHours
  FROM incident i
  LEFT JOIN incidentemployee ie ON ie.incidentId = i.incidentId
  WHERE i.incidentDateTime >= DATE_SUB(CURRENT_DATE, INTERVAL 12 MONTH)
  GROUP BY i.incidentId, i.operationalAreaId
), incidentsbyarea AS (
  SELECT operationalAreaId,
         COUNT(*) AS incidentCount,
         SUM(lostHours) AS lostHours
  FROM incidentloss
  GROUP BY operationalAreaId
)
SELECT oa.areaName,
       COALESCE(h.labourHours, 0) AS labourHours,
       COALESCE(i.incidentCount, 0) AS incidentCount,
       COALESCE(i.lostHours, 0) AS lostHours,
       CASE
         WHEN COALESCE(h.labourHours, 0) = 0 THEN NULL
         ELSE ROUND(COALESCE(i.incidentCount, 0) * 1000.0 / h.labourHours, 2)
       END AS incidentsPer1000Hours
FROM operationalarea oa
LEFT JOIN hoursbyarea h ON h.operationalAreaId = oa.operationalAreaId
LEFT JOIN incidentsbyarea i ON i.operationalAreaId = oa.operationalAreaId
WHERE h.labourHours IS NOT NULL OR i.incidentCount IS NOT NULL
ORDER BY (incidentsPer1000Hours IS NULL), incidentsPer1000Hours DESC, oa.areaName;
