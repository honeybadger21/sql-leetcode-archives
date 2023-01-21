-- Solution Archive for LeetCode SQL Study Plan - III
-- 10 Days of SQL practice, created by Ruchi Sharma [UT Austin '23, IIT Roorkee '21]
-- [16 Jan 2023, 25 Jan 2023] 

-----------
-- Day 1 --
-----------

-- 1303. Find the Team Size
SELECT employee_id, COUNT(employee_id) OVER (PARTITION BY team_id) AS team_size FROM Employee 

-- 1308. Running Total for Different Genders
SELECT gender, day, SUM(score_points) OVER(PARTITION BY gender ORDER BY day) AS total FROM Scores

-- 1501. Countries You Can Safely Invest In
SELECT CO.name AS country 
FROM Person P 
JOIN Country CO
    ON SUBSTRING(phone_number, 1, 3) = country_code
JOIN Calls C
    ON P.id IN (C.caller_id, C.callee_id)
GROUP BY CO.name
HAVING AVG(duration) > (SELECT AVG(duration) FROM Calls)

-----------
-- Day 2 --
-----------

-- 1077. Project Employees III
SELECT project_id, employee_id FROM 
(
    SELECT a.project_id, a.employee_id,
           rank() over (partition by a.project_id order by b.experience_years DESC) AS ranking
           FROM project a LEFT JOIN employee b
           ON a.employee_id = b. employee_id
) c
where ranking = 1

-- 1549. The Most Recent Orders for Each Product
SELECT product_name, product_id, order_id, order_date
FROM
(
    SELECT p.product_name, o.product_id, o.order_id, o.order_date, 
           rank() over (PARTITION BY o.product_id ORDER BY o.order_date DESC) AS ranking
           FROM orders o 
           JOIN products p 
           ON o.product_id = p.product_id
) a
WHERE ranking = 1
ORDER BY product_name, product_id, order_id

-- 1285. Find the Start and End Number of Continuous Ranges
-- 1596. The Most Frequently Ordered Products for Each Customer
