/*
============================================================
SQL PRACTICE 04: CONVERSION AND SPECIAL FUNCTIONS

Topics:
1. CAST()
2. CONVERT()
3. TRY_CAST()
4. TRY_CONVERT()
5. PARSE()
6. TRY_PARSE()
7. ISNULL()
8. COALESCE()
9. NULLIF()
10. CHOOSE()
11. IIF()
12. SQL_VARIANT_PROPERTY()
13. SUSER_NAME()
14. DB_NAME()
15. OBJECT_NAME()
16. Practical examples and interview questions
============================================================
*/


-- =========================================================
-- SECTION 1: CAST()
-- =========================================================

-- CAST() converts one data type into another.
-- Syntax: CAST(expression AS data_type)

-- Convert integer into VARCHAR.

SELECT CAST(100 AS VARCHAR(20)) AS ConvertedValue;


-- Convert VARCHAR into INT.

SELECT CAST('250' AS INT) AS ConvertedValue;


-- Convert DECIMAL into INT.
-- Decimal portion is truncated, not rounded.

SELECT CAST(125.89 AS INT) AS ConvertedValue;


-- Convert VARCHAR into DATE.

SELECT CAST('2024-05-15' AS DATE) AS ConvertedDate;


-- Convert DATETIME into DATE.

SELECT CAST(GETDATE() AS DATE) AS OnlyDate;


-- Convert DECIMAL into another DECIMAL precision.

SELECT CAST(125.6789 AS DECIMAL(10,2)) AS ConvertedValue;


-- =========================================================
-- SECTION 2: CONVERT()
-- =========================================================

-- CONVERT() also changes one data type into another.
-- It supports optional formatting styles.

-- Syntax: CONVERT(data_type, expression, style)

SELECT CONVERT(VARCHAR(20), 100) AS ConvertedValue;


-- Convert DATE into VARCHAR.

SELECT CONVERT(VARCHAR(10), GETDATE(), 103) AS DateInDDMMYYYY;


-- Common date formatting styles:

-- Style 101: MM/DD/YYYY

SELECT CONVERT(VARCHAR(10), GETDATE(), 101) AS DateFormat101;


-- Style 103: DD/MM/YYYY

SELECT CONVERT(VARCHAR(10), GETDATE(), 103) AS DateFormat103;


-- Style 105: DD-MM-YYYY

SELECT CONVERT(VARCHAR(10), GETDATE(), 105) AS DateFormat105;


-- Style 120: YYYY-MM-DD HH:MI:SS

SELECT CONVERT(VARCHAR(19), GETDATE(), 120) AS DateFormat120;


-- =========================================================
-- SECTION 3: TRY_CAST()
-- =========================================================

-- TRY_CAST() attempts conversion.
-- If conversion fails, it returns NULL instead of an error.

SELECT TRY_CAST('500' AS INT) AS ValidConversion;


SELECT TRY_CAST('Hello' AS INT) AS InvalidConversion;


-- Compare CAST() and TRY_CAST().

-- CAST('Hello' AS INT) produces a conversion error.
-- TRY_CAST('Hello' AS INT) returns NULL.


-- =========================================================
-- SECTION 4: TRY_CONVERT()
-- =========================================================

-- TRY_CONVERT() works similarly to CONVERT().
-- It returns NULL when conversion fails.

SELECT TRY_CONVERT(INT, '250') AS ValidConversion;


SELECT TRY_CONVERT(INT, 'ABC') AS InvalidConversion;


-- Convert date text using a specified style.

SELECT TRY_CONVERT(DATE, '15/05/2024', 103) AS ConvertedDate;


-- Invalid date conversion.

SELECT TRY_CONVERT(DATE, '45/15/2024', 103) AS InvalidDate;


-- =========================================================
-- SECTION 5: PARSE()
-- =========================================================

-- PARSE() converts a string into a specified data type.
-- It supports culture-specific formats.
-- It is generally more expensive than CAST() and CONVERT().

SELECT PARSE('123.45' AS DECIMAL(10,2)) AS ParsedValue;


-- Parse a date using British English culture.

SELECT PARSE('31/12/2024' AS DATE USING 'en-GB') AS ParsedDate;


-- Parse a date using US English culture.

SELECT PARSE('12/31/2024' AS DATE USING 'en-US') AS ParsedDate;


-- =========================================================
-- SECTION 6: TRY_PARSE()
-- =========================================================

-- TRY_PARSE() returns NULL when parsing fails.

SELECT TRY_PARSE('123.45' AS DECIMAL(10,2)) AS ValidValue;


SELECT TRY_PARSE('Hello' AS DECIMAL(10,2)) AS InvalidValue;


-- Parse a date safely.

SELECT TRY_PARSE('31/12/2024' AS DATE USING 'en-GB') AS ParsedDate;


-- Invalid date.

SELECT TRY_PARSE('45/15/2024' AS DATE USING 'en-GB') AS InvalidDate;


-- =========================================================
-- SECTION 7: CREATE SAMPLE TABLE
-- =========================================================

CREATE TABLE #Employees
(
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10,2),
    Bonus DECIMAL(10,2) NULL,
    Department VARCHAR(50) NULL,
    Email VARCHAR(100) NULL,
    PhoneNumber VARCHAR(20) NULL
);


INSERT INTO #Employees
VALUES
(101, 'Rahul', 55000, 5000, 'IT', 'rahul@gmail.com', '9876543210'),
(102, 'Priya', 45000, NULL, 'HR', 'priya@gmail.com', NULL),
(103, 'Amit', 65000, 7000, 'IT', NULL, '9876543212'),
(104, 'Sneha', 60000, NULL, 'Finance', 'sneha@gmail.com', '9876543213'),
(105, 'Neha', 50000, 4000, NULL, 'neha@gmail.com', NULL),
(106, 'Karan', 75000, 8000, 'Marketing', NULL, '9876543215'),
(107, 'Pooja', 70000, NULL, 'IT', 'pooja@gmail.com', '9876543216'),
(108, 'Rohan', 35000, 2500, 'Sales', 'rohan@gmail.com', NULL),
(109, 'Anjali', 58000, NULL, 'Finance', NULL, '9876543218'),
(110, 'Varun', 80000, 9000, NULL, 'varun@gmail.com', '9876543219');


SELECT *
FROM #Employees;


-- =========================================================
-- SECTION 8: ISNULL()
-- =========================================================

-- ISNULL() replaces NULL with a specified replacement value.
-- Syntax: ISNULL(expression, replacement_value)

SELECT
    EmployeeName,
    Bonus,
    ISNULL(Bonus, 0) AS UpdatedBonus
FROM #Employees;


-- Replace missing department with 'Not Assigned'.

SELECT
    EmployeeName,
    ISNULL(Department, 'Not Assigned') AS Department
FROM #Employees;


-- Replace missing email with a message.

SELECT
    EmployeeName,
    ISNULL(Email, 'Email Not Available') AS Email
FROM #Employees;


-- Calculate total earnings even when bonus is NULL.

SELECT
    EmployeeName,
    Salary,
    Bonus,
    Salary + ISNULL(Bonus, 0) AS TotalEarnings
FROM #Employees;


-- =========================================================
-- SECTION 9: COALESCE()
-- =========================================================

-- COALESCE() returns the first non-NULL expression.
-- Syntax: COALESCE(expression1, expression2, ...)

SELECT
    EmployeeName,
    COALESCE(Email, PhoneNumber, 'No Contact Available')
        AS ContactDetails
FROM #Employees;


-- Find the first available value among three columns.

SELECT
    EmployeeName,
    COALESCE(Department, Email, PhoneNumber, 'Not Available')
        AS AvailableInformation
FROM #Employees;


-- Compare ISNULL() and COALESCE().

SELECT
    EmployeeName,
    ISNULL(Department, 'Unknown') AS UsingISNULL,
    COALESCE(Department, 'Unknown') AS UsingCOALESCE
FROM #Employees;


-- =========================================================
-- SECTION 10: NULLIF()
-- =========================================================

-- NULLIF() compares two expressions.
-- If they are equal, it returns NULL.
-- Otherwise, it returns the first expression.

SELECT NULLIF(100, 100) AS Result;


SELECT NULLIF(100, 200) AS Result;


-- Practical use: Prevent division by zero.

SELECT
    EmployeeName,
    Salary,
    Bonus,
    Salary / NULLIF(Bonus, 0) AS SalaryBonusRatio
FROM #Employees;


-- Example with zero denominator.

SELECT
    100 / NULLIF(0, 0) AS SafeDivision;


-- =========================================================
-- SECTION 11: CHOOSE()
-- =========================================================

-- CHOOSE() returns an item based on its index.
-- Indexing starts from 1.

SELECT CHOOSE(1, 'Red', 'Green', 'Blue') AS SelectedColor;


SELECT CHOOSE(2, 'Red', 'Green', 'Blue') AS SelectedColor;


SELECT CHOOSE(3, 'Red', 'Green', 'Blue') AS SelectedColor;


-- Practical example: Department based on a numeric code.

SELECT
    EmployeeName,
    CHOOSE(1, 'IT', 'HR', 'Finance') AS Department
FROM #Employees;


-- =========================================================
-- SECTION 12: IIF()
-- =========================================================

-- IIF() returns one value when a condition is TRUE
-- and another value when it is FALSE.
--
-- Syntax: IIF(condition, true_value, false_value)

SELECT
    EmployeeName,
    Salary,
    IIF(Salary >= 60000, 'High Salary', 'Low Salary')
        AS SalaryCategory
FROM #Employees;


-- Check whether a bonus is available.

SELECT
    EmployeeName,
    Bonus,
    IIF(Bonus IS NULL, 'No Bonus', 'Bonus Available')
        AS BonusStatus
FROM #Employees;


-- =========================================================
-- SECTION 13: SQL_VARIANT_PROPERTY()
-- =========================================================

-- SQL_VARIANT_PROPERTY() returns information about
-- a sql_variant expression.

DECLARE @SampleValue SQL_VARIANT = 125.50;

SELECT
    SQL_VARIANT_PROPERTY(@SampleValue, 'BaseType') AS BaseType,
    SQL_VARIANT_PROPERTY(@SampleValue, 'Precision') AS PrecisionValue,
    SQL_VARIANT_PROPERTY(@SampleValue, 'Scale') AS ScaleValue,
    SQL_VARIANT_PROPERTY(@SampleValue, 'MaxLength') AS MaximumLength;


-- =========================================================
-- SECTION 14: SERVER AND DATABASE INFORMATION FUNCTIONS
-- =========================================================

-- SUSER_NAME(): Returns the current SQL Server login name.

SELECT SUSER_NAME() AS CurrentLogin;


-- DB_NAME(): Returns the current database name.

SELECT DB_NAME() AS CurrentDatabase;


-- OBJECT_NAME(): Returns the name of a database object
-- when supplied with its object ID.

SELECT OBJECT_NAME(OBJECT_ID('tempdb..#Employees')) AS ObjectName;


-- =========================================================
-- SECTION 15: PRACTICAL DATA CLEANING
-- =========================================================

-- 1. Convert salary to integer.

SELECT
    EmployeeName,
    Salary,
    CAST(Salary AS INT) AS SalaryAsInteger
FROM #Employees;


-- 2. Replace missing bonus with zero.

SELECT
    EmployeeName,
    ISNULL(Bonus, 0) AS CleanBonus
FROM #Employees;


-- 3. Replace missing department with 'Unassigned'.

SELECT
    EmployeeName,
    COALESCE(Department, 'Unassigned') AS CleanDepartment
FROM #Employees;


-- 4. Select the first available contact detail.

SELECT
    EmployeeName,
    COALESCE(Email, PhoneNumber, 'No Contact') AS Contact
FROM #Employees;


-- 5. Convert text into numbers safely.

SELECT
    TRY_CAST('45000' AS DECIMAL(10,2)) AS ValidSalary,
    TRY_CAST('Unknown' AS DECIMAL(10,2)) AS InvalidSalary;


-- =========================================================
-- SECTION 16: IMPORTANT DIFFERENCES
-- =========================================================

/*
CAST() vs CONVERT()
------------------
CAST() is standard SQL syntax.
CONVERT() is SQL Server-specific and supports style codes.

CAST('2024-05-15' AS DATE)
CONVERT(DATE, '2024-05-15')


CAST() vs TRY_CAST()
--------------------
CAST() raises an error if conversion fails.
TRY_CAST() returns NULL if conversion fails.


CONVERT() vs TRY_CONVERT()
--------------------------
CONVERT() raises an error for failed conversions.
TRY_CONVERT() returns NULL for failed conversions.


ISNULL() vs COALESCE()
---------------------
ISNULL() accepts two arguments.
COALESCE() accepts multiple arguments.

ISNULL() generally returns the data type of its first argument.
COALESCE() returns the data type with the highest precedence
among its arguments.

COALESCE() follows the SQL standard.
ISNULL() is specific to SQL Server.


ISNULL() vs NULLIF()
--------------------
ISNULL() replaces NULL with a specified value.
NULLIF() returns NULL when two expressions are equal.


IIF() vs CASE
-------------
IIF() is a shorter conditional expression.
CASE supports multiple conditions and is more flexible.


PARSE() vs TRY_PARSE()
---------------------
PARSE() raises an error when parsing fails.
TRY_PARSE() returns NULL when parsing fails.
*/


-- =========================================================
-- SECTION 17: PRACTICE QUESTIONS
-- =========================================================

/*
Q1. Convert the value '5000' into INT using CAST().

Q2. Convert the value 125.75 into INT.

Q3. Convert the current date into VARCHAR using CONVERT().

Q4. Convert '250' into INT using TRY_CAST().

Q5. Try converting 'Hello' into INT using TRY_CAST().

Q6. Convert '15/05/2024' into DATE using TRY_CONVERT().

Q7. Replace NULL bonuses with zero.

Q8. Replace NULL departments with 'Unassigned'.

Q9. Return the first available value from Email and PhoneNumber.

Q10. Use NULLIF() to prevent division by zero.

Q11. Use CHOOSE() to return the second month name
     from a list of three month names.

Q12. Categorize salary as:
     High Salary if salary >= 60000,
     otherwise Low Salary.

Q13. Display the current database name.

Q14. Display the current login name.

Q15. Find the name of the temporary Employees table
     using OBJECT_NAME().

Q16. Convert salary into DECIMAL(10,0).

Q17. Use COALESCE() to display Email, PhoneNumber
     or 'No Contact Available'.

Q18. Use IIF() to identify employees whose bonus is NULL.

Q19. Convert '31/12/2024' into DATE using PARSE()
     with British English culture.

Q20. Safely convert 'ABC123' into INT using TRY_CONVERT().
*/


-- =========================================================
-- SECTION 18: SOLUTIONS
-- =========================================================

-- Q1
SELECT CAST('5000' AS INT) AS ConvertedValue;


-- Q2
SELECT CAST(125.75 AS INT) AS ConvertedValue;


-- Q3
SELECT CONVERT(VARCHAR(10), GETDATE(), 103) AS CurrentDate;


-- Q4
SELECT TRY_CAST('250' AS INT) AS ConvertedValue;


-- Q5
SELECT TRY_CAST('Hello' AS INT) AS ConvertedValue;


-- Q6
SELECT TRY_CONVERT(DATE, '15/05/2024', 103) AS ConvertedDate;


-- Q7
SELECT
    EmployeeName,
    ISNULL(Bonus, 0) AS UpdatedBonus
FROM #Employees;


-- Q8
SELECT
    EmployeeName,
    ISNULL(Department, 'Unassigned') AS UpdatedDepartment
FROM #Employees;


-- Q9
SELECT
    EmployeeName,
    COALESCE(Email, PhoneNumber, 'No Contact Available') AS Contact
FROM #Employees;


-- Q10
SELECT 100 / NULLIF(0, 0) AS SafeDivision;


-- Q11
SELECT CHOOSE(2, 'January', 'February', 'March') AS MonthName;


-- Q12
SELECT
    EmployeeName,
    IIF(Salary >= 60000, 'High Salary', 'Low Salary')
        AS SalaryCategory
FROM #Employees;


-- Q13
SELECT DB_NAME() AS DatabaseName;


-- Q14
SELECT SUSER_NAME() AS LoginName;


-- Q15
SELECT OBJECT_NAME(OBJECT_ID('tempdb..#Employees')) AS TableName;


-- Q16
SELECT
    EmployeeName,
    CAST(Salary AS DECIMAL(10,0)) AS ConvertedSalary
FROM #Employees;


-- Q17
SELECT
    EmployeeName,
    COALESCE(Email, PhoneNumber, 'No Contact Available') AS Contact
FROM #Employees;


-- Q18
SELECT
    EmployeeName,
    IIF(Bonus IS NULL, 'Missing Bonus', 'Bonus Available')
        AS BonusStatus
FROM #Employees;


-- Q19
SELECT PARSE('31/12/2024' AS DATE USING 'en-GB') AS ConvertedDate;


-- Q20
SELECT TRY_CONVERT(INT, 'ABC123') AS ConvertedValue;


-- =========================================================
-- SECTION 19: INTERVIEW QUICK REVISION
-- =========================================================

/*
CAST()                  -> Converts data types.
CONVERT()               -> Converts data types with styles.
TRY_CAST()              -> Safe CAST; returns NULL on failure.
TRY_CONVERT()           -> Safe CONVERT; returns NULL on failure.
PARSE()                 -> Converts using culture-specific formats.
TRY_PARSE()             -> Safe PARSE; returns NULL on failure.

ISNULL()                -> Replaces NULL with another value.
COALESCE()              -> Returns first non-NULL expression.
NULLIF()                -> Returns NULL when expressions are equal.
CHOOSE()                -> Returns an item using its index.
IIF()                   -> Returns one of two values based on a condition.

SQL_VARIANT_PROPERTY()  -> Returns properties of sql_variant.
SUSER_NAME()            -> Returns current login name.
DB_NAME()               -> Returns database name.
OBJECT_NAME()           -> Returns object name from its ID.

IMPORTANT:
- TRY_CAST() and TRY_CONVERT() are useful when cleaning
  columns containing inconsistent values.
- Use NULLIF() to avoid division-by-zero errors.
- COALESCE() can check multiple columns for a non-NULL value.
- CAST() and CONVERT() are often preferable to PARSE()
  for ordinary conversions.
- Be careful with implicit data type conversion.
- The result data type of ISNULL() and COALESCE() can differ.

============================================================
END OF PRACTICE FILE
============================================================
*/