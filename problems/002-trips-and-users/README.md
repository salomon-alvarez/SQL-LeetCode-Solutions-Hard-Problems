262. Trips and Users

📌 LeetCode Problem: Trips and Users
🧩 Difficulty: Hard

⸻

📋 Problem Description

We are given taxi trip data and user data. A trip can be completed or canceled by either the driver or client. A user may be banned, in which case their trips should be excluded from analysis.

Goal:
For each day between 2013-10-01 and 2013-10-03, compute the cancellation rate of trips where both the client and the driver are not banned.
The cancellation rate is defined as:

Cancelled Trips with unbanned users / Total Trips with unbanned users

Round the result to two decimal places.

⸻

🧾 Schema

Trips
+-------------+--------+
| Column Name | Type   |
+-------------+--------+
| id          | int    |
| client_id   | int    |
| driver_id   | int    |
| city_id     | int    |
| status      | enum   |
| request_at  | string |
+-------------+--------+

status ∈ ('completed', 'cancelled_by_driver', 'cancelled_by_client')

Users
+-------------+--------+
| Column Name | Type   |
+-------------+--------+
| users_id    | int    |
| banned      | enum   |
| role        | enum   |
+-------------+--------+

banned ∈ ('Yes', 'No')  
role ∈ ('client', 'driver', 'partner')


⸻

📌 Example Input

Trips  
id  client_id  driver_id  city_id  status               request_at  
1   1          10         1        completed            2013-10-01  
2   2          11         1        cancelled_by_driver  2013-10-01  
3   3          12         6        completed            2013-10-01  
4   4          13         6        cancelled_by_client  2013-10-01  
5   1          10         1        completed            2013-10-02  
6   2          11         6        completed            2013-10-02  
7   3          12         6        completed            2013-10-02  
8   2          12         12       completed            2013-10-03  
9   3          10         12       completed            2013-10-03  
10  4          13         12       cancelled_by_driver  2013-10-03  

Users  
users_id  banned  role  
1         No      client  
2         Yes     client  
3         No      client  
4         No      client  
10        No      driver  
11        No      driver  
12        No      driver  
13        No      driver  


⸻

✅ Solution Strategy
	1.	Filter out trips where either the client or the driver is banned.
	2.	Tag each remaining trip as canceled (1) or not (0).
	3.	Group trips by date.
	4.	Compute the cancellation rate as SUM(cancelled) / COUNT(*) per day.
	5.	Round to 2 decimal places.

⸻

💡 SQL Solution

-- Step 1: CleanedTrips filters only trips where both client and driver are unbanned.
-- It also marks cancelled trips with a 1 and others with 0 for easy aggregation.
WITH CleanedTrips AS (
    SELECT 
        t.request_at,
        CASE 
            WHEN t.status IN ('cancelled_by_driver', 'cancelled_by_client') THEN 1
            ELSE 0
        END AS is_cancelled
    FROM Trips t
    JOIN Users c ON t.client_id = c.users_id AND c.banned = 'No'
    JOIN Users d ON t.driver_id = d.users_id AND d.banned = 'No'
    WHERE t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
),

-- Step 2: Group by date and calculate cancellation rate
Aggregated AS (
    SELECT 
        request_at AS Day,
        ROUND(
            CAST(SUM(is_cancelled) AS FLOAT) / COUNT(*), 
            2
        ) AS [Cancellation Rate]
    FROM CleanedTrips
    GROUP BY request_at
)

-- Final output
SELECT *
FROM Aggregated;


⸻

🧪 Output

Day         Cancellation Rate  
2013-10-01  0.33  
2013-10-02  0.00  
2013-10-03  0.50  

⸻
