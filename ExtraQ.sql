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

