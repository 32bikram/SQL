-- Write your MySQL query statement below
select class from Courses group by class having count(*) > 4;
-- select class from Courses group by class where count(*) > 4;

-- WHERE → filters individual rows before grouping
-- HAVING → filters groups after GROUP BY

-- like select class from courses where class != math group by class having count(*)>4 order by desc;

-- typical order of query
-- FROM
--   ↓
-- WHERE
--   ↓
-- GROUP BY
--   ↓
-- HAVING
--   ↓
-- CONDITION
--   ↓
-- ORDER BY
