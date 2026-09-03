# Write your MySQL query statement below
select w1.id from Weather w1 
join Weather w2 
on w1.recordDate = DATE_ADD(w2.recordDate,Interval 1 day) 
where w1.temperature > w2.temperature;

on w1.recordDate = w2.recordDate+1
will make 31/01/2021 to 32/01/2021 not 1st feb
