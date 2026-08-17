-- Write your MySQL query statement below
select event_day as day, emp_id, sum(time) as total_time from(
select event_day, emp_id, out_time - in_time as time from Employees
) as time_segment group by event_day, emp_id;

-- i wrote this shitttt
-- internally emp_id, event_day and time niye akta kore row banalam
-- erpor oikhaner emp_id ar day diye group by korlam ar time gulake sum korlam
