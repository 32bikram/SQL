--Write your MySQL query statement below
select sell_date,
count(distinct product) as num_sold,
group_concat(distinct product) as products
from Activities
group by sell_date
order by sell_date;

-- group by the sell_date
-- group_concat(distinct product) as products
-- then concat the whole group and select only distict products
-- count(distinct product) as num_sold,
-- count only the distinct product
-- selct the sell_date
