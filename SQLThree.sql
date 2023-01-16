-- Solution Archive for LeetCode SQL Study Plan - III
-- 10 Days of SQL practice, created by Ruchi Sharma [UT Austin '23, IIT Roorkee '21]
-- [30 Dec 2022, 8 Jan 2023] 

-----------
-- Day 1 --
-----------

-- 1303. Find the Team Size
SELECT employee_id, COUNT(employee_id) OVER (PARTITION BY team_id) AS team_size FROM Employee 

-- 1308. Running Total for Different Genders
SELECT gender, day, SUM(score_points) OVER(PARTITION BY gender ORDER BY day) AS total FROM Scores
