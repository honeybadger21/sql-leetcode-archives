-- 1683. Invalid Tweets
select distinct tweet_id from tweets where length(content) > 15

-- 1378. Replace employee ID with the unique identifier 
select unique_id, name from employees e1 left join employeeUNI e2 on e1.id=e2.id

-- 1068. Product Sales Analysis I
select product_name, year, price from sales a left join product b on a.product_id = b.product_id

-- 1661. Average Time of Process per Machine
select machine_id, round(sum(ok)/count(process_id), 3) as processing_time from (
select * from(
select a1.machine_id, a1.process_id, round((a2.timestamp-a1.timestamp), 3) as ok from activity a1 join activity a2
on a1.machine_id = a2.machine_id and a1.process_id = a2.process_id) t where ok>0
) t2
group by 1

-- 577. Employee Bonus
select name, bonus from employee a left join bonus b on a.empId = b.empId 
where bonus is null or bonus < 1000

-- 1280. Students and Examinations
-- good cross join use 
SELECT s.student_id, s.student_name, sub.subject_name, COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e ON s.student_id = e.student_id AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;

-- 570. Managers with at Least 5 Direct Reports
select e.name from (
select managerId, count(id) s from employee where managerId is not null group by 1 having s >= 5
) t
join employee e on t.managerId = e.id

-- 1934. Confirmation Rate
WITH rate_cte AS
  (SELECT user_id,
          ROUND(SUM(CASE
                        WHEN action='confirmed' THEN 1
                        ELSE 0
                    END) / COUNT(*), 2) AS confirmation_rate
   FROM Confirmations
   GROUP BY user_id
   ORDER BY NULL)

SELECT s.user_id,
       IFNULL(r.confirmation_rate, 0) AS confirmation_rate
FROM Signups s
LEFT JOIN rate_cte r ON s.user_id = r.user_id;

-- 1251. Average Selling Price 
-- this is a fun question, nice problem solving 
select distinct(q.product_id), IFNULL(t2.average_price,0) as average_price from 
prices q left join
(
select product_id, round(sum(price*units)/sum(units), 2) as average_price from (
select p.product_id, p.price, u.units from prices p join unitssold u on p.start_date <= u.purchase_date and p.end_date >= u.purchase_date and p.product_id = u.product_id
) t1
group by 1
) t2
on q.product_id = t2.product_id

-- 1075. Project Employees I
select project_id, round(sum(experience_years)/count(name), 2) as average_years
from project p join employee e on p.employee_id=e.employee_id
group by 1
