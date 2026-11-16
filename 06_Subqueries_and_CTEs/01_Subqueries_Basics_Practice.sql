/*
============================================================
SQL PRACTICE 01: SUBQUERIES - BASICS

Topics:
1. Introduction to Subqueries
2. Inner Query and Outer Query
3. Single-Row Subqueries
4. Multiple-Row Subqueries
5. Subqueries with Comparison Operators
6. IN and NOT IN
7. ANY and ALL
8. EXISTS and NOT EXISTS
9. Subqueries in SELECT, FROM and WHERE
10. Correlated and Non-Correlated Subqueries
11. Practical Examples
12. Practice Questions and Solutions
============================================================
*/


-- =========================================================
-- SECTION 1: CREATE SAMPLE TABLES
-- =========================================================

DROP TABLE IF EXISTS #Employees;
DROP TABLE IF EXISTS #Departments;


CREATE TABLE #Departments
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);


CREATE TABLE #Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT NULL,
    Salary DECIMAL(10,2),
    Age INT,
    City VARCHAR(50)
);


INSERT INTO #Departments
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Sales'),
(5, 'Marketing');


INSERT INTO #Employees
VALUES
(101, 'Rahul', 1, 90000, 28, 'Pune'),
(102, 'Priya', 1, 65000, 25, 'Mumbai'),
(103, 'Amit', 1, 75000, 30, 'Pune'),
(104, 'Sneha', 2, 55000, 27, 'Delhi'),
(105, 'Neha', 2, 50000, 24, 'Mumbai'),
(106, 'Karan', 3, 80000, 32, 'Pune'),
(107, 'Pooja', 3, 60000, 29, 'Delhi'),
(108, 'Rohan', 4, 45000, 26, 'Mumbai'),
(109, 'Anjali', 4, 48000, 31, 'Pune'),
(110, 'Varun', 1, 95000, 35, 'Delhi'),
(111, 'Meera', NULL, 52000, 23, 'Mumbai'),
(112, 'Arjun', 5, 70000, 28, 'Pune');


SELECT * FROM #Employees;
SELECT * FROM #Departments;


-- =========================================================
-- SECTION 2: WHAT IS A SUBQUERY?
-- =========================================================

/*
A SUBQUERY is a query written inside another SQL query.

It is also called:
- Inner Query
- Nested Query

The query inside another query is called the INNER QUERY.
The query that contains it is called the OUTER QUERY.

Why do we use subqueries?

Suppose we want to find employees who earn more
than the company's average salary.

First, we need to calculate the average salary.
Then, we need to find employees earning more than that.

A subquery allows us to perform both operations
within a single SQL statement.

General syntax:

SELECT columns
FROM table_name
WHERE column_name operator
(
    SELECT column_name
    FROM table_name
);

The inner query is evaluated to provide a result
that the outer query can use.

The exact execution strategy may vary depending
on the SQL Server query optimizer.
*/


-- =========================================================
-- SECTION 3: INNER QUERY AND OUTER QUERY
-- =========================================================

-- Find employees earning more than the average salary.

SELECT *
FROM #Employees
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM #Employees
);


-- Inner query:
SELECT AVG(Salary) AS AverageSalary
FROM #Employees;


-- Outer query uses the average salary
-- returned by the inner query.


-- =========================================================
-- SECTION 4: SINGLE-ROW SUBQUERY
-- =========================================================

/*
A single-row subquery returns one row.

Example:
SELECT AVG(Salary)
FROM #Employees;

Aggregate functions such as AVG, MAX, MIN and SUM
without GROUP BY generally return one row.

Single-row subqueries can be used with:

=
>
<
>=
<=
<>
*/


-- Example 1:
-- Find employees earning more than the average salary.

SELECT *
FROM #Employees
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM #Employees
);


-- Example 2:
-- Find employees earning the highest salary.

SELECT *
FROM #Employees
WHERE Salary =
(
    SELECT MAX(Salary)
    FROM #Employees
);


-- Example 3:
-- Find employees earning the lowest salary.

SELECT *
FROM #Employees
WHERE Salary =
(
    SELECT MIN(Salary)
    FROM #Employees
);


-- Example 4:
-- Find employees earning the same salary as Rahul.

SELECT *
FROM #Employees
WHERE Salary =
(
    SELECT Salary
    FROM #Employees
    WHERE EmployeeName = 'Rahul'
);


-- Example 5:
-- Find employees older than the average employee age.

SELECT *
FROM #Employees
WHERE Age >
(
    SELECT AVG(Age)
    FROM #Employees
);


-- =========================================================
-- SECTION 5: MULTIPLE-ROW SUBQUERY
-- =========================================================

/*
A multiple-row subquery returns more than one row.

For example:

SELECT DepartmentID
FROM #Departments
WHERE DepartmentName IN ('IT', 'HR');

This returns multiple DepartmentIDs.

You generally cannot use a multi-row result
with a normal equality comparison (=).

Use operators such as:

IN
NOT IN
ANY
ALL
EXISTS
NOT EXISTS
*/


-- Example 1:
-- Find employees working in IT or HR.

SELECT *
FROM #Employees
WHERE DepartmentID IN
(
    SELECT DepartmentID
    FROM #Departments
    WHERE DepartmentName IN ('IT', 'HR')
);


-- Example 2:
-- Find employees who do not belong to IT or HR.

SELECT *
FROM #Employees
WHERE DepartmentID NOT IN
(
    SELECT DepartmentID
    FROM #Departments
    WHERE DepartmentName IN ('IT', 'HR')
);


-- IMPORTANT:
-- NOT IN can behave unexpectedly when the inner query
-- returns NULL.
--
-- A NULL in the returned list can prevent expected matches.
-- Consider NOT EXISTS when NULL values are possible.


-- =========================================================
-- SECTION 6: SUBQUERY WITH IN AND NOT IN
-- =========================================================

/*
IN:
Checks whether a value matches any value
returned by the subquery.

NOT IN:
Checks whether a value does not match any value
returned by the subquery.
*/


-- Find employees working in departments
-- that have at least one employee.

SELECT *
FROM #Employees
WHERE DepartmentID IN
(
    SELECT DISTINCT DepartmentID
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
);


-- Find departments that have no employees.

SELECT *
FROM #Departments
WHERE DepartmentID NOT IN
(
    SELECT DepartmentID
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
);


-- =========================================================
-- SECTION 7: ANY AND ALL OPERATORS
-- =========================================================

/*
ANY:
The condition is TRUE if it matches at least one
value returned by the subquery.

ALL:
The condition must be TRUE for every value
returned by the subquery.

SQL Server also supports SOME, which is a synonym for ANY.

Common comparisons:

> ANY
< ANY
= ANY
> ALL
< ALL
= ALL
*/


-- Example 1:
-- Find employees earning more than at least one
-- employee in the HR department.

SELECT *
FROM #Employees
WHERE Salary > ANY
(
    SELECT Salary
    FROM #Employees
    WHERE DepartmentID = 2
);


-- Example 2:
-- Find employees earning more than every employee
-- in the HR department.

SELECT *
FROM #Employees
WHERE Salary > ALL
(
    SELECT Salary
    FROM #Employees
    WHERE DepartmentID = 2
);


-- Example 3:
-- Find employees earning less than at least one
-- employee in the IT department.

SELECT *
FROM #Employees
WHERE Salary < ANY
(
    SELECT Salary
    FROM #Employees
    WHERE DepartmentID = 1
);


-- Example 4:
-- Find employees earning less than every employee
-- in the IT department.

SELECT *
FROM #Employees
WHERE Salary < ALL
(
    SELECT Salary
    FROM #Employees
    WHERE DepartmentID = 1
);


-- =========================================================
-- SECTION 8: EXISTS AND NOT EXISTS
-- =========================================================

/*
EXISTS:
Checks whether the subquery returns at least one row.

NOT EXISTS:
Checks whether the subquery returns no rows.

EXISTS does not need to return a particular column.
It checks whether a matching row exists.

It is especially useful for checking relationships
between tables.
*/


-- Example 1:
-- Find departments that have employees.

SELECT *
FROM #Departments D
WHERE EXISTS
(
    SELECT 1
    FROM #Employees E
    WHERE E.DepartmentID = D.DepartmentID
);


-- Example 2:
-- Find departments that do not have employees.

SELECT *
FROM #Departments D
WHERE NOT EXISTS
(
    SELECT 1
    FROM #Employees E
    WHERE E.DepartmentID = D.DepartmentID
);


-- Example 3:
-- Find employees whose department exists
-- in the Departments table.

SELECT *
FROM #Employees E
WHERE EXISTS
(
    SELECT 1
    FROM #Departments D
    WHERE D.DepartmentID = E.DepartmentID
);


-- Example 4:
-- Find employees whose department does not exist
-- in the Departments table.

SELECT *
FROM #Employees E
WHERE NOT EXISTS
(
    SELECT 1
    FROM #Departments D
    WHERE D.DepartmentID = E.DepartmentID
);


-- =========================================================
-- SECTION 9: SUBQUERY IN SELECT CLAUSE
-- =========================================================

/*
A subquery can be written inside the SELECT clause.

A scalar subquery returns one value.

That value can be displayed alongside every row
returned by the outer query.
*/


-- Display each employee with the company average salary.

SELECT
    EmployeeName,
    Salary,
    (
        SELECT AVG(Salary)
        FROM #Employees
    ) AS CompanyAverageSalary
FROM #Employees;


-- Display each employee with the maximum salary.

SELECT
    EmployeeName,
    Salary,
    (
        SELECT MAX(Salary)
        FROM #Employees
    ) AS MaximumSalary
FROM #Employees;


-- =========================================================
-- SECTION 10: SUBQUERY IN FROM CLAUSE
-- =========================================================

/*
A subquery inside the FROM clause acts as a derived table.

A derived table must have an alias in SQL Server.

It allows us to create an intermediate result
and query that result.
*/


-- Calculate average salary department-wise
-- and display departments with average salary above 60000.

SELECT *
FROM
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
) AS DepartmentSummary
WHERE AverageSalary > 60000;


-- Display department-wise employee counts.

SELECT *
FROM
(
    SELECT
        DepartmentID,
        COUNT(*) AS TotalEmployees
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
) AS EmployeeSummary
WHERE TotalEmployees >= 2;


-- =========================================================
-- SECTION 11: NON-CORRELATED SUBQUERY
-- =========================================================

/*
A NON-CORRELATED SUBQUERY does not depend on the
outer query.

The inner query can be understood independently.

Example:

SELECT *
FROM #Employees
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM #Employees
);

The inner query calculates the company average.
It does not refer to any alias from the outer query.
*/


-- Find employees earning above the company average.

SELECT *
FROM #Employees
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM #Employees
);


-- =========================================================
-- SECTION 12: CORRELATED SUBQUERY
-- =========================================================

/*
A CORRELATED SUBQUERY refers to a column or alias
from the outer query.

The inner query depends on the current row
being considered by the outer query.

Example:
For every employee, compare their salary with
the average salary of their own department.

E is the outer query alias.
E2 is the inner query alias.

The inner query refers to E.DepartmentID.
*/


-- Find employees earning more than their
-- own department's average salary.

SELECT
    E.EmployeeID,
    E.EmployeeName,
    E.DepartmentID,
    E.Salary
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Salary >
(
    SELECT AVG(E2.Salary)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- Find the highest-paid employee in each department.

SELECT
    E.EmployeeID,
    E.EmployeeName,
    E.DepartmentID,
    E.Salary
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Salary =
(
    SELECT MAX(E2.Salary)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- Find employees who are the oldest in their department.

SELECT
    E.EmployeeName,
    E.DepartmentID,
    E.Age
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Age =
(
    SELECT MAX(E2.Age)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- =========================================================
-- SECTION 13: SUBQUERY VS JOIN
-- =========================================================

/*
Both JOINs and subqueries can solve many of the same
problems, but they express the logic differently.

JOIN:
Combines related rows from multiple tables.

Subquery:
Uses the result of one query inside another query.

Neither is automatically faster in every situation.
SQL Server's optimizer decides the execution plan.
*/


-- Using SUBQUERY:
-- Find employees working in IT.

SELECT *
FROM #Employees
WHERE DepartmentID =
(
    SELECT DepartmentID
    FROM #Departments
    WHERE DepartmentName = 'IT'
);


-- Using JOIN:

SELECT
    E.*
FROM #Employees E
INNER JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'IT';


-- =========================================================
-- SECTION 14: PRACTICE QUESTIONS
-- =========================================================

/*
Try solving these questions yourself before checking
the solutions.

Q1. Find employees earning more than the average salary.

Q2. Find employees earning the highest salary.

Q3. Find employees earning the lowest salary.

Q4. Find employees earning more than Rahul.

Q5. Find employees working in the IT department.

Q6. Find employees working in IT or HR.

Q7. Find employees who do not work in IT or HR.

Q8. Find employees earning more than at least one
    employee in the HR department using ANY.

Q9. Find employees earning more than every employee
    in the HR department using ALL.

Q10. Find departments that have employees using EXISTS.

Q11. Find departments that do not have employees
     using NOT EXISTS.

Q12. Find employees whose department exists
     in the Departments table using EXISTS.

Q13. Display each employee with the company average salary
     using a subquery in SELECT.

Q14. Find departments with an average salary above 60000
     using a subquery in FROM.

Q15. Find employees earning more than their
     department's average salary.

Q16. Find the highest-paid employee in each department.

Q17. Find the oldest employee in each department.

Q18. Find employees earning less than the company average.

Q19. Find employees working in departments
     that have at least two employees.

Q20. Find departments whose average salary is
     greater than the company's average salary.

Q21. Find employees whose salary is greater than
     the average salary of employees from Pune.

Q22. Find employees who earn the same salary
     as at least one other employee.

Q23. Find employees who do not belong to any
     existing department using NOT EXISTS.

Q24. Find employees earning more than all employees
     in the Sales department.

Q25. Find the employees who have the maximum salary
     in the entire company without using MAX
     in the outer query.


-- =========================================================
-- SECTION 15: SOLUTIONS
-- =========================================================

-- Q1
SELECT *
FROM #Employees
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM #Employees
);


-- Q2
SELECT *
FROM #Employees
WHERE Salary =
(
    SELECT MAX(Salary)
    FROM #Employees
);


-- Q3
SELECT *
FROM #Employees
WHERE Salary =
(
    SELECT MIN(Salary)
    FROM #Employees
);


-- Q4
SELECT *
FROM #Employees
WHERE Salary >
(
    SELECT Salary
    FROM #Employees
    WHERE EmployeeName = 'Rahul'
);


-- Q5
SELECT *
FROM #Employees
WHERE DepartmentID =
(
    SELECT DepartmentID
    FROM #Departments
    WHERE DepartmentName = 'IT'
);


-- Q6
SELECT *
FROM #Employees
WHERE DepartmentID IN
(
    SELECT DepartmentID
    FROM #Departments
    WHERE DepartmentName IN ('IT', 'HR')
);


-- Q7
SELECT *
FROM #Employees
WHERE DepartmentID NOT IN
(
    SELECT DepartmentID
    FROM #Departments
    WHERE DepartmentName IN ('IT', 'HR')
);


-- Q8
SELECT *
FROM #Employees
WHERE Salary > ANY
(
    SELECT Salary
    FROM #Employees
    WHERE DepartmentID = 2
);


-- Q9
SELECT *
FROM #Employees
WHERE Salary > ALL
(
    SELECT Salary
    FROM #Employees
    WHERE DepartmentID = 2
);


-- Q10
SELECT *
FROM #Departments D
WHERE EXISTS
(
    SELECT 1
    FROM #Employees E
    WHERE E.DepartmentID = D.DepartmentID
);


-- Q11
SELECT *
FROM #Departments D
WHERE NOT EXISTS
(
    SELECT 1
    FROM #Employees E
    WHERE E.DepartmentID = D.DepartmentID
);


-- Q12
SELECT *
FROM #Employees E
WHERE EXISTS
(
    SELECT 1
    FROM #Departments D
    WHERE D.DepartmentID = E.DepartmentID
);


-- Q13
SELECT
    EmployeeName,
    Salary,
    (
        SELECT AVG(Salary)
        FROM #Employees
    ) AS CompanyAverageSalary
FROM #Employees;


-- Q14
SELECT *
FROM
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
) AS DepartmentSummary
WHERE AverageSalary > 60000;


-- Q15
SELECT *
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Salary >
(
    SELECT AVG(E2.Salary)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- Q16
SELECT *
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Salary =
(
    SELECT MAX(E2.Salary)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- Q17
SELECT *
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Age =
(
    SELECT MAX(E2.Age)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- Q18
SELECT *
FROM #Employees
WHERE Salary <
(
    SELECT AVG(Salary)
    FROM #Employees
);


-- Q19
SELECT *
FROM #Employees E
WHERE E.DepartmentID IN
(
    SELECT DepartmentID
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING COUNT(*) >= 2
);


-- Q20
SELECT D.DepartmentName
FROM #Departments D
WHERE D.DepartmentID IN
(
    SELECT E.DepartmentID
    FROM #Employees E
    WHERE E.DepartmentID IS NOT NULL
    GROUP BY E.DepartmentID
    HAVING AVG(E.Salary) >
    (
        SELECT AVG(Salary)
        FROM #Employees
    )
);


-- Q21
SELECT *
FROM #Employees
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM #Employees
    WHERE City = 'Pune'
);


-- Q22
SELECT *
FROM #Employees E
WHERE EXISTS
(
    SELECT 1
    FROM #Employees E2
    WHERE E2.Salary = E.Salary
      AND E2.EmployeeID <> E.EmployeeID
);


-- Q23
SELECT *
FROM #Employees E
WHERE NOT EXISTS
(
    SELECT 1
    FROM #Departments D
    WHERE D.DepartmentID = E.DepartmentID
);


-- Q24
SELECT *
FROM #Employees
WHERE Salary > ALL
(
    SELECT Salary
    FROM #Employees
    WHERE DepartmentID = 4
);


-- Q25
SELECT *
FROM #Employees E
WHERE NOT EXISTS
(
    SELECT 1
    FROM #Employees E2
    WHERE E2.Salary > E.Salary
);


-- =========================================================
-- SECTION 16: IMPORTANT INTERVIEW REVISION
-- =========================================================

/*
1. What is a subquery?
   A query written inside another query.

2. What is an inner query?
   The query written inside another query.

3. What is an outer query?
   The query that contains the subquery.

4. What is a single-row subquery?
   A subquery that returns one row.

5. What is a multiple-row subquery?
   A subquery that returns multiple rows.

6. What is a correlated subquery?
   A subquery that refers to a column or alias
   from the outer query.

7. What is a non-correlated subquery?
   A subquery that does not depend on the outer query.

8. What is EXISTS?
   It checks whether the subquery returns at least one row.

9. What is NOT EXISTS?
   It checks whether the subquery returns no rows.

10. Difference between IN and EXISTS?

    IN checks whether a value matches a value
    in the returned list.

    EXISTS checks whether a matching row exists.

11. Difference between ANY and ALL?

    ANY: Condition must be true for at least one value.

    ALL: Condition must be true for every value.

12. Can a subquery be used in SELECT?
    Yes, if it returns a scalar value where required.

13. Can a subquery be used in FROM?
    Yes. It is called a derived table and needs an alias.

14. What is a scalar subquery?
    A subquery that returns exactly one value:
    one row and one column.

15. What happens if a scalar subquery returns
    multiple rows?
    SQL Server raises an error.

16. Can we use a JOIN instead of a subquery?
    In many situations, yes. The correct choice depends
    on the requirement and query structure.

17. Is a correlated subquery always slower?
    No. Performance depends on the query and execution plan.

IMPORTANT INTERVIEW POINTS:

- A subquery can be nested inside another subquery.
- A scalar subquery must return one value.
- IN and NOT IN need careful handling of NULL.
- EXISTS is useful for checking whether related rows exist.
- A derived table in FROM requires an alias.
- Correlated subqueries refer to the outer query.
- SQL Server's optimizer determines the execution strategy.

============================================================
END OF PRACTICE FILE
============================================================
*/