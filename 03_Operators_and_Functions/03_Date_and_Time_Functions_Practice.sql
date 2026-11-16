/*
============================================================
SQL PRACTICE 03: DATE AND TIME FUNCTIONS

Topics:
1. GETDATE()
2. SYSDATETIME()
3. CURRENT_TIMESTAMP
4. GETUTCDATE()
5. DATEPART()
6. DATENAME()
7. YEAR(), MONTH(), DAY()
8. DATEADD()
9. DATEDIFF()
10. EOMONTH()
11. ISDATE()
12. FORMAT()
13. CAST() and CONVERT()
14. Real-world date calculations
15. Practice questions and solutions
============================================================
*/


-- =========================================================
-- SECTION 1: CURRENT DATE AND TIME FUNCTIONS
-- =========================================================

-- GETDATE(): Returns the current system date and time.

SELECT GETDATE() AS CurrentDateTime;


-- SYSDATETIME(): Returns current date and time
-- with greater fractional-second precision.

SELECT SYSDATETIME() AS CurrentSystemDateTime;


-- CURRENT_TIMESTAMP: ANSI SQL equivalent of GETDATE()
-- in SQL Server.

SELECT CURRENT_TIMESTAMP AS CurrentDateTime;


-- GETUTCDATE(): Returns current UTC date and time.

SELECT GETUTCDATE() AS CurrentUTCDateTime;


-- Compare the output of all four functions.

SELECT
    GETDATE() AS GetDateValue,
    SYSDATETIME() AS SysDateTimeValue,
    CURRENT_TIMESTAMP AS CurrentTimestampValue,
    GETUTCDATE() AS UTCDateTimeValue;


-- =========================================================
-- SECTION 2: CREATE SAMPLE EMPLOYEE TABLE
-- =========================================================

CREATE TABLE #Employees
(
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    JoiningDate DATE,
    DateOfBirth DATE
);


INSERT INTO #Employees
VALUES
(101, 'Rahul', 'IT', '2020-01-15', '1998-05-12'),
(102, 'Priya', 'HR', '2021-03-10', '1999-08-20'),
(103, 'Amit', 'IT', '2019-06-20', '1996-02-15'),
(104, 'Sneha', 'Finance', '2022-11-05', '1997-12-10'),
(105, 'Neha', 'HR', '2023-08-12', '2000-04-25'),
(106, 'Karan', 'Marketing', '2018-04-18', '1995-09-18'),
(107, 'Pooja', 'IT', '2021-09-25', '1998-11-30'),
(108, 'Rohan', 'Sales', '2024-01-08', '2001-06-14'),
(109, 'Anjali', 'Finance', '2022-05-14', '1997-03-22'),
(110, 'Varun', 'Marketing', '2017-12-01', '1994-07-08');


SELECT *
FROM #Employees;


-- =========================================================
-- SECTION 3: YEAR(), MONTH() AND DAY()
-- =========================================================

-- YEAR(): Extracts the year.

SELECT
    EmployeeName,
    JoiningDate,
    YEAR(JoiningDate) AS JoiningYear
FROM #Employees;


-- MONTH(): Extracts the month number.

SELECT
    EmployeeName,
    JoiningDate,
    MONTH(JoiningDate) AS JoiningMonth
FROM #Employees;


-- DAY(): Extracts the day of the month.

SELECT
    EmployeeName,
    JoiningDate,
    DAY(JoiningDate) AS JoiningDay
FROM #Employees;


-- Extract all three parts together.

SELECT
    EmployeeName,
    JoiningDate,
    YEAR(JoiningDate) AS JoiningYear,
    MONTH(JoiningDate) AS JoiningMonth,
    DAY(JoiningDate) AS JoiningDay
FROM #Employees;


-- =========================================================
-- SECTION 4: DATEPART()
-- =========================================================

-- DATEPART(): Returns a specified part of a date as an integer.

SELECT
    EmployeeName,
    JoiningDate,
    DATEPART(YEAR, JoiningDate) AS JoiningYear,
    DATEPART(MONTH, JoiningDate) AS JoiningMonth,
    DATEPART(DAY, JoiningDate) AS JoiningDay
FROM #Employees;


-- Extract the quarter.

SELECT
    EmployeeName,
    JoiningDate,
    DATEPART(QUARTER, JoiningDate) AS JoiningQuarter
FROM #Employees;


-- Extract the weekday number.

SELECT
    EmployeeName,
    JoiningDate,
    DATEPART(WEEKDAY, JoiningDate) AS WeekdayNumber
FROM #Employees;


-- Extract the week number.

SELECT
    EmployeeName,
    JoiningDate,
    DATEPART(WEEK, JoiningDate) AS WeekNumber
FROM #Employees;


-- =========================================================
-- SECTION 5: DATENAME()
-- =========================================================

-- DATENAME(): Returns the name of a specified date part.

SELECT
    EmployeeName,
    JoiningDate,
    DATENAME(MONTH, JoiningDate) AS MonthName
FROM #Employees;


-- Extract weekday names.

SELECT
    EmployeeName,
    JoiningDate,
    DATENAME(WEEKDAY, JoiningDate) AS WeekdayName
FROM #Employees;


-- Extract year and month names.

SELECT
    EmployeeName,
    JoiningDate,
    DATENAME(YEAR, JoiningDate) AS YearName,
    DATENAME(MONTH, JoiningDate) AS MonthName
FROM #Employees;


-- =========================================================
-- SECTION 6: DATEADD()
-- =========================================================

-- DATEADD(): Adds or subtracts a specified interval.
--
-- Syntax:
-- DATEADD(datepart, number, date)
--
-- Negative numbers subtract time.

-- Add 5 days.

SELECT
    JoiningDate,
    DATEADD(DAY, 5, JoiningDate) AS AfterFiveDays
FROM #Employees;


-- Add 3 months.

SELECT
    JoiningDate,
    DATEADD(MONTH, 3, JoiningDate) AS AfterThreeMonths
FROM #Employees;


-- Add 2 years.

SELECT
    JoiningDate,
    DATEADD(YEAR, 2, JoiningDate) AS AfterTwoYears
FROM #Employees;


-- Subtract 1 year.

SELECT
    JoiningDate,
    DATEADD(YEAR, -1, JoiningDate) AS OneYearBefore
FROM #Employees;


-- Add 30 minutes to the current date and time.

SELECT DATEADD(MINUTE, 30, GETDATE()) AS AfterThirtyMinutes;


-- =========================================================
-- SECTION 7: DATEDIFF()
-- =========================================================

-- DATEDIFF(): Returns the number of datepart boundaries
-- crossed between two dates.
--
-- Syntax:
-- DATEDIFF(datepart, startdate, enddate)

-- Find difference in years.

SELECT
    EmployeeName,
    JoiningDate,
    DATEDIFF(YEAR, JoiningDate, GETDATE()) AS YearDifference
FROM #Employees;


-- Find difference in months.

SELECT
    EmployeeName,
    JoiningDate,
    DATEDIFF(MONTH, JoiningDate, GETDATE()) AS MonthDifference
FROM #Employees;


-- Find difference in days.

SELECT
    EmployeeName,
    JoiningDate,
    DATEDIFF(DAY, JoiningDate, GETDATE()) AS DaysSinceJoining
FROM #Employees;


-- Find difference in weeks.

SELECT
    EmployeeName,
    JoiningDate,
    DATEDIFF(WEEK, JoiningDate, GETDATE()) AS WeekDifference
FROM #Employees;


-- IMPORTANT:
-- DATEDIFF(YEAR, ...) counts year boundaries crossed.
-- It does not necessarily give completed years of experience.
-- We will calculate completed years more accurately later.


-- =========================================================
-- SECTION 8: EOMONTH()
-- =========================================================

-- EOMONTH(): Returns the last day of a month.

SELECT
    JoiningDate,
    EOMONTH(JoiningDate) AS MonthEndDate
FROM #Employees;


-- Find the last day of the current month.

SELECT EOMONTH(GETDATE()) AS CurrentMonthEnd;


-- Find the last day of the next month.

SELECT EOMONTH(GETDATE(), 1) AS NextMonthEnd;


-- Find the last day of the previous month.

SELECT EOMONTH(GETDATE(), -1) AS PreviousMonthEnd;


-- =========================================================
-- SECTION 9: ISDATE()
-- =========================================================

-- ISDATE(): Checks whether an expression is a valid date/time.
-- Returns 1 for valid input and 0 for invalid input.
-- Results can depend on date format and session settings.

SELECT
    ISDATE('2024-05-15') AS ValidDate;


SELECT
    ISDATE('2024-15-45') AS InvalidDate;


SELECT
    ISDATE('Hello') AS InvalidDate;


-- Check several values.

SELECT
    DateValue,
    ISDATE(DateValue) AS IsValidDate
FROM
(
    VALUES
        ('2024-05-15'),
        ('2024-15-45'),
        ('Hello'),
        ('2023-12-31')
) AS DateCheck(DateValue);


-- =========================================================
-- SECTION 10: FORMAT()
-- =========================================================

-- FORMAT(): Converts a date or number into formatted text.
-- Uses .NET formatting patterns and culture settings.

SELECT
    JoiningDate,
    FORMAT(JoiningDate, 'dd-MM-yyyy') AS FormattedDate
FROM #Employees;


-- Format as month name and year.

SELECT
    JoiningDate,
    FORMAT(JoiningDate, 'MMMM yyyy') AS MonthAndYear
FROM #Employees;


-- Format as day, month name and year.

SELECT
    JoiningDate,
    FORMAT(JoiningDate, 'dd MMMM yyyy') AS ReadableDate
FROM #Employees;


-- Format the current date.

SELECT FORMAT(GETDATE(), 'dd-MM-yyyy') AS CurrentDate;


-- FORMAT() returns text, not a DATE value.
-- Avoid using it unnecessarily in WHERE conditions.


-- =========================================================
-- SECTION 11: CAST() AND CONVERT()
-- =========================================================

-- CAST(): Converts one data type into another.

SELECT
    CAST(GETDATE() AS DATE) AS OnlyDate;


-- Convert date into VARCHAR.

SELECT
    CAST(JoiningDate AS VARCHAR(20)) AS DateAsText
FROM #Employees;


-- CONVERT(): Converts a value into another data type.
-- It also supports date formatting styles.

SELECT
    CONVERT(VARCHAR(10), JoiningDate, 103) AS DateInDDMMYYYY
FROM #Employees;


-- Style 101: MM/DD/YYYY

SELECT
    CONVERT(VARCHAR(10), JoiningDate, 101) AS DateInMMDDYYYY
FROM #Employees;


-- Style 120: YYYY-MM-DD HH:MI:SS (24-hour format).

SELECT
    CONVERT(VARCHAR(19), GETDATE(), 120) AS StandardDateTime
FROM #Employees;


-- Convert text into DATE.

SELECT CAST('2024-05-15' AS DATE) AS ConvertedDate;


-- =========================================================
-- SECTION 12: REAL-WORLD DATE CALCULATIONS
-- =========================================================

-- 1. Find how many days each employee has worked.

SELECT
    EmployeeName,
    JoiningDate,
    DATEDIFF(DAY, JoiningDate, GETDATE()) AS TotalWorkingDays
FROM #Employees;


-- 2. Find employees who joined in 2022.

SELECT *
FROM #Employees
WHERE YEAR(JoiningDate) = 2022;


-- 3. Find employees who joined in January.

SELECT *
FROM #Employees
WHERE MONTH(JoiningDate) = 1;


-- 4. Find employees who joined in the last 5 years.

SELECT *
FROM #Employees
WHERE JoiningDate >= DATEADD(YEAR, -5, CAST(GETDATE() AS DATE));


-- 5. Find employees who joined before 2021.

SELECT *
FROM #Employees
WHERE JoiningDate < '2021-01-01';


-- 6. Find employees who joined during 2022.

SELECT *
FROM #Employees
WHERE JoiningDate >= '2022-01-01'
AND JoiningDate < '2023-01-01';


-- 7. Find employees whose birthday is in May.

SELECT *
FROM #Employees
WHERE MONTH(DateOfBirth) = 5;


-- 8. Find employees born between 1995 and 2000.

SELECT *
FROM #Employees
WHERE DateOfBirth >= '1995-01-01'
AND DateOfBirth < '2001-01-01';


-- 9. Find employees who joined in the current month
-- and current year.

SELECT *
FROM #Employees
WHERE MONTH(JoiningDate) = MONTH(GETDATE())
AND YEAR(JoiningDate) = YEAR(GETDATE());


-- 10. Find employees who joined in the current year.

SELECT *
FROM #Employees
WHERE JoiningDate >= DATEFROMPARTS(YEAR(GETDATE()), 1, 1)
AND JoiningDate < DATEFROMPARTS(YEAR(GETDATE()) + 1, 1, 1);


-- =========================================================
-- SECTION 13: COMPLETED YEARS OF EXPERIENCE
-- =========================================================

-- DATEDIFF(YEAR, ...) alone can overcount completed years.
-- The following calculation adjusts for whether the
-- employee's anniversary has occurred this year.

SELECT
    EmployeeName,
    JoiningDate,
    DATEDIFF(YEAR, JoiningDate, CAST(GETDATE() AS DATE))
    -
    CASE
        WHEN DATEADD(
            YEAR,
            DATEDIFF(YEAR, JoiningDate, CAST(GETDATE() AS DATE)),
            JoiningDate
        ) > CAST(GETDATE() AS DATE)
        THEN 1
        ELSE 0
    END AS CompletedYearsOfExperience
FROM #Employees;


-- =========================================================
-- SECTION 14: PRACTICE QUESTIONS
-- =========================================================

/*
Q1. Display the current date and time.

Q2. Display only the current date.

Q3. Extract the joining year of each employee.

Q4. Extract the joining month number.

Q5. Display the joining month name.

Q6. Display the weekday name for each joining date.

Q7. Add 6 months to every joining date.

Q8. Subtract 2 years from every joining date.

Q9. Calculate the number of days since each employee joined.

Q10. Find employees who joined in 2021.

Q11. Find employees who joined between 2019 and 2022.

Q12. Find employees born in December.

Q13. Find the last day of each employee's joining month.

Q14. Display joining dates in DD-MM-YYYY format.

Q15. Find employees who joined in the current year.

Q16. Find employees who joined before 2020.

Q17. Find employees who joined in the last 3 years.

Q18. Calculate completed years of experience.

Q19. Find employees whose birthdays fall in the current month.

Q20. Find the number of months between joining date and today.
*/


-- =========================================================
-- SECTION 15: SOLUTIONS
-- =========================================================

-- Q1
SELECT GETDATE() AS CurrentDateTime;


-- Q2
SELECT CAST(GETDATE() AS DATE) AS CurrentDate;


-- Q3
SELECT
    EmployeeName,
    YEAR(JoiningDate) AS JoiningYear
FROM #Employees;


-- Q4
SELECT
    EmployeeName,
    MONTH(JoiningDate) AS JoiningMonth
FROM #Employees;


-- Q5
SELECT
    EmployeeName,
    DATENAME(MONTH, JoiningDate) AS JoiningMonthName
FROM #Employees;


-- Q6
SELECT
    EmployeeName,
    DATENAME(WEEKDAY, JoiningDate) AS JoiningWeekday
FROM #Employees;


-- Q7
SELECT
    EmployeeName,
    DATEADD(MONTH, 6, JoiningDate) AS NewDate
FROM #Employees;


-- Q8
SELECT
    EmployeeName,
    DATEADD(YEAR, -2, JoiningDate) AS PreviousDate
FROM #Employees;


-- Q9
SELECT
    EmployeeName,
    DATEDIFF(DAY, JoiningDate, GETDATE()) AS DaysWorked
FROM #Employees;


-- Q10
SELECT *
FROM #Employees
WHERE JoiningDate >= '2021-01-01'
AND JoiningDate < '2022-01-01';


-- Q11
SELECT *
FROM #Employees
WHERE JoiningDate >= '2019-01-01'
AND JoiningDate < '2023-01-01';


-- Q12
SELECT *
FROM #Employees
WHERE MONTH(DateOfBirth) = 12;


-- Q13
SELECT
    EmployeeName,
    EOMONTH(JoiningDate) AS MonthEndDate
FROM #Employees;


-- Q14
SELECT
    EmployeeName,
    CONVERT(VARCHAR(10), JoiningDate, 105) AS FormattedDate
FROM #Employees;


-- Q15
SELECT *
FROM #Employees
WHERE JoiningDate >= DATEFROMPARTS(YEAR(GETDATE()), 1, 1)
AND JoiningDate < DATEFROMPARTS(YEAR(GETDATE()) + 1, 1, 1);


-- Q16
SELECT *
FROM #Employees
WHERE JoiningDate < '2020-01-01';


-- Q17
SELECT *
FROM #Employees
WHERE JoiningDate >= DATEADD(YEAR, -3, CAST(GETDATE() AS DATE));


-- Q18
SELECT
    EmployeeName,
    DATEDIFF(YEAR, JoiningDate, CAST(GETDATE() AS DATE))
    -
    CASE
        WHEN DATEADD(
            YEAR,
            DATEDIFF(YEAR, JoiningDate, CAST(GETDATE() AS DATE)),
            JoiningDate
        ) > CAST(GETDATE() AS DATE)
        THEN 1
        ELSE 0
    END AS CompletedYears
FROM #Employees;


-- Q19
SELECT *
FROM #Employees
WHERE MONTH(DateOfBirth) = MONTH(GETDATE());


-- Q20
SELECT
    EmployeeName,
    DATEDIFF(MONTH, JoiningDate, GETDATE()) AS MonthsWorked
FROM #Employees;


-- =========================================================
-- SECTION 16: INTERVIEW QUICK REVISION
-- =========================================================

/*
GETDATE()          -> Current system date and time.
SYSDATETIME()      -> Current date and time with higher precision.
CURRENT_TIMESTAMP  -> Current date and time.
GETUTCDATE()       -> Current UTC date and time.

YEAR()             -> Extracts year.
MONTH()            -> Extracts month.
DAY()              -> Extracts day.

DATEPART()         -> Returns a date part as an integer.
DATENAME()         -> Returns the name of a date part.

DATEADD()          -> Adds or subtracts a date interval.
DATEDIFF()         -> Counts datepart boundaries crossed.
EOMONTH()          -> Returns the last day of a month.

ISDATE()           -> Checks whether an expression is a valid date.
FORMAT()           -> Converts a date/number into formatted text.

CAST()             -> Converts one data type into another.
CONVERT()          -> Converts data types with optional styles.

IMPORTANT INTERVIEW POINTS:

1. Difference between DATEPART() and DATENAME():
   DATEPART(MONTH, '2024-05-15') = 5
   DATENAME(MONTH, '2024-05-15') = May

2. Difference between DATEADD() and DATEDIFF():
   DATEADD() modifies a date.
   DATEDIFF() calculates datepart boundaries crossed.

3. DATEDIFF(YEAR, ...) does not necessarily calculate
   completed years of experience.

4. FORMAT() returns text and can be slower than simpler
   conversion methods for large datasets.

5. For filtering a complete year, prefer a date range:
   JoiningDate >= '2022-01-01'
   AND JoiningDate < '2023-01-01'

6. Avoid converting a date column to text in WHERE
   conditions when a direct date comparison is possible.

7. GETDATE() uses the SQL Server system's local date/time.
   GETUTCDATE() returns UTC.

============================================================
END OF PRACTICE FILE
============================================================
*/