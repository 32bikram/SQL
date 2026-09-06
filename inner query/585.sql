# Write your MySQL query statement below
select ROUND(sum(tiv_2016), 2) as tiv_2016
from Insurance I 
where tiv_2015 in
(select tiv_2015 from Insurance group by tiv_2015 having count(*) > 1) 
and pid in 
(select pid from Insurance group by lat, lon having count(*) = 1);
