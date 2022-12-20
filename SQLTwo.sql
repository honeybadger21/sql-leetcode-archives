-- Solution Archive for LeetCode SQL Study Plan - II 
-- 11 Days of SQL practice, created by Ruchi Sharma [UT Austin '23, IIT Roorkee '21]
-- [19 Dec 2022, 19 Dec 2022] 

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
