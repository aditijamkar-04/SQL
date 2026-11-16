/*
============================================================
SQL PRACTICE 02: ADVANCED WINDOW FUNCTIONS
============================================================

Topics:
1. Aggregate Window Functions
2. Running Total
3. Cumulative Sum
4. Running Average
5. Moving Average
6. ROWS and RANGE
7. UNBOUNDED PRECEDING
8. CURRENT ROW
9. LAG()
10. LEAD()
11. FIRST_VALUE()
12. LAST_VALUE()
13. NTILE()
14. Month-over-Month Analysis
15. Practical Exercises and Solutions

============================================================
*/


-- =========================================================
-- SECTION 1: CREATE SAMPLE TABLES
-- =========================================================

DROP TABLE IF EXISTS #Employees;
DROP TABLE IF EXISTS #Sales;


CREATE TABLE #Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    JoiningDate DATE
);


INSERT INTO #Employees
VALUES
(101, 'Rahul', 'IT', 95000, '2021-01-10'),
(102, 'Priya', 'IT', 75000, '2022-03-15'),
(103, 'Amit', 'IT', 75000, '2020-06-20'),
(104, 'Sneha', 'HR', 60000, '2021-07-12'),
(105, 'Neha', 'HR', 55000, '2023-02-10'),
(106, 'Karan', 'Finance', 85000, '2019-04-18'),
(107, 'Pooja', 'Finance', 70000, '2022-08-25'),
(108, 'Rohan', 'Sales', 50000, '2021-11-05'),
(109, 'Anjali', 'Sales', 50000, '2020-09-14'),
(110, 'Varun', 'IT', 95000, '2018-05-22'),
(111, 'Meera', 'HR', 60000, '2023-06-01'),
(112, 'Arjun', 'Finance', 80000, '2022-01-30');


CREATE TABLE #Sales
(
    SaleID INT PRIMARY KEY,
    SaleDate DATE,
    Product VARCHAR(50),
    Category VARCHAR(50),
    Region VARCHAR(50),
    SalesAmount DECIMAL(12,2)
);


INSERT INTO #Sales
VALUES
(1, '2026-01-01', 'Laptop', 'Electronics', 'North', 50000),
(2, '2026-01-02', 'Mobile', 'Electronics', 'South', 30000),
(3, '2026-01-03', 'Chair', 'Furniture', 'North', 10000),
(4, '2026-01-04', 'Table', 'Furniture', 'West', 15000),
(5, '2026-01-05', 'Laptop', 'Electronics', 'South', 60000),
(6, '2026-01-06', 'Mobile', 'Electronics', 'North', 35000),
(7, '2026-01-07', 'Chair', 'Furniture', 'West', 12000),
(8, '2026-01-08', 'Table', 'Furniture', 'South', 18000),
(9, '2026-01-09', 'Laptop', 'Electronics', 'North', 55000),
(10, '2026-01-10', 'Mobile', 'Electronics', 'West', 40000),
(11, '2026-01-11', 'Chair', 'Furniture', 'South', 11000),
(12, '2026-01-12', 'Table', 'Furniture', 'North', 20000),
(13, '2026-02-01', 'Laptop', 'Electronics', 'North', 65000),
(14, '2026-02-02', 'Mobile', 'Electronics', 'South', 45000),
(15, '2026-02-03', 'Chair', 'Furniture', 'West', 14000),
(16, '2026-02-04', 'Table', 'Furniture', 'South', 22000),
(17, '2026-02-05', 'Laptop', 'Electronics', 'West', 70000),
(18, '2026-02-06', 'Mobile', 'Electronics', 'North', 42000),
(19, '2026-02-07', 'Chair', 'Furniture', 'North', 13000),
(20, '2026-02-08', 'Table', 'Furniture', 'West', 25000),
(21, '2026-02-09', 'Laptop', 'Electronics', 'South', 62000),
(22, '2026-02-10', 'Mobile', 'Electronics', 'West', 48000),
(23, '2026-02-11', 'Chair', 'Furniture', 'South', 16000),
(24, '2026-02-12', 'Table', 'Furniture', 'North', 24000);


SELECT * FROM #Employees;
SELECT * FROM #Sales;


-- =========================================================
-- SECTION 2: AGGREGATE WINDOW FUNCTIONS
-- =========================================================

/*
Aggregate functions calculate a summary.

When used with OVER(), they become window calculations
and retain individual rows.

Common functions:

SUM()
AVG()
COUNT()
MIN()
MAX()
*/


-- 1. Company-wide total salary.

SELECT
    EmployeeName,
    Salary,
    SUM(Salary) OVER() AS CompanyTotalSalary
FROM #Employees;


-- 2. Department-wise total salary.

SELECT
    EmployeeName,
    Department,
    Salary,
    SUM(Salary) OVER
    (
        PARTITION BY Department
    ) AS DepartmentTotalSalary
FROM #Employees;


-- 3. Department-wise average salary.

SELECT
    EmployeeName,
    Department,
    Salary,
    AVG(Salary) OVER
    (
        PARTITION BY Department
    ) AS DepartmentAverage
FROM #Employees;


-- 4. Department-wise employee count.

SELECT
    EmployeeName,
    Department,
    COUNT(*) OVER
    (
        PARTITION BY Department
    ) AS DepartmentEmployeeCount
FROM #Employees;


-- 5. Department-wise minimum and maximum salary.

SELECT
    EmployeeName,
    Department,
    Salary,
    MIN(Salary) OVER
    (
        PARTITION BY Department
    ) AS MinimumSalary,
    MAX(Salary) OVER
    (
        PARTITION BY Department
    ) AS MaximumSalary
FROM #Employees;


-- =========================================================
-- SECTION 3: RUNNING TOTAL / CUMULATIVE SUM
-- =========================================================

/*
A running total is the cumulative sum of values
up to the current row.

Example:

SaleDate       SalesAmount    RunningTotal
2026-01-01       50000           50000
2026-01-02       30000           80000
2026-01-03       10000           90000
2026-01-04       15000          105000

WHY USE IT?

1. Track cumulative sales.
2. Monitor revenue growth.
3. Calculate cumulative expenses.
4. Track account balances.
5. Monitor cumulative customer activity.

GENERAL SYNTAX:

SUM(Value) OVER
(
    ORDER BY DateColumn
    ROWS BETWEEN UNBOUNDED PRECEDING
    AND CURRENT ROW
);
*/


-- Running total of sales.

SELECT
    SaleDate,
    SalesAmount,
    SUM(SalesAmount) OVER
    (
        ORDER BY SaleDate, SaleID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS RunningTotal
FROM #Sales
ORDER BY SaleDate, SaleID;


-- Running total of employee salaries ordered by EmployeeID.

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    SUM(Salary) OVER
    (
        ORDER BY EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS RunningSalaryTotal
FROM #Employees
ORDER BY EmployeeID;


-- =========================================================
-- SECTION 4: DEPARTMENT-WISE RUNNING TOTAL
-- =========================================================

/*
PARTITION BY creates an independent running total
for each department.

When a new department starts, the running total resets.
*/


SELECT
    EmployeeName,
    Department,
    Salary,
    SUM(Salary) OVER
    (
        PARTITION BY Department
        ORDER BY EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS DepartmentRunningTotal
FROM #Employees
ORDER BY Department, EmployeeID;


-- Region-wise running sales total.

SELECT
    SaleDate,
    Region,
    SalesAmount,
    SUM(SalesAmount) OVER
    (
        PARTITION BY Region
        ORDER BY SaleDate, SaleID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS RegionRunningTotal
FROM #Sales
ORDER BY Region, SaleDate, SaleID;


-- =========================================================
-- SECTION 5: RUNNING AVERAGE
-- =========================================================

/*
A running average calculates the average of all values
from the beginning of the window up to the current row.

Example:

Values: 10, 20, 30, 40

Running average:
10
15
20
25
*/


SELECT
    SaleDate,
    SalesAmount,
    AVG(SalesAmount) OVER
    (
        ORDER BY SaleDate, SaleID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS RunningAverage
FROM #Sales
ORDER BY SaleDate, SaleID;


-- Department-wise running average salary.

SELECT
    EmployeeName,
    Department,
    Salary,
    AVG(Salary) OVER
    (
        PARTITION BY Department
        ORDER BY EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS DepartmentRunningAverage
FROM #Employees
ORDER BY Department, EmployeeID;


-- =========================================================
-- SECTION 6: MOVING AVERAGE
-- =========================================================

/*
A moving average calculates the average over
a fixed-size window of rows.

Example:

For a three-row moving average:

Row 1: Average of row 1
Row 2: Average of rows 1 and 2
Row 3: Average of rows 1, 2 and 3
Row 4: Average of rows 2, 3 and 4

WHY USE IT?

1. Smooth daily sales fluctuations.
2. Analyse trends.
3. Reduce short-term noise.
4. Understand business performance.

NOTE:
A three-row moving average means three rows,
not necessarily three calendar days.
*/


-- Three-row moving average of sales.

SELECT
    SaleDate,
    SalesAmount,
    AVG(SalesAmount) OVER
    (
        ORDER BY SaleDate, SaleID
        ROWS BETWEEN 2 PRECEDING
        AND CURRENT ROW
    ) AS MovingAverage3Rows
FROM #Sales
ORDER BY SaleDate, SaleID;


-- Two-row moving average of employee salaries.

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    AVG(Salary) OVER
    (
        ORDER BY EmployeeID
        ROWS BETWEEN 1 PRECEDING
        AND CURRENT ROW
    ) AS MovingAverage2Rows
FROM #Employees
ORDER BY EmployeeID;


-- =========================================================
-- SECTION 7: WINDOW FRAME
-- =========================================================

/*
A window frame specifies which rows around the
current row are included in a window calculation.

Common frame boundaries:

UNBOUNDED PRECEDING
    Starts at the first row of the partition.

n PRECEDING
    Includes n rows before the current row.

CURRENT ROW
    Refers to the current row.

n FOLLOWING
    Includes n rows after the current row.

UNBOUNDED FOLLOWING
    Ends at the last row of the partition.


GENERAL SYNTAX:

FUNCTION() OVER
(
    PARTITION BY column
    ORDER BY column
    ROWS BETWEEN start_boundary
    AND end_boundary
);
*/


-- Example 1:
-- From the first row up to the current row.

SELECT
    EmployeeID,
    Salary,
    SUM(Salary) OVER
    (
        ORDER BY EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS RunningTotal
FROM #Employees;


-- Example 2:
-- Previous row and current row.

SELECT
    EmployeeID,
    Salary,
    SUM(Salary) OVER
    (
        ORDER BY EmployeeID
        ROWS BETWEEN 1 PRECEDING
        AND CURRENT ROW
    ) AS CurrentAndPreviousTotal
FROM #Employees;


-- Example 3:
-- Current row and next row.

SELECT
    EmployeeID,
    Salary,
    SUM(Salary) OVER
    (
        ORDER BY EmployeeID
        ROWS BETWEEN CURRENT ROW
        AND 1 FOLLOWING
    ) AS CurrentAndNextTotal
FROM #Employees;


-- Example 4:
-- Entire partition.

SELECT
    EmployeeID,
    Department,
    Salary,
    SUM(Salary) OVER
    (
        PARTITION BY Department
        ORDER BY EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS DepartmentTotal
FROM #Employees;


-- =========================================================
-- SECTION 8: ROWS VS RANGE
-- =========================================================

/*
ROWS:
Works with a physical number of rows relative
to the current row.

RANGE:
Works with logical ordering values and includes
peers that have the same ORDER BY value.

Example salaries:

95000
95000
85000
75000

With:

ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

The calculation advances one physical row at a time.

With:

RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

Rows tied on the ORDER BY value are included
in the same frame.

IMPORTANT:
If ORDER BY has duplicate values, ROWS and RANGE
can produce different results.

Use ROWS when you specifically want a row-by-row
running calculation.
*/


-- ROWS example with duplicate salaries.

SELECT
    EmployeeName,
    Salary,
    SUM(Salary) OVER
    (
        ORDER BY Salary DESC, EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS RowsRunningTotal
FROM #Employees
ORDER BY Salary DESC, EmployeeID;


-- RANGE example.
-- EmployeeID is intentionally not included in
-- the window ORDER BY, so tied salaries are peers.

SELECT
    EmployeeName,
    Salary,
    SUM(Salary) OVER
    (
        ORDER BY Salary DESC
        RANGE BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS RangeRunningTotal
FROM #Employees
ORDER BY Salary DESC, EmployeeID;


-- =========================================================
-- SECTION 9: LAG()
-- =========================================================

/*
LAG() retrieves a value from a previous row
without joining the table to itself.

Syntax:

LAG(column, offset, default_value)
OVER
(
    ORDER BY column
);

Parameters:

column:
The value to retrieve.

offset:
How many rows backward to look.
Default = 1.

default_value:
Value returned if no previous row exists.
Default = NULL.

WHY USE LAG?

1. Compare current sales with previous sales.
2. Compare current salary with previous salary.
3. Calculate month-over-month changes.
4. Analyse historical records.
*/


-- Retrieve previous employee salary.

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    LAG(Salary) OVER
    (
        ORDER BY EmployeeID
    ) AS PreviousSalary
FROM #Employees
ORDER BY EmployeeID;


-- Compare current salary with previous employee salary.

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    LAG(Salary) OVER
    (
        ORDER BY EmployeeID
    ) AS PreviousSalary,
    Salary - LAG(Salary) OVER
    (
        ORDER BY EmployeeID
    ) AS SalaryDifference
FROM #Employees
ORDER BY EmployeeID;


-- Retrieve the salary from two rows earlier.

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    LAG(Salary, 2) OVER
    (
        ORDER BY EmployeeID
    ) AS SalaryTwoRowsEarlier
FROM #Employees
ORDER BY EmployeeID;


-- Use a default value instead of NULL.

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    LAG(Salary, 1, 0) OVER
    (
        ORDER BY EmployeeID
    ) AS PreviousSalary
FROM #Employees
ORDER BY EmployeeID;


-- Department-wise previous salary.

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    LAG(Salary) OVER
    (
        PARTITION BY Department
        ORDER BY EmployeeID
    ) AS PreviousDepartmentSalary
FROM #Employees
ORDER BY Department, EmployeeID;


-- =========================================================
-- SECTION 10: LEAD()
-- =========================================================

/*
LEAD() retrieves a value from a future row.

LAG:
Looks backward.

LEAD:
Looks forward.

Syntax:

LEAD(column, offset, default_value)
OVER
(
    ORDER BY column
);
*/


-- Retrieve the next employee salary.

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    LEAD(Salary) OVER
    (
        ORDER BY EmployeeID
    ) AS NextSalary
FROM #Employees
ORDER BY EmployeeID;


-- Compare current and next salary.

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    LEAD(Salary) OVER
    (
        ORDER BY EmployeeID
    ) AS NextSalary,
    LEAD(Salary) OVER
    (
        ORDER BY EmployeeID
    ) - Salary AS DifferenceWithNext
FROM #Employees
ORDER BY EmployeeID;


-- Retrieve salary two rows ahead.

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    LEAD(Salary, 2) OVER
    (
        ORDER BY EmployeeID
    ) AS SalaryTwoRowsAhead
FROM #Employees
ORDER BY EmployeeID;


-- Department-wise next salary.

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    LEAD(Salary) OVER
    (
        PARTITION BY Department
        ORDER BY EmployeeID
    ) AS NextDepartmentSalary
FROM #Employees
ORDER BY Department, EmployeeID;


-- =========================================================
-- SECTION 11: LAG() VS LEAD()
-- =========================================================

/*
LAG:
Previous row.

LEAD:
Next row.

Example:

EmployeeID   Salary
101          95000
102          75000
103          75000

LAG for employee 102:
95000

LEAD for employee 102:
75000
*/


SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    LAG(Salary) OVER
    (
        ORDER BY EmployeeID
    ) AS PreviousSalary,
    LEAD(Salary) OVER
    (
        ORDER BY EmployeeID
    ) AS NextSalary
FROM #Employees
ORDER BY EmployeeID;


-- =========================================================
-- SECTION 12: FIRST_VALUE()
-- =========================================================

/*
FIRST_VALUE() returns the first value in the
specified window frame.

It is useful for:
1. Finding the highest salary in a department.
2. Finding the earliest transaction.
3. Comparing records with the first record.
*/


-- Highest salary in each department.

SELECT
    EmployeeName,
    Department,
    Salary,
    FIRST_VALUE(Salary) OVER
    (
        PARTITION BY Department
        ORDER BY Salary DESC, EmployeeID
    ) AS HighestDepartmentSalary
FROM #Employees
ORDER BY Department, Salary DESC, EmployeeID;


-- Earliest joining date in each department.

SELECT
    EmployeeName,
    Department,
    JoiningDate,
    FIRST_VALUE(JoiningDate) OVER
    (
        PARTITION BY Department
        ORDER BY JoiningDate ASC, EmployeeID
    ) AS EarliestJoiningDate
FROM #Employees
ORDER BY Department, JoiningDate;


-- =========================================================
-- SECTION 13: LAST_VALUE()
-- =========================================================

/*
LAST_VALUE() returns the last value in the current
window frame.

IMPORTANT:

With ORDER BY, the default frame generally ends
at the current row and its peers.

Therefore, LAST_VALUE() may return the current
row's value instead of the final value in the
entire partition.

To get the final value in the entire partition,
explicitly use:

ROWS BETWEEN UNBOUNDED PRECEDING
AND UNBOUNDED FOLLOWING.
*/


-- Correct: Get the lowest salary in each department.

SELECT
    EmployeeName,
    Department,
    Salary,
    LAST_VALUE(Salary) OVER
    (
        PARTITION BY Department
        ORDER BY Salary ASC, EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS LowestDepartmentSalary
FROM #Employees
ORDER BY Department, Salary;


-- Get the latest joining date in each department.

SELECT
    EmployeeName,
    Department,
    JoiningDate,
    LAST_VALUE(JoiningDate) OVER
    (
        PARTITION BY Department
        ORDER BY JoiningDate ASC, EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS LatestJoiningDate
FROM #Employees
ORDER BY Department, JoiningDate;


-- =========================================================
-- SECTION 14: NTILE()
-- =========================================================

/*
NTILE(n) divides ordered rows into n approximately
equal groups called buckets.

Example:

NTILE(4)

Divides rows into four groups.

Common uses:
1. Customer segmentation.
2. Salary distribution.
3. Performance grouping.
4. Sales quartiles.
5. Dividing records into equal-sized groups.

IMPORTANT:
NTILE distributes rows, not necessarily distinct values.
Rows with tied values can be assigned to different buckets.
*/


-- Divide employees into four salary groups.

SELECT
    EmployeeName,
    Salary,
    NTILE(4) OVER
    (
        ORDER BY Salary DESC, EmployeeID
    ) AS SalaryQuartile
FROM #Employees;


-- Divide employees into three salary groups.

SELECT
    EmployeeName,
    Salary,
    NTILE(3) OVER
    (
        ORDER BY Salary DESC, EmployeeID
    ) AS SalaryGroup
FROM #Employees;


-- Department-wise salary groups.

SELECT
    EmployeeName,
    Department,
    Salary,
    NTILE(2) OVER
    (
        PARTITION BY Department
        ORDER BY Salary DESC, EmployeeID
    ) AS DepartmentSalaryGroup
FROM #Employees;


-- =========================================================
-- SECTION 15: MONTH-OVER-MONTH SALES ANALYSIS
-- =========================================================

/*
Month-over-month analysis compares a month's
performance with the previous month.

Typical calculations:

Difference:
CurrentMonthSales - PreviousMonthSales

Percentage Growth:
(
    CurrentMonthSales - PreviousMonthSales
) * 100.0 / PreviousMonthSales

LAG() is useful for retrieving the previous month.
*/


-- Step 1: Calculate monthly sales.

WITH MonthlySales AS
(
    SELECT
        YEAR(SaleDate) AS SalesYear,
        MONTH(SaleDate) AS SalesMonth,
        SUM(SalesAmount) AS TotalSales
    FROM #Sales
    GROUP BY
        YEAR(SaleDate),
        MONTH(SaleDate)
),
PreviousMonthSales AS
(
    SELECT
        SalesYear,
        SalesMonth,
        TotalSales,
        LAG(TotalSales) OVER
        (
            ORDER BY SalesYear, SalesMonth
        ) AS PreviousMonthTotal
    FROM MonthlySales
)
SELECT
    SalesYear,
    SalesMonth,
    TotalSales,
    PreviousMonthTotal,
    TotalSales - PreviousMonthTotal AS SalesDifference,
    CAST
    (
        (TotalSales - PreviousMonthTotal) * 100.0
        / NULLIF(PreviousMonthTotal, 0)
        AS DECIMAL(10,2)
    ) AS GrowthPercentage
FROM PreviousMonthSales
ORDER BY SalesYear, SalesMonth;


-- =========================================================
-- SECTION 16: PRODUCT-WISE RUNNING SALES
-- =========================================================

SELECT
    SaleDate,
    Product,
    SalesAmount,
    SUM(SalesAmount) OVER
    (
        PARTITION BY Product
        ORDER BY SaleDate, SaleID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS ProductRunningSales
FROM #Sales
ORDER BY Product, SaleDate, SaleID;


-- =========================================================
-- SECTION 17: COMPARE SALES WITH PREVIOUS SALES
-- =========================================================

SELECT
    SaleDate,
    SalesAmount,
    LAG(SalesAmount) OVER
    (
        ORDER BY SaleDate, SaleID
    ) AS PreviousSale,
    SalesAmount - LAG(SalesAmount) OVER
    (
        ORDER BY SaleDate, SaleID
    ) AS SalesDifference
FROM #Sales
ORDER BY SaleDate, SaleID;


-- =========================================================
-- SECTION 18: PRACTICE QUESTIONS
-- =========================================================

/*
Q1. Calculate company-wide total salary.

Q2. Calculate department-wise total salary.

Q3. Calculate department-wise average salary.

Q4. Calculate company-wide employee count.

Q5. Calculate department-wise employee count.

Q6. Calculate a running total of salaries ordered
    by EmployeeID.

Q7. Calculate department-wise running salary totals.

Q8. Calculate a running average of sales.

Q9. Calculate a three-row moving average of sales.

Q10. Calculate the total salary of the current row
     and previous row.

Q11. Calculate the total salary of the current row
     and next row.

Q12. Retrieve the previous employee's salary using LAG().

Q13. Retrieve the next employee's salary using LEAD().

Q14. Compare current salary with previous salary.

Q15. Retrieve salary from two rows earlier.

Q16. Retrieve the highest salary in each department
     using FIRST_VALUE().

Q17. Retrieve the lowest salary in each department
     using LAST_VALUE().

Q18. Divide employees into four salary groups using NTILE().

Q19. Divide employees into two salary groups
     separately by department.

Q20. Calculate monthly sales totals.

Q21. Compare each month's sales with the previous month.

Q22. Calculate month-over-month sales growth percentage.

Q23. Calculate product-wise running sales.

Q24. Calculate region-wise running sales.

Q25. Compare employee salary with department average
     and show the difference.

Q26. Retrieve the latest joining date in each department.

Q27. Find employees whose salary increased compared
     with the previous EmployeeID.

Q28. Find employees whose salary is greater than
     the next employee's salary.

Q29. Calculate the running total of sales separately
     for every product.

Q30. Find the highest monthly sales using a window function.


-- =========================================================
-- SECTION 19: SOLUTIONS
-- ========================================================= */


-- Q1. Company-wide total salary

SELECT
    EmployeeName,
    Salary,
    SUM(Salary) OVER() AS CompanyTotalSalary
FROM #Employees;


-- Q2. Department-wise total salary

SELECT
    EmployeeName,
    Department,
    Salary,
    SUM(Salary) OVER
    (
        PARTITION BY Department
    ) AS DepartmentTotalSalary
FROM #Employees;


-- Q3. Department-wise average salary

SELECT
    EmployeeName,
    Department,
    AVG(Salary) OVER
    (
        PARTITION BY Department
    ) AS DepartmentAverage
FROM #Employees;


-- Q4. Company-wide employee count

SELECT
    EmployeeName,
    COUNT(*) OVER() AS TotalEmployees
FROM #Employees;


-- Q5. Department-wise employee count

SELECT
    EmployeeName,
    Department,
    COUNT(*) OVER
    (
        PARTITION BY Department
    ) AS DepartmentEmployeeCount
FROM #Employees;


-- Q6. Running total of salaries

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    SUM(Salary) OVER
    (
        ORDER BY EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS RunningTotal
FROM #Employees;


-- Q7. Department-wise running total

SELECT
    EmployeeName,
    Department,
    Salary,
    SUM(Salary) OVER
    (
        PARTITION BY Department
        ORDER BY EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS DepartmentRunningTotal
FROM #Employees;


-- Q8. Running average of sales

SELECT
    SaleDate,
    SalesAmount,
    AVG(SalesAmount) OVER
    (
        ORDER BY SaleDate, SaleID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS RunningAverage
FROM #Sales;


-- Q9. Three-row moving average

SELECT
    SaleDate,
    SalesAmount,
    AVG(SalesAmount) OVER
    (
        ORDER BY SaleDate, SaleID
        ROWS BETWEEN 2 PRECEDING
        AND CURRENT ROW
    ) AS MovingAverage
FROM #Sales;


-- Q10. Current row and previous row total

SELECT
    EmployeeID,
    Salary,
    SUM(Salary) OVER
    (
        ORDER BY EmployeeID
        ROWS BETWEEN 1 PRECEDING
        AND CURRENT ROW
    ) AS TwoRowTotal
FROM #Employees;


-- Q11. Current row and next row total

SELECT
    EmployeeID,
    Salary,
    SUM(Salary) OVER
    (
        ORDER BY EmployeeID
        ROWS BETWEEN CURRENT ROW
        AND 1 FOLLOWING
    ) AS TwoRowTotal
FROM #Employees;


-- Q12. Previous employee salary

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    LAG(Salary) OVER
    (
        ORDER BY EmployeeID
    ) AS PreviousSalary
FROM #Employees;


-- Q13. Next employee salary

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    LEAD(Salary) OVER
    (
        ORDER BY EmployeeID
    ) AS NextSalary
FROM #Employees;


-- Q14. Current salary vs previous salary

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    LAG(Salary) OVER
    (
        ORDER BY EmployeeID
    ) AS PreviousSalary,
    Salary - LAG(Salary) OVER
    (
        ORDER BY EmployeeID
    ) AS SalaryDifference
FROM #Employees;


-- Q15. Salary from two rows earlier

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    LAG(Salary, 2) OVER
    (
        ORDER BY EmployeeID
    ) AS SalaryTwoRowsEarlier
FROM #Employees;


-- Q16. Highest salary in each department

SELECT
    EmployeeName,
    Department,
    Salary,
    FIRST_VALUE(Salary) OVER
    (
        PARTITION BY Department
        ORDER BY Salary DESC, EmployeeID
    ) AS HighestDepartmentSalary
FROM #Employees;


-- Q17. Lowest salary in each department

SELECT
    EmployeeName,
    Department,
    Salary,
    LAST_VALUE(Salary) OVER
    (
        PARTITION BY Department
        ORDER BY Salary ASC, EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS LowestDepartmentSalary
FROM #Employees;


-- Q18. Four salary groups

SELECT
    EmployeeName,
    Salary,
    NTILE(4) OVER
    (
        ORDER BY Salary DESC, EmployeeID
    ) AS SalaryGroup
FROM #Employees;


-- Q19. Two salary groups per department

SELECT
    EmployeeName,
    Department,
    Salary,
    NTILE(2) OVER
    (
        PARTITION BY Department
        ORDER BY Salary DESC, EmployeeID
    ) AS SalaryGroup
FROM #Employees;


-- Q20. Monthly sales totals

WITH MonthlySales AS
(
    SELECT
        YEAR(SaleDate) AS SalesYear,
        MONTH(SaleDate) AS SalesMonth,
        SUM(SalesAmount) AS TotalSales
    FROM #Sales
    GROUP BY
        YEAR(SaleDate),
        MONTH(SaleDate)
)
SELECT *
FROM MonthlySales
ORDER BY SalesYear, SalesMonth;


-- Q21. Compare each month with previous month

WITH MonthlySales AS
(
    SELECT
        YEAR(SaleDate) AS SalesYear,
        MONTH(SaleDate) AS SalesMonth,
        SUM(SalesAmount) AS TotalSales
    FROM #Sales
    GROUP BY
        YEAR(SaleDate),
        MONTH(SaleDate)
)
SELECT
    SalesYear,
    SalesMonth,
    TotalSales,
    LAG(TotalSales) OVER
    (
        ORDER BY SalesYear, SalesMonth
    ) AS PreviousMonthSales
FROM MonthlySales;


-- Q22. Month-over-month growth percentage

WITH MonthlySales AS
(
    SELECT
        YEAR(SaleDate) AS SalesYear,
        MONTH(SaleDate) AS SalesMonth,
        SUM(SalesAmount) AS TotalSales
    FROM #Sales
    GROUP BY
        YEAR(SaleDate),
        MONTH(SaleDate)
),
PreviousSales AS
(
    SELECT
        SalesYear,
        SalesMonth,
        TotalSales,
        LAG(TotalSales) OVER
        (
            ORDER BY SalesYear, SalesMonth
        ) AS PreviousMonthSales
    FROM MonthlySales
)
SELECT
    SalesYear,
    SalesMonth,
    TotalSales,
    PreviousMonthSales,
    CAST
    (
        (TotalSales - PreviousMonthSales) * 100.0
        / NULLIF(PreviousMonthSales, 0)
        AS DECIMAL(10,2)
    ) AS GrowthPercentage
FROM PreviousSales;


-- Q23. Product-wise running sales

SELECT
    SaleDate,
    Product,
    SalesAmount,
    SUM(SalesAmount) OVER
    (
        PARTITION BY Product
        ORDER BY SaleDate, SaleID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS ProductRunningSales
FROM #Sales;


-- Q24. Region-wise running sales

SELECT
    SaleDate,
    Region,
    SalesAmount,
    SUM(SalesAmount) OVER
    (
        PARTITION BY Region
        ORDER BY SaleDate, SaleID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS RegionRunningSales
FROM #Sales;


-- Q25. Salary difference from department average

SELECT
    EmployeeName,
    Department,
    Salary,
    AVG(Salary) OVER
    (
        PARTITION BY Department
    ) AS DepartmentAverage,
    Salary - AVG(Salary) OVER
    (
        PARTITION BY Department
    ) AS DifferenceFromAverage
FROM #Employees;


-- Q26. Latest joining date in each department

SELECT
    EmployeeName,
    Department,
    JoiningDate,
    LAST_VALUE(JoiningDate) OVER
    (
        PARTITION BY Department
        ORDER BY JoiningDate, EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS LatestJoiningDate
FROM #Employees;


-- Q27. Employees whose salary is greater than
--      the previous EmployeeID's salary

WITH SalaryComparison AS
(
    SELECT
        *,
        LAG(Salary) OVER
        (
            ORDER BY EmployeeID
        ) AS PreviousSalary
    FROM #Employees
)
SELECT *
FROM SalaryComparison
WHERE Salary > PreviousSalary;


-- Q28. Employees whose salary is greater than
--      the next EmployeeID's salary

WITH SalaryComparison AS
(
    SELECT
        *,
        LEAD(Salary) OVER
        (
            ORDER BY EmployeeID
        ) AS NextSalary
    FROM #Employees
)
SELECT *
FROM SalaryComparison
WHERE Salary > NextSalary;


-- Q29. Product-wise running total

SELECT
    Product,
    SaleDate,
    SalesAmount,
    SUM(SalesAmount) OVER
    (
        PARTITION BY Product
        ORDER BY SaleDate, SaleID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS RunningTotal
FROM #Sales
ORDER BY Product, SaleDate, SaleID;


-- Q30. Highest monthly sales

WITH MonthlySales AS
(
    SELECT
        YEAR(SaleDate) AS SalesYear,
        MONTH(SaleDate) AS SalesMonth,
        SUM(SalesAmount) AS TotalSales
    FROM #Sales
    GROUP BY
        YEAR(SaleDate),
        MONTH(SaleDate)
),
MonthlyRanking AS
(
    SELECT
        *,
        DENSE_RANK() OVER
        (
            ORDER BY TotalSales DESC
        ) AS SalesRank
    FROM MonthlySales
)
SELECT *
FROM MonthlyRanking
WHERE SalesRank = 1;


-- =========================================================
-- SECTION 20: IMPORTANT INTERVIEW REVISION
-- =========================================================

/*
1. What is a running total?

   A cumulative sum from the beginning of a window
   up to the current row.


2. What is a moving average?

   An average calculated over a fixed-size window
   of rows.


3. What is LAG()?

   Returns a value from a previous row.


4. What is LEAD()?

   Returns a value from a future row.


5. Difference between LAG() and LEAD()?

   LAG looks backward.
   LEAD looks forward.


6. What is FIRST_VALUE()?

   Returns the first value in the current window frame.


7. What is LAST_VALUE()?

   Returns the last value in the current window frame.


8. Why do we use UNBOUNDED FOLLOWING with LAST_VALUE()?

   To extend the frame to the final row of the partition.


9. What is NTILE()?

   Divides ordered rows into approximately equal
   numbered buckets.


10. What is ROWS?

    Defines a frame using physical row positions.


11. What is RANGE?

    Defines a frame using logical ORDER BY values
    and includes peer rows with equal ordering values.


12. What is UNBOUNDED PRECEDING?

    Starts the frame from the first row of the partition.


13. What is CURRENT ROW?

    Refers to the current row in the ordered window.


14. What is a common use of LAG() in business?

    Month-over-month sales comparisons.


15. What is a common use of NTILE()?

    Customer segmentation and salary grouping.


16. What is the difference between a running
    average and a moving average?

    Running average:
    Uses all rows from the start up to the current row.

    Moving average:
    Uses a fixed-size rolling group of rows.


IMPORTANT:
For reliable row-by-row calculations, include a
unique tie-breaker in the window ORDER BY whenever
the business logic requires a deterministic order.

============================================================
END OF ADVANCED WINDOW FUNCTIONS PRACTICE
============================================================
*/