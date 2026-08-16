# Write your MySQL query statement below
select customer_number from Orders 
group by customer_number order by count(*) desc limit 1;

-- When SQL reaches:
-- GROUP BY customer_number
-- it conceptually creates:
-- customer_number = 10
--     → row 1
--     → row 3
--     → row 5
-- customer_number = 20
--     → row 2
--     → row 6
-- Now COUNT(*) operates inside each group, not on the entire table.
-- So:
-- COUNT(*)
-- means:
-- "Count all rows in this particular group."
-- Therefore:
-- customer 10 → COUNT(*) = 3
-- customer 20 → COUNT(*) = 2
-- customer 30 → COUNT(*) = 1
