USE cloudrestwines;

-- QA reconciliation: expected result is zero rows.
-- Employee-level lost hours are the detailed source used by Query 2.
SELECT i.incidentId,
       i.totalLostHours AS storedIncidentTotal,
       COALESCE(SUM(ie.employeeLostHours), 0) AS employeeDetailTotal
FROM incident i
LEFT JOIN incidentemployee ie ON ie.incidentId = i.incidentId
GROUP BY i.incidentId, i.totalLostHours
HAVING i.totalLostHours <> COALESCE(SUM(ie.employeeLostHours), 0);
