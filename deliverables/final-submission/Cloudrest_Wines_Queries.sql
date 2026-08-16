-- Cloudrest Wines — six decision-support queries
-- Execute each numbered section in MySQL Workbench for video/report evidence.

USE cloudrestwines;

DROP VIEW IF EXISTS openincidentaction;
CREATE VIEW openincidentaction AS
SELECT
  ca.correctiveActionId,
  i.incidentId,
  i.incidentDateTime,
  i.severity,
  oa.areaName,
  ca.actionDescription,
  ca.targetDate,
  ca.actionStatus,
  CONCAT(e.firstName, ' ', e.lastName) AS responsibleEmployee,
  GREATEST(DATEDIFF(CURRENT_DATE, ca.targetDate), 0) AS daysOverdue
FROM correctiveaction ca
JOIN incident i ON i.incidentId = ca.incidentId
JOIN operationalarea oa ON oa.operationalAreaId = i.operationalAreaId
JOIN employee e ON e.employeeId = ca.responsibleEmployeeId
WHERE ca.actionStatus IN ('OPEN','INPROGRESS');

DROP PROCEDURE IF EXISTS getExpiringQualifications;
DELIMITER $$
CREATE PROCEDURE getExpiringQualifications(IN daysAhead INT)
BEGIN
  IF daysAhead < 0 OR daysAhead > 730 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'daysAhead must be between 0 and 730';
  END IF;

  SELECT
    eq.employeeId,
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
    q.qualificationName,
    q.isSafetyCritical,
    eq.expiryDate,
    DATEDIFF(eq.expiryDate, CURRENT_DATE) AS daysUntilExpiry
  FROM employeequalification eq
  JOIN employee e ON e.employeeId = eq.employeeId
  JOIN qualification q ON q.qualificationId = eq.qualificationId
  WHERE eq.expiryDate BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL daysAhead DAY)
  ORDER BY eq.expiryDate, employeeName;
END$$
DELIMITER ;

-- ===== QUERY 01: trainingcoverage =====
USE cloudrestwines;
-- Management question: Which operational areas have gaps in annual safety and sustainability training?
WITH activeworkforce AS (
  SELECT er.employeeId, er.operationalAreaId
  FROM employeerole er
  WHERE er.startDateTime <= NOW() AND (er.endDateTime IS NULL OR er.endDateTime > NOW())
), completion AS (
  SELECT ta.employeeId
  FROM trainingattendance ta
  JOIN trainingsession ts ON ts.trainingSessionId = ta.trainingSessionId
  JOIN trainingcourse tc ON tc.trainingCourseId = ts.trainingCourseId
  JOIN activeworkforce aw ON aw.employeeId = ta.employeeId
  WHERE ta.attendanceStatus = 'COMPLETED'
    AND tc.trainingCategory IN ('SAFETY','SUSTAINABILITY')
    AND ts.sessionDate >= MAKEDATE(YEAR(CURRENT_DATE), 1)
    AND (ts.operationalAreaId IS NULL OR ts.operationalAreaId = aw.operationalAreaId)
  GROUP BY ta.employeeId
  HAVING COUNT(DISTINCT tc.trainingCategory) = 2
)
SELECT oa.areaName,
       COUNT(DISTINCT aw.employeeId) AS activeEmployees,
       COUNT(DISTINCT c.employeeId) AS employeesTrained,
       ROUND(100.0 * COUNT(DISTINCT c.employeeId) / NULLIF(COUNT(DISTINCT aw.employeeId),0), 1) AS coveragePercent
FROM activeworkforce aw
JOIN operationalarea oa ON oa.operationalAreaId = aw.operationalAreaId
LEFT JOIN completion c ON c.employeeId = aw.employeeId
GROUP BY oa.operationalAreaId, oa.areaName
ORDER BY coveragePercent, oa.areaName;

-- ===== QUERY 02: incidentrate =====
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

-- ===== QUERY 03: trainingimpact =====
USE cloudrestwines;
-- Compare employee incidents in the 180 days before and after completed annual safety training.
WITH completion AS (
  SELECT ta.employeeId, MIN(ta.completionDate) AS completionDate
  FROM trainingattendance ta
  JOIN trainingsession ts ON ts.trainingSessionId = ta.trainingSessionId
  JOIN trainingcourse tc ON tc.trainingCourseId = ts.trainingCourseId
  WHERE ta.attendanceStatus = 'COMPLETED' AND tc.trainingCategory = 'SAFETY'
  GROUP BY ta.employeeId
)
SELECT c.employeeId, CONCAT(e.firstName,' ',e.lastName) AS employeeName, c.completionDate,
       SUM(CASE WHEN i.incidentDateTime >= DATE_SUB(c.completionDate, INTERVAL 180 DAY)
                 AND i.incidentDateTime < c.completionDate THEN 1 ELSE 0 END) AS incidentsBefore,
       SUM(CASE WHEN i.incidentDateTime >= c.completionDate
                 AND i.incidentDateTime < DATE_ADD(c.completionDate, INTERVAL 180 DAY) THEN 1 ELSE 0 END) AS incidentsAfter
FROM completion c
JOIN employee e ON e.employeeId = c.employeeId
LEFT JOIN incidentemployee ie ON ie.employeeId = c.employeeId AND ie.involvementRole = 'AFFECTED'
LEFT JOIN incident i ON i.incidentId = ie.incidentId
GROUP BY c.employeeId, e.firstName, e.lastName, c.completionDate
ORDER BY incidentsBefore DESC, incidentsAfter DESC;

-- ===== QUERY 04: overtimerisk =====
USE cloudrestwines;
-- Identify people for supervisor review without exposing confidential wellbeing notes.
WITH workload AS (
  SELECT sa.employeeId, SUM(sa.regularHours) AS regularHours, SUM(sa.overtimeHours) AS overtimeHours
  FROM shiftassignment sa JOIN shift s ON s.shiftId = sa.shiftId
  WHERE s.shiftDate >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
  GROUP BY sa.employeeId
), recentincident AS (
  SELECT ie.employeeId, COUNT(DISTINCT ie.incidentId) AS incidentCount
  FROM incidentemployee ie JOIN incident i ON i.incidentId = ie.incidentId
  WHERE i.incidentDateTime >= DATE_SUB(NOW(), INTERVAL 30 DAY)
    AND ie.involvementRole = 'AFFECTED'
  GROUP BY ie.employeeId
), recentconcern AS (
  SELECT employeeId, COUNT(*) AS concernCount
  FROM wellbeingcheckin
  WHERE checkinDate >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) AND concernRaisedFlag = TRUE
  GROUP BY employeeId
)
SELECT w.employeeId, CONCAT(e.firstName,' ',e.lastName) AS employeeName,
       w.regularHours, w.overtimeHours, COALESCE(ri.incidentCount,0) AS recentIncidents,
       COALESCE(rc.concernCount,0) AS wellbeingConcernCount,
       CASE WHEN w.overtimeHours >= 4 OR ri.incidentCount > 0 OR rc.concernCount > 0 THEN 'SUPERVISOR REVIEW' ELSE 'MONITOR' END AS recommendedAction
FROM workload w
JOIN employee e ON e.employeeId = w.employeeId
LEFT JOIN recentincident ri ON ri.employeeId = w.employeeId
LEFT JOIN recentconcern rc ON rc.employeeId = w.employeeId
ORDER BY (w.overtimeHours + COALESCE(ri.incidentCount,0) * 5 + COALESCE(rc.concernCount,0) * 5) DESC;

-- ===== QUERY 05: expiringqualification =====
USE cloudrestwines;
-- Video demonstration must call both parameter values.
CALL getExpiringQualifications(30);
CALL getExpiringQualifications(90);

-- ===== QUERY 06: openactions =====
USE cloudrestwines;
-- View-based management query: prioritise overdue and high-severity corrective actions.
SELECT correctiveActionId, incidentId, incidentDateTime, severity, areaName,
       actionDescription, responsibleEmployee, targetDate, daysOverdue, actionStatus
FROM openincidentaction
ORDER BY (daysOverdue > 0) DESC,
         FIELD(severity,'CRITICAL','HIGH','MODERATE','LOW'),
         daysOverdue DESC, targetDate;

EXPLAIN
SELECT correctiveActionId, incidentId, incidentDateTime, severity, areaName,
       actionDescription, responsibleEmployee, targetDate, daysOverdue, actionStatus
FROM openincidentaction
ORDER BY (daysOverdue > 0) DESC,
         FIELD(severity,'CRITICAL','HIGH','MODERATE','LOW'),
         daysOverdue DESC, targetDate;
