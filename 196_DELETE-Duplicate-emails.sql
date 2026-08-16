# Write your MySQL query statement below
delete p1 from Person p1 join Person p2 on p1.email = p2.email and p1.id > p2.id;

-- delete works on a whole row not an attribute thats why deleting whole p1 row
-- Top 1%
-- DELETE FROM Person
-- WHERE id NOT IN (
--     SELECT id
--     FROM (
--         SELECT MIN(id) AS id
--         FROM Person
--         GROUP BY email
--     ) AS temp
-- );

-- select the minimum id from each emaail group, do this for all the group,
-- now if any emails arent in that list delete it
