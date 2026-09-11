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
  IF daysAhead IS NULL OR daysAhead < 0 OR daysAhead > 730 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'daysAhead must be a non-NULL value between 0 and 730';
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
-- Management question: Which operational areas have gaps in annual mandatory safety/sustainability training?
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

-- ===== QUERY 03: trainingimpact =====
USE cloudrestwines;
-- Compare employee incidents before and after completed annual safety training using
-- equal observed windows of up to 180 days. This avoids understating post-training
-- incidents when fewer than 180 days have elapsed since training.
WITH completion AS (
  SELECT ta.employeeId, MIN(ta.completionDate) AS completionDate
  FROM trainingattendance ta
  JOIN trainingsession ts ON ts.trainingSessionId = ta.trainingSessionId
  JOIN trainingcourse tc ON tc.trainingCourseId = ts.trainingCourseId
  WHERE ta.attendanceStatus = 'COMPLETED' AND tc.trainingCategory = 'SAFETY'
  GROUP BY ta.employeeId
), observed AS (
  SELECT employeeId,
         completionDate,
         LEAST(180, GREATEST(DATEDIFF(CURRENT_DATE, completionDate), 0)) AS observationDays
  FROM completion
)
SELECT o.employeeId,
       CONCAT(e.firstName,' ',e.lastName) AS employeeName,
       o.completionDate,
       o.observationDays,
       SUM(CASE WHEN i.incidentDateTime >= DATE_SUB(o.completionDate, INTERVAL o.observationDays DAY)
                 AND i.incidentDateTime < o.completionDate THEN 1 ELSE 0 END) AS incidentsBefore,
       SUM(CASE WHEN i.incidentDateTime >= o.completionDate
                 AND i.incidentDateTime < DATE_ADD(o.completionDate, INTERVAL o.observationDays DAY)
                 AND i.incidentDateTime < DATE_ADD(CURRENT_DATE, INTERVAL 1 DAY)
                THEN 1 ELSE 0 END) AS incidentsAfter
FROM observed o
JOIN employee e ON e.employeeId = o.employeeId
LEFT JOIN incidentemployee ie ON ie.employeeId = o.employeeId AND ie.involvementRole = 'AFFECTED'
LEFT JOIN incident i ON i.incidentId = ie.incidentId
GROUP BY o.employeeId, e.firstName, e.lastName, o.completionDate, o.observationDays
ORDER BY incidentsBefore DESC, incidentsAfter DESC;

-- ===== QUERY 04: overtimerisk =====
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
