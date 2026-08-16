SQL JOIN — COMPLETE VISUAL GUIDE
================================
1. TWO TABLES
=============
Students
--------
+------------+-------+-----------+
| student_id | name  | course_id |
+------------+-------+-----------+
| 1          | Alice | 101       |
| 2          | Bob   | 102       |
| 3          | Charlie| 103      |
| 4          | David | 999       |
+------------+-------+-----------+
Courses
-------
+-----------+-------------+
| course_id | course_name |
+-----------+-------------+
| 101       | SQL         |
| 102       | Python      |
| 103       | Java        |
| 104       | C++         |
+-----------+-------------+
JOIN CONDITION
==============
Students.course_id = Courses.course_id
Important cases:

Alice   -> 101 -> SQL       MATCH
Bob     -> 102 -> Python    MATCH
Charlie -> 103 -> Java      MATCH
David   -> 999 -> ???       NO MATCH

104 -> C++ -> NO STUDENT

2. WHAT DOES JOIN ACTUALLY DO?
==============================

A JOIN essentially says:

"Take rows from two tables and combine rows
when the ON condition is TRUE."

Students                         Courses

Alice   -----------------------> SQL
Bob     -----------------------> Python
Charlie -----------------------> Java
David   -----------------------> ???       NO MATCH

                                    C++    NO STUDENT

The JOIN compares rows.

It does NOT simply glue two tables together.

3. INNER JOIN
==============

SQL:

SELECT *
FROM Students s
INNER JOIN Courses c
    ON s.course_id = c.course_id;

OUTPUT:

+------------+---------+-----------+-----------+-------------+
| student_id | name    | course_id | course_id | course_name |
+------------+---------+-----------+-----------+-------------+
| 1          | Alice   | 101       | 101       | SQL         |
| 2          | Bob     | 102       | 102       | Python      |
| 3          | Charlie | 103       | 103       | Java        |
+------------+---------+-----------+-----------+-------------+

David disappears:

David.course_id = 999
There is no:
Courses.course_id = 999

C++ disappears:
Courses.course_id = 104
There is no:
Students.course_id = 104


VISUAL:
Students                 Courses
Alice   ---------------- SQL        KEEP
Bob     ---------------- Python     KEEP
Charlie ---------------- Java       KEEP
David   ---------------- ???        REMOVE

                         C++        REMOVE

MENTAL MODEL:
INNER JOIN = ONLY MATCHES

4. LEFT JOIN
=============
SQL:
SELECT *
FROM Students s
LEFT JOIN Courses c
    ON s.course_id = c.course_id;

OUTPUT:
+------------+---------+-----------+-----------+-------------+
| student_id | name    | course_id | course_id | course_name |
+------------+---------+-----------+-----------+-------------+
| 1          | Alice   | 101       | 101       | SQL         |
| 2          | Bob     | 102       | 102       | Python      |
| 3          | Charlie | 103       | 103       | Java        |
| 4          | David   | 999       | NULL      | NULL        |
+------------+---------+-----------+-----------+-------------+

Why is David still there?
Because Students is the LEFT table.
LEFT JOIN says:
"KEEP EVERYTHING FROM THE LEFT TABLE."
David has no matching course, so the Courses columns
become NULL.

VISUAL:
Students                 Courses
Alice   ---------------- SQL        KEEP
Bob     ---------------- Python     KEEP
Charlie ---------------- Java       KEEP
David   ---------------- ???        KEEP
                                     ^
                                     |
                                    NULL


C++ is NOT included because C++ belongs to the
RIGHT table and LEFT JOIN does not preserve
unmatched rows from the right table.

MENTAL MODEL:
LEFT JOIN = EVERYTHING FROM LEFT + MATCHES FROM RIGHT

5. RIGHT JOIN
==============
SQL:

SELECT *
FROM Students s
RIGHT JOIN Courses c
    ON s.course_id = c.course_id;


OUTPUT:
+------------+---------+-----------+-----------+-------------+
| student_id | name    | course_id | course_id | course_name |
+------------+---------+-----------+-----------+-------------+
| 1          | Alice   | 101       | 101       | SQL         |
| 2          | Bob     | 102       | 102       | Python      |
| 3          | Charlie | 103       | 103       | Java        |
| NULL       | NULL    | NULL      | 104       | C++         |
+------------+---------+-----------+-----------+-------------+


C++ stays because Courses is the RIGHT table.
There is no student for C++.
Therefore:
student_id = NULL
name       = NULL
student columns = NULL

VISUAL:
Students                 Courses
Alice   ---------------- SQL        KEEP
Bob     ---------------- Python     KEEP
Charlie ---------------- Java       KEEP

                         C++        KEEP
                          ^
                          |
                         NULL student

David disappears because David belongs to the
LEFT table and has no matching course.
MENTAL MODEL:
RIGHT JOIN = EVERYTHING FROM RIGHT + MATCHES FROM LEFT

6. FULL OUTER JOIN
===================
SQL:
SELECT *
FROM Students s
FULL OUTER JOIN Courses c
    ON s.course_id = c.course_id;
   
OUTPUT:
+------------+---------+-----------+-----------+-------------+
| student_id | name    | course_id | course_id | course_name |
+------------+---------+-----------+-----------+-------------+
| 1          | Alice   | 101       | 101       | SQL         |
| 2          | Bob     | 102       | 102       | Python      |
| 3          | Charlie | 103       | 103       | Java        |
| 4          | David   | 999       | NULL      | NULL        |
| NULL       | NULL    | NULL      | 104       | C++         |
+------------+---------+-----------+-----------+-------------+
Everything survives.
VISUAL:
Students                 Courses
Alice   ---------------- SQL
Bob     ---------------- Python
Charlie ---------------- Java

David   ---------------- ???        KEEP

                         C++        KEEP

MENTAL MODEL:
FULL JOIN = EVERYTHING FROM BOTH TABLES

7. ALL JOINS COMPARED
=====================
Original unmatched rows:
Students:
    David
Courses:
    C++

+----------------+--------+-----+---------+-------+-----+
| JOIN           | Alice  | Bob | Charlie | David | C++ |
+----------------+--------+-----+---------+-------+-----+
| INNER JOIN     |   YES  | YES |   YES   |  NO   | NO  |
| LEFT JOIN      |   YES  | YES |   YES   | YES   | NO  |
| RIGHT JOIN     |   YES  | YES |   YES   |  NO   | YES |
| FULL JOIN      |   YES  | YES |   YES   | YES   | YES |
+----------------+--------+-----+---------+-------+-----+

EASY WAY TO REMEMBER:

INNER
    -> Only matches

LEFT
    -> Everything on LEFT
    -> Plus matches from RIGHT

RIGHT
    -> Everything on RIGHT
    -> Plus matches from LEFT

FULL
    -> Everything from BOTH

8. VERY IMPORTANT EDGE CASE:
   MULTIPLE MATCHES
===============================

This is one of the most important things
to understand about JOINs.

Suppose Courses is:
+-----------+----------------+
| course_id | course_name    |
+-----------+----------------+
| 101       | SQL            |
| 101       | Advanced SQL   |
| 102       | Python         |
| 103       | Java           |
| 104       | C++            |
+-----------+----------------+

Alice has:
course_id = 101
Now:

SELECT *
FROM Students s
JOIN Courses c
    ON s.course_id = c.course_id;
Alice matches TWO rows:


Alice ---------------- SQL

Alice ---------------- Advanced SQL

OUTPUT:
+-------+-----------+----------------+
| name  | course_id | course_name    |
+-------+-----------+----------------+
| Alice | 101       | SQL            |
| Alice | 101       | Advanced SQL   |
+-------+-----------+----------------+

Why does Alice appear twice?
Because JOIN does NOT mean:
"Find ONE matching row."
It means:
"Find EVERY pair of rows where the
JOIN condition is TRUE."
Alice + SQL
101 = 101
TRUE
    |
    +----> KEEP

Alice + Advanced SQL
101 = 101
TRUE
    |
    +----> KEEP

Therefore:
Alice appears twice.

9. ONE-TO-MANY RELATIONSHIP
============================

Suppose:
Students:
+----+-------+-----------+
| id | name  | course_id |
+----+-------+-----------+
| 1  | Alice | 101       |
+----+-------+-----------+


Courses:
+-----------+------------------+
| course_id | course_name      |
+-----------+------------------+
| 101       | SQL              |
| 101       | Advanced SQL     |
| 101       | Database Design  |
+-----------+------------------+
Alice matches THREE rows.
VISUAL:

                 SQL
                /
Alice -------- 101 -------- Advanced SQL
                \
                 Database Design

OUTPUT:
+-------+------------------+
| name  | course_name      |
+-------+------------------+
| Alice | SQL              |
| Alice | Advanced SQL     |
| Alice | Database Design  |
+-------+------------------+
ONE row on the left can produce
MULTIPLE rows in the result.

10. MANY-TO-MANY RELATIONSHIP
==============================
Suppose Students:
+----+-------+-----------+
| id | name  | course_id |
+----+-------+-----------+
| 1  | Alice | 101       |
| 2  | Bob   | 101       |
+----+-------+-----------+

Courses:
+-----------+------------------+
| course_id | course_name      |
+-----------+------------------+
| 101       | SQL              |
| 101       | Advanced SQL     |
| 101       | Database Design  |
+-----------+------------------+

Alice matches 3 courses.
Bob matches 3 courses.
Therefore:
2 students × 3 courses = 6 rows

OUTPUT:
+-------+------------------+
| name  | course_name      |
+-------+------------------+
| Alice | SQL              |
| Alice | Advanced SQL     |
| Alice | Database Design  |
| Bob   | SQL              |
| Bob   | Advanced SQL     |
| Bob   | Database Design  |
+-------+------------------+
This is why JOINs can sometimes produce
MORE rows than either original table.

11. THE MOST IMPORTANT MENTAL MODEL
====================================

DO NOT THINK:

    JOIN = Attach two tables together


THINK:

    JOIN = Find matching PAIRS of rows

For:

SELECT *
FROM A
JOIN B
    ON A.id = B.id;

SQL conceptually checks:

A row 1 + B row 1 -> MATCH?
A row 1 + B row 2 -> MATCH?
A row 1 + B row 3 -> MATCH?

A row 2 + B row 1 -> MATCH?
A row 2 + B row 2 -> MATCH?
A row 2 + B row 3 -> MATCH?

...

Every pair where:
A.id = B.id
is included.

The JOIN type then decides what happens
to rows that DID NOT find a match.

12. FINAL CHEAT SHEET
=====================

INNER JOIN:

SELECT *
FROM A
INNER JOIN B
    ON A.id = B.id;

    ONLY MATCHES


LEFT JOIN:

SELECT *
FROM A
LEFT JOIN B
    ON A.id = B.id;

    EVERYTHING FROM A
    + MATCHES FROM B


RIGHT JOIN:

SELECT *
FROM A
RIGHT JOIN B
    ON A.id = B.id;

    EVERYTHING FROM B
    + MATCHES FROM A


FULL OUTER JOIN:

SELECT *
FROM A
FULL OUTER JOIN B
    ON A.id = B.id;

    EVERYTHING FROM A
    + EVERYTHING FROM B

13. ONE SENTENCE TO REMEMBER
=============================

JOIN decides WHICH ROWS GET PAIRED.

The type of JOIN decides WHICH UNMATCHED ROWS
are allowed to survive.


INNER  -> matches only
LEFT   -> preserve left
RIGHT  -> preserve right
FULL   -> preserve both
