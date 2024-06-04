-- 1683. Invalid Tweets
select distinct tweet_id from tweets where length(content) > 15

-- 1378. Replace employee ID with the unique identifier 
select unique_id, name from employees e1 left join employeeUNI e2 on e1.id=e2.id

-- 1068. Product Sales Analysis I
select product_name, year, price from sales a left join product b on a.product_id = b.product_id
