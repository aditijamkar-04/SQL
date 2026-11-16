/*
============================================================
SQL PRACTICE 02: GROUP BY AND HAVING

Topics:
1. GROUP BY
2. GROUP BY with multiple columns
3. Aggregate functions with GROUP BY
4. HAVING clause
5. WHERE vs HAVING
6. GROUP BY with WHERE
7. GROUP BY with HAVING
8. Filtering multiple groups
9. Real-world business queries
10. Interview questions and solutions
============================================================
*/


-- =========================================================
-- SECTION 1: CREATE SAMPLE TABLE
-- =========================================================

DROP TABLE IF EXISTS #Employees;

CREATE TABLE #Employees
(
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    Gender VARCHAR(10),
    Salary DECIMAL(10,2),
    Bonus DECIMAL(10,2) NULL,
    Age INT
);


INSERT INTO #Employees
VALUES
(101, 'Rahul', 'IT', 'Male', 55000, 5000, 25),
(102, 'Priya', 'HR', 'Female', 45000, NULL, 24),
(103, 'Amit', 'IT', 'Male', 65000, 7000, 28),
(104, 'Sneha', 'Finance', 'Female', 60000, NULL, 26),
(105, 'Neha', 'HR', 'Female', 50000, 4000, 25),
(106, 'Karan', 'Marketing', 'Male', 75000, 8000, 30),
(107, 'Pooja', 'IT', 'Female', 70000, NULL, 27),
(108, 'Rohan', 'Sales', 'Male', 35000, 2500, 23),
(109, 'Anjali', 'Finance', 'Female', 58000, NULL, 29),
(110, 'Varun', 'Marketing', 'Male', 80000, 9000, 32),
(111, 'Meera', 'IT', 'Female', 62000, 3000, 26),
(112, 'Arjun', 'Sales', 'Male', 42000, NULL, 24),
(113, 'Kavya', 'HR', 'Female', 52000, 4500, 27),
(114, 'Rohit', 'Finance', 'Male', 67000, 6000, 31),
(115, 'Isha', 'Marketing', 'Female', 72000, NULL, 28);


SELECT *
FROM #Employees;


-- =========================================================
-- SECTION 2: INTRODUCTION TO GROUP BY
-- =========================================================

-- GROUP BY combines rows having the same value
-- into groups.

-- Find the number of employees in each department.

SELECT
    Department,
    COUNT(*) AS TotalEmployees
FROM #Employees
GROUP BY Department;


-- Find the total salary of each department.

SELECT
    Department,
    SUM(Salary) AS TotalSalary
FROM #Employees
GROUP BY Department;


-- Find the average salary of each department.

SELECT
    Department,
    AVG(Salary) AS AverageSalary
FROM #Employees
GROUP BY Department;


-- Find the highest salary in each department.

SELECT
    Department,
    MAX(Salary) AS HighestSalary
FROM #Employees
GROUP BY Department;


-- Find the lowest salary in each department.

SELECT
    Department,
    MIN(Salary) AS LowestSalary
FROM #Employees
GROUP BY Department;


-- =========================================================
-- SECTION 3: MULTIPLE AGGREGATE FUNCTIONS WITH GROUP BY
-- =========================================================

-- We can use multiple aggregate functions together.

SELECT
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(Salary) AS TotalSalary,
    AVG(Salary) AS AverageSalary,
    MIN(Salary) AS MinimumSalary,
    MAX(Salary) AS MaximumSalary
FROM #Employees
GROUP BY Department;


-- Find total bonus and number of employees with a bonus.

SELECT
    Department,
    COUNT(Bonus) AS EmployeesWithBonus,
    SUM(Bonus) AS TotalBonus
FROM #Employees
GROUP BY Department;


-- =========================================================
-- SECTION 4: GROUP BY WITH MULTIPLE COLUMNS
-- =========================================================

-- We can group data using more than one column.

-- Find the number of employees in each department
-- according to gender.

SELECT
    Department,
    Gender,
    COUNT(*) AS TotalEmployees
FROM #Employees
GROUP BY Department, Gender;


-- Find the average salary for each department and gender.

SELECT
    Department,
    Gender,
    AVG(Salary) AS AverageSalary
FROM #Employees
GROUP BY Department, Gender;


-- Find total salary for each gender in each department.

SELECT
    Department,
    Gender,
    SUM(Salary) AS TotalSalary
FROM #Employees
GROUP BY Department, Gender;


-- IMPORTANT:
-- GROUP BY Department, Gender creates separate groups
-- for each unique Department + Gender combination.


-- =========================================================
-- SECTION 5: GROUP BY WITH WHERE
-- =========================================================

-- WHERE filters individual rows before grouping.

-- Find the number of employees in each department
-- whose salary is greater than 50000.

SELECT
    Department,
    COUNT(*) AS TotalEmployees
FROM #Employees
WHERE Salary > 50000
GROUP BY Department;


-- Find average salary department-wise
-- for female employees only.

SELECT
    Department,
    AVG(Salary) AS AverageSalary
FROM #Employees
WHERE Gender = 'Female'
GROUP BY Department;


-- Find total salary department-wise
-- for employees aged above 25.

SELECT
    Department,
    SUM(Salary) AS TotalSalary
FROM #Employees
WHERE Age > 25
GROUP BY Department;


-- =========================================================
-- SECTION 6: INTRODUCTION TO HAVING
-- =========================================================

-- HAVING filters groups after GROUP BY.

-- Find departments having more than 2 employees.

SELECT
    Department,
    COUNT(*) AS TotalEmployees
FROM #Employees
GROUP BY Department
HAVING COUNT(*) > 2;


-- Find departments whose average salary is greater than 60000.

SELECT
    Department,
    AVG(Salary) AS AverageSalary
FROM #Employees
GROUP BY Department
HAVING AVG(Salary) > 60000;


-- Find departments whose total salary is greater than 150000.

SELECT
    Department,
    SUM(Salary) AS TotalSalary
FROM #Employees
GROUP BY Department
HAVING SUM(Salary) > 150000;


-- Find departments having a maximum salary above 70000.

SELECT
    Department,
    MAX(Salary) AS MaximumSalary
FROM #Employees
GROUP BY Department
HAVING MAX(Salary) > 70000;


-- =========================================================
-- SECTION 7: GROUP BY WITH WHERE AND HAVING
-- =========================================================

-- WHERE filters rows.
-- GROUP BY creates groups.
-- HAVING filters the resulting groups.

-- Find departments where:
-- 1. Employees have salary greater than 40000.
-- 2. The department has at least 2 such employees.

SELECT
    Department,
    COUNT(*) AS TotalEmployees,
    AVG(Salary) AS AverageSalary
FROM #Employees
WHERE Salary > 40000
GROUP BY Department
HAVING COUNT(*) >= 2;


-- Find departments where:
-- 1. Only female employees are considered.
-- 2. Average salary is greater than 50000.

SELECT
    Department,
    AVG(Salary) AS AverageSalary
FROM #Employees
WHERE Gender = 'Female'
GROUP BY Department
HAVING AVG(Salary) > 50000;


-- Find departments where:
-- 1. Employees are older than 25.
-- 2. Total salary is greater than 100000.

SELECT
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(Salary) AS TotalSalary
FROM #Employees
WHERE Age > 25
GROUP BY Department
HAVING SUM(Salary) > 100000;


-- =========================================================
-- SECTION 8: WHERE VS HAVING
-- =========================================================

-- Example 1: WHERE
-- Find employees whose salary is greater than 60000.

SELECT *
FROM #Employees
WHERE Salary > 60000;


-- Example 2: HAVING
-- Find departments whose average salary is greater than 60000.

SELECT
    Department,
    AVG(Salary) AS AverageSalary
FROM #Employees
GROUP BY Department
HAVING AVG(Salary) > 60000;


-- Example 3: WHERE + HAVING
-- First select employees earning above 40000.
-- Then show departments having more than 2 selected employees.

SELECT
    Department,
    COUNT(*) AS TotalEmployees
FROM #Employees
WHERE Salary > 40000
GROUP BY Department
HAVING COUNT(*) > 2;


-- =========================================================
-- SECTION 9: GROUP BY WITH DISTINCT
-- =========================================================

-- COUNT(DISTINCT column_name) counts unique non-NULL values
-- within each group.

-- Find the number of unique salary values in each department.

SELECT
    Department,
    COUNT(DISTINCT Salary) AS UniqueSalaryCount
FROM #Employees
GROUP BY Department;


-- Find total unique salary values for each gender.

SELECT
    Gender,
    COUNT(DISTINCT Salary) AS UniqueSalaryCount
FROM #Employees
GROUP BY Gender;


-- =========================================================
-- SECTION 10: GROUP BY WITH ORDER BY
-- =========================================================

-- Sort departments by total salary in descending order.

SELECT
    Department,
    SUM(Salary) AS TotalSalary
FROM #Employees
GROUP BY Department
ORDER BY TotalSalary DESC;


-- Sort departments by employee count.

SELECT
    Department,
    COUNT(*) AS TotalEmployees
FROM #Employees
GROUP BY Department
ORDER BY TotalEmployees DESC;


-- Show departments with average salary in ascending order.

SELECT
    Department,
    AVG(Salary) AS AverageSalary
FROM #Employees
GROUP BY Department
ORDER BY AverageSalary ASC;


-- =========================================================
-- SECTION 11: IMPORTANT GROUP BY RULES
-- =========================================================

/*
RULE 1:
Every selected column that is not inside an aggregate
function must generally appear in the GROUP BY clause.

Correct:

SELECT Department, COUNT(*)
FROM #Employees
GROUP BY Department;


Incorrect:

SELECT Department, EmployeeName, COUNT(*)
FROM #Employees
GROUP BY Department;

Why?
EmployeeName is neither aggregated nor included in GROUP BY.


RULE 2:
WHERE cannot directly filter aggregate results.

Incorrect:

SELECT Department, COUNT(*)
FROM #Employees
WHERE COUNT(*) > 2
GROUP BY Department;

Correct:

SELECT Department, COUNT(*)
FROM #Employees
GROUP BY Department
HAVING COUNT(*) > 2;


RULE 3:
HAVING can be used without GROUP BY in SQL Server
when filtering an aggregate over the entire result set.

Example:

SELECT COUNT(*) AS TotalEmployees
FROM #Employees
HAVING COUNT(*) > 10;


RULE 4:
NULL values in a grouping column are grouped together.

Example:

SELECT Department, COUNT(*) AS TotalEmployees
FROM #Employees
GROUP BY Department;

All rows with NULL Department belong to one group.
*/


-- =========================================================
-- SECTION 12: PRACTICE QUESTIONS
-- =========================================================

/*
Q1. Find the total number of employees in each department.

Q2. Find the total salary paid by each department.

Q3. Find the average salary of each department.

Q4. Find the highest salary in each department.

Q5. Find the lowest salary in each department.

Q6. Count male and female employees in each department.

Q7. Find average salary for each gender in each department.

Q8. Find departments having more than 2 employees.

Q9. Find departments having average salary greater than 55000.

Q10. Find departments whose total salary is greater than 200000.

Q11. Find departments where average salary is below 50000.

Q12. Consider only employees earning above 45000.
     Find the number of employees in each department.

Q13. Consider only female employees.
     Find departments having at least 2 employees.

Q14. Find departments where employees are older than 25
     and their total salary is greater than 100000.

Q15. Find departments with more than 2 employees
     whose salary is above 40000.

Q16. Find the number of employees with a recorded bonus
     in each department.

Q17. Find the total bonus in each department.

Q18. Find the department with the highest total salary.
     (Display all departments tied for the highest total.)

Q19. Sort departments by average salary in descending order.

Q20. Find departments having at least 2 unique salary values.

Q21. Find the total salary of male employees
     in each department.

Q22. Find departments where the maximum salary is above 70000.

Q23. Find the average salary of employees aged between
     25 and 30 in each department.

Q24. Find departments having more than 1 female employee
     whose salary is greater than 50000.

Q25. Find departments with total salary greater than 100000
     after considering only employees earning above 40000.
*/


-- =========================================================
-- SECTION 13: SOLUTIONS
-- =========================================================

-- Q1
SELECT Department, COUNT(*) AS TotalEmployees
FROM #Employees
GROUP BY Department;


-- Q2
SELECT Department, SUM(Salary) AS TotalSalary
FROM #Employees
GROUP BY Department;


-- Q3
SELECT Department, AVG(Salary) AS AverageSalary
FROM #Employees
GROUP BY Department;


-- Q4
SELECT Department, MAX(Salary) AS HighestSalary
FROM #Employees
GROUP BY Department;


-- Q5
SELECT Department, MIN(Salary) AS LowestSalary
FROM #Employees
GROUP BY Department;


-- Q6
SELECT Department, Gender, COUNT(*) AS TotalEmployees
FROM #Employees
GROUP BY Department, Gender;


-- Q7
SELECT Department, Gender, AVG(Salary) AS AverageSalary
FROM #Employees
GROUP BY Department, Gender;


-- Q8
SELECT Department, COUNT(*) AS TotalEmployees
FROM #Employees
GROUP BY Department
HAVING COUNT(*) > 2;


-- Q9
SELECT Department, AVG(Salary) AS AverageSalary
FROM #Employees
GROUP BY Department
HAVING AVG(Salary) > 55000;


-- Q10
SELECT Department, SUM(Salary) AS TotalSalary
FROM #Employees
GROUP BY Department
HAVING SUM(Salary) > 200000;


-- Q11
SELECT Department, AVG(Salary) AS AverageSalary
FROM #Employees
GROUP BY Department
HAVING AVG(Salary) < 50000;


-- Q12
SELECT Department, COUNT(*) AS TotalEmployees
FROM #Employees
WHERE Salary > 45000
GROUP BY Department;


-- Q13
SELECT Department, COUNT(*) AS FemaleEmployees
FROM #Employees
WHERE Gender = 'Female'
GROUP BY Department
HAVING COUNT(*) >= 2;


-- Q14
SELECT Department, SUM(Salary) AS TotalSalary
FROM #Employees
WHERE Age > 25
GROUP BY Department
HAVING SUM(Salary) > 100000;


-- Q15
SELECT Department, COUNT(*) AS TotalEmployees
FROM #Employees
WHERE Salary > 40000
GROUP BY Department
HAVING COUNT(*) > 2;


-- Q16
SELECT Department, COUNT(Bonus) AS EmployeesWithBonus
FROM #Employees
GROUP BY Department;


-- Q17
SELECT Department, SUM(Bonus) AS TotalBonus
FROM #Employees
GROUP BY Department;


-- Q18
SELECT Department, SUM(Salary) AS TotalSalary
FROM #Employees
GROUP BY Department
HAVING SUM(Salary) =
(
    SELECT MAX(DepartmentSalary)
    FROM
    (
        SELECT SUM(Salary) AS DepartmentSalary
        FROM #Employees
        GROUP BY Department
    ) AS DepartmentTotals
);


-- Q19
SELECT Department, AVG(Salary) AS AverageSalary
FROM #Employees
GROUP BY Department
ORDER BY AverageSalary DESC;


-- Q20
SELECT Department, COUNT(DISTINCT Salary) AS UniqueSalaryCount
FROM #Employees
GROUP BY Department
HAVING COUNT(DISTINCT Salary) >= 2;


-- Q21
SELECT Department, SUM(Salary) AS MaleTotalSalary
FROM #Employees
WHERE Gender = 'Male'
GROUP BY Department;


-- Q22
SELECT Department, MAX(Salary) AS MaximumSalary
FROM #Employees
GROUP BY Department
HAVING MAX(Salary) > 70000;


-- Q23
SELECT Department, AVG(Salary) AS AverageSalary
FROM #Employees
WHERE Age BETWEEN 25 AND 30
GROUP BY Department;


-- Q24
SELECT Department, COUNT(*) AS FemaleEmployees
FROM #Employees
WHERE Gender = 'Female'
  AND Salary > 50000
GROUP BY Department
HAVING COUNT(*) > 1;


-- Q25
SELECT Department, SUM(Salary) AS TotalSalary
FROM #Employees
WHERE Salary > 40000
GROUP BY Department
HAVING SUM(Salary) > 100000;


-- =========================================================
-- SECTION 14: INTERVIEW QUICK REVISION
-- =========================================================

/*
1. What is GROUP BY?
   It groups rows having the same values in specified columns.

2. What is HAVING?
   It filters groups based on a condition.

3. Difference between WHERE and HAVING?
   WHERE filters rows before grouping.
   HAVING filters groups after grouping.

4. Can we use WHERE and HAVING together?
   Yes.

5. Can GROUP BY contain multiple columns?
   Yes.

6. Can we use aggregate functions with GROUP BY?
   Yes. COUNT, SUM, AVG, MIN and MAX are common examples.

7. Can we use aggregate functions in WHERE?
   Not directly. Use HAVING for aggregate conditions.

8. Can we use HAVING without GROUP BY?
   Yes, for conditions on an aggregate over the entire result.

9. What happens to NULL values in GROUP BY?
   Rows with NULL in the grouping column are grouped together.

10. What is the difference between GROUP BY and DISTINCT?
    DISTINCT removes duplicate result rows.
    GROUP BY creates groups and is commonly used with aggregates.

IMPORTANT QUERY EXECUTION ORDER (SIMPLIFIED):
FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
*/


-- =========================================================
-- END OF PRACTICE FILE
-- =========================================================