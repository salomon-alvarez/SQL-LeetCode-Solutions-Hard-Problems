# 🏢 185. Department Top Three Salaries

📌 **LeetCode Problem**: [Department Top Three Salaries](https://leetcode.com/problems/department-top-three-salaries/?envType=study-plan-v2&envId=top-sql-50)  
🧩 **Difficulty**: Hard

---

## 📋 Problem Description

A company's executives want to see the top earners in each department. A **high earner** is an employee whose salary is among the **top three unique salaries** within their department.

---

### 🧾 Schema

#### Table: `Employee`

| Column Name  | Type    |
|--------------|---------|
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |

- `id` is the primary key.
- `departmentId` is a foreign key referencing `Department.id`.
- Each row represents an employee’s id, name, salary, and department.

#### Table: `Department`

| Column Name | Type    |
|-------------|---------|
| id          | int     |
| name        | varchar |

- `id` is the primary key.
- Each row represents a department's id and name.

---

### 📌 Example Input

#### Employee

| id | name  | salary | departmentId |
|----|-------|--------|--------------|
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |

#### Department

| id | name  |
|----|--------|
| 1  | IT     |
| 2  | Sales  |

#### Expected Output

| Department | Employee | Salary |
|------------|----------|--------|
| IT         | Max      | 90000  |
| IT         | Joe      | 85000  |
| IT         | Randy    | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |

---

## ✅ Solution Strategy

1. Use a **window function** `DENSE_RANK()` to assign a rank to salaries **within each department**.
2. Rank by `salary DESC` so higher salaries get lower ranks.
3. Filter for rows where rank is `<= 3` (i.e., top three unique salaries).
4. Join with the `Department` table to get the department name.
5. Select the final output as: `Department`, `Employee`, `Salary`.

---

## 💡 SQL Solution

```sql
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