SELECT firstName, lastName, city, state FROM Person
INNER JOIN Address ON Person.personId=Address.personId;

---inner join takes only the matched rows that are available
---in both tables, left join takes all from left table and 
---only matching from right, and right does the opposite
