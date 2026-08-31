select v.customer_id , count(v.customer_id) as count_no_trans
from Visits v
left join Transactions t 
on v.visit_id = t.visit_id
-- c_id - v_id - t_id
--   23 -  1  -  12
--    9 -  2  -  13
--   30 -  4  -  Null
--   54 -  5  -  2
--   96 -  6  -  Null
--   54 -  7  -  Null
--   54 -  8  -  Null
where t.transaction_id is NULL
-- condition on the join so only join those rows where transaction id is null,
-- dont just join all rows that matches the on condition
--   30 -  4  -  Null
--   96 -  6  -  Null
--   54 -  7  -  Null
--   54 -  8  -  Null
group by v.customer_id;
--  30 - 4 - N
--  96 - 6 - N
--  54 - 7,8 - N

example-
1. Multiple conditions
SELECT *
FROM Visits v
JOIN Transactions t
    ON v.visit_id = t.visit_id
   AND t.amount > 100;

This means:

Join a transaction to a visit only if the visit IDs match and the transaction amount is > 100.

2. Conditions using different columns
JOIN Employees e
    ON e.department_id = d.department_id
   AND e.salary > 50000

Very important: ON vs WHERE
Consider:
FROM Visits v
LEFT JOIN Transactions t
    ON v.visit_id = t.visit_id
    AND t.amount > 100

The condition t.amount > 100 determines which transactions are allowed to match.
Whereas:

FROM Visits v
LEFT JOIN Transactions t
    ON v.visit_id = t.visit_id
WHERE t.amount > 100

The WHERE condition filters the result after the join.
This distinction becomes especially important with LEFT JOIN.
A good mental model is:
ON = rules for matching rows.
WHERE = rules for filtering the resulting rows.
