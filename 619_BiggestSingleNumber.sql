-- # Write your MySQL query statement below
select max(num) as num from
(SELECT num from MyNumbers group by num having count(num) = 1) as unique_nums;
-- --Why the alias is needed
-- MySQL requires every subquery in the FROM clause to have a name: thats why unique_nums is given
