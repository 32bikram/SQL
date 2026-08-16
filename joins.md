Suppose we have:

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

Notice the edge cases:

Alice → matching course
Bob → matching course
Charlie → matching course
David → no matching course (999)
C++ → no student (104)

Now let's visualize what each JOIN does.

Give feedback
The one rule I want you to remember

Imagine the JOIN condition as a bridge:

Students                    Courses


Alice ──────────────── SQL
Bob   ──────────────── Python
Charlie ────────────── Java
David                    ✗
                         C++
                         ↑
                       no student

Then:

JOIN	What survives?
INNER JOIN	Only things with a bridge
LEFT JOIN	Everything on the left + bridges
RIGHT JOIN	Everything on the right + bridges
FULL JOIN	Everything on both sides
One more important edge case: multiple matches

This is where JOINs really click.

Suppose Courses had:

course_id	course_name
101	SQL
101	Advanced SQL

And Alice has course_id = 101.

Then:

SELECT *
FROM Students s
JOIN Courses c
  ON s.course_id = c.course_id;

Alice would appear twice:

name	course_id	course_name
Alice	101	SQL
Alice	101	Advanced SQL

Why?

Because SQL isn't saying:

"Find one matching row."

It's saying:

"Find every pair of rows for which the ON condition is true."

That's the fundamental idea behind JOINs. Once you understand that, LEFT JOIN, RIGHT JOIN, self-joins, duplicate rows, and even many-to-many joins become much easier.
