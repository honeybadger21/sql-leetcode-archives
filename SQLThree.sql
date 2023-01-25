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

-- 1709. Biggest Window Between Visits [Good Question]
SELECT user_id, MAX(diff) AS biggest_window 
FROM
(
    SELECT user_id, 
           DATEDIFF(LEAD(visit_date, 1, '2021-01-01') OVER (PARTITION BY user_id ORDER BY visit_date), visit_date) AS diff FROM userVisits
) A
GROUP BY user_id ORDER BY user_id


-----------
-- Day 4 --
-----------

-- 1949. Strong Friendship
WITH CTE AS (
    SELECT user1_id AS user, user2_id AS friend FROM Friendship
    UNION ALL
    SELECT user2_id AS user, user1_id AS friend FROM Friendship)
    
SELECT A.user AS user1_id, B.user AS user2_id, count(*) AS common_friend
FROM CTE A JOIN CTE B
WHERE a.user < b.user AND a.friend = b.friend AND (a.user, b.user) IN (SELECT user, friend FROM CTE)
GROUP BY 1, 2
HAVING common_friend >=3

-- 1532. The Most Recent Three Orders
SELECT name AS customer_name, customer_id, order_id, order_date
FROM 
    (
    SELECT name, C.customer_id, order_id, order_date, 
           RANK() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS ranks
    FROM Customers C JOIN Orders O on C.customer_id = O.customer_id
     ) SUB
WHERE ranks <= 3 ORDER BY 1, 2, 4 DESC

-- 1126. Active Businesses
SELECT business_id FROM
(
    SELECT event_type, AVG(occurences) AS avg_o FROM EVENTS E1 GROUP BY event_type
) T1
JOIN
EVENTS E2 ON T1.event_type = E2.event_type
WHERE E2.occurences > T1.avg_o 
GROUP BY business_id HAVING COUNT(DISTINCT T1.event_type) > 1

-- 1831. Maximum Transaction Each Day
SELECT transaction_id
FROM 
(
    SELECT transaction_id, 
           RANK() OVER(PARTITION BY DATE(day) ORDER BY amount DESC) AS ranks
    FROM Transactions
) T1
WHERE ranks = 1 ORDER BY 1

-----------
-- Day 5 --
-----------

-- 1613. Find the Missing IDs
WITH RECURSIVE T1 AS 
(
    SELECT 1 AS n 
    UNION
    SELECT n+1 FROM T1
    WHERE n < (SELECT MAX(customer_id) FROM customers)
)

SELECT n as ids FROM T1 
WHERE n NOT IN (SELECT customer_id FROM customers)

-- 1270. All People Report to the Given Manager
SELECT E1.employee_id FROM Employees E1, Employees E2, Employees E3
WHERE E1.manager_id = E2.employee_id
      AND E2.manager_id = E3.employee_id
      AND E3.manager_id = 1
      AND E1.employee_id != 1
      
-- 1369. Get the Second Most Recent Activity
SELECT username, activity, startDate, endDate FROM
(
    SELECT username, activity, startDate, endDate,
           row_number() OVER (PARTITION BY username ORDER BY startDate DESC) AS ranks, 
           COUNT(username) OVER (PARTITION BY username) AS COUNTS
    FROM UserActivity
) T1
WHERE counts = 1 OR ranks = 2

-----------
-- Day 6 --
-----------

-- 1412. Find the Quiet Students in All Exams
SELECT E.student_id, S.student_name 
FROM Exam E, 
     Student S, 
     (SELECT MAX(score) AS high, MIN(score) AS low, exam_id FROM Exam GROUP BY exam_id) T
WHERE E.student_id = S.student_id AND E.exam_id = T.exam_id
GROUP BY E.student_id, S.student_name
HAVING SUM(CASE WHEN E.score = T.high THEN 1 ELSE 0 END) = 0 AND 
       SUM(CASE WHEN E.score = T.low THEN 1 ELSE 0 END) = 0
ORDER BY E.student_id

-- 1972. First and Last Call On the Same Day [TOUGH QUESTION]
WITH CTE AS 
(
    SELECT caller_id AS U1, recipient_id AS U2, call_time FROM Calls 
    UNION ALL
    SELECT recipient_id AS U1, caller_id AS U2, call_time FROM Calls 
), 

CTE2 AS 
(
    SELECT U1, U2, 
           RANK() OVER (PARTITION BY U1, DATE(call_time) ORDER BY call_time) AS ASCY,
           RANK() OVER (PARTITION BY U1, DATE(call_time) ORDER BY call_time DESC) AS DESCY
    FROM CTE
)

SELECT DISTINCT C1.U1 AS user_id FROM CTE2 C1 JOIN CTE2 C2
ON C1.U1 = C2.U1 AND C1.U2 = C2.U2 AND C1.ASCY = 1 AND C2.DESCY = 1

-----------
-- Day 7 --
-----------

-- 185. Department Top Three Salaries
SELECT D.Name AS 'Department', E1.Name AS 'Employee', E1.Salary
FROM Employee E1 JOIN Department D ON E1.DepartmentId = D.Id
WHERE 3 > (
            SELECT COUNT(DISTINCT E2.Salary)
            FROM Employee E2
            WHERE E2.Salary > E1.Salary AND E1.DepartmentId = E2.DepartmentId
          )
          
-- 1767. Find the Subtasks That Did Not Execute [Good Question]
WITH RECURSIVE CTE AS
(
    SELECT task_id, subtasks_count FROM Tasks
    UNION ALL 
    SELECT task_id, subtasks_count - 1
    FROM CTE WHERE subtasks_count > 1
)

SELECT task_id, subtasks_count AS subtask_id FROM CTE
WHERE (task_id, subtasks_count) NOT IN (SELECT * FROM Executed)

-----------
-- Day 8 --
-----------

-- 1384. Total Sales Amount by Year [Tough Question]
SELECT a.product_id, b.product_name, a.report_year, a.total_amount
FROM (
    SELECT product_id, '2018' AS report_year,
        average_daily_sales * (DATEDIFF(LEAST(period_end, '2018-12-31'), GREATEST(period_start, '2018-01-01'))+1) AS total_amount
    FROM Sales
    WHERE YEAR(period_start)=2018 OR YEAR(period_end)=2018

    UNION ALL

    SELECT product_id, '2019' AS report_year,
        average_daily_sales * (DATEDIFF(LEAST(period_end, '2019-12-31'), GREATEST(period_start, '2019-01-01'))+1) AS total_amount
    FROM Sales
    WHERE YEAR(period_start)<=2019 AND YEAR(period_end)>=2019

    UNION ALL

    SELECT product_id, '2020' AS report_year,
        average_daily_sales * (DATEDIFF(LEAST(period_end, '2020-12-31'), GREATEST(period_start, '2020-01-01'))+1) AS total_amount
    FROM Sales
    WHERE YEAR(period_start)=2020 OR YEAR(period_end)=2020
) a
LEFT JOIN Product b
ON a.product_id = b.product_id
ORDER BY a.product_id, a.report_year

-- 569. Median Employee Salary [Good Question]
SELECT Id, Company, Salary FROM
(
    SELECT *, ROW_NUMBER() OVER(PARTITION BY COMPANY ORDER BY Salary, Id) AS R1, 
              ROW_NUMBER() OVER(PARTITION BY COMPANY ORDER BY Salary DESC, Id DESC) AS R2
    FROM Employee
) T
WHERE R1 BETWEEN R2 - 1 AND R2 + 1
ORDER BY Company, Salary

-----------
-- Day 9 --
-----------

-- 571. Find Median Given Frequency of Numbers [Good Question]
SELECT AVG(N.Num) Median FROM Numbers N
WHERE N.Frequency >= ABS((SELECT SUM(Frequency) FROM Numbers WHERE Num <= N.Num)
                            - (SELECT SUM(Frequency) FROM Numbers WHERE Num >= N.Num))
                            
-- 1225. Report Contiguous Dates
WITH combined as 
(
    SELECT fail_date as dt, 'failed' as period_state,
           DAYOFYEAR(fail_date) - ROW_NUMBER() OVER(ORDER BY fail_date) AS period_group 
    FROM Failed WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
    UNION ALL
    SELECT success_date as dt, 'succeeded' as period_state,
           DAYOFYEAR(success_date) - ROW_NUMBER() OVER(ORDER BY success_date) AS period_group 
    FROM Succeeded WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31'  
)

SELECT period_state, MIN(dt) AS start_date, MAX(dt) AS end_date
FROM combined GROUP BY period_state, period_group ORDER BY start_date

-----------
-- Day 10 --
-----------

-- 1454. Active Users
-- 618. Students Report By Geography
-- 2010. The Number of Seniors and Juniors to Join the Company II
