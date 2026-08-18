USE cloudrestwines;
-- Identify people for supervisor workload/safety review without exposing confidential wellbeing notes.
-- The query avoids an invented numeric risk score: affected incidents or a recorded concern trigger review;
-- overtime remains a visible workload indicator and secondary sort key.
WITH workload AS (
  SELECT sa.employeeId, SUM(sa.regularHours) AS regularHours, SUM(sa.overtimeHours) AS overtimeHours
  FROM shiftassignment sa
  JOIN shift s ON s.shiftId = sa.shiftId
  WHERE s.shiftDate >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
  GROUP BY sa.employeeId
), recentincident AS (
  SELECT ie.employeeId, COUNT(DISTINCT ie.incidentId) AS incidentCount
  FROM incidentemployee ie
  JOIN incident i ON i.incidentId = ie.incidentId
  WHERE i.incidentDateTime >= DATE_SUB(NOW(), INTERVAL 30 DAY)
    AND ie.involvementRole = 'AFFECTED'
  GROUP BY ie.employeeId
), recentconcern AS (
  SELECT employeeId, COUNT(*) AS concernCount
  FROM wellbeingcheckin
  WHERE checkinDate >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    AND concernRaisedFlag = TRUE
  GROUP BY employeeId
)
SELECT w.employeeId, CONCAT(e.firstName,' ',e.lastName) AS employeeName,
       w.regularHours, w.overtimeHours,
       COALESCE(ri.incidentCount,0) AS recentIncidents,
       COALESCE(rc.concernCount,0) AS wellbeingConcernCount,
       CASE
         WHEN COALESCE(ri.incidentCount,0) > 0 OR COALESCE(rc.concernCount,0) > 0 THEN 'SUPERVISOR REVIEW'
         WHEN w.overtimeHours > 0 THEN 'MONITOR OVERTIME'
         ELSE 'ROUTINE'
       END AS recommendedAction
FROM workload w
JOIN employee e ON e.employeeId = w.employeeId
LEFT JOIN recentincident ri ON ri.employeeId = w.employeeId
LEFT JOIN recentconcern rc ON rc.employeeId = w.employeeId
ORDER BY
  CASE WHEN COALESCE(ri.incidentCount,0) > 0 OR COALESCE(rc.concernCount,0) > 0 THEN 0
       WHEN w.overtimeHours > 0 THEN 1 ELSE 2 END,
  w.overtimeHours DESC,
  w.employeeId;
