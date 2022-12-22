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















