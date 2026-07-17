-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | name        | varchar |
-- | salary      | int     |
-- | managerId   | int     |
-- +-------------+---------+
-- id is the primary key (column with unique values) for this table.
-- Each row of this table indicates the ID of an employee, their name, salary, and the ID of their manager.

 

-- Write a solution to find the employees who earn more than their managers.

-- Return the result table in any order.
--=========================================================================================================================
SELECT e.name as Emp from Employee e join Employee m on e.managerId = m.id where e.salary > m.salary;

-- What's happening?
-- Employee e → treat the table as the employee table.
-- Employee m → treat the same table as the manager table.
-- e.managerId = m.id → pair each employee with their manager.
-- e.salary > m.salary → keep only employees earning more than their manager.
-- SELECT e.name → return the employee's name.

-- Why a self join?
-- The Employee table contains both employees and managers. So we treat it as two copies:
-- e → the employee
-- m → the employee's manager
