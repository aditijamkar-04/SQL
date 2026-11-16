/*
============================================================
SQL PRACTICE 02: ADVANCED AND NESTED SUBQUERIES

Topics:
1. Nested Subqueries
2. Multi-Level Subqueries
3. Correlated Subqueries
4. Subqueries with GROUP BY and HAVING
5. EXISTS and NOT EXISTS
6. Second-Highest Salary
7. Nth-Highest Salary
8. Duplicate Records
9. Department-Wise Comparisons
10. Real-World Interview Problems
11. Practice Questions and Solutions
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
(5, 'Marketing'),
(6, 'Operations');


INSERT INTO #Employees
VALUES
(101, 'Rahul', 1, 95000, 29, 'Pune'),
(102, 'Priya', 1, 75000, 26, 'Mumbai'),
(103, 'Amit', 1, 75000, 31, 'Pune'),
(104, 'Sneha', 2, 60000, 27, 'Delhi'),
(105, 'Neha', 2, 55000, 25, 'Mumbai'),
(106, 'Karan', 3, 85000, 33, 'Pune'),
(107, 'Pooja', 3, 70000, 29, 'Delhi'),
(108, 'Rohan', 4, 50000, 28, 'Mumbai'),
(109, 'Anjali', 4, 50000, 32, 'Pune'),
(110, 'Varun', 1, 95000, 35, 'Delhi'),
(111, 'Meera', NULL, 65000, 24, 'Mumbai'),
(112, 'Arjun', 5, 80000, 28, 'Pune'),
(113, 'Isha', 5, 45000, 23, 'Delhi'),
(114, 'Kabir', 3, 85000, 30, 'Mumbai'),
(115, 'Tara', 2, 60000, 27, 'Pune');


SELECT * FROM #Employees;
SELECT * FROM #Departments;


-- =========================================================
-- SECTION 2: WHAT IS A NESTED SUBQUERY?
-- =========================================================

/*
A NESTED SUBQUERY means placing one subquery inside
another subquery.

In simple terms:

Outer Query
    |
    |---- Inner Query
              |
              |---- Another Inner Query

Why do we use it?

Sometimes the answer to a problem requires multiple
intermediate calculations.

Example:

Find employees who earn more than the average salary
of the department that has the highest average salary.

Step 1:
Calculate the average salary of each department.

Step 2:
Find the highest department average.

Step 3:
Find employees earning more than that value.

We can solve this using nested subqueries.
*/


-- =========================================================
-- SECTION 3: BASIC NESTED SUBQUERY
-- =========================================================

-- Find employees working in the department
-- that has the highest average salary.

SELECT *
FROM #Employees
WHERE DepartmentID =
(
    SELECT DepartmentID
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING AVG(Salary) =
    (
        SELECT MAX(DepartmentAverage)
        FROM
        (
            SELECT AVG(Salary) AS DepartmentAverage
            FROM #Employees
            WHERE DepartmentID IS NOT NULL
            GROUP BY DepartmentID
        ) AS DepartmentSummary
    )
);


-- Understand the innermost query separately.

SELECT
    DepartmentID,
    AVG(Salary) AS DepartmentAverage
FROM #Employees
WHERE DepartmentID IS NOT NULL
GROUP BY DepartmentID;


-- Find the highest average salary among departments.

SELECT MAX(DepartmentAverage) AS HighestDepartmentAverage
FROM
(
    SELECT AVG(Salary) AS DepartmentAverage
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
) AS DepartmentSummary;


-- =========================================================
-- SECTION 4: MULTI-LEVEL SUBQUERIES
-- =========================================================

-- Find employees who work in the department
-- with the highest total salary.

SELECT *
FROM #Employees
WHERE DepartmentID =
(
    SELECT DepartmentID
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING SUM(Salary) =
    (
        SELECT MAX(DepartmentTotal)
        FROM
        (
            SELECT SUM(Salary) AS DepartmentTotal
            FROM #Employees
            WHERE DepartmentID IS NOT NULL
            GROUP BY DepartmentID
        ) AS DepartmentSummary
    )
);


-- Find employees earning more than the average salary
-- of the department with the highest average salary.

SELECT *
FROM #Employees
WHERE Salary >
(
    SELECT MAX(DepartmentAverage)
    FROM
    (
        SELECT
            DepartmentID,
            AVG(Salary) AS DepartmentAverage
        FROM #Employees
        WHERE DepartmentID IS NOT NULL
        GROUP BY DepartmentID
    ) AS DepartmentSummary
);


-- Find employees working in departments
-- whose average salary is greater than the company average.

SELECT *
FROM #Employees
WHERE DepartmentID IN
(
    SELECT DepartmentID
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING AVG(Salary) >
    (
        SELECT AVG(Salary)
        FROM #Employees
    )
);


-- =========================================================
-- SECTION 5: CORRELATED SUBQUERY IN DEPTH
-- =========================================================

/*
A correlated subquery refers to the outer query.

The inner query uses a value from the current outer row.

Example:

For each employee:
1. Identify their department.
2. Calculate that department's average salary.
3. Compare the employee's salary with that average.

The inner query uses E.DepartmentID from the outer query.
*/


-- Find employees earning above their department average.

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


-- Find employees earning below their department average.

SELECT
    E.EmployeeName,
    E.DepartmentID,
    E.Salary
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Salary <
(
    SELECT AVG(E2.Salary)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- Find employees earning exactly their department average.

SELECT
    E.EmployeeName,
    E.DepartmentID,
    E.Salary
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Salary =
(
    SELECT AVG(E2.Salary)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- Find the highest-paid employee in each department.

SELECT *
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Salary =
(
    SELECT MAX(E2.Salary)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- Find the lowest-paid employee in each department.

SELECT *
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Salary =
(
    SELECT MIN(E2.Salary)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- =========================================================
-- SECTION 6: SUBQUERY WITH GROUP BY AND HAVING
-- =========================================================

-- Find departments having more employees
-- than the average department employee count.

SELECT *
FROM #Departments
WHERE DepartmentID IN
(
    SELECT DepartmentID
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING COUNT(*) >
    (
        SELECT AVG(EmployeeCount * 1.0)
        FROM
        (
            SELECT COUNT(*) AS EmployeeCount
            FROM #Employees
            WHERE DepartmentID IS NOT NULL
            GROUP BY DepartmentID
        ) AS DepartmentCounts
    )
);


-- Find departments whose total salary
-- is greater than 150000.

SELECT *
FROM #Departments
WHERE DepartmentID IN
(
    SELECT DepartmentID
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING SUM(Salary) > 150000
);


-- Find employees working in departments
-- having more than two employees.

SELECT *
FROM #Employees
WHERE DepartmentID IN
(
    SELECT DepartmentID
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING COUNT(*) > 2
);


-- =========================================================
-- SECTION 7: SECOND-HIGHEST SALARY
-- =========================================================

/*
IMPORTANT INTERVIEW QUESTION:

Find the second-highest salary.

First understand the difference:

Method 1:
Second-highest DISTINCT salary.

Method 2:
Second row after sorting salary in descending order.

These are not always the same when duplicate salaries exist.

Example:

Salary:
95000
95000
85000
80000
75000

Second-highest DISTINCT salary = 85000.

The second row after sorting = 95000.
*/


-- METHOD 1: Using MAX and a subquery.

SELECT MAX(Salary) AS SecondHighestSalary
FROM #Employees
WHERE Salary <
(
    SELECT MAX(Salary)
    FROM #Employees
);


-- METHOD 2: Using DISTINCT and TOP.

SELECT TOP (1) Salary AS SecondHighestSalary
FROM
(
    SELECT DISTINCT Salary
    FROM #Employees
) AS DistinctSalaries
WHERE Salary <
(
    SELECT MAX(Salary)
    FROM #Employees
)
ORDER BY Salary DESC;


-- METHOD 3: Using NOT EXISTS.

SELECT MAX(E1.Salary) AS SecondHighestSalary
FROM #Employees E1
WHERE EXISTS
(
    SELECT 1
    FROM #Employees E2
    WHERE E2.Salary > E1.Salary
);


-- The above NOT EXISTS pattern is NOT sufficient
-- for second-highest salary by itself.
-- Correct NOT EXISTS method:

SELECT MAX(E1.Salary) AS SecondHighestSalary
FROM #Employees E1
WHERE E1.Salary <
(
    SELECT MAX(E2.Salary)
    FROM #Employees E2
);


-- =========================================================
-- SECTION 8: NTH-HIGHEST DISTINCT SALARY
-- =========================================================

/*
We can use a variable to find the Nth-highest salary.

Example:
N = 1 means highest salary.
N = 2 means second-highest DISTINCT salary.
N = 3 means third-highest DISTINCT salary.

We use DISTINCT because duplicate salaries should
not occupy multiple salary ranks in this problem.
*/


DECLARE @N INT = 3;


SELECT MAX(Salary) AS NthHighestSalary
FROM #Employees E1
WHERE
(
    SELECT COUNT(DISTINCT E2.Salary)
    FROM #Employees E2
    WHERE E2.Salary > E1.Salary
) = @N - 1;


-- Try changing @N to 1, 2, 3, 4 and 5.


-- Alternative using TOP and a derived table.

DECLARE @Position INT = 3;


SELECT MIN(Salary) AS NthHighestSalary
FROM
(
    SELECT DISTINCT TOP (@Position) Salary
    FROM #Employees
    ORDER BY Salary DESC
) AS TopSalaries;


-- =========================================================
-- SECTION 9: DUPLICATE RECORDS USING SUBQUERIES
-- =========================================================

/*
Duplicate records can be identified by grouping
the columns that should be unique.

For example:
If two employees have the same salary,
that salary is repeated.

Remember:
Duplicate salary does not mean duplicate employee.
*/


-- Find salaries that appear more than once.

SELECT Salary
FROM #Employees
GROUP BY Salary
HAVING COUNT(*) > 1;


-- Find all employees having a duplicate salary.

SELECT *
FROM #Employees E
WHERE E.Salary IN
(
    SELECT Salary
    FROM #Employees
    GROUP BY Salary
    HAVING COUNT(*) > 1
);


-- Find employees sharing the same department and salary.

SELECT *
FROM #Employees E
WHERE EXISTS
(
    SELECT 1
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
      AND E2.Salary = E.Salary
      AND E2.EmployeeID <> E.EmployeeID
);


-- Find departments having duplicate employee salary values.

SELECT DepartmentID, Salary
FROM #Employees
WHERE DepartmentID IS NOT NULL
GROUP BY DepartmentID, Salary
HAVING COUNT(*) > 1;


-- =========================================================
-- SECTION 10: DEPARTMENT-WISE COMPARISONS
-- =========================================================

-- Find employees earning more than the average salary
-- of the IT department.

SELECT *
FROM #Employees
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM #Employees
    WHERE DepartmentID = 1
);


-- Find employees earning more than the average salary
-- of their own department.

SELECT *
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Salary >
(
    SELECT AVG(E2.Salary)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- Find departments whose average salary
-- is greater than the average salary of IT.

SELECT
    DepartmentID,
    AVG(Salary) AS AverageSalary
FROM #Employees
WHERE DepartmentID IS NOT NULL
GROUP BY DepartmentID
HAVING AVG(Salary) >
(
    SELECT AVG(Salary)
    FROM #Employees
    WHERE DepartmentID = 1
);


-- Find employees earning more than the average salary
-- of their city.

SELECT *
FROM #Employees E
WHERE E.Salary >
(
    SELECT AVG(E2.Salary)
    FROM #Employees E2
    WHERE E2.City = E.City
);


-- =========================================================
-- SECTION 11: EXISTS AND NOT EXISTS ADVANCED EXAMPLES
-- =========================================================

-- Find departments having at least two employees.

SELECT *
FROM #Departments D
WHERE
(
    SELECT COUNT(*)
    FROM #Employees E
    WHERE E.DepartmentID = D.DepartmentID
) >= 2;


-- Same requirement using EXISTS.

SELECT *
FROM #Departments D
WHERE EXISTS
(
    SELECT 1
    FROM #Employees E
    WHERE E.DepartmentID = D.DepartmentID
    GROUP BY E.DepartmentID
    HAVING COUNT(*) >= 2
);


-- Find employees who share their city with another employee.

SELECT *
FROM #Employees E
WHERE EXISTS
(
    SELECT 1
    FROM #Employees E2
    WHERE E2.City = E.City
      AND E2.EmployeeID <> E.EmployeeID
);


-- Find departments that have no employees.

SELECT *
FROM #Departments D
WHERE NOT EXISTS
(
    SELECT 1
    FROM #Employees E
    WHERE E.DepartmentID = D.DepartmentID
);


-- =========================================================
-- SECTION 12: PRACTICE QUESTIONS
-- =========================================================

/*
Try solving these questions before looking at the solutions.

Q1. Find employees earning more than the highest
    average salary of any department.

Q2. Find employees working in the department
    with the highest total salary.

Q3. Find employees earning above their own
    department average.

Q4. Find employees earning below their own
    department average.

Q5. Find employees receiving the highest salary
    in their department.

Q6. Find employees receiving the lowest salary
    in their department.

Q7. Find departments having more employees
    than the average department employee count.

Q8. Find departments having total salary above 200000.

Q9. Find employees working in departments
    having at least three employees.

Q10. Find the second-highest DISTINCT salary.

Q11. Find the third-highest DISTINCT salary.

Q12. Find the fourth-highest DISTINCT salary
     using a variable.

Q13. Find all employees sharing a salary with
     at least one other employee.

Q14. Find duplicate salary values.

Q15. Find duplicate salary values within each department.

Q16. Find employees earning more than the average
     salary of the IT department.

Q17. Find departments having average salary
     greater than the IT department average.

Q18. Find employees earning more than the average
     salary of their own city.

Q19. Find employees who share their city with another employee.

Q20. Find departments that do not have employees.

Q21. Find employees earning more than every employee
     in the HR department.

Q22. Find employees earning less than at least one
     employee in the Finance department.

Q23. Find the highest-paid employee in the entire company
     using a correlated subquery.

Q24. Find employees who are not the highest-paid
     employee in their department.

Q25. Find the department with the maximum number
     of employees.

*/


-- =========================================================
-- SECTION 13: SOLUTIONS
-- =========================================================


-- Q1
SELECT *
FROM #Employees
WHERE Salary >
(
    SELECT MAX(DepartmentAverage)
    FROM
    (
        SELECT AVG(Salary) AS DepartmentAverage
        FROM #Employees
        WHERE DepartmentID IS NOT NULL
        GROUP BY DepartmentID
    ) AS DepartmentSummary
);


-- Q2
SELECT *
FROM #Employees
WHERE DepartmentID IN
(
    SELECT DepartmentID
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING SUM(Salary) =
    (
        SELECT MAX(DepartmentTotal)
        FROM
        (
            SELECT SUM(Salary) AS DepartmentTotal
            FROM #Employees
            WHERE DepartmentID IS NOT NULL
            GROUP BY DepartmentID
        ) AS DepartmentSummary
    )
);


-- Q3
SELECT *
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Salary >
(
    SELECT AVG(E2.Salary)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- Q4
SELECT *
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Salary <
(
    SELECT AVG(E2.Salary)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- Q5
SELECT *
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Salary =
(
    SELECT MAX(E2.Salary)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- Q6
SELECT *
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND E.Salary =
(
    SELECT MIN(E2.Salary)
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
);


-- Q7
SELECT *
FROM #Departments
WHERE DepartmentID IN
(
    SELECT DepartmentID
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING COUNT(*) >
    (
        SELECT AVG(EmployeeCount * 1.0)
        FROM
        (
            SELECT COUNT(*) AS EmployeeCount
            FROM #Employees
            WHERE DepartmentID IS NOT NULL
            GROUP BY DepartmentID
        ) AS DepartmentCounts
    )
);


-- Q8
SELECT *
FROM #Departments
WHERE DepartmentID IN
(
    SELECT DepartmentID
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING SUM(Salary) > 200000
);


-- Q9
SELECT *
FROM #Employees
WHERE DepartmentID IN
(
    SELECT DepartmentID
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING COUNT(*) >= 3
);


-- Q10
SELECT MAX(Salary) AS SecondHighestSalary
FROM #Employees
WHERE Salary <
(
    SELECT MAX(Salary)
    FROM #Employees
);


-- Q11
SELECT MAX(Salary) AS ThirdHighestSalary
FROM #Employees E1
WHERE
(
    SELECT COUNT(DISTINCT E2.Salary)
    FROM #Employees E2
    WHERE E2.Salary > E1.Salary
) = 2;


-- Q12
DECLARE @N INT = 4;

SELECT MAX(Salary) AS NthHighestSalary
FROM #Employees E1
WHERE
(
    SELECT COUNT(DISTINCT E2.Salary)
    FROM #Employees E2
    WHERE E2.Salary > E1.Salary
) = @N - 1;


-- Q13
SELECT *
FROM #Employees E
WHERE EXISTS
(
    SELECT 1
    FROM #Employees E2
    WHERE E2.Salary = E.Salary
      AND E2.EmployeeID <> E.EmployeeID
);


-- Q14
SELECT Salary
FROM #Employees
GROUP BY Salary
HAVING COUNT(*) > 1;


-- Q15
SELECT DepartmentID, Salary
FROM #Employees
WHERE DepartmentID IS NOT NULL
GROUP BY DepartmentID, Salary
HAVING COUNT(*) > 1;


-- Q16
SELECT *
FROM #Employees
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM #Employees
    WHERE DepartmentID = 1
);


-- Q17
SELECT
    DepartmentID,
    AVG(Salary) AS AverageSalary
FROM #Employees
WHERE DepartmentID IS NOT NULL
GROUP BY DepartmentID
HAVING AVG(Salary) >
(
    SELECT AVG(Salary)
    FROM #Employees
    WHERE DepartmentID = 1
);


-- Q18
SELECT *
FROM #Employees E
WHERE E.Salary >
(
    SELECT AVG(E2.Salary)
    FROM #Employees E2
    WHERE E2.City = E.City
);


-- Q19
SELECT *
FROM #Employees E
WHERE EXISTS
(
    SELECT 1
    FROM #Employees E2
    WHERE E2.City = E.City
      AND E2.EmployeeID <> E.EmployeeID
);


-- Q20
SELECT *
FROM #Departments D
WHERE NOT EXISTS
(
    SELECT 1
    FROM #Employees E
    WHERE E.DepartmentID = D.DepartmentID
);


-- Q21
SELECT *
FROM #Employees
WHERE Salary > ALL
(
    SELECT Salary
    FROM #Employees
    WHERE DepartmentID = 2
);


-- Q22
SELECT *
FROM #Employees
WHERE Salary < ANY
(
    SELECT Salary
    FROM #Employees
    WHERE DepartmentID = 3
);


-- Q23
SELECT *
FROM #Employees E
WHERE NOT EXISTS
(
    SELECT 1
    FROM #Employees E2
    WHERE E2.Salary > E.Salary
);


-- Q24
SELECT *
FROM #Employees E
WHERE E.DepartmentID IS NOT NULL
  AND EXISTS
(
    SELECT 1
    FROM #Employees E2
    WHERE E2.DepartmentID = E.DepartmentID
      AND E2.Salary > E.Salary
);


-- Q25
SELECT *
FROM #Departments D
WHERE
(
    SELECT COUNT(*)
    FROM #Employees E
    WHERE E.DepartmentID = D.DepartmentID
) =
(
    SELECT MAX(EmployeeCount)
    FROM
    (
        SELECT COUNT(*) AS EmployeeCount
        FROM #Employees
        WHERE DepartmentID IS NOT NULL
        GROUP BY DepartmentID
    ) AS DepartmentCounts
);


-- =========================================================
-- SECTION 14: IMPORTANT INTERVIEW REVISION
-- =========================================================

/*
1. What is a nested subquery?
   A subquery placed inside another subquery.

2. What is a correlated subquery?
   A subquery that refers to a column from the outer query.

3. What is the difference between correlated and
   non-correlated subqueries?

   Correlated:
   Depends on the outer query.

   Non-correlated:
   Does not depend on the outer query.

4. How do you find the second-highest salary?

   SELECT MAX(Salary)
   FROM #Employees
   WHERE Salary <
   (
       SELECT MAX(Salary)
       FROM #Employees
   );

5. How do you find the Nth-highest DISTINCT salary?

   Count the number of distinct salaries greater
   than the current salary.

   For the Nth-highest salary, that count must be N - 1.

6. How do you identify duplicate values?

   GROUP BY the column and use HAVING COUNT(*) > 1.

7. Can a correlated subquery be used with EXISTS?
   Yes.

8. Can a subquery contain another subquery?
   Yes. This is called nesting.

9. Does a correlated subquery always execute once
   for every outer row?
   Not necessarily. SQL Server can transform and optimize
   the query. Think in terms of logical dependency,
   not a guaranteed physical execution count.

10. What is the difference between second-highest
    salary and second row by salary?

    Second-highest DISTINCT salary ignores duplicates.
    Second row can contain the same salary as the first row.

11. What happens if the Nth-highest salary does not exist?
    The MAX-based solution returns NULL.

12. Can multiple employees have the same
    highest salary?
    Yes. A query using equality with MAX returns all ties.

IMPORTANT:
- Always clarify whether the question asks for DISTINCT
  salary ranks or sorted rows.
- Handle NULL values intentionally.
- Use meaningful aliases in correlated subqueries.
- Check the result of each inner query independently.
- Do not assume nested queries are automatically slower
  than joins.
============================================================
END OF PRACTICE FILE
============================================================
*/