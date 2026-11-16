/*
============================================================
SQL PRACTICE 02: NUMERIC FUNCTIONS

Topics:
1. ABS()
2. CEILING()
3. FLOOR()
4. ROUND()
5. POWER()
6. SQRT()
7. SQUARE()
8. SIGN()
9. RAND()
10. EXP()
11. LOG()
12. LOG10()
13. PI()
14. Real-world calculations
15. Practice questions and solutions
============================================================
*/


-- =========================================================
-- SECTION 1: BASIC NUMERIC FUNCTIONS
-- =========================================================

-- ABS(): Returns the absolute (non-negative) value.
-- Example: -50 becomes 50.

SELECT ABS(-50) AS AbsoluteValue;

SELECT ABS(25) AS AbsoluteValue;


-- CEILING(): Rounds a number UP to the nearest integer.

SELECT CEILING(12.1) AS CeilingValue;
SELECT CEILING(12.9) AS CeilingValue;
SELECT CEILING(-12.9) AS CeilingValue;


-- FLOOR(): Rounds a number DOWN to the nearest integer.

SELECT FLOOR(12.9) AS FloorValue;
SELECT FLOOR(12.1) AS FloorValue;
SELECT FLOOR(-12.1) AS FloorValue;


-- ROUND(): Rounds a number to the specified decimal places.

SELECT ROUND(125.4567, 2) AS RoundedValue;
SELECT ROUND(125.4567, 0) AS RoundedValue;
SELECT ROUND(125.4567, 1) AS RoundedValue;


-- ROUND() with a negative length:
-- Rounds to the left of the decimal point.

SELECT ROUND(1256.78, -1) AS RoundedToNearestTen;
SELECT ROUND(1256.78, -2) AS RoundedToNearestHundred;


-- ROUND() with a third argument of 1 truncates
-- instead of rounding.

SELECT ROUND(125.4567, 2, 1) AS TruncatedValue;


-- =========================================================
-- SECTION 2: MATHEMATICAL FUNCTIONS
-- =========================================================

-- POWER(): Raises a number to a specified power.

SELECT POWER(2, 3) AS PowerValue;
-- 2 * 2 * 2 = 8

SELECT POWER(5, 2) AS SquareValue;


-- SQRT(): Returns the square root.

SELECT SQRT(25) AS SquareRoot;
SELECT SQRT(144) AS SquareRoot;


-- SQUARE(): Returns the square of a number.

SELECT SQUARE(5) AS SquareValue;
SELECT SQUARE(12) AS SquareValue;


-- SIGN(): Returns the sign of a number.
-- Positive number -> 1
-- Negative number -> -1
-- Zero -> 0

SELECT SIGN(100) AS SignValue;
SELECT SIGN(-100) AS SignValue;
SELECT SIGN(0) AS SignValue;


-- =========================================================
-- SECTION 3: RANDOM AND EXPONENTIAL FUNCTIONS
-- =========================================================

-- RAND(): Generates a pseudo-random float between 0 and 1.

SELECT RAND() AS RandomValue;


-- Generate a random integer between 1 and 100.

SELECT FLOOR(RAND() * 100) + 1 AS RandomNumber;


-- Generate a random decimal between 10 and 50.

SELECT RAND() * 40 + 10 AS RandomDecimal;


-- EXP(): Returns e raised to the specified power.

SELECT EXP(1) AS ExponentialValue;
SELECT EXP(2) AS ExponentialValue;


-- LOG(): Returns the natural logarithm by default.

SELECT LOG(10) AS NaturalLogValue;


-- LOG() with a specified base.

SELECT LOG(100, 10) AS LogarithmBase10;
SELECT LOG(8, 2) AS LogarithmBase2;


-- LOG10(): Returns logarithm with base 10.

SELECT LOG10(100) AS LogValue;
SELECT LOG10(1000) AS LogValue;


-- PI(): Returns the value of pi.

SELECT PI() AS PiValue;


-- =========================================================
-- SECTION 4: CREATE SAMPLE EMPLOYEE TABLE
-- =========================================================

CREATE TABLE #Employees
(
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(12,2),
    Bonus DECIMAL(12,2),
    PerformanceScore DECIMAL(5,2)
);


INSERT INTO #Employees
VALUES
(101, 'Rahul', 'IT', 55000.75, 5000.50, 8.567),
(102, 'Priya', 'HR', 45000.45, 3500.25, 9.123),
(103, 'Amit', 'IT', 65000.90, 7000.75, 7.891),
(104, 'Sneha', 'Finance', 60000.25, 6000.50, 8.456),
(105, 'Neha', 'HR', 50000.80, 4000.20, 9.678),
(106, 'Karan', 'Marketing', 75000.65, 8000.90, 7.456),
(107, 'Pooja', 'IT', 70000.40, 7500.30, 8.987),
(108, 'Rohan', 'Sales', 35000.35, 2500.45, 6.789),
(109, 'Anjali', 'Finance', 58000.95, 5500.80, 8.234),
(110, 'Varun', 'Marketing', 80000.60, 9000.70, 9.456);


SELECT *
FROM #Employees;


-- =========================================================
-- SECTION 5: ROUNDING SALARY VALUES
-- =========================================================

-- 1. Round salary to two decimal places.

SELECT
    EmployeeName,
    Salary,
    ROUND(Salary, 2) AS RoundedSalary
FROM #Employees;


-- 2. Round salary to the nearest whole number.

SELECT
    EmployeeName,
    Salary,
    ROUND(Salary, 0) AS RoundedSalary
FROM #Employees;


-- 3. Round salary upwards.

SELECT
    EmployeeName,
    Salary,
    CEILING(Salary) AS SalaryRoundedUp
FROM #Employees;


-- 4. Round salary downwards.

SELECT
    EmployeeName,
    Salary,
    FLOOR(Salary) AS SalaryRoundedDown
FROM #Employees;


-- =========================================================
-- SECTION 6: SALARY AND BONUS CALCULATIONS
-- =========================================================

-- 1. Calculate total salary including bonus.

SELECT
    EmployeeName,
    Salary,
    Bonus,
    Salary + Bonus AS TotalEarnings
FROM #Employees;


-- 2. Calculate 10% bonus on salary.

SELECT
    EmployeeName,
    Salary,
    Salary * 0.10 AS TenPercentBonus
FROM #Employees;


-- 3. Calculate salary after a 15% increment.

SELECT
    EmployeeName,
    Salary,
    Salary * 1.15 AS SalaryAfterIncrement
FROM #Employees;


-- 4. Calculate annual salary assuming monthly salary.

SELECT
    EmployeeName,
    Salary,
    Salary * 12 AS AnnualSalary
FROM #Employees;


-- 5. Calculate monthly salary from annual salary.

SELECT
    EmployeeName,
    Salary * 12 AS AnnualSalary,
    ROUND((Salary * 12) / 12, 2) AS MonthlySalary
FROM #Employees;


-- =========================================================
-- SECTION 7: PERCENTAGE CALCULATIONS
-- =========================================================

-- 1. Calculate bonus percentage relative to salary.

SELECT
    EmployeeName,
    Salary,
    Bonus,
    ROUND((Bonus / Salary) * 100, 2) AS BonusPercentage
FROM #Employees
WHERE Salary <> 0;


-- 2. Calculate salary increment of 20%.

SELECT
    EmployeeName,
    Salary,
    Salary * 0.20 AS IncrementAmount,
    Salary * 1.20 AS NewSalary
FROM #Employees;


-- 3. Calculate a 5% deduction.

SELECT
    EmployeeName,
    Salary,
    Salary * 0.05 AS Deduction,
    Salary - (Salary * 0.05) AS SalaryAfterDeduction
FROM #Employees;


-- 4. Calculate salary after increment and deduction.

SELECT
    EmployeeName,
    Salary,
    Salary * 1.10 AS SalaryAfterIncrement,
    Salary * 1.10 * 0.95 AS FinalSalary
FROM #Employees;


-- =========================================================
-- SECTION 8: PERFORMANCE SCORE CALCULATIONS
-- =========================================================

-- 1. Round performance scores to two decimal places.

SELECT
    EmployeeName,
    PerformanceScore,
    ROUND(PerformanceScore, 2) AS RoundedScore
FROM #Employees;


-- 2. Find the square of performance scores.

SELECT
    EmployeeName,
    PerformanceScore,
    SQUARE(PerformanceScore) AS SquaredScore
FROM #Employees;


-- 3. Calculate the square root of performance scores.

SELECT
    EmployeeName,
    PerformanceScore,
    SQRT(PerformanceScore) AS SquareRootScore
FROM #Employees;


-- =========================================================
-- SECTION 9: PRACTICE QUESTIONS
-- =========================================================

/*
Q1. Find the absolute value of -250.

Q2. Round 45.6789 to two decimal places.

Q3. Round 89.456 to the nearest integer.

Q4. Round 123.45 upwards using CEILING().

Q5. Round 123.45 downwards using FLOOR().

Q6. Find the square of 15.

Q7. Find the square root of 225.

Q8. Calculate 2 raised to the power of 5.

Q9. Find the sign of -75.

Q10. Generate a random number between 1 and 100.

Q11. Find the natural logarithm of 20.

Q12. Find the base-10 logarithm of 10000.

Q13. Calculate annual salary for every employee.

Q14. Calculate a 12% salary increment.

Q15. Calculate a 7% salary deduction.

Q16. Calculate total earnings (salary + bonus).

Q17. Calculate the bonus percentage relative to salary.

Q18. Round salary to the nearest whole number.

Q19. Display salary rounded upwards and downwards.

Q20. Calculate the final salary after a 10% increment
     followed by a 5% deduction.
*/


-- =========================================================
-- SECTION 10: SOLUTIONS
-- =========================================================

-- Q1
SELECT ABS(-250) AS AbsoluteValue;


-- Q2
SELECT ROUND(45.6789, 2) AS RoundedValue;


-- Q3
SELECT ROUND(89.456, 0) AS RoundedValue;


-- Q4
SELECT CEILING(123.45) AS CeilingValue;


-- Q5
SELECT FLOOR(123.45) AS FloorValue;


-- Q6
SELECT SQUARE(15) AS SquareValue;


-- Q7
SELECT SQRT(225) AS SquareRoot;


-- Q8
SELECT POWER(2, 5) AS PowerValue;


-- Q9
SELECT SIGN(-75) AS SignValue;


-- Q10
SELECT FLOOR(RAND() * 100) + 1 AS RandomNumber;


-- Q11
SELECT LOG(20) AS NaturalLogValue;


-- Q12
SELECT LOG10(10000) AS LogValue;


-- Q13
SELECT
    EmployeeName,
    Salary,
    Salary * 12 AS AnnualSalary
FROM #Employees;


-- Q14
SELECT
    EmployeeName,
    Salary,
    Salary * 1.12 AS NewSalary
FROM #Employees;


-- Q15
SELECT
    EmployeeName,
    Salary,
    Salary * 0.07 AS Deduction,
    Salary * 0.93 AS SalaryAfterDeduction
FROM #Employees;


-- Q16
SELECT
    EmployeeName,
    Salary,
    Bonus,
    Salary + Bonus AS TotalEarnings
FROM #Employees;


-- Q17
SELECT
    EmployeeName,
    ROUND((Bonus / Salary) * 100, 2) AS BonusPercentage
FROM #Employees
WHERE Salary <> 0;


-- Q18
SELECT
    EmployeeName,
    Salary,
    ROUND(Salary, 0) AS RoundedSalary
FROM #Employees;


-- Q19
SELECT
    EmployeeName,
    Salary,
    CEILING(Salary) AS RoundedUp,
    FLOOR(Salary) AS RoundedDown
FROM #Employees;


-- Q20
SELECT
    EmployeeName,
    Salary,
    Salary * 1.10 * 0.95 AS FinalSalary
FROM #Employees;


-- =========================================================
-- SECTION 11: INTERVIEW QUICK REVISION
-- =========================================================

/*
ABS()       -> Returns absolute value.
CEILING()   -> Rounds up to the next integer.
FLOOR()     -> Rounds down to the previous integer.
ROUND()     -> Rounds to a specified decimal position.
POWER()     -> Calculates a number raised to a power.
SQRT()      -> Returns square root.
SQUARE()    -> Returns square.
SIGN()      -> Returns -1, 0 or 1.
RAND()      -> Generates a pseudo-random float.
EXP()       -> Calculates e raised to a power.
LOG()       -> Calculates logarithm.
LOG10()     -> Calculates base-10 logarithm.
PI()        -> Returns pi.

IMPORTANT INTERVIEW POINTS:

1. Difference between CEILING() and FLOOR():
   CEILING(-12.9) = -12
   FLOOR(-12.9)   = -13

2. Difference between ROUND() and truncation:
   ROUND(125.456, 2)    = 125.460
   ROUND(125.456, 2, 1) = 125.450

3. Difference between POWER() and SQUARE():
   POWER(5, 3) = 125
   SQUARE(5)   = 25

4. RAND() returns a pseudo-random number between 0 and 1.
   Its output should not be treated as cryptographically secure.

5. SQL Server decimal arithmetic:
   Use DECIMAL for financial calculations where precision
   matters. Be careful with integer division.

============================================================
END OF PRACTICE FILE
============================================================
*/