# SQL JOIN — Complete Visual Guide

## 1. Two Tables

**Students**

| student_id | name    | course_id |
|------------|---------|-----------|
| 1          | Alice   | 101       |
| 2          | Bob     | 102       |
| 3          | Charlie | 103       |
| 4          | David   | 999       |

**Courses**

| course_id | course_name |
|-----------|-------------|
| 101       | SQL         |
| 102       | Python      |
| 103       | Java        |
| 104       | C++         |

**Join condition:** `Students.course_id = Courses.course_id`

Important cases:

- Alice → 101 → SQL → **MATCH**
- Bob → 102 → Python → **MATCH**
- Charlie → 103 → Java → **MATCH**
- David → 999 → ??? → **NO MATCH**
- 104 → C++ → **NO STUDENT**

---

## 2. What Does JOIN Actually Do?

A JOIN essentially says:

> "Take rows from two tables and combine rows when the ON condition is TRUE."

```
Students                         Courses

Alice   -----------------------> SQL
Bob     -----------------------> Python
Charlie -----------------------> Java
David   -----------------------> ???       NO MATCH

                                    C++    NO STUDENT
```

The JOIN **compares rows**. It does **not** simply glue two tables together.

---

## 3. INNER JOIN

```sql
SELECT *
FROM Students s
INNER JOIN Courses c
    ON s.course_id = c.course_id;
```

**Output:**

| student_id | name    | course_id | course_id | course_name |
|------------|---------|-----------|-----------|-------------|
| 1          | Alice   | 101       | 101       | SQL         |
| 2          | Bob     | 102       | 102       | Python      |
| 3          | Charlie | 103       | 103       | Java        |

- **David disappears:** `David.course_id = 999`, and there is no `Courses.course_id = 999`
- **C++ disappears:** `Courses.course_id = 104`, and there is no `Students.course_id = 104`

**Visual:**

```
Students                 Courses
Alice   ---------------- SQL        KEEP
Bob     ---------------- Python     KEEP
Charlie ---------------- Java       KEEP
David   ---------------- ???        REMOVE

                         C++        REMOVE
```

**Mental model:** `INNER JOIN = ONLY MATCHES`

Note: plain `JOIN` (with no keyword in front) defaults to `INNER JOIN` in every major SQL engine.

---

## 4. LEFT JOIN

```sql
SELECT *
FROM Students s
LEFT JOIN Courses c
    ON s.course_id = c.course_id;
```

**Output:**

| student_id | name    | course_id | course_id | course_name |
|------------|---------|-----------|-----------|-------------|
| 1          | Alice   | 101       | 101       | SQL         |
| 2          | Bob     | 102       | 102       | Python      |
| 3          | Charlie | 103       | 103       | Java        |
| 4          | David   | 999       | NULL      | NULL        |

Why is David still there? Because `Students` is the **LEFT** table.

> LEFT JOIN says: "KEEP EVERYTHING FROM THE LEFT TABLE."

David has no matching course, so the Courses columns become `NULL`.

**Visual:**

```
Students                 Courses
Alice   ---------------- SQL        KEEP
Bob     ---------------- Python     KEEP
Charlie ---------------- Java       KEEP
David   ---------------- ???        KEEP
                                     ^
                                     |
                                    NULL
```

C++ is **not** included because C++ belongs to the RIGHT table, and LEFT JOIN does not preserve unmatched rows from the right table.

**Mental model:** `LEFT JOIN = EVERYTHING FROM LEFT + MATCHES FROM RIGHT`

(This is technically called `LEFT OUTER JOIN` — the word `OUTER` is optional and almost always dropped. See section 7.)

---

## 5. RIGHT JOIN

```sql
SELECT *
FROM Students s
RIGHT JOIN Courses c
    ON s.course_id = c.course_id;
```

**Output:**

| student_id | name    | course_id | course_id | course_name |
|------------|---------|-----------|-----------|-------------|
| 1          | Alice   | 101       | 101       | SQL         |
| 2          | Bob     | 102       | 102       | Python      |
| 3          | Charlie | 103       | 103       | Java        |
| NULL       | NULL    | NULL      | 104       | C++         |

C++ stays because `Courses` is the RIGHT table. There is no student for C++, so all Student columns are `NULL`.

**Visual:**

```
Students                 Courses
Alice   ---------------- SQL        KEEP
Bob     ---------------- Python     KEEP
Charlie ---------------- Java       KEEP

                         C++        KEEP
                          ^
                          |
                         NULL student
```

David disappears because David belongs to the LEFT table and has no matching course.

**Mental model:** `RIGHT JOIN = EVERYTHING FROM RIGHT + MATCHES FROM LEFT`

(Full name: `RIGHT OUTER JOIN`. Rarely used in practice — most people rewrite a RIGHT JOIN as a LEFT JOIN by swapping the table order, since it's easier to read.)

---

## 6. FULL OUTER JOIN

```sql
SELECT *
FROM Students s
FULL OUTER JOIN Courses c
    ON s.course_id = c.course_id;
```

**Output:**

| student_id | name    | course_id | course_id | course_name |
|------------|---------|-----------|-----------|-------------|
| 1          | Alice   | 101       | 101       | SQL         |
| 2          | Bob     | 102       | 102       | Python      |
| 3          | Charlie | 103       | 103       | Java        |
| 4          | David   | 999       | NULL      | NULL        |
| NULL       | NULL    | NULL      | 104       | C++         |

Everything survives.

**Visual:**

```
Students                 Courses
Alice   ---------------- SQL
Bob     ---------------- Python
Charlie ---------------- Java

David   ---------------- ???        KEEP

                         C++        KEEP
```

**Mental model:** `FULL OUTER JOIN = EVERYTHING FROM BOTH TABLES`

Note: MySQL doesn't support `FULL OUTER JOIN` directly — you simulate it with `LEFT JOIN UNION RIGHT JOIN`.

---

## 7. OUTER JOIN (the umbrella term)

`OUTER JOIN` isn't a separate join type you write on its own — it's the **category name** for any join that can keep unmatched rows (i.e. produce `NULL`s on one side).

| Keyword you type      | Full/official name  | Keeps unmatched rows from... |
|------------------------|----------------------|-------------------------------|
| `LEFT JOIN`            | `LEFT OUTER JOIN`    | left table only               |
| `RIGHT JOIN`           | `RIGHT OUTER JOIN`   | right table only               |
| `FULL JOIN`             | `FULL OUTER JOIN`    | both tables                    |

The `OUTER` keyword is optional in all major engines — `LEFT JOIN` and `LEFT OUTER JOIN` are identical statements.

**Mental model:** `INNER JOIN` throws unmatched rows away → `OUTER JOIN` (any of the three above) keeps them, filling the missing side with `NULL`.

```
INNER JOIN  ──►  discards unmatched rows
OUTER JOIN  ──►  keeps unmatched rows, pads with NULL
                 ├── LEFT OUTER JOIN   (keep left's orphans)
                 ├── RIGHT OUTER JOIN  (keep right's orphans)
                 └── FULL OUTER JOIN   (keep both sides' orphans)
```

---

## 8. CROSS JOIN

```sql
SELECT *
FROM Students s
CROSS JOIN Courses c;
```

A `CROSS JOIN` has **no `ON` condition at all**. It pairs *every* row of table A with *every* row of table B — the Cartesian product.

With 4 Students and 4 Courses, the output is 4 × 4 = **16 rows**:

| name    | course_id | course_name |
|---------|-----------|--------------|
| Alice   | 101       | SQL          |
| Alice   | 102       | Python       |
| Alice   | 103       | Java         |
| Alice   | 104       | C++          |
| Bob     | 101       | SQL          |
| Bob     | 102       | Python       |
| Bob     | 103       | Java         |
| Bob     | 104       | C++          |
| ...     | ...       | ...          |
| David   | 104       | C++          |

**Visual:**

```
Students          Courses
Alice   ────┬───► SQL
            ├───► Python
            ├───► Java
            └───► C++

Bob     ────┬───► SQL
            ├───► Python
            ├───► Java
            └───► C++

... (same for Charlie and David)
```

**Mental model:** `CROSS JOIN = EVERY ROW × EVERY ROW` (no matching logic, no `NULL`s — just every possible combination)

You'll rarely want this on real data (it explodes row counts fast), but it's genuinely useful for generating combinations — e.g. pairing every product with every size/color variant.

**Fun fact:** an `INNER JOIN` with no `ON` clause and old comma-join syntax (`FROM A, B`) both behave like a `CROSS JOIN` — this is a classic accidental-Cartesian-product bug when someone forgets the `ON`/`WHERE` condition.

---

## 9. FULL OUTER JOIN vs CROSS JOIN

These two get confused because they can both produce more rows than either source table — but they work completely differently.

- **FULL OUTER JOIN** — matches rows using the `ON` condition, keeps unmatched rows from both sides padded with `NULL`. It respects the relationship between the tables.
- **CROSS JOIN** — ignores any relationship entirely and pairs *every* row with *every* row. There's no `ON`, no matching, no `NULL` padding.

Small example — two tiny tables:

**A**

| id | val |
|----|-----|
| 1  | X   |
| 2  | Y   |

**B**

| id | val |
|----|-----|
| 1  | P   |
| 3  | Q   |

```sql
-- FULL OUTER JOIN
SELECT *
FROM A
FULL OUTER JOIN B
    ON A.id = B.id;
```

| A.id | A.val | B.id | B.val |
|------|-------|------|-------|
| 1    | X     | 1    | P     |
| 2    | Y     | NULL | NULL  |
| NULL | NULL  | 3    | Q     |

→ **3 rows.** Row 1 matched (`id=1`). Row 2 (Y) had no match, so B side is `NULL`. Row (Q) had no match, so A side is `NULL`.

```sql
-- CROSS JOIN
SELECT *
FROM A
CROSS JOIN B;
```

| A.id | A.val | B.id | B.val |
|------|-------|------|-------|
| 1    | X     | 1    | P     |
| 1    | X     | 3    | Q     |
| 2    | Y     | 1    | P     |
| 2    | Y     | 3    | Q     |

→ **4 rows** (2 × 2). No matching happened at all — every A row is paired with every B row, including the (1,X)–(3,Q) pair even though `id` doesn't match.

**Key difference:**

| | FULL OUTER JOIN | CROSS JOIN |
|---|---|---|
| Needs `ON` condition? | Yes | No |
| Row count | rows that match + unmatched from both sides | (rows in A) × (rows in B), always |
| Produces `NULL`s? | Yes, for unmatched rows | Never |
| Relationship between tables matters? | Yes | No — completely ignored |

**Mental model:** `FULL OUTER JOIN` asks "what matches, plus what's left over?" — `CROSS JOIN` doesn't ask anything, it just multiplies.

---

## 10. All Joins Compared

Original unmatched rows: Students → David, Courses → C++

| JOIN        | Alice | Bob | Charlie | David | C++ | Row count |
|-------------|-------|-----|---------|-------|-----|-----------|
| INNER JOIN  | YES   | YES | YES     | NO    | NO  | 3         |
| LEFT JOIN   | YES   | YES | YES     | YES   | NO  | 4         |
| RIGHT JOIN  | YES   | YES | YES     | NO    | YES | 4         |
| FULL JOIN   | YES   | YES | YES     | YES   | YES | 5         |
| CROSS JOIN  | YES   | YES | YES     | YES   | YES | 16 (4×4)  |

**Easy way to remember:**

- **INNER** → Only matches
- **LEFT** → Everything on LEFT + matches from RIGHT
- **RIGHT** → Everything on RIGHT + matches from LEFT
- **FULL (OUTER)** → Everything from BOTH
- **CROSS** → Every row paired with every row, no condition needed

---

## 11. Very Important Edge Case: Multiple Matches

This is one of the most important things to understand about JOINs.

Suppose `Courses` is:

| course_id | course_name  |
|-----------|--------------|
| 101       | SQL          |
| 101       | Advanced SQL |
| 102       | Python       |
| 103       | Java         |
| 104       | C++          |

Alice has `course_id = 101`.

```sql
SELECT *
FROM Students s
JOIN Courses c
    ON s.course_id = c.course_id;
```

Alice matches **two** rows:

```
Alice ---------------- SQL
Alice ---------------- Advanced SQL
```

**Output:**

| name  | course_id | course_name  |
|-------|-----------|---------------|
| Alice | 101       | SQL           |
| Alice | 101       | Advanced SQL  |

Why does Alice appear twice? Because JOIN does **not** mean "Find ONE matching row." It means:

> "Find EVERY pair of rows where the JOIN condition is TRUE."

- Alice + SQL → 101 = 101 → TRUE → KEEP
- Alice + Advanced SQL → 101 = 101 → TRUE → KEEP

Therefore, Alice appears twice.

---

## 12. One-to-Many Relationship

**Students**

| id | name  | course_id |
|----|-------|-----------|
| 1  | Alice | 101       |

**Courses**

| course_id | course_name     |
|-----------|-----------------|
| 101       | SQL             |
| 101       | Advanced SQL    |
| 101       | Database Design |

Alice matches **three** rows.

```
                 SQL
                /
Alice -------- 101 -------- Advanced SQL
                \
                 Database Design
```

**Output:**

| name  | course_name     |
|-------|-----------------|
| Alice | SQL             |
| Alice | Advanced SQL    |
| Alice | Database Design |

ONE row on the left can produce MULTIPLE rows in the result.

---

## 13. Many-to-Many Relationship

**Students**

| id | name  | course_id |
|----|-------|-----------|
| 1  | Alice | 101       |
| 2  | Bob   | 101       |

**Courses**

| course_id | course_name     |
|-----------|-----------------|
| 101       | SQL             |
| 101       | Advanced SQL    |
| 101       | Database Design |

Alice matches 3 courses. Bob matches 3 courses.
Therefore: 2 students × 3 courses = 6 rows.

**Output:**

| name  | course_name     |
|-------|-----------------|
| Alice | SQL             |
| Alice | Advanced SQL    |
| Alice | Database Design |
| Bob   | SQL             |
| Bob   | Advanced SQL    |
| Bob   | Database Design |

This is why JOINs can sometimes produce MORE rows than either original table.

---

## 14. The Most Important Mental Model

**Do not think:** `JOIN = Attach two tables together`

**Think:** `JOIN = Find matching PAIRS of rows`

For:

```sql
SELECT *
FROM A
JOIN B
    ON A.id = B.id;
```

SQL conceptually checks:

```
A row 1 + B row 1 -> MATCH?
A row 1 + B row 2 -> MATCH?
A row 1 + B row 3 -> MATCH?

A row 2 + B row 1 -> MATCH?
A row 2 + B row 2 -> MATCH?
A row 2 + B row 3 -> MATCH?
...
```

Every pair where `A.id = B.id` is included.

The JOIN type then decides what happens to rows that did **not** find a match. (`CROSS JOIN` skips this step entirely — there's no condition to fail.)

---

## 15. Final Cheat Sheet

**INNER JOIN**
```sql
SELECT *
FROM A
INNER JOIN B
    ON A.id = B.id;
```
→ ONLY MATCHES

**LEFT (OUTER) JOIN**
```sql
SELECT *
FROM A
LEFT JOIN B
    ON A.id = B.id;
```
→ EVERYTHING FROM A + MATCHES FROM B

**RIGHT (OUTER) JOIN**
```sql
SELECT *
FROM A
RIGHT JOIN B
    ON A.id = B.id;
```
→ EVERYTHING FROM B + MATCHES FROM A

**FULL OUTER JOIN**
```sql
SELECT *
FROM A
FULL OUTER JOIN B
    ON A.id = B.id;
```
→ EVERYTHING FROM A + EVERYTHING FROM B

**CROSS JOIN**
```sql
SELECT *
FROM A
CROSS JOIN B;
```
→ EVERY ROW OF A × EVERY ROW OF B (no condition)

---

## 16. One Sentence to Remember

> JOIN decides WHICH ROWS GET PAIRED. The type of JOIN decides WHICH UNMATCHED ROWS are allowed to survive.

- **INNER** → matches only
- **LEFT** → preserve left
- **RIGHT** → preserve right
- **FULL (OUTER)** → preserve both
- **CROSS** → no matching at all, just every combination
