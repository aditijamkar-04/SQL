/*
============================================================
SQL PRACTICE 03: COMMON TABLE EXPRESSIONS (CTE)

Topics:
1. Introduction to CTE
2. CTE Syntax
3. Single CTE
4. Multiple CTEs
5. CTE with WHERE, GROUP BY and HAVING
6. CTE with JOIN
7. CTE with INSERT, UPDATE and DELETE
8. CTE vs Subquery vs Derived Table
9. CTE Advantages and Limitations
10. Recursive CTE Introduction
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
-- SECTION 2: WHAT IS A CTE?
-- =========================================================

/*
CTE stands for COMMON TABLE EXPRESSION.

A CTE is a named temporary result set that we define
using the WITH keyword.

We can refer to that result set in the statement
that immediately follows its definition.

Why do we use CTEs?

1. To make complicated queries easier to understand.
2. To divide a large query into smaller logical steps.
3. To avoid repeating the same subquery.
4. To perform recursive queries.
5. To make query logic easier to maintain.

IMPORTANT:
A CTE is not a permanent table.
It does not automatically store data physically.
Its scope is limited to the single statement
immediately following the CTE definition.

GENERAL SYNTAX:

WITH CTE_Name AS
(
    SELECT columns
    FROM table_name
    WHERE condition
)

SELECT *
FROM CTE_Name;
*/


-- =========================================================
-- SECTION 3: BASIC CTE
-- =========================================================

-- Find employees earning more than 70000.

WITH HighSalaryEmployees AS
(
    SELECT *
    FROM #Employees
    WHERE Salary > 70000
)
SELECT *
FROM HighSalaryEmployees;


-- Explanation:
-- Step 1: The CTE selects employees earning above 70000.
-- Step 2: The outer query retrieves the CTE result.


-- =========================================================
-- SECTION 4: CTE WITH SELECT
-- =========================================================

-- Display employee names and salaries using a CTE.

WITH EmployeeDetails AS
(
    SELECT
        EmployeeName,
        Salary
    FROM #Employees
)
SELECT *
FROM EmployeeDetails;


-- Find employees earning more than the average salary.

WITH AverageSalary AS
(
    SELECT AVG(Salary) AS CompanyAverage
    FROM #Employees
)
SELECT E.*
FROM #Employees E
CROSS JOIN AverageSalary A
WHERE E.Salary > A.CompanyAverage;


-- Find employees from Pune.

WITH PuneEmployees AS
(
    SELECT *
    FROM #Employees
    WHERE City = 'Pune'
)
SELECT *
FROM PuneEmployees;


-- =========================================================
-- SECTION 5: CTE WITH GROUP BY
-- =========================================================

-- Calculate department-wise average salary.

WITH DepartmentSalary AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT *
FROM DepartmentSalary;


-- Calculate department-wise employee count.

WITH DepartmentCount AS
(
    SELECT
        DepartmentID,
        COUNT(*) AS TotalEmployees
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT *
FROM DepartmentCount;


-- =========================================================
-- SECTION 6: CTE WITH HAVING
-- =========================================================

-- Find departments having more than two employees.

WITH DepartmentCount AS
(
    SELECT
        DepartmentID,
        COUNT(*) AS TotalEmployees
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING COUNT(*) > 2
)
SELECT *
FROM DepartmentCount;


-- Find departments having average salary above 70000.

WITH DepartmentAverage AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING AVG(Salary) > 70000
)
SELECT *
FROM DepartmentAverage;


-- =========================================================
-- SECTION 7: CTE WITH JOIN
-- =========================================================

-- Display employee name and department name.

WITH EmployeeDetails AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        DepartmentID,
        Salary
    FROM #Employees
)
SELECT
    E.EmployeeName,
    D.DepartmentName,
    E.Salary
FROM EmployeeDetails E
INNER JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID;


-- Display all employees, including those
-- without a matching department.

WITH EmployeeDetails AS
(
    SELECT *
    FROM #Employees
)
SELECT
    E.EmployeeName,
    D.DepartmentName
FROM EmployeeDetails E
LEFT JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID;


-- =========================================================
-- SECTION 8: MULTIPLE CTEs
-- =========================================================

/*
We can define multiple CTEs in a single WITH clause.

Separate CTE definitions using commas.

Syntax:

WITH CTE1 AS
(
    SELECT ...
),
CTE2 AS
(
    SELECT ...
)
SELECT ...
FROM CTE1
JOIN CTE2 ON ...;

A later CTE can reference an earlier CTE
defined in the same WITH clause.
*/


-- Example 1:
-- First calculate department-wise salary.
-- Then find departments with average salary above 70000.

WITH DepartmentSalary AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
),
HighSalaryDepartments AS
(
    SELECT *
    FROM DepartmentSalary
    WHERE AverageSalary > 70000
)
SELECT *
FROM HighSalaryDepartments;


-- Example 2:
-- Calculate department-wise employee count and salary.
-- Then display departments with more than two employees.

WITH DepartmentCount AS
(
    SELECT
        DepartmentID,
        COUNT(*) AS TotalEmployees
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
),
DepartmentSalary AS
(
    SELECT
        DepartmentID,
        SUM(Salary) AS TotalSalary
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT
    C.DepartmentID,
    C.TotalEmployees,
    S.TotalSalary
FROM DepartmentCount C
INNER JOIN DepartmentSalary S
    ON C.DepartmentID = S.DepartmentID
WHERE C.TotalEmployees > 2;


-- =========================================================
-- SECTION 9: MULTIPLE CTEs REFERENCING EACH OTHER
-- =========================================================

-- Step 1: Calculate department averages.
-- Step 2: Find the highest department average.
-- Step 3: Display departments with that average.

WITH DepartmentAverage AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
),
HighestAverage AS
(
    SELECT MAX(AverageSalary) AS HighestAverageSalary
    FROM DepartmentAverage
)
SELECT
    D.DepartmentID,
    D.AverageSalary
FROM DepartmentAverage D
CROSS JOIN HighestAverage H
WHERE D.AverageSalary = H.HighestAverageSalary;


-- =========================================================
-- SECTION 10: CTE WITH RANKING
-- =========================================================

/*
A CTE can store the result of a window function.

This is especially useful when we want to filter
the result of ROW_NUMBER(), RANK() or DENSE_RANK().

We cannot normally use a window function directly
in the WHERE clause of the same SELECT query.

A CTE provides an intermediate query layer.
*/


-- Find the highest-paid employee in each department.

WITH EmployeeRanking AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        DepartmentID,
        Salary,
        DENSE_RANK() OVER
        (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
)
SELECT *
FROM EmployeeRanking
WHERE SalaryRank = 1;


-- Find the second-highest DISTINCT salary in the company.

WITH SalaryRanking AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        Salary,
        DENSE_RANK() OVER
        (
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM #Employees
)
SELECT *
FROM SalaryRanking
WHERE SalaryRank = 2;


-- Find the top two salary ranks in each department.

WITH DepartmentRanking AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        DepartmentID,
        Salary,
        DENSE_RANK() OVER
        (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
)
SELECT *
FROM DepartmentRanking
WHERE SalaryRank <= 2;


-- =========================================================
-- SECTION 11: CTE WITH UPDATE
-- =========================================================

/*
A CTE can be used as the target of an UPDATE
when the CTE is updatable.

For this demonstration, we create a separate copy
so the original sample data remains unchanged.
*/


DROP TABLE IF EXISTS #EmployeeUpdateDemo;

SELECT *
INTO #EmployeeUpdateDemo
FROM #Employees;


-- Increase salary by 5000 for IT employees.

WITH ITEmployees AS
(
    SELECT *
    FROM #EmployeeUpdateDemo
    WHERE DepartmentID = 1
)
UPDATE ITEmployees
SET Salary = Salary + 5000;


SELECT *
FROM #EmployeeUpdateDemo;


-- =========================================================
-- SECTION 12: CTE WITH DELETE
-- =========================================================

/*
A CTE can also be used as the target of DELETE
when it is updatable.

We will use a separate demo table.
*/


DROP TABLE IF EXISTS #EmployeeDeleteDemo;

SELECT *
INTO #EmployeeDeleteDemo
FROM #Employees;


-- Delete employees whose salary is below 50000.

WITH LowSalaryEmployees AS
(
    SELECT *
    FROM #EmployeeDeleteDemo
    WHERE Salary < 50000
)
DELETE FROM LowSalaryEmployees;


SELECT *
FROM #EmployeeDeleteDemo;


-- =========================================================
-- SECTION 13: CTE WITH INSERT
-- =========================================================

/*
A CTE can provide rows for an INSERT statement.

The INSERT statement is the statement immediately
following the CTE definition.
*/


DROP TABLE IF EXISTS #HighSalaryEmployees;


CREATE TABLE #HighSalaryEmployees
(
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10,2)
);


WITH HighSalaryEmployees AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        Salary
    FROM #Employees
    WHERE Salary >= 80000
)
INSERT INTO #HighSalaryEmployees
(
    EmployeeID,
    EmployeeName,
    Salary
)
SELECT
    EmployeeID,
    EmployeeName,
    Salary
FROM HighSalaryEmployees;


SELECT *
FROM #HighSalaryEmployees;


-- =========================================================
-- SECTION 14: CTE VS SUBQUERY VS DERIVED TABLE
-- =========================================================

/*
SUBQUERY:

SELECT *
FROM #Employees
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM #Employees
);


CTE:

WITH AverageSalary AS
(
    SELECT AVG(Salary) AS AvgSalary
    FROM #Employees
)
SELECT E.*
FROM #Employees E
CROSS JOIN AverageSalary A
WHERE E.Salary > A.AvgSalary;


DERIVED TABLE:

SELECT *
FROM
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
) AS DepartmentSummary;


Main differences:

CTE:
- Defined using WITH.
- Has a meaningful name.
- Can be referenced multiple times in the same statement.
- Supports recursive queries.

Subquery:
- Written inside another query.
- Useful for filtering or calculating intermediate values.

Derived Table:
- A subquery written in the FROM clause.
- Must have an alias in SQL Server.

IMPORTANT:
A CTE is not automatically faster than a subquery.
A nonrecursive CTE is generally not a materialized,
persistently stored result set.
SQL Server may inline or otherwise optimize its definition.

If you need a reusable physical intermediate result,
consider a temporary table.
*/


-- =========================================================
-- SECTION 15: CTE LIMITATIONS AND IMPORTANT RULES
-- =========================================================

/*
1. A CTE must be followed by a single statement
   that uses it.

2. A CTE is not a permanent table.

3. A CTE's scope is limited to the statement
   immediately following its definition.

4. Multiple CTEs can be defined in one WITH clause.

5. Later CTEs can reference earlier CTEs.

6. A CTE name must be unique within its WITH clause.

7. A CTE can be used with SELECT, INSERT, UPDATE,
   DELETE and MERGE statements, subject to the
   rules of the statement and updatable CTE.

8. A CTE can be recursive.

9. ORDER BY is generally not allowed inside a CTE
   unless used with TOP or OFFSET/FETCH as permitted.
   Even then, ordering of the final result is not
   guaranteed without an outer ORDER BY.

10. If the previous statement is not terminated,
    use a semicolon before WITH.

Example:

;WITH EmployeeCTE AS
(
    SELECT *
    FROM #Employees
)
SELECT *
FROM EmployeeCTE;
*/


-- =========================================================
-- SECTION 16: PRACTICE QUESTIONS
-- =========================================================

/*
Q1. Display employees earning more than 70000 using CTE.

Q2. Find employees earning more than company average.

Q3. Calculate department-wise average salary.

Q4. Calculate department-wise employee count.

Q5. Find departments having more than two employees.

Q6. Find departments having average salary above 70000.

Q7. Display employee name and department name using CTE.

Q8. Display all employees, including those without
    a matching department.

Q9. Use two CTEs to calculate department count
    and department total salary.

Q10. Find the department with the highest average salary.

Q11. Find the highest-paid employee in each department.

Q12. Find the second-highest DISTINCT salary using CTE.

Q13. Find the top two salary ranks in each department.

Q14. Find employees earning above their department average.

Q15. Find employees from Pune earning above 70000.

Q16. Increase IT employees' salaries by 5000
     using CTE and UPDATE.

Q17. Delete employees earning below 50000
     using CTE and DELETE.

Q18. Insert employees earning at least 80000
     into a separate table using CTE.

Q19. Find departments whose average salary is
     greater than company average.

Q20. Find the department having the maximum
     number of employees.

Q21. Find employees whose salary is the highest
     in the entire company.

Q22. Find employees with duplicate salary values.

Q23. Find the average salary for each city.

Q24. Find employees earning above their city average.

Q25. Display department names with employee counts,
     including departments having zero employees.


-- =========================================================
-- SECTION 17: SOLUTIONS
-- =========================================================


-- Q1
WITH HighSalaryEmployees AS
(
    SELECT *
    FROM #Employees
    WHERE Salary > 70000
)
SELECT *
FROM HighSalaryEmployees;


-- Q2
WITH AverageSalary AS
(
    SELECT AVG(Salary) AS AvgSalary
    FROM #Employees
)
SELECT E.*
FROM #Employees E
CROSS JOIN AverageSalary A
WHERE E.Salary > A.AvgSalary;


-- Q3
WITH DepartmentAverage AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT *
FROM DepartmentAverage;


-- Q4
WITH DepartmentCount AS
(
    SELECT
        DepartmentID,
        COUNT(*) AS TotalEmployees
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT *
FROM DepartmentCount;


-- Q5
WITH DepartmentCount AS
(
    SELECT
        DepartmentID,
        COUNT(*) AS TotalEmployees
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING COUNT(*) > 2
)
SELECT *
FROM DepartmentCount;


-- Q6
WITH DepartmentAverage AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    HAVING AVG(Salary) > 70000
)
SELECT *
FROM DepartmentAverage;


-- Q7
WITH EmployeeDetails AS
(
    SELECT *
    FROM #Employees
)
SELECT
    E.EmployeeName,
    D.DepartmentName
FROM EmployeeDetails E
INNER JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID;


-- Q8
WITH EmployeeDetails AS
(
    SELECT *
    FROM #Employees
)
SELECT
    E.EmployeeName,
    D.DepartmentName
FROM EmployeeDetails E
LEFT JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID;


-- Q9
WITH DepartmentCount AS
(
    SELECT
        DepartmentID,
        COUNT(*) AS TotalEmployees
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
),
DepartmentSalary AS
(
    SELECT
        DepartmentID,
        SUM(Salary) AS TotalSalary
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT
    C.DepartmentID,
    C.TotalEmployees,
    S.TotalSalary
FROM DepartmentCount C
INNER JOIN DepartmentSalary S
    ON C.DepartmentID = S.DepartmentID;


-- Q10
WITH DepartmentAverage AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT *
FROM DepartmentAverage
WHERE AverageSalary =
(
    SELECT MAX(AverageSalary)
    FROM DepartmentAverage
);


-- Q11
WITH EmployeeRanking AS
(
    SELECT
        *,
        DENSE_RANK() OVER
        (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
)
SELECT *
FROM EmployeeRanking
WHERE SalaryRank = 1;


-- Q12
WITH SalaryRanking AS
(
    SELECT
        Salary,
        DENSE_RANK() OVER
        (
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM #Employees
)
SELECT DISTINCT Salary
FROM SalaryRanking
WHERE SalaryRank = 2;


-- Q13
WITH DepartmentRanking AS
(
    SELECT
        *,
        DENSE_RANK() OVER
        (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
)
SELECT *
FROM DepartmentRanking
WHERE SalaryRank <= 2;


-- Q14
WITH DepartmentAverage AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT E.*
FROM #Employees E
INNER JOIN DepartmentAverage D
    ON E.DepartmentID = D.DepartmentID
WHERE E.Salary > D.AverageSalary;


-- Q15
WITH PuneHighSalaryEmployees AS
(
    SELECT *
    FROM #Employees
    WHERE City = 'Pune'
      AND Salary > 70000
)
SELECT *
FROM PuneHighSalaryEmployees;


-- Q16
DROP TABLE IF EXISTS #EmployeeUpdatePractice;

SELECT *
INTO #EmployeeUpdatePractice
FROM #Employees;

WITH ITEmployees AS
(
    SELECT *
    FROM #EmployeeUpdatePractice
    WHERE DepartmentID = 1
)
UPDATE ITEmployees
SET Salary = Salary + 5000;

SELECT *
FROM #EmployeeUpdatePractice;


-- Q17
DROP TABLE IF EXISTS #EmployeeDeletePractice;

SELECT *
INTO #EmployeeDeletePractice
FROM #Employees;

WITH LowSalaryEmployees AS
(
    SELECT *
    FROM #EmployeeDeletePractice
    WHERE Salary < 50000
)
DELETE FROM LowSalaryEmployees;

SELECT *
FROM #EmployeeDeletePractice;


-- Q18
DROP TABLE IF EXISTS #EmployeeInsertPractice;

CREATE TABLE #EmployeeInsertPractice
(
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10,2)
);

WITH HighSalaryEmployees AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        Salary
    FROM #Employees
    WHERE Salary >= 80000
)
INSERT INTO #EmployeeInsertPractice
SELECT
    EmployeeID,
    EmployeeName,
    Salary
FROM HighSalaryEmployees;

SELECT *
FROM #EmployeeInsertPractice;


-- Q19
WITH DepartmentAverage AS
(
    SELECT
        DepartmentID,
        AVG(Salary) AS AverageSalary
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
),
CompanyAverage AS
(
    SELECT AVG(Salary) AS AverageSalary
    FROM #Employees
)
SELECT D.*
FROM DepartmentAverage D
CROSS JOIN CompanyAverage C
WHERE D.AverageSalary > C.AverageSalary;


-- Q20
WITH DepartmentCount AS
(
    SELECT
        DepartmentID,
        COUNT(*) AS TotalEmployees
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT *
FROM DepartmentCount
WHERE TotalEmployees =
(
    SELECT MAX(TotalEmployees)
    FROM DepartmentCount
);


-- Q21
WITH EmployeeRanking AS
(
    SELECT
        *,
        DENSE_RANK() OVER
        (
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM #Employees
)
SELECT *
FROM EmployeeRanking
WHERE SalaryRank = 1;


-- Q22
WITH SalaryCounts AS
(
    SELECT
        Salary,
        COUNT(*) AS SalaryCount
    FROM #Employees
    GROUP BY Salary
)
SELECT E.*
FROM #Employees E
INNER JOIN SalaryCounts S
    ON E.Salary = S.Salary
WHERE S.SalaryCount > 1;


-- Q23
WITH CityAverage AS
(
    SELECT
        City,
        AVG(Salary) AS AverageSalary
    FROM #Employees
    GROUP BY City
)
SELECT *
FROM CityAverage;


-- Q24
WITH CityAverage AS
(
    SELECT
        City,
        AVG(Salary) AS AverageSalary
    FROM #Employees
    GROUP BY City
)
SELECT E.*
FROM #Employees E
INNER JOIN CityAverage C
    ON E.City = C.City
WHERE E.Salary > C.AverageSalary;


-- Q25
WITH DepartmentCount AS
(
    SELECT
        DepartmentID,
        COUNT(*) AS TotalEmployees
    FROM #Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
)
SELECT
    D.DepartmentName,
    COALESCE(C.TotalEmployees, 0) AS TotalEmployees
FROM #Departments D
LEFT JOIN DepartmentCount C
    ON D.DepartmentID = C.DepartmentID
ORDER BY D.DepartmentID;


-- =========================================================
-- SECTION 18: IMPORTANT INTERVIEW REVISION
-- =========================================================

/*
1. What is a CTE?
   A named result set defined using the WITH keyword.

2. What is the full form of CTE?
   Common Table Expression.

3. Why do we use CTE?
   To simplify complex queries and improve readability.

4. Is a CTE a permanent table?
   No.

5. Does a CTE automatically store data physically?
   No. A nonrecursive CTE is generally not materialized
   as a separate stored result set.

6. Can we use multiple CTEs in one query?
   Yes. Separate their definitions using commas.

7. Can one CTE refer to another CTE?
   Yes, a later CTE can reference an earlier one
   in the same WITH clause.

8. Can we use CTE with UPDATE?
   Yes, when the CTE is updatable.

9. Can we use CTE with DELETE?
   Yes, when the CTE is updatable.

10. Can we use CTE with INSERT?
    Yes. A CTE can provide rows for an INSERT statement.

11. Can we use GROUP BY and HAVING in a CTE?
    Yes.

12. Can we use window functions in a CTE?
    Yes.

13. What is a recursive CTE?
    A CTE that refers to itself to process hierarchical
    or sequential data.

14. Difference between CTE and subquery?

    CTE:
    - Named query expression.
    - Can be referenced multiple times in the
      following statement.
    - Supports recursion.

    Subquery:
    - Nested inside another query.
    - Useful for filtering and intermediate calculations.

15. Is CTE faster than a subquery?
    Not automatically. The execution plan and data
    determine performance.

16. What is a derived table?
    A subquery in the FROM clause.

17. What is the scope of a CTE?
    The single statement immediately following
    the CTE definition.

18. Why use a CTE for ranking?
    To calculate a window function first and then
    filter its result in an outer query.

============================================================
END OF PRACTICE FILE
============================================================
*/