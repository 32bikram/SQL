CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
    select e.salary from 
    (select salary ,dense_rank() over 
    (order by salary DESC) as r from Employee)
    e where e.r = N limit 1
  );
END


-- (select salary ,dense_rank() over 
--     (order by salary DESC) as r from Employee)

-- select the salaries and assign them rank as r from the employee column
-- this returns the table as salary, r format


-- now that format is made an allias table called e.
-- it is a temporary table.

-- now just select salary from e where rank matches the given rank
