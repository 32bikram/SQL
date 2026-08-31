-- # Write your MySQL query statement below
select * from Patients where conditions like 'DIAB1%' or conditions like '% DIAB1%';


1. The Two Essential Wildcards
    % (Percent sign): Represents zero, one, or multiple characters.
    _ (Underscore): Represents exactly one single character.
2. Common Pattern Matching ExamplesPatternWhat it MatchesSQL ExampleMatches...
'A%'Starts with "A"WHERE name LIKE 'A%'Apple, Alice, A
'%ing'Ends with "ing"WHERE job LIKE '%ing'Marketing, Running
'%data%'Contains "data" anywhereWHERE info LIKE '%data%'Database, Mydata, Metadata
'A%Z'Starts with "A" and ends with "Z"WHERE code LIKE 'A%Z'AZ, AmazonZ, A123Z
'_at'Exactly 3 characters long, ending in "at"WHERE word LIKE '_at'Cat, Hat, Bat
'A__%'Starts with "A" and is at least 3 characters longWHERE code LIKE 'A__%'Alex, App (but not "An")3.

3.Negating a Pattern (NOT LIKE)If you want to find records that do not match a pattern, use NOT LIKE:sql-- Finds all users whose email does NOT end in @gmail.com
SELECT * FROM users 
WHERE email NOT LIKE '%@gmail.com';

4. Advanced Quick TipsCase Sensitivity: In SQL Server and MySQL, LIKE is usually case-insensitive by default. In PostgreSQL, LIKE is case-sensitive; you must use ILIKE for case-insensitive matching.

Escaping Wildcards: If you need to search for a literal % or _, use an escape character:sql-- Finds strings containing "10%"
WHERE discount LIKE '%10!%%' ESCAPE '!';
