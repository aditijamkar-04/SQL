/*
============================================================
SQL PRACTICE 01: WINDOW FUNCTIONS BASICS
============================================================

Topics:
1. Introduction to Window Functions
2. Aggregate Functions vs Window Functions
3. OVER() Clause
4. PARTITION BY Clause
5. ORDER BY inside OVER()
6. ROW_NUMBER()
7. RANK()
8. DENSE_RANK()
9. Ranking Functions Comparison
10. Department-wise Ranking
11. Nth Highest Salary
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
    DepartmentID INT,
    Salary DECIMAL(10,2),
    City VARCHAR(50),
    JoiningDate DATE
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
(101, 'Rahul', 1, 95000, 'Pune', '2021-01-10'),
(102, 'Priya', 1, 75000, 'Mumbai', '2022-03-15'),
(103, 'Amit', 1, 75000, 'Pune', '2020-06-20'),
(104, 'Sneha', 2, 60000, 'Delhi', '2021-07-12'),
(105, 'Neha', 2, 55000, 'Mumbai', '2023-02-10'),
(106, 'Karan', 3, 85000, 'Pune', '2019-04-18'),
(107, 'Pooja', 3, 70000, 'Delhi', '2022-08-25'),
(108, 'Rohan', 4, 50000, 'Mumbai', '2021-11-05'),
(109, 'Anjali', 4, 50000, 'Pune', '2020-09-14'),
(110, 'Varun', 1, 95000, 'Delhi', '2018-05-22'),
(111, 'Meera', 2, 60000, 'Mumbai', '2023-06-01'),
(112, 'Arjun', 5, 80000, 'Pune', '2022-01-30'),
(113, 'Isha', 5, 45000, 'Delhi', '2024-02-15'),
(114, 'Kabir', 3, 85000, 'Mumbai', '2020-12-11'),
(115, 'Tara', 2, 55000, 'Pune', '2021-10-19');


SELECT * FROM #Employees;
SELECT * FROM #Departments;


-- =========================================================
-- SECTION 2: WHAT ARE WINDOW FUNCTIONS?
-- =========================================================

/*
A WINDOW FUNCTION performs a calculation across a set
of related rows while keeping the individual rows
in the result.

In simple words:

It calculates something using other rows without
collapsing all those rows into one result.

WHY DO WE USE WINDOW FUNCTIONS?

1. Ranking employees based on salary.
2. Finding the highest-paid employee in each department.
3. Calculating running totals.
4. Comparing current and previous records.
5. Calculating moving averages.
6. Finding the Nth-highest salary.
7. Comparing individual values with group averages.

GENERAL SYNTAX:

FUNCTION_NAME()
OVER
(
    PARTITION BY column_name
    ORDER BY column_name
);

OVER() defines the window of rows used by the function.
*/


-- =========================================================
-- SECTION 3: AGGREGATE FUNCTIONS VS WINDOW FUNCTIONS
-- =========================================================

/*
AGGREGATE FUNCTION:

Usually combines multiple rows into a smaller number
of result rows.

Example:
SELECT DepartmentID, AVG(Salary)
FROM #Employees
GROUP BY DepartmentID;

Result:
One row per department.


WINDOW FUNCTION:

Calculates across related rows but keeps each
individual employee row.

Example:
SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    AVG(Salary) OVER() AS CompanyAverage
FROM #Employees;

Result:
Every employee remains visible, along with
the company average.
*/


-- Aggregate example.

SELECT
    DepartmentID,
    AVG(Salary) AS AverageSalary
FROM #Employees
GROUP BY DepartmentID;


-- Window function example.

SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    AVG(Salary) OVER() AS CompanyAverage
FROM #Employees;


-- =========================================================
-- SECTION 4: OVER() CLAUSE
-- =========================================================

/*
OVER() defines the set of rows over which a window
function operates.

If we use OVER() without PARTITION BY:

The function considers all rows in the result set
as one window.

Example:
*/


-- Company-wide average salary.

SELECT
    EmployeeName,
    Salary,
    AVG(Salary) OVER() AS CompanyAverage
FROM #Employees;


-- Company-wide maximum salary.

SELECT
    EmployeeName,
    Salary,
    MAX(Salary) OVER() AS MaximumSalary
FROM #Employees;


-- Company-wide minimum salary.

SELECT
    EmployeeName,
    Salary,
    MIN(Salary) OVER() AS MinimumSalary
FROM #Employees;


-- Company-wide total salary.

SELECT
    EmployeeName,
    Salary,
    SUM(Salary) OVER() AS CompanyTotalSalary
FROM #Employees;


-- Company-wide employee count.

SELECT
    EmployeeName,
    COUNT(*) OVER() AS TotalEmployees
FROM #Employees;


-- =========================================================
-- SECTION 5: PARTITION BY CLAUSE
-- =========================================================

/*
PARTITION BY divides the result set into separate groups
or windows.

It is similar to GROUP BY in terms of grouping logic,
but it does not collapse the individual rows.

Example:

AVG(Salary) OVER(PARTITION BY DepartmentID)

Meaning:

Calculate the average salary separately for each
department and display that average on every
employee row in that department.
*/


-- Department-wise average salary.

SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    AVG(Salary) OVER
    (
        PARTITION BY DepartmentID
    ) AS DepartmentAverage
FROM #Employees;


-- Department-wise maximum salary.

SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    MAX(Salary) OVER
    (
        PARTITION BY DepartmentID
    ) AS DepartmentMaximum
FROM #Employees;


-- Department-wise minimum salary.

SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    MIN(Salary) OVER
    (
        PARTITION BY DepartmentID
    ) AS DepartmentMinimum
FROM #Employees;


-- Department-wise employee count.

SELECT
    EmployeeName,
    DepartmentID,
    COUNT(*) OVER
    (
        PARTITION BY DepartmentID
    ) AS DepartmentEmployeeCount
FROM #Employees;


-- Department-wise total salary.

SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    SUM(Salary) OVER
    (
        PARTITION BY DepartmentID
    ) AS DepartmentTotalSalary
FROM #Employees;


-- =========================================================
-- SECTION 6: PARTITION BY MULTIPLE COLUMNS
-- =========================================================

/*
We can partition using more than one column.

Example:

PARTITION BY DepartmentID, City

This creates a separate window for every
DepartmentID and City combination.
*/


-- Average salary for each department and city.

SELECT
    EmployeeName,
    DepartmentID,
    City,
    Salary,
    AVG(Salary) OVER
    (
        PARTITION BY DepartmentID, City
    ) AS DepartmentCityAverage
FROM #Employees;


-- Employee count for each department and city.

SELECT
    EmployeeName,
    DepartmentID,
    City,
    COUNT(*) OVER
    (
        PARTITION BY DepartmentID, City
    ) AS EmployeeCount
FROM #Employees;


-- =========================================================
-- SECTION 7: ORDER BY INSIDE OVER()
-- =========================================================

/*
ORDER BY inside OVER() defines the logical ordering
of rows for the window function.

It is especially important for:

1. Ranking.
2. Running totals.
3. Previous and next row comparisons.
4. Moving calculations.

IMPORTANT:

ORDER BY inside OVER() does not guarantee
the final display order.

Use an outer ORDER BY when you need sorted output.
*/


-- Rank employees by salary from highest to lowest.

SELECT
    EmployeeName,
    Salary,
    ROW_NUMBER() OVER
    (
        ORDER BY Salary DESC, EmployeeID
    ) AS RowNumber
FROM #Employees
ORDER BY Salary DESC, EmployeeID;


-- =========================================================
-- SECTION 8: ROW_NUMBER()
-- =========================================================

/*
ROW_NUMBER() assigns a unique sequential number
to every row.

Syntax:

ROW_NUMBER() OVER
(
    ORDER BY column_name
);

Important points:

1. Starts from 1.
2. Every row receives a different number.
3. Tied values still receive different row numbers.
4. Use a unique tie-breaker for deterministic ordering.
*/


-- Assign row numbers based on salary.

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    ROW_NUMBER() OVER
    (
        ORDER BY Salary DESC, EmployeeID
    ) AS RowNumber
FROM #Employees;


-- Assign row numbers separately in each department.

SELECT
    EmployeeID,
    EmployeeName,
    DepartmentID,
    Salary,
    ROW_NUMBER() OVER
    (
        PARTITION BY DepartmentID
        ORDER BY Salary DESC, EmployeeID
    ) AS DepartmentRowNumber
FROM #Employees;


-- Find the first employee in each department.

WITH EmployeeRanking AS
(
    SELECT
        *,
        ROW_NUMBER() OVER
        (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC, EmployeeID
        ) AS RowNumber
    FROM #Employees
)
SELECT *
FROM EmployeeRanking
WHERE RowNumber = 1;


-- =========================================================
-- SECTION 9: RANK()
-- =========================================================

/*
RANK() assigns ranks based on the ORDER BY values.

Important points:

1. Equal values receive the same rank.
2. The next rank is skipped after a tie.

Example:

Salary     RANK
95000       1
95000       1
85000       3
75000       4
75000       4
70000       6

Notice the gaps in ranking.
*/


SELECT
    EmployeeName,
    Salary,
    RANK() OVER
    (
        ORDER BY Salary DESC
    ) AS SalaryRank
FROM #Employees
ORDER BY Salary DESC, EmployeeID;


-- Department-wise RANK.

SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    RANK() OVER
    (
        PARTITION BY DepartmentID
        ORDER BY Salary DESC
    ) AS DepartmentRank
FROM #Employees
ORDER BY DepartmentID, DepartmentRank;


-- =========================================================
-- SECTION 10: DENSE_RANK()
-- =========================================================

/*
DENSE_RANK() also assigns ranks based on ORDER BY.

Important points:

1. Equal values receive the same rank.
2. The next rank is not skipped.

Example:

Salary     DENSE_RANK
95000          1
95000          1
85000          2
75000          3
75000          3
70000          4

There are no gaps in ranking.
*/


SELECT
    EmployeeName,
    Salary,
    DENSE_RANK() OVER
    (
        ORDER BY Salary DESC
    ) AS SalaryRank
FROM #Employees
ORDER BY Salary DESC, EmployeeID;


-- Department-wise DENSE_RANK.

SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    DENSE_RANK() OVER
    (
        PARTITION BY DepartmentID
        ORDER BY Salary DESC
    ) AS DepartmentRank
FROM #Employees
ORDER BY DepartmentID, DepartmentRank;


-- =========================================================
-- SECTION 11: COMPARISON OF ROW_NUMBER, RANK AND DENSE_RANK
-- =========================================================

/*
Suppose the salaries are:

95000
95000
85000
75000
75000
70000

Result:

Salary   ROW_NUMBER   RANK   DENSE_RANK
95000       1          1        1
95000       2          1        1
85000       3          3        2
75000       4          4        3
75000       5          4        3
70000       6          6        4

ROW_NUMBER:
Always assigns a unique sequence number.

RANK:
Same rank for ties, but skips subsequent rank numbers.

DENSE_RANK:
Same rank for ties, without skipping rank numbers.
*/


SELECT
    EmployeeName,
    Salary,
    ROW_NUMBER() OVER
    (
        ORDER BY Salary DESC, EmployeeID
    ) AS RowNumber,
    RANK() OVER
    (
        ORDER BY Salary DESC
    ) AS RankNumber,
    DENSE_RANK() OVER
    (
        ORDER BY Salary DESC
    ) AS DenseRankNumber
FROM #Employees
ORDER BY Salary DESC, EmployeeID;


-- =========================================================
-- SECTION 12: FIND THE HIGHEST SALARY
-- =========================================================

-- Highest salary in the company.

SELECT MAX(Salary) AS HighestSalary
FROM #Employees;


-- Display all employees having the highest salary.

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


-- =========================================================
-- SECTION 13: FIND SECOND-HIGHEST DISTINCT SALARY
-- =========================================================

/*
DENSE_RANK is useful for finding the Nth-highest
DISTINCT salary.

Why?

Because tied salaries receive the same rank,
and the next distinct salary gets the next rank.
*/


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
WHERE SalaryRank = 2;


-- =========================================================
-- SECTION 14: FIND NTH-HIGHEST DISTINCT SALARY
-- =========================================================

-- Example: Third-highest distinct salary.

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
WHERE SalaryRank = 3;


-- Example: Fourth-highest distinct salary.

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
WHERE SalaryRank = 4;


-- =========================================================
-- SECTION 15: FIND HIGHEST SALARY IN EACH DEPARTMENT
-- =========================================================

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
)
SELECT *
FROM DepartmentRanking
WHERE SalaryRank = 1;


-- =========================================================
-- SECTION 16: FIND SECOND-HIGHEST SALARY IN EACH DEPARTMENT
-- =========================================================

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
)
SELECT *
FROM DepartmentRanking
WHERE SalaryRank = 2;


-- =========================================================
-- SECTION 17: FIND TOP 2 EMPLOYEES IN EACH DEPARTMENT
-- =========================================================

/*
ROW_NUMBER:
Returns at most two rows per department.

RANK:
May return more than two rows because of ties
and skipped rank values.

DENSE_RANK:
Returns employees having the top two distinct
salary ranks in each department.
*/


WITH EmployeeRanking AS
(
    SELECT
        *,
        ROW_NUMBER() OVER
        (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC, EmployeeID
        ) AS RowNumber
    FROM #Employees
)
SELECT *
FROM EmployeeRanking
WHERE RowNumber <= 2;


-- =========================================================
-- SECTION 18: PRACTICAL USE OF WINDOW FUNCTIONS
-- =========================================================

-- Compare employee salary with company average.

SELECT
    EmployeeName,
    Salary,
    AVG(Salary) OVER() AS CompanyAverage,
    Salary - AVG(Salary) OVER() AS DifferenceFromAverage
FROM #Employees;


-- Compare employee salary with department average.

SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    AVG(Salary) OVER
    (
        PARTITION BY DepartmentID
    ) AS DepartmentAverage
FROM #Employees;


-- Calculate each employee's percentage of company salary.

SELECT
    EmployeeName,
    Salary,
    SUM(Salary) OVER() AS TotalSalary,
    CAST
    (
        Salary * 100.0 / SUM(Salary) OVER()
        AS DECIMAL(10,2)
    ) AS SalaryPercentage
FROM #Employees;


-- Calculate department-wise percentage contribution.

SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    SUM(Salary) OVER
    (
        PARTITION BY DepartmentID
    ) AS DepartmentTotalSalary,
    CAST
    (
        Salary * 100.0 /
        SUM(Salary) OVER(PARTITION BY DepartmentID)
        AS DECIMAL(10,2)
    ) AS DepartmentSalaryPercentage
FROM #Employees;


-- =========================================================
-- SECTION 19: PRACTICE QUESTIONS
-- =========================================================

/*
Q1. Display every employee with company average salary.

Q2. Display every employee with department average salary.

Q3. Find the highest salary in the company using a window
    function.

Q4. Find the minimum salary in each department.

Q5. Count employees in each department using a window
    function.

Q6. Calculate total salary for each department.

Q7. Assign ROW_NUMBER based on salary descending.

Q8. Assign RANK based on salary descending.

Q9. Assign DENSE_RANK based on salary descending.

Q10. Assign ROW_NUMBER separately for every department.

Q11. Find the highest-paid employee in each department.

Q12. Find the second-highest distinct salary in the company.

Q13. Find the third-highest distinct salary in the company.

Q14. Find the second-highest distinct salary in each department.

Q15. Find the top two employees in each department.

Q16. Find all employees having the highest salary.

Q17. Find employees earning above the company average.

Q18. Find employees earning above their department average.

Q19. Calculate salary percentage contribution
     of each employee to company salary.

Q20. Calculate salary percentage contribution
     within each department.

Q21. Find employees having the same salary rank.

Q22. Assign rankings based on salary and EmployeeID.

Q23. Find the employee with the lowest salary in each
     department.

Q24. Find departments where the highest salary is
     greater than 80000.

Q25. Display employee name, salary, department average
     and difference from department average.


-- =========================================================
-- SECTION 20: SOLUTIONS
-- ========================================================= */


-- Q1. Company average salary

SELECT
    EmployeeName,
    Salary,
    AVG(Salary) OVER() AS CompanyAverage
FROM #Employees;


-- Q2. Department average salary

SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    AVG(Salary) OVER
    (
        PARTITION BY DepartmentID
    ) AS DepartmentAverage
FROM #Employees;


-- Q3. Highest salary using a window function

SELECT
    EmployeeName,
    Salary,
    MAX(Salary) OVER() AS HighestSalary
FROM #Employees;


-- Q4. Minimum salary in each department

SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    MIN(Salary) OVER
    (
        PARTITION BY DepartmentID
    ) AS MinimumSalary
FROM #Employees;


-- Q5. Employee count in each department

SELECT
    EmployeeName,
    DepartmentID,
    COUNT(*) OVER
    (
        PARTITION BY DepartmentID
    ) AS EmployeeCount
FROM #Employees;


-- Q6. Total salary in each department

SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    SUM(Salary) OVER
    (
        PARTITION BY DepartmentID
    ) AS DepartmentTotalSalary
FROM #Employees;


-- Q7. ROW_NUMBER based on salary descending

SELECT
    EmployeeName,
    Salary,
    ROW_NUMBER() OVER
    (
        ORDER BY Salary DESC, EmployeeID
    ) AS RowNumber
FROM #Employees;


-- Q8. RANK based on salary descending

SELECT
    EmployeeName,
    Salary,
    RANK() OVER
    (
        ORDER BY Salary DESC
    ) AS SalaryRank
FROM #Employees;


-- Q9. DENSE_RANK based on salary descending

SELECT
    EmployeeName,
    Salary,
    DENSE_RANK() OVER
    (
        ORDER BY Salary DESC
    ) AS SalaryRank
FROM #Employees;


-- Q10. ROW_NUMBER department-wise

SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    ROW_NUMBER() OVER
    (
        PARTITION BY DepartmentID
        ORDER BY Salary DESC, EmployeeID
    ) AS DepartmentRowNumber
FROM #Employees;


-- Q11. Highest-paid employee in each department

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
)
SELECT *
FROM EmployeeRanking
WHERE SalaryRank = 1;


-- Q12. Second-highest distinct salary

WITH SalaryRanking AS
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
FROM SalaryRanking
WHERE SalaryRank = 2;


-- Q13. Third-highest distinct salary

WITH SalaryRanking AS
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
FROM SalaryRanking
WHERE SalaryRank = 3;


-- Q14. Second-highest distinct salary in each department

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
)
SELECT *
FROM DepartmentRanking
WHERE SalaryRank = 2;


-- Q15. Top two employees in each department

WITH EmployeeRanking AS
(
    SELECT
        *,
        ROW_NUMBER() OVER
        (
            PARTITION BY DepartmentID
            ORDER BY Salary DESC, EmployeeID
        ) AS RowNumber
    FROM #Employees
)
SELECT *
FROM EmployeeRanking
WHERE RowNumber <= 2;


-- Q16. Employees having the highest salary

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


-- Q17. Employees earning above company average

WITH EmployeeAverage AS
(
    SELECT
        *,
        AVG(Salary) OVER() AS CompanyAverage
    FROM #Employees
)
SELECT *
FROM EmployeeAverage
WHERE Salary > CompanyAverage;


-- Q18. Employees earning above department average

WITH DepartmentAverage AS
(
    SELECT
        *,
        AVG(Salary) OVER
        (
            PARTITION BY DepartmentID
        ) AS DepartmentAverage
    FROM #Employees
)
SELECT *
FROM DepartmentAverage
WHERE Salary > DepartmentAverage;


-- Q19. Employee percentage of company salary

SELECT
    EmployeeName,
    Salary,
    CAST
    (
        Salary * 100.0 / SUM(Salary) OVER()
        AS DECIMAL(10,2)
    ) AS SalaryPercentage
FROM #Employees;


-- Q20. Employee percentage within department

SELECT
    EmployeeName,
    DepartmentID,
    Salary,
    CAST
    (
        Salary * 100.0 /
        SUM(Salary) OVER(PARTITION BY DepartmentID)
        AS DECIMAL(10,2)
    ) AS DepartmentPercentage
FROM #Employees;


-- Q21. Employees having the same salary rank

WITH SalaryRanking AS
(
    SELECT
        *,
        RANK() OVER
        (
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM #Employees
)
SELECT *
FROM SalaryRanking
WHERE SalaryRank IN
(
    SELECT SalaryRank
    FROM SalaryRanking
    GROUP BY SalaryRank
    HAVING COUNT(*) > 1
);


-- Q22. Ranking based on salary and EmployeeID

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    ROW_NUMBER() OVER
    (
        ORDER BY Salary DESC, EmployeeID ASC
    ) AS RowNumber
FROM #Employees;


-- Q23. Lowest-paid employee in each department

WITH EmployeeRanking AS
(
    SELECT
        *,
        DENSE_RANK() OVER
        (
            PARTITION BY DepartmentID
            ORDER BY Salary ASC
        ) AS SalaryRank
    FROM #Employees
)
SELECT *
FROM EmployeeRanking
WHERE SalaryRank = 1;


-- Q24. Departments where maximum salary is above 80000

WITH DepartmentMaximum AS
(
    SELECT
        DepartmentID,
        MAX(Salary) OVER
        (
            PARTITION BY DepartmentID
        ) AS MaximumSalary
    FROM #Employees
)
SELECT DISTINCT
    DepartmentID,
    MaximumSalary
FROM DepartmentMaximum
WHERE MaximumSalary > 80000;


-- Q25. Salary and department average difference

SELECT
    EmployeeName,
    Salary,
    AVG(Salary) OVER
    (
        PARTITION BY DepartmentID
    ) AS DepartmentAverage,
    Salary - AVG(Salary) OVER
    (
        PARTITION BY DepartmentID
    ) AS DifferenceFromAverage
FROM #Employees;


-- =========================================================
-- SECTION 21: IMPORTANT INTERVIEW REVISION
-- =========================================================

/*
1. What is a window function?

   A function that calculates across a related set
   of rows while keeping individual rows in the result.


2. What is OVER()?

   It defines the window of rows used by a window function.


3. What is PARTITION BY?

   It divides rows into separate windows based on
   one or more columns.


4. Difference between GROUP BY and PARTITION BY?

   GROUP BY:
   - Combines rows into groups.
   - Usually returns one row per group.

   PARTITION BY:
   - Divides rows into windows.
   - Keeps individual rows in the result.


5. Difference between ROW_NUMBER, RANK and DENSE_RANK?

   ROW_NUMBER:
   - Unique number for every row.

   RANK:
   - Same rank for ties.
   - Skips the next rank numbers.

   DENSE_RANK:
   - Same rank for ties.
   - Does not skip rank numbers.


6. Which function is best for the Nth-highest
   DISTINCT salary?

   DENSE_RANK.


7. Which function is useful when we need exactly
   one row per group?

   ROW_NUMBER, with a suitable ORDER BY and
   a deterministic tie-breaker.


8. Can we use PARTITION BY with multiple columns?

   Yes.


9. Does ORDER BY inside OVER() sort the final output?

   No. It defines the logical ordering for the
   window calculation. Use the outer ORDER BY
   for the final result order.


10. Can aggregate functions be used as window functions?

    Yes, for example:
    SUM(Salary) OVER()
    AVG(Salary) OVER()
    COUNT(*) OVER()


11. Can we filter a window function directly
    in the WHERE clause of the same SELECT?

    No. Use a CTE or derived table to calculate
    the window function first, then filter outside.


12. Are tied rows guaranteed a particular
    ROW_NUMBER order?

    No, not unless the ORDER BY includes
    sufficient tie-breaking columns.


============================================================
END OF WINDOW FUNCTIONS BASICS
============================================================
*/