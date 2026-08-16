SQL JOIN — Complete Visual Guide
1. Two Tables

Let's use these two tables throughout the examples.

Students
student_id	name	course_id
1	Alice	101
2	Bob	102
3	Charlie	103
4	David	999
Courses
course_id	course_name
101	SQL
102	Python
103	Java
104	C++

Our JOIN condition will be:

Students.course_id = Courses.course_id
2. What Does JOIN Actually Do?

A JOIN essentially says:

Take rows from two tables and combine rows when the ON condition is true.

Think of it like this:

Students                         Courses


Alice ────────────────→ SQL
Bob   ────────────────→ Python
Charlie ──────────────→ Java
David ────────────────→ ???        ← No match


                                  C++ ← No student

The important thing is that JOIN compares rows.

3. INNER JOIN
SELECT *
FROM Students s
INNER JOIN Courses c
    ON s.course_id = c.course_id;
Result
student_id	name	course_id	course_id	course_name
1	Alice	101	101	SQL
2	Bob	102	102	Python
3	Charlie	103	103	Java
What happened?

Only rows that found a match survived.

Students                 Courses


Alice ─────────────────── SQL       ✓
Bob   ─────────────────── Python    ✓
Charlie ───────────────── Java      ✓
David ─────────────────── ???       ✗


                         C++        ✗

David disappears because:

David.course_id = 999

There is no course with:

course_id = 999

C++ disappears because:

Courses.course_id = 104

but no student has:

course_id = 104
Mental model
INNER JOIN = ONLY MATCHES
4. LEFT JOIN
SELECT *
FROM Students s
LEFT JOIN Courses c
    ON s.course_id = c.course_id;

The left table is Students.

Result
student_id	name	course_id	course_id	course_name
1	Alice	101	101	SQL
2	Bob	102	102	Python
3	Charlie	103	103	Java
4	David	999	NULL	NULL
What happened?

The LEFT table is always preserved.

Students                 Courses


Alice ─────────────────── SQL       ✓
Bob   ─────────────────── Python    ✓
Charlie ───────────────── Java      ✓
David ─────────────────── ???       ← still kept

Since David has no matching course, SQL fills the columns belonging to Courses with NULL.

David | 999 | NULL | NULL

C++ is not included because C++ belongs to the right table, and LEFT JOIN does not promise to preserve unmatched rows from the right table.

Mental model
LEFT JOIN = EVERYTHING FROM LEFT + MATCHES FROM RIGHT
5. RIGHT JOIN
SELECT *
FROM Students s
RIGHT JOIN Courses c
    ON s.course_id = c.course_id;

The right table is Courses.

Result
student_id	name	course_id	course_id	course_name
1	Alice	101	101	SQL
2	Bob	102	102	Python
3	Charlie	103	103	Java
NULL	NULL	NULL	104	C++
What happened?

The RIGHT table is always preserved.

Students                 Courses


Alice ─────────────────── SQL       ✓
Bob   ─────────────────── Python    ✓
Charlie ───────────────── Java      ✓


                         C++        ← still kept

C++ has no student, so the Students columns become NULL.

NULL | NULL | NULL | 104 | C++

David disappears because David belongs to the left table and has no match.

Mental model
RIGHT JOIN = EVERYTHING FROM RIGHT + MATCHES FROM LEFT
6. FULL OUTER JOIN
SELECT *
FROM Students s
FULL OUTER JOIN Courses c
    ON s.course_id = c.course_id;
Result
student_id	name	student_course_id	course_id	course_name
1	Alice	101	101	SQL
2	Bob	102	102	Python
3	Charlie	103	103	Java
4	David	999	NULL	NULL
NULL	NULL	NULL	104	C++

Both sides are preserved.

Students                 Courses


Alice ─────────────────── SQL
Bob   ─────────────────── Python
Charlie ───────────────── Java


David ─────────────────── ???       ← kept


                         C++        ← kept
Mental model
FULL JOIN = EVERYTHING FROM BOTH TABLES
7. All JOINs Compared

Using our example:

Students:


Alice
Bob
Charlie
David        ← unmatched




Courses:


SQL
Python
Java
C++          ← unmatched
JOIN	Alice	Bob	Charlie	David	C++
INNER JOIN	✓	✓	✓	❌	❌
LEFT JOIN	✓	✓	✓	✓	❌
RIGHT JOIN	✓	✓	✓	❌	✓
FULL JOIN	✓	✓	✓	✓	✓

The easiest way to remember:

INNER → matches only


LEFT  → everything on LEFT
        + matches on RIGHT


RIGHT → everything on RIGHT
        + matches on LEFT


FULL  → everything on BOTH
8. Important Edge Case — Multiple Matches

This is extremely important.

Suppose Courses changes to:

course_id	course_name
101	SQL
101	Advanced SQL
102	Python
103	Java
104	C++

And Alice has:

course_id = 101

Now Alice can match two rows.

SELECT *
FROM Students s
JOIN Courses c
    ON s.course_id = c.course_id;
Result
name	student course_id	course_name
Alice	101	SQL
Alice	101	Advanced SQL
Bob	102	Python
Charlie	103	Java

Alice appears twice.

Why?

Because JOIN does NOT mean:

"Find one matching row."

It means:

"Find every pair of rows for which the JOIN condition is true."

So SQL finds:

Alice + SQL
       ↓
course_id 101 = 101 ✓


Alice + Advanced SQL
       ↓
course_id 101 = 101 ✓

Both are valid matches.

Therefore both appear in the result.

9. Another Important Edge Case — One-to-Many

Suppose:

Students
student_id	name
1	Alice
Courses
course_id	course_name
101	SQL
101	Advanced SQL
101	Database Design

And:

Alice.course_id = 101

Then:

                 SQL
                /
Alice ── 101 ── Advanced SQL
                \
                 Database Design

Result:

name	course_name
Alice	SQL
Alice	Advanced SQL
Alice	Database Design

One row from the left can produce multiple rows in the result.

10. Many-to-Many Can Multiply Even More

Suppose the left table has:

Alice → 101
Bob   → 101

And the right table has:

101 → SQL
101 → Advanced SQL
101 → Database Design

Then:

             SQL
            /
Alice ─────┼── Advanced SQL
            \
             Database Design




             SQL
            /
Bob ───────┼── Advanced SQL
            \
             Database Design

Result:

student	course
Alice	SQL
Alice	Advanced SQL
Alice	Database Design
Bob	SQL
Bob	Advanced SQL
Bob	Database Design

That's:

2 students × 3 courses = 6 rows

This is why JOINs can sometimes unexpectedly produce many more rows than either original table.

11. The Most Important Mental Model

Don't think:

JOIN = attach two tables together

Think:

JOIN = find matching PAIRS of rows

For:

FROM A
JOIN B
ON A.id = B.id

SQL conceptually asks:

A row 1 + B row 1 → match?
A row 1 + B row 2 → match?
A row 1 + B row 3 → match?


A row 2 + B row 1 → match?
A row 2 + B row 2 → match?
A row 2 + B row 3 → match?


...

Every pair where:

A.id = B.id

is included.

The different JOIN types simply determine what happens to rows that don't find a match.

                MATCH?
                  │
        ┌─────────┴─────────┐
       YES                  NO
        │                    │
      combine          depends on JOIN
                           │
             ┌─────────────┼─────────────┐
             │             │             │
          INNER          LEFT          RIGHT
          discard      keep left      keep right
             
                         FULL
                    keep both sides
Final cheat sheet
-- Only matching rows
SELECT *
FROM A
INNER JOIN B
ON A.id = B.id;




-- Everything from A
SELECT *
FROM A
LEFT JOIN B
ON A.id = B.id;




-- Everything from B
SELECT *
FROM A
RIGHT JOIN B
ON A.id = B.id;




-- Everything from A and B
SELECT *
FROM A
FULL OUTER JOIN B
ON A.id = B.id;

One sentence to remember forever:

JOIN decides which rows get paired; the type of JOIN decides which unmatched rows are allowed to survive.
