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
