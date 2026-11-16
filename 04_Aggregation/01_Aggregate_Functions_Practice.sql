/*
============================================================
SQL PRACTICE 01: AGGREGATE FUNCTIONS

Topics:
1. COUNT()
2. COUNT(*)
3. COUNT(column_name)
4. COUNT(DISTINCT)
5. SUM()
6. AVG()
7. MIN()
8. MAX()
9. Handling NULL values
10. Aggregate functions with WHERE
11. Practical business queries
12. Interview practice questions
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
(112, 'Arjun', 'Sales', 'Male', 42000, NULL, 24);


SELECT *
FROM #Employees;


-- =========================================================
-- SECTION 2: COUNT()
-- =========================================================

-- COUNT() is used to count records or non-NULL values.

-- COUNT(*)
-- Counts all rows, including rows containing NULL values.

SELECT COUNT(*) AS TotalEmployees
FROM #Employees;


-- COUNT(column_name)
-- Counts only non-NULL values in that column.

SELECT COUNT(Bonus) AS EmployeesWithBonus
FROM #Employees;


-- Count employees having an email is not applicable here;
-- instead, count non-NULL department values.

SELECT COUNT(Department) AS EmployeesWithDepartment
FROM #Employees;


-- COUNT(DISTINCT column_name)
-- Counts unique non-NULL values.

SELECT COUNT(DISTINCT Department) AS TotalDepartments
FROM #Employees;


SELECT COUNT(DISTINCT Gender) AS TotalGenderCategories
FROM #Employees;


-- =========================================================
-- SECTION 3: SUM()
-- =========================================================

-- SUM() calculates the total of numeric values.

SELECT SUM(Salary) AS TotalSalary
FROM #Employees;


-- Total bonus paid to employees.

SELECT SUM(Bonus) AS TotalBonus
FROM #Employees;


-- Total salary and bonus combined.
-- NULL bonus values are treated as zero for this calculation.

SELECT
    SUM(Salary + ISNULL(Bonus, 0)) AS TotalCompanyPayment
FROM #Employees;


-- =========================================================
-- SECTION 4: AVG()
-- =========================================================

-- AVG() calculates the average of numeric values.
-- NULL values are ignored.

SELECT AVG(Salary) AS AverageSalary
FROM #Employees;


-- Average bonus among employees who have a recorded bonus.

SELECT AVG(Bonus) AS AverageBonus
FROM #Employees;


-- Average salary rounded to two decimal places.

SELECT ROUND(AVG(Salary), 2) AS AverageSalary
FROM #Employees;


-- =========================================================
-- SECTION 5: MIN() AND MAX()
-- =========================================================

-- MIN() returns the smallest value.

SELECT MIN(Salary) AS MinimumSalary
FROM #Employees;


-- MAX() returns the largest value.

SELECT MAX(Salary) AS MaximumSalary
FROM #Employees;


-- Find minimum and maximum bonus.

SELECT
    MIN(Bonus) AS MinimumBonus,
    MAX(Bonus) AS MaximumBonus
FROM #Employees;


-- MIN() and MAX() also work with dates and text.

SELECT
    MIN(EmployeeName) AS AlphabeticallyFirstName,
    MAX(EmployeeName) AS AlphabeticallyLastName
FROM #Employees;


-- =========================================================
-- SECTION 6: MULTIPLE AGGREGATE FUNCTIONS
-- =========================================================

-- We can use multiple aggregate functions in one query.

SELECT
    COUNT(*) AS TotalEmployees,
    SUM(Salary) AS TotalSalary,
    AVG(Salary) AS AverageSalary,
    MIN(Salary) AS MinimumSalary,
    MAX(Salary) AS MaximumSalary
FROM #Employees;


-- Department-wise summary is covered in the next file
-- using GROUP BY.


-- =========================================================
-- SECTION 7: AGGREGATE FUNCTIONS WITH WHERE
-- =========================================================

-- Total number of IT employees.

SELECT COUNT(*) AS IT_Employees
FROM #Employees
WHERE Department = 'IT';


-- Total salary of IT employees.

SELECT SUM(Salary) AS IT_TotalSalary
FROM #Employees
WHERE Department = 'IT';


-- Average salary of female employees.

SELECT AVG(Salary) AS FemaleAverageSalary
FROM #Employees
WHERE Gender = 'Female';


-- Highest salary among employees older than 25.

SELECT MAX(Salary) AS HighestSalary
FROM #Employees
WHERE Age > 25;


-- Lowest salary among male employees.

SELECT MIN(Salary) AS LowestMaleSalary
FROM #Employees
WHERE Gender = 'Male';


-- =========================================================
-- SECTION 8: NULL HANDLING IN AGGREGATE FUNCTIONS
-- =========================================================

-- Aggregate functions such as SUM(), AVG(), MIN(), and MAX()
-- ignore NULL values.
--
-- COUNT(*) counts all rows.
-- COUNT(column_name) counts only non-NULL values.

SELECT
    COUNT(*) AS TotalRows,
    COUNT(Bonus) AS NonNullBonusCount,
    COUNT(*) - COUNT(Bonus) AS NullBonusCount
FROM #Employees;


-- Compare average bonus with and without replacing NULL.

SELECT
    AVG(Bonus) AS AverageOfAvailableBonuses,
    AVG(ISNULL(Bonus, 0)) AS AverageIncludingMissingAsZero
FROM #Employees;


-- IMPORTANT:
-- These two averages answer different questions.
--
-- AVG(Bonus):
-- Average of only employees with a recorded bonus.
--
-- AVG(ISNULL(Bonus, 0)):
-- Treats missing bonuses as zero and includes every employee.


-- =========================================================
-- SECTION 9: DISTINCT WITH AGGREGATE FUNCTIONS
-- =========================================================

-- Total salary without duplicate salary values.

SELECT SUM(DISTINCT Salary) AS SumOfUniqueSalaries
FROM #Employees;


-- Average of unique salary values.

SELECT AVG(DISTINCT Salary) AS AverageOfUniqueSalaries
FROM #Employees;


-- Count unique departments.

SELECT COUNT(DISTINCT Department) AS UniqueDepartments
FROM #Employees;


-- =========================================================
-- SECTION 10: PRACTICAL BUSINESS QUERIES
-- =========================================================

-- 1. Find the total number of employees.

SELECT COUNT(*) AS TotalEmployees
FROM #Employees;


-- 2. Find the total monthly salary expense.

SELECT SUM(Salary) AS MonthlySalaryExpense
FROM #Employees;


-- 3. Find the average employee salary.

SELECT AVG(Salary) AS AverageSalary
FROM #Employees;


-- 4. Find the highest-paid employee's salary.

SELECT MAX(Salary) AS HighestSalary
FROM #Employees;


-- 5. Find the lowest-paid employee's salary.

SELECT MIN(Salary) AS LowestSalary
FROM #Employees;


-- 6. Find how many employees have a recorded bonus.

SELECT COUNT(Bonus) AS EmployeesWithBonus
FROM #Employees;


-- 7. Find the total bonus paid.

SELECT SUM(Bonus) AS TotalBonusPaid
FROM #Employees;


-- 8. Find the average salary of employees earning
-- more than 50000.

SELECT AVG(Salary) AS AverageSalary
FROM #Employees
WHERE Salary > 50000;


-- 9. Count employees earning between 40000 and 70000.

SELECT COUNT(*) AS EmployeeCount
FROM #Employees
WHERE Salary BETWEEN 40000 AND 70000;


-- 10. Find the total salary paid to female employees.

SELECT SUM(Salary) AS FemaleTotalSalary
FROM #Employees
WHERE Gender = 'Female';


-- =========================================================
-- SECTION 11: PRACTICE QUESTIONS
-- =========================================================

/*
Q1. Find the total number of employees.

Q2. Count how many employees have a recorded bonus.

Q3. Count the number of unique departments.

Q4. Find the total salary paid by the company.

Q5. Find the average salary of all employees.

Q6. Find the highest salary.

Q7. Find the lowest salary.

Q8. Find the total bonus paid.

Q9. Find the average bonus.

Q10. Count employees whose salary is greater than 50000.

Q11. Find the total salary of IT employees.

Q12. Find the average salary of HR employees.

Q13. Find the highest salary among female employees.

Q14. Find the lowest salary among male employees.

Q15. Count employees whose bonus is NULL.

Q16. Find the average salary of employees aged above 25.

Q17. Find the sum of unique salary values.

Q18. Find the average of unique salary values.

Q19. Count employees whose salary is between 40000 and 60000.

Q20. Find the total salary paid to employees
     whose department is either IT or Finance.
*/


-- =========================================================
-- SECTION 12: SOLUTIONS
-- =========================================================

-- Q1
SELECT COUNT(*) AS TotalEmployees
FROM #Employees;


-- Q2
SELECT COUNT(Bonus) AS EmployeesWithBonus
FROM #Employees;


-- Q3
SELECT COUNT(DISTINCT Department) AS UniqueDepartments
FROM #Employees;


-- Q4
SELECT SUM(Salary) AS TotalSalary
FROM #Employees;


-- Q5
SELECT AVG(Salary) AS AverageSalary
FROM #Employees;


-- Q6
SELECT MAX(Salary) AS HighestSalary
FROM #Employees;


-- Q7
SELECT MIN(Salary) AS LowestSalary
FROM #Employees;


-- Q8
SELECT SUM(Bonus) AS TotalBonus
FROM #Employees;


-- Q9
SELECT AVG(Bonus) AS AverageBonus
FROM #Employees;


-- Q10
SELECT COUNT(*) AS EmployeeCount
FROM #Employees
WHERE Salary > 50000;


-- Q11
SELECT SUM(Salary) AS IT_TotalSalary
FROM #Employees
WHERE Department = 'IT';


-- Q12
SELECT AVG(Salary) AS HR_AverageSalary
FROM #Employees
WHERE Department = 'HR';


-- Q13
SELECT MAX(Salary) AS HighestFemaleSalary
FROM #Employees
WHERE Gender = 'Female';


-- Q14
SELECT MIN(Salary) AS LowestMaleSalary
FROM #Employees
WHERE Gender = 'Male';


-- Q15
SELECT COUNT(*) AS MissingBonusCount
FROM #Employees
WHERE Bonus IS NULL;


-- Q16
SELECT AVG(Salary) AS AverageSalary
FROM #Employees
WHERE Age > 25;


-- Q17
SELECT SUM(DISTINCT Salary) AS UniqueSalaryTotal
FROM #Employees;


-- Q18
SELECT AVG(DISTINCT Salary) AS UniqueSalaryAverage
FROM #Employees;


-- Q19
SELECT COUNT(*) AS EmployeeCount
FROM #Employees
WHERE Salary BETWEEN 40000 AND 60000;


-- Q20
SELECT SUM(Salary) AS TotalSalary
FROM #Employees
WHERE Department IN ('IT', 'Finance');


-- =========================================================
-- SECTION 13: INTERVIEW QUICK REVISION
-- =========================================================

/*
1. What are aggregate functions?
   Functions that calculate a single result from multiple rows.

2. Does COUNT(*) count NULL values?
   Yes. It counts all rows.

3. Does COUNT(column_name) count NULL values?
   No. It counts only non-NULL values.

4. Do SUM() and AVG() consider NULL values?
   No. They ignore NULL values.

5. What is COUNT(DISTINCT column_name)?
   It counts unique non-NULL values.

6. Can aggregate functions be used with WHERE?
   Yes. WHERE filters rows before aggregation.

7. What is the difference between SUM() and COUNT()?
   SUM() calculates a numeric total.
   COUNT() counts rows or non-NULL values.

8. What happens when AVG() is used on a column
   containing NULL values?
   NULL values are ignored.

9. Can aggregate functions work on text columns?
   MIN() and MAX() can work with comparable text values.
   SUM() and AVG() require numeric values.

10. Can we use aggregate functions with GROUP BY?
    Yes. GROUP BY calculates aggregate results
    separately for each group.

IMPORTANT:
Aggregate functions generally return one result for the
whole filtered set of rows. GROUP BY allows us to calculate
separate results for different groups.

============================================================
END OF PRACTICE FILE
============================================================
*/