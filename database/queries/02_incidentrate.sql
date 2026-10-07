USE cloudrestwines;
-- Sustainability measure: incidents per 1,000 actual labour hours during the last 12 months.
-- Labour hours are derived from assignment start/end times so they cannot disagree with stored hour totals.
WITH assignmenthours AS (
  SELECT s.operationalAreaId,
         GREATEST(
           TIMESTAMPDIFF(MINUTE, sa.actualStartTime, sa.actualEndTime) - sa.breakMinutes,
           0
         ) / 60.0 AS labourHours
  FROM shift s
  JOIN shiftassignment sa ON sa.shiftId = s.shiftId
  WHERE s.shiftDate >= DATE_SUB(CURRENT_DATE, INTERVAL 12 MONTH)
), hoursbyarea AS (
  SELECT operationalAreaId, SUM(labourHours) AS labourHours
  FROM assignmenthours
  GROUP BY operationalAreaId
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
       ROUND(COALESCE(h.labourHours, 0), 2) AS labourHours,
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
