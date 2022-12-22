-- Solution Archive for LeetCode SQL Study Plan - I 
-- 10 Days of SQL practice, created by Ruchi Sharma [UT Austin '23, IIT Roorkee '21]
-- [30 Sept 2022, 9 Oct 2022] 

-- Badge Earned: SQL I, https://leetcode.com/WamDam/

-----------
-- Day 1 --
-----------

-- 595. Big Countries
select name, population, area from World
where area >= 3000000 or population >= 25000000;

-- 1757. Recylable and Low Fat Products
select product_id from Products
where low_fats = 'Y' and recyclable = 'Y';

-- 584. Find Customer Reference 
select name from Customer 
where referee_id != 2 or referee_id is Null;

-- 183. Customers Who Never Order 
select name as Customers from Customers
left join Orders on Customers.id = Orders.customerId
where Orders.customerId is Null

-----------
-- Day 2 --
-----------

-- 1873. Calculate Special Bonus 
select employee_id, (case when employee_id%2=0 or name like 'M%' then 0 else salary end) as bonus 
from Employees order by employee_id;

-- 627. Swap Salary 
update Salary set sex = case when sex = 'f' then 'm' when sex = 'm' then 'f' end

-- 196. Delete Duplicate Emails 
DELETE FROM Person WHERE Id NOT IN (SELECT * FROM(SELECT MIN(Id) 
FROM Person GROUP BY Email) as p);

-----------
-- Day 3 --
-----------

-- 1667. Fix Names in a Table
select user_id, concat(upper(substring(name, 1, 1)), lower(substring(name, 2))) as name 
from Users order by user_id;

-- 1484. Group Sold Products 
select sell_date, count(distinct product) as num_sold, group_concat(distinct product order by product) as products 
from Activities group by sell_date order by sell_date 

-- 1527. Pateints With a Condition 
SELECT * FROM patients WHERE conditions REGEXP '\\bDIAB1'

-----------
-- Day 4 --
-----------

-- 1965. Employees With Missing Information
select employee_id from employees where employee_id not in (select employee_id from salaries) union select employee_id 
from salaries where employee_id not in (select employee_id from employees) order by employee_id;

-- 1795. Rearrange Product Table
select product_id, 'store1' as store, store1 as price from products where store1 is not null 
union 
select product_id, 'store2' as store, store2 as price from products where store2 is not null 
union 
select product_id, 'store3' as store, store3 as price from products where store3 is not null 

-- 608. Tree Node
# Write your MySQL query statement below

select 
    id, 'Root' as Type
from 
    tree
where 
    p_id is null 

union

select 
    id, 'Leaf' as Type
from 
    tree
where 
    id not in (select distinct p_id from tree where p_id is not null)
    and 
    p_id is not null 
    
union 

select 
    id, 'Inner' as Type
from 
    tree
where 
    id in (select distinct p_id from tree where p_id is not null)
    and
    p_id is not null
    
order by id;
    
-- 176. Second Highest Salary
select
(select distinct salary from employee order by salary desc limit 1 offset 1)
as SecondHighestSalary

-----------
-- Day 5 --
-----------

-- 175. Combine Two Tables 
select FirstName, LastName, City, State
from Person left join Address on Person.PersonId = Address.PersonId

-- 1581. Customer Who Visited But Did Not Make Any Transactions
select customer_id, count(customer_id) as count_no_trans from Visits
left join Transactions on Transactions.visit_id = Visits.visit_id
where transaction_id is NULL group by customer_id

-- 1148. Article Views I. 
select distinct author_id as id 
from Views where author_id = viewer_id order by id

-----------
-- Day 6 --
-----------

-- 197. Rising Temprature 
select weather.id as 'Id' from weather 
join weather w on datediff(weather.recordDate, w.recordDate) = 1 and weather.Temperature > w.Temperature

-- Sales Person
select s.name from salesperson s 
where s.sales_id not in (select o.sales_id from orders o left join company c on o.com_id = c.com_id where c.name = 'RED') 

-----------
-- Day 7 --
-----------

-- User Activity For The Past 30 Days I
select activity_date as day, count(distinct user_id) as active_users 
from activity where (activity_date > "2019-06-27" and activity_date <= "2019-07-27") group by activity_date; 

-- Daily Leads and Partners 
select date_id, make_name, count(distinct lead_id) as unique_leads, count(distinct partner_id) as unique_partners 
from DailySales group by 1, 2; 

-- Find Followers Count
select user_id, count(distinct follower_id) as followers_count 
from Followers group by 1;

-----------
-- Day 8 --
-----------

-- Customer Placing The Largest Number of Orders 
select customer_number from Orders group by customer_number 
order by count(*) desc limit 1

-- Game Play Analysis I
select player_id, min(event_date) as first_login 
from Activity group by 1

-- The Latest Login in 2020
select user_id, max(time_stamp) as last_stamp from Logins
where time_stamp >= '2020-01-01 00:00:00' and time_stamp < '2021-01-01 00:00:00'
group by 1

-- Find Total Time Spent by Each Employee
select event_day as day, emp_id, (sum(out_time)-sum(in_time)) as total_time 
from Employees group by emp_id, day

-----------
-- Day 9 --
-----------

-- Capital Gain/Loss 
select stock_name, SUM(CASE WHEN operation = 'Sell' THEN price ELSE -price END) as capital_gain_loss 
from stocks group by stock_name;

-- Top Travellers 
select distinct u.name, ifnull(sum(distance) over (partition by user_id), 0) as travelled_distance 
from rides r right join users u on r.user_id = u.id order by travelled_distance desc, name

-- Market Analysis I 
SELECT user_id AS buyer_id, join_date, SUM(IF(YEAR(order_date) = '2019', 1, 0)) AS orders_in_2019 
FROM users u LEFT JOIN orders o ON u.user_id = o.buyer_id GROUP BY user_id; 

------------
-- Day 10 --
------------

-- Duplicate Emails 
select email from Person group by email having count(*)>1

-- Actors and Directors Who Cooperated Atleast Three Times 
select actor_id, director_id 
from ActorDirector group by 1, 2 having count(timestamp) > 2

-- Bank Account Summary II 
select a.name, sum(amount) as balance from Transactions b 
inner join Users a on b.account = a.account 
group by b.account having balance >= 10000

-- Sales Analysis III 
select product_id, product_name from Sales 
join Product using(product_id) 
group by product_id 
having min(sale_date) >= '2019-01-01' and max(sale_date) <= '2019-03-31'

