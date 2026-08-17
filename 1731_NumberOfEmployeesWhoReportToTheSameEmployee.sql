# Write your MySQL query statement below
select * from
(select  m.employee_id, m.name,
count(*)
as reports_count, round(avg(e.age)) as average_age from 
Employees e join Employees m on e.reports_to = m.employee_id
group by m.employee_id, e.reports_to order by m.employee_id)
as sub;

-- So, we will be joining. After using the inner join, the only matching rows will remain. So, there is employee ID, there is name, there is reports to, and age. So, we are joining using the reports to and employee ID. Okay. So, in the first table, employee ID, we will take only the employees, and the second table we will do the manager table. Okay, M. So now, after joining in the employee table, it will only remain Alice and Bob, and in the M, the manager table, it will only remain Harry boss. Because the second table, we are taking the employee ID, and the first table we are taking the reports to ID to join them. Okay. So the table will return Alice reports to 9, Harry, and Bob reports to 9, and Harry. So, that table contains only two rows. Okay. Now, we use GROUP BY. GROUP BY what? We use GROUP BY by reports to and employee ID. Because every reports to and employee ID will make a unique combination. Like, Alice reports to 9, and 9 is a manager ID. Then 9 and 9 creates a unique combination. So Bob reports to 9, and Harry has an employee ID of 9. Then he also belongs to the group. That means every employee that belongs under the manager will come into the same group. Then what we do? Then we just count the number of rows in that group, the group we are making. Okay. And also, to get the average. Now, when we group by, the employees that have the same manager will be in the same group, so their age will also be in the same group. So now, we just average the employee age and return it. That's it.
