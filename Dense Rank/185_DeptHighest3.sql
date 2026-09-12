# Write your MySQL query statement below
select Department, Employee, Salary from (
    select d.name as Department,
    e.salary as Salary,
    e.name as Employee,
    dense_rank() over (partition by d.id 
    order by e.salary desc) as rnk
    from Department d join Employee e
    on e.departmentId = d.id
) temp where rnk <= 3;
