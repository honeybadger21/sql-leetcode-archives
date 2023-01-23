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
WITH CTE AS 
(
    SELECT log_id, row_number() OVER(ORDER BY log_id) AS rownum FROM logs
)

SELECT min(log_id) as start_id, 
       max(log_id) as end_id
FROM CTE
GROUP BY (log_id - rownum)
ORDER BY start_id

-- 1596. The Most Frequently Ordered Products for Each Customer
SELECT customer_id, product_id, product_name
FROM (
    SELECT O.customer_id, O.product_id, P.product_name, 
    RANK() OVER (PARTITION BY customer_id ORDER BY COUNT(O.product_id) DESC) AS rnk
    FROM Orders O
    JOIN Products P
    ON O.product_id = P.product_id  
    GROUP BY customer_id, product_id
) temp
WHERE rnk = 1 
ORDER BY customer_id, product_id

-----------
-- Day 3 --
-----------

-- 178. Rank Scores
SELECT S.score, DENSE_RANK() OVER (ORDER BY S.score DESC) AS "rank" FROM Scores S

-- 177. Nth Highest Salary
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
DECLARE M int;
SET M = N - 1;
  RETURN (
    SELECT DISTINCT salary FROM employee 
    ORDER BY salary DESC LIMIT M, 1
  );
END

-- 1951. All the Pairs With the Maximum Number of Common Followers
SELECT user1_id, user2_id 
FROM
(
    SELECT a.user_id as user1_id, b.user_id as user2_id, 
           dense_rank() over(order by count(a.follower_id) desc) as ranks
    FROM Relations a, Relations b
    WHERE a.user_id < b.user_id AND a.follower_id = b.follower_id
    GROUP BY a.user_id, b.user_id
) TEMP
WHERE ranks = 1

-- 1709. Biggest Window Between Visits

-----------
-- Day 4 --
-----------

-- 1949. Strong Friendship
-- 1532. The Most Recent Three Orders
-- 1126. Active Businesses
-- 1831. Maximum Transaction Each Day

-----------
-- Day 5 --
-----------

-- 1613. Find the Missing IDs
-- 1270. All People Report to the Given Manager
-- 1369. Get the Second Most Recent Activity

-----------
-- Day 6 --
-----------

-- 1412. Find the Quiet Students in All Exams
-- 1972. First and Last Call On the Same Day

-----------
-- Day 7 --
-----------

-- 185. Department Top Three Salaries
-- 1767. Find the Subtasks That Did Not Execute

-----------
-- Day 8 --
-----------

-- 1384. Total Sales Amount by Year
-- 569. Median Employee Salary

-----------
-- Day 9 --
-----------

-- 571. Find Median Given Frequency of Numbers
-- 1225. Report Contiguous Dates

-----------
-- Day 10 --
-----------

-- 1454. Active Users
-- 618. Students Report By Geography
-- 2010. The Number of Seniors and Juniors to Join the Company II
