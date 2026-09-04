-- # Write your MySQL query statement below
-- select distinct(l.num) as ConsecutiveNums from Logs l
-- where (select num from Logs where id = l.id-1) = l.num and
-- (select num from Logs where id = l.id+1) = num;

select distinct l1.num as ConsecutiveNums from Logs l1
join Logs l2 on l1.id = l2.id - 1
join Logs l3 on l1.id = l3.id +1
where l1.num = l2.num and
l1.num = l3.num;
