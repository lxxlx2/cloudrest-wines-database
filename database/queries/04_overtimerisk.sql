USE cloudrestwines;
-- Workforce review query: surface recent workload/safety/wellbeing indicators without exposing confidential notes.
WITH activeworkforce AS (
  SELECT e.employeeId,
         e.firstName,
         e.lastName,
         er.operationalAreaId,
         r.roleName
  FROM employee e
  JOIN employeerole er ON er.employeeId = e.employeeId
  JOIN role r ON r.roleId = er.roleId
  WHERE e.employmentStartDate <= CURRENT_DATE
    AND (e.employmentEndDate IS NULL OR e.employmentEndDate >= CURRENT_DATE)
    AND er.startDateTime <= NOW()
    AND (er.endDateTime IS NULL OR er.endDateTime >= NOW())
), workload AS (
  SELECT sa.employeeId,
         SUM(sa.regularHours) AS regularHours,
         SUM(sa.overtimeHours) AS overtimeHours
  FROM shiftassignment sa
  JOIN shift s ON s.shiftId = sa.shiftId
  WHERE s.shiftDate >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
  GROUP BY sa.employeeId
), recentincident AS (
  SELECT ie.employeeId, COUNT(DISTINCT ie.incidentId) AS incidentCount
  FROM incidentemployee ie
  JOIN incident i ON i.incidentId = ie.incidentId
  WHERE i.incidentDateTime >= DATE_SUB(NOW(), INTERVAL 30 DAY)
  GROUP BY ie.employeeId
), recentconcern AS (
  SELECT employeeId, COUNT(*) AS concernCount
  FROM wellbeingcheckin
  WHERE checkinDate >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
    AND concernRaisedFlag = TRUE
  GROUP BY employeeId
)
SELECT aw.employeeId,
       CONCAT(aw.firstName, ' ', aw.lastName) AS employeeName,
       oa.areaName,
       aw.roleName,
       COALESCE(w.regularHours, 0) AS regularHours,
       COALESCE(w.overtimeHours, 0) AS overtimeHours,
       COALESCE(ri.incidentCount, 0) AS recentIncidents,
       COALESCE(rc.concernCount, 0) AS wellbeingConcernCount,
       CASE
         WHEN COALESCE(ri.incidentCount, 0) > 0
           OR COALESCE(rc.concernCount, 0) > 0
           OR COALESCE(w.overtimeHours, 0) > 0
         THEN 'SUPERVISOR REVIEW'
         ELSE 'NO RECENT INDICATOR'
       END AS recommendedAction
FROM activeworkforce aw
JOIN operationalarea oa ON oa.operationalAreaId = aw.operationalAreaId
LEFT JOIN workload w ON w.employeeId = aw.employeeId
LEFT JOIN recentincident ri ON ri.employeeId = aw.employeeId
LEFT JOIN recentconcern rc ON rc.employeeId = aw.employeeId
ORDER BY (COALESCE(ri.incidentCount, 0) > 0) DESC,
         (COALESCE(rc.concernCount, 0) > 0) DESC,
         COALESCE(w.overtimeHours, 0) DESC,
         employeeName;
