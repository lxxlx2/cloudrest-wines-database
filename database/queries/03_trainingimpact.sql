USE cloudrestwines;
-- Compare affected-employee incidents in symmetric 180-day windows around each employee's latest completed safety training.
WITH completion AS (
  SELECT ta.employeeId, MAX(ta.completionDate) AS completionDate
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
