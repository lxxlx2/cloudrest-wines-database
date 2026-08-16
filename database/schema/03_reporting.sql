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
