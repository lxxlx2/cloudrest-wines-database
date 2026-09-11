USE cloudrestwines;
-- Identify active employees for workload/safety/wellbeing review without exposing confidential notes.
-- employee is the driver so active employees with no recent shift are still visible.
WITH workload AS (
  SELECT sa.employeeId, SUM(sa.regularHours) AS regularHours, SUM(sa.overtimeHours) AS overtimeHours
  FROM shiftassignment sa JOIN shift s ON s.shiftId = sa.shiftId
  WHERE s.shiftDate >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
  GROUP BY sa.employeeId
), recentincident AS (
  SELECT ie.employeeId, COUNT(DISTINCT ie.incidentId) AS incidentCount
  FROM incidentemployee ie JOIN incident i ON i.incidentId = ie.incidentId
  WHERE i.incidentDateTime >= DATE_SUB(NOW(), INTERVAL 30 DAY)
  GROUP BY ie.employeeId
), recentconcern AS (
  SELECT employeeId, COUNT(*) AS concernCount
  FROM wellbeingcheckin
  WHERE checkinDate >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) AND concernRaisedFlag = TRUE
  GROUP BY employeeId
)
SELECT e.employeeId, CONCAT(e.firstName,' ',e.lastName) AS employeeName,
       COALESCE(w.regularHours,0) AS regularHours,
       COALESCE(w.overtimeHours,0) AS overtimeHours,
       COALESCE(ri.incidentCount,0) AS recentIncidents,
       COALESCE(rc.concernCount,0) AS wellbeingConcernCount,
       CASE
         WHEN COALESCE(ri.incidentCount,0) > 0 OR COALESCE(rc.concernCount,0) > 0 THEN 'PRIORITY REVIEW'
         WHEN COALESCE(w.overtimeHours,0) > 0 THEN 'WORKLOAD REVIEW'
         ELSE 'MONITOR'
       END AS recommendedAction
FROM employee e
LEFT JOIN workload w ON w.employeeId = e.employeeId
LEFT JOIN recentincident ri ON ri.employeeId = e.employeeId
LEFT JOIN recentconcern rc ON rc.employeeId = e.employeeId
WHERE e.employmentEndDate IS NULL OR e.employmentEndDate >= CURRENT_DATE
ORDER BY FIELD(recommendedAction,'PRIORITY REVIEW','WORKLOAD REVIEW','MONITOR'),
         overtimeHours DESC, recentIncidents DESC, wellbeingConcernCount DESC, employeeName;
