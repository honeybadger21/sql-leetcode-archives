-- Solution Archive for LeetCode SQL Study Plan - II 
-- 11 Days of SQL practice, created by Ruchi Sharma [UT Austin '23, IIT Roorkee '21]
-- [19 Dec 2022, 29 Dec 2022] 

-----------
-- Day 1 --
-----------

-- 1699. Number of Calls Between Two Persons
SELECT person1, person2, COUNT(*) as call_count, SUM(duration) as total_duration FROM
(
    SELECT
        (CASE WHEN from_id < to_id THEN from_id else to_id END) AS person1,
        (CASE WHEN from_id < to_id THEN to_id else from_id END) AS person2,
        duration
    FROM
        Calls
) a
GROUP BY person1, person2

-- 1251. Average Selling Price 
SELECT P.product_id, ROUND(SUM(units*price)/SUM(units), 2) average_price 
FROM Prices P JOIN UnitsSold U ON P.product_id = U.product_id 
AND purchase_date BETWEEN start_date and end_date
GROUP BY P.product_id

-- 1571. Warehouse Manager 
SELECT W.name AS warehouse_name, SUM(P.width * p.length * p.height * w.units) AS VOLUME 
FROM Warehouse W INNER JOIN Products P ON W.product_id = P.product_id GROUP BY W.name

-- 1445. Apples & Oranges
SELECT A.sale_date, A.S1 - B.S2 AS diff
FROM (SELECT sale_date, SUM(sold_num) AS S1 FROM Sales WHERE fruit = 'apples' GROUP BY sale_date) A
INNER JOIN (SELECT sale_date, SUM(sold_num) AS S2 FROM Sales WHERE fruit = 'oranges' GROUP BY sale_date) B
ON A.sale_date = B.sale_date 

-----------
-- Day 2 --
-----------

-- 1193. Monthly Transactions I
SELECT date_format(trans_date,"%Y-%m") AS month, 
       country, 
       COUNT(id) AS trans_count, 
       SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
       SUM(amount) AS trans_total_amount, 
       SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY month, country 

-- 1633. Percentage of Users Attended a Contest
SELECT contest_id, ROUND(100*COUNT(user_id)/(SELECT COUNT(DISTINCT user_id) FROM Users), 2) AS percentage
FROM Register GROUP BY contest_id ORDER BY percentage DESC, contest_id

-- 1173. Immediate Food Delivery I
SELECT ROUND(100*SUM(CASE WHEN customer_pref_delivery_date = order_date THEN 1 ELSE 0 END)/(SELECT COUNT(delivery_id) FROM Delivery), 2)
AS immediate_percentage FROM Delivery 

-- 1211. Queries Quality and Percentage
SELECT query_name,
       ROUND(AVG(rating/position), 2) AS quality, 
       ROUND(100*SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END)/COUNT(query_name), 2) AS poor_query_percentage
FROM queries GROUP BY query_name

-----------
-- Day 3 --
-----------

-- 1607. Sellers With No Sales
SELECT A.seller_name AS SELLER_NAME 
FROM seller A LEFT JOIN orders B ON A.seller_id = B.seller_id 
WHERE A.seller_id NOT IN (SELECT seller_id FROM orders WHERE YEAR(sale_date)=2020)
ORDER BY A.seller_name

-- 619. Biggest Single Number
SELECT MAX(num) AS num FROM (SELECT num FROM MyNumbers GROUP BY num HAVING count(*) = 1) A

-- 1112. Highest Grade For Each Student
SELECT student_id, MIN(course_id) AS course_id, grade FROM Enrollments
WHERE (student_id, grade) IN (SELECT student_id, MAX(grade) FROM Enrollments GROUP BY student_id)
GROUP BY student_id ORDER BY student_id, course_id

-- 1398. Customers Who Bought Products A and B but Not C [Good Question] 
SELECT DISTINCT customer_id, customer_name FROM Customers
WHERE customer_id NOT IN (SELECT customer_id FROM Orders WHERE product_name = 'C')
AND customer_id IN (SELECT customer_id FROM Orders WHERE product_name = 'A')
AND customer_id IN (SELECT customer_id FROM Orders WHERE product_name = 'B')
ORDER BY customer_id

-----------
-- Day 4 --
-----------

-- 1440. Evaluate Boolean Expression [Good Question]
SELECT E.*, CASE E.operator WHEN ">" THEN IF(V1.value > V2.value, "true", "false")
                            WHEN "=" THEN IF(V1.value = V2.value, "true", "false")
                            WHEN "<" THEN IF(V1.value < V2.value, "true", "false")
                            END AS value 
FROM Expressions E LEFT JOIN Variables V1
ON E.left_operand = V1.name
LEFT JOIN Variables V2
ON E.right_operand = V2.name

-- 1264. Page Recommendations [Meta]
SELECT DISTINCT B.page_id AS recommended_page 
FROM Friendship A INNER JOIN Likes B
ON A.user1_id = B.user_id OR A.user2_id = B.user_id 
WHERE (A.user1_id = 1 OR A.user2_id = 1) AND B.page_id NOT IN (SELECT page_id FROM Likes WHERE user_id = 1)

-- 570. Managers with at Least 5 Direct Reports
SELECT M.name FROM Employee E JOIN Employee M 
WHERE E.managerId = M.id GROUP BY E.managerId HAVING COUNT(*) >= 5

-- 1303. Find the Team Size
SELECT employee_id, COUNT(employee_id) OVER (PARTITION BY team_id) AS team_size FROM Employee 

-----------
-- Day 5 --
-----------

-- 1280. Students and Examinations [Redo using subquery and join]
SELECT A.student_id, A.student_name, B.subject_name, COUNT(C.subject_name) AS attended_exams
FROM Students A JOIN Subjects B LEFT JOIN Examinations C ON A.student_id = C.student_id AND B.subject_name = C.subject_name 
GROUP BY A.student_id, B.subject_name ORDER BY student_id, subject_name 

-- 1501. Countries You Can Safely Invest In [Revisit]
SELECT A.name as country 
FROM 
    (SELECT CO.name, AVG(C.duration) AS co_duration 
    FROM calls C 
    JOIN person P ON P.id = C.caller_id OR P.id = C.callee_id 
    JOIN country CO ON substring(P.phone_number, 1, 3) = CO.country_code
    GROUP BY CO.name) A 
WHERE A.co_duration > (SELECT AVG(C.duration) AS go_duration FROM calls C)
JOIN person P ON P.id = C.caller_id OR P.id = C.callee_id 
JOIN country CO ON substring(P.phone_number, 1, 3) = CO.country_code

-- 184. Department Highest Salary [Revisit]
SELECT D.Name as Department, E.Name as Employee, E.Salary
FROM Department D, Employee E, Employee E2
WHERE D.ID = E.DepartmentId and E.DepartmentId = E2.DepartmentId AND E.Salary <= E2.Salary
GROUP BY D.ID, E.Name HAVING COUNT(DISTINCT E2.Salary) = 1
ORDER BY D.Name DESC

-- 580. Count Student Number in Departments [Revisit]
SELECT D.dept_name AS dept_name, COUNT(S.student_id) AS student_number FROM student AS S 
RIGHT JOIN department AS D ON S.dept_id = D.dept_id 
GROUP BY D.dept_name ORDER BY student_number DESC

-----------
-- Day 6 --
-----------

-- 1294. Weather Type in Each Country
SELECT B.country_name, A.weather_type
FROM 
    (SELECT country_id, 
            CASE WHEN AVG(weather_state) <= 15 THEN "Cold"
            WHEN AVG(weather_state) >= 25 THEN "Hot"
            ELSE "Warm" END AS weather_type 
     FROM Weather WHERE MONTH(day) = 11 AND YEAR(day) = 2019 GROUP BY country_id
    ) A, 
Countries B 
WHERE A.country_id = B.country_id

-- 626. Exchange Seats
/*
Using flow control statement CASE: For students with odd id, the new id is (id+1) after switch unless it is the last seat. 
And for students with even id, the new id is (id-1). In order to know how many seats in total, we can use a subquery. 
Then, we can use the CASE statement and MOD() function to alter the seat id of each student.
*/

SELECT
    (CASE
        WHEN MOD(id, 2) != 0 AND counts != id THEN id + 1
        WHEN MOD(id, 2) != 0 AND counts = id THEN id
        ELSE id - 1
    END) AS id,
    student
FROM
    seat,
    (SELECT
        COUNT(*) AS counts
    FROM
        seat) AS seat_counts
ORDER BY id ASC

-- 1783. Grand Slam Titles [Good Question] 
SELECT player_id, player_name, 
       SUM(player_id = Wimbledon) + SUM(player_id = Fr_open)
       + SUM(player_id = US_open) + SUM(player_id = Au_open) AS grand_slams_count
FROM Players JOIN Championships 
ON player_id = Wimbledon OR player_id = Fr_open 
    OR player_id = US_open OR player_id = Au_open
GROUP BY player_id

-- 1164. Product Price at a Given Date
SELECT A.product_id, IFNULL(B.new_price, 10) AS price
FROM 
    (SELECT DISTINCT product_id FROM Products) A
LEFT JOIN 
    (SELECT product_id, new_price FROM Products 
        WHERE (product_id, change_date) IN 
            (SELECT product_id, MAX(change_date) 
             FROM Products 
             WHERE change_date <= '2019-08-16' 
             GROUP BY product_id)
    ) B
ON A.product_id = B.product_id

-----------
-- Day 7 --
-----------

-- 603. Consecutive Available Seats
SELECT DISTINCT A.seat_id FROM Cinema A JOIN Cinema B 
ON ABS(A.seat_id - b.seat_id) = 1 AND a.free = TRUE AND b.free = TRUE
ORDER BY seat_id

-- 1731. The Number of Employees Which Report to Each Employee
SELECT A.reports_to AS employee_id,
	   B.name AS name,
	   COUNT(A.employee_id) AS reports_count,
	   ROUND(AVG(A.age)) AS average_age
FROM Employees A JOIN Employees A ON A.reports_to = B.employee_id
WHERE A.reports_to IS NOT NULL 
GROUP BY A.reports_to ORDER BY A.reports_to

-- 1747. Leetflex Banned Accounts
SELECT DISTINCT A.account_id FROM LogInfo A JOIN Loginfo B 
ON A.account_id = B.account_id AND A.ip_address <> B.ip_address
WHERE A.login BETWEEN B.login AND B.logout OR B.login BETWEEN A.login and A.logout 

-- 181. Employees Earning More Than Their Managers
SELECT A.name AS Employee FROM Employee A JOIN Employee B 
ON A.managerId = B.id WHERE A.salary > B.salary

-----------
-- Day 8 --
-----------

-- 1459. Rectangles Area
SELECT A.id AS P1, B.id AS P2,  
       ABS(A.x_value - B.x_value)*ABS(A.y_value - B.y_value) AS area
FROM Points A JOIN Points B 
ON A.x_value != B.x_value AND A.y_value != B.y_value AND A.id < B.id
ORDER BY area DESC, P1 ASC, P2 ASC

-- 180. Consecutive Numbers
SELECT DISTINCT(A.num) AS ConsecutiveNums FROM 
(
SELECT id, 
       num, 
       LAG(num, 1, 0) OVER (ORDER BY id) AS num2, 
       LAG(num, 2, 0) over (ORDER BY id) AS num3
FROM Logs ORDER BY id
) A 
WHERE A.num = A.num2 AND A.num3 = A.num2

-- 1988. Find Cutoff Score for Each School
SELECT school_id, IFNULL(MIN(SCORE), -1) AS score
FROM Schools A LEFT JOIN Exam B ON A.capacity >= B.student_count
GROUP BY school_id

-----------
-- Day 9 --
-----------

-- 1549. The Most Recent Orders for Each Product
SELECT B.product_name, A.product_id, A.order_id, A.order_date 
FROM Orders A JOIN Products B ON A.product_id = B.product_id 
WHERE (A.product_id, A.order_date) IN 
    (
        SELECT product_id, MAX(order_date) AS order_date
        FROM Orders
        GROUP BY product_id
    )
ORDER BY B.product_name, A.product_id, A.order_id

-- 1321. Restaurant Growth
SELECT T1.visited_on AS visited_on, 
       SUM(amount) AS amount,
       ROUND(SUM(AMOUNT)/7, 2) AS average_amount
FROM (
        SELECT DISTINCT(visited_on) AS visited_on FROM Customer
        WHERE DATE_SUB(visited_on, INTERVAL 6 DAY) IN 
            (
                SELECT DISTINCT(visited_on) FROM Customer
            )
     ) AS T1
LEFT JOIN Customer as T2
ON T2.visited_on BETWEEN DATE_SUB(t1.visited_on, INTERVAL 6 DAY) 
    AND T1.visited_on GROUP BY T1.visited_on

-- 1045. Customers Who Bought All Products
SELECT customer_id FROM Customer GROUP BY customer_id 
HAVING (COUNT(DISTINCT product_key) = (SELECT COUNT(product_key) FROM Product))

------------
-- Day 10 --
------------

-- 1341. Movie Rating 
SELECT user_name AS results FROM 
(
    SELECT B.name AS user_name, COUNT(*) AS counts 
    FROM MovieRating A JOIN USERS B
    ON A.user_id = B.user_id
    GROUP BY A.user_id
    ORDER BY counts DESC, user_name ASC LIMIT 1
) C

UNION

SELECT movie_name AS results FROM 
(
    SELECT D.TITLE AS movie_name, AVG(E.rating) AS grade
    FROM MovieRating E JOIN Movies D
    ON E.movie_id = D.movie_id
    WHERE SUBSTR(E.created_at, 1, 7) = "2020-02"
    GROUP BY E.movie_id ORDER BY grade DESC, movie_name ASC LIMIT 1
) F

-- 1867. Orders With Maximum Quantity Above Average
WITH order_quantity AS 
(
    SELECT order_id, 
           SUM(quantity) / COUNT(product_id) AS average_quantity, 
           MAX(quantity) AS maximum_quantity
    FROM OrdersDetails 
    GROUP BY order_id
)

SELECT order_id FROM order_quantity 
WHERE maximum_quantity > (SELECT MAX(average_quantity) FROM order_quantity)

------------
-- Day 11 --
------------

-- 550. Game Play Analysis IV
SELECT ROUND(COUNT(NULLIF(A.event_date, NULL))/COUNT(*), 2) fraction
FROM ACTIVITY A RIGHT JOIN 
(
    SELECT player_id, MIN(event_date) event_date FROM Activity
    GROUP BY player_id
) B
ON DATEDIFF(A.event_date, b.event_date) = 1
    AND A.player_id = B.player_id

-- 262. Trips and Users [Important] 
SELECT T.request_at AS Day, 
       ROUND(AVG(IF(T.status <> 'completed', 1, 0)), 2) AS 'Cancellation Rate'
FROM Trips T JOIN Users U ON T.client_id = U.users_id AND U.banned = "No"
WHERE T.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY T.request_at
