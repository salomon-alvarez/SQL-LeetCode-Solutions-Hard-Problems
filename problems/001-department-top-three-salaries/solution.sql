WITH RankedSalaries AS (
    SELECT 
        e.name AS Employee,
        e.salary,
        e.departmentId,
        DENSE_RANK() OVER (
            PARTITION BY e.departmentId
            ORDER BY e.salary DESC
        ) AS rk
    FROM Employee e
)
SELECT 
    d.name AS Department,
    r.Employee,
    r.salary
FROM RankedSalaries r
JOIN Department d ON r.departmentId = d.id
WHERE rk <= 3;