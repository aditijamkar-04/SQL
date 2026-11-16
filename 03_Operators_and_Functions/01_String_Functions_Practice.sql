/*
============================================================
SQL PRACTICE 01: STRING FUNCTIONS

Topics:
1. UPPER() and LOWER()
2. LEN()
3. LEFT() and RIGHT()
4. SUBSTRING()
5. LTRIM(), RTRIM() and TRIM()
6. REPLACE()
7. CONCAT()
8. CHARINDEX()
9. REVERSE()
10. Data Cleaning Practice
11. Interview Questions
============================================================
*/


-- =========================================================
-- SECTION 1: CREATE SAMPLE TABLE
-- =========================================================

CREATE TABLE #Employees
(
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Department VARCHAR(100),
    Email VARCHAR(150),
    City VARCHAR(100),
    PhoneNumber VARCHAR(20)
);


-- =========================================================
-- SECTION 2: INSERT SAMPLE DATA
-- =========================================================

INSERT INTO #Employees
VALUES
(101, 'Rahul Sharma', 'IT', 'Rahul@gmail.com', 'Pune', '9876543210'),
(102, 'PRIYA PATIL', 'HR', 'PRIYA@GMAIL.COM', 'Mumbai', '9876543211'),
(103, 'amit deshmukh', 'Finance', 'amit@gmail.com', 'Nagpur', '9876543212'),
(104, ' Sneha Joshi ', 'Marketing', 'sneha@gmail.com', 'Pune', '9876543213'),
(105, 'Neha  Kulkarni', 'HR', 'neha@gmail.com', 'Mumbai', '9876543214'),
(106, 'Karan Mehta', 'IT', 'karan@gmail.com', 'Hyderabad', '9876543215'),
(107, 'Pooja Patil', 'Finance', 'pooja@gmail.com', 'Nagpur', '9876543216'),
(108, 'Rohan Verma', 'Sales', 'rohan@gmail.com', 'Delhi', '9876543217'),
(109, 'Anjali Rao', 'IT', 'anjali@gmail.com', 'Pune', '9876543218'),
(110, '  VARUN SHAH  ', 'Marketing', 'varun@gmail.com', 'Hyderabad', '9876543219');


SELECT *
FROM #Employees;


-- =========================================================
-- SECTION 3: UPPER() FUNCTION
-- =========================================================

-- Converts all lowercase characters into uppercase.

SELECT
    EmployeeName,
    UPPER(EmployeeName) AS UppercaseName
FROM #Employees;


-- Practical use:
-- Standardize names before comparing inconsistent text.

SELECT
    EmployeeName,
    UPPER(TRIM(EmployeeName)) AS StandardizedName
FROM #Employees;


-- =========================================================
-- SECTION 4: LOWER() FUNCTION
-- =========================================================

-- Converts all uppercase characters into lowercase.

SELECT
    Email,
    LOWER(Email) AS LowercaseEmail
FROM #Employees;


-- Practical use:
-- Standardize email addresses for consistent comparison.

SELECT
    LOWER(TRIM(Email)) AS CleanEmail
FROM #Employees;


-- =========================================================
-- SECTION 5: LEN() FUNCTION
-- =========================================================

-- Returns the number of characters in a string.
-- Important: SQL Server LEN() ignores trailing spaces.
-- It does not ignore leading spaces.

SELECT
    EmployeeName,
    LEN(EmployeeName) AS NameLength
FROM #Employees;


-- Compare LEN() and DATALENGTH().

SELECT
    EmployeeName,
    LEN(EmployeeName) AS CharacterLength,
    DATALENGTH(EmployeeName) AS StorageLengthInBytes
FROM #Employees;


-- Practical use:
-- Find names having more than 10 characters.

SELECT *
FROM #Employees
WHERE LEN(EmployeeName) > 10;


-- =========================================================
-- SECTION 6: LEFT() FUNCTION
-- =========================================================

-- Extracts a specified number of characters from the left.

SELECT
    EmployeeName,
    LEFT(EmployeeName, 4) AS FirstFourCharacters
FROM #Employees;


-- Extract the first character of each employee name.

SELECT
    EmployeeName,
    LEFT(EmployeeName, 1) AS FirstCharacter
FROM #Employees;


-- Practical use:
-- Find employees whose names start with 'R'.

SELECT *
FROM #Employees
WHERE LEFT(EmployeeName, 1) = 'R';


-- =========================================================
-- SECTION 7: RIGHT() FUNCTION
-- =========================================================

-- Extracts a specified number of characters from the right.

SELECT
    EmployeeName,
    RIGHT(EmployeeName, 4) AS LastFourCharacters
FROM #Employees;


-- Extract the last four digits of phone numbers.

SELECT
    PhoneNumber,
    RIGHT(PhoneNumber, 4) AS LastFourDigits
FROM #Employees;


-- =========================================================
-- SECTION 8: SUBSTRING() FUNCTION
-- =========================================================

-- Syntax:
-- SUBSTRING(expression, start_position, length)
--
-- SQL Server uses 1-based positions.
-- Position 1 means the first character.

SELECT
    EmployeeName,
    SUBSTRING(EmployeeName, 1, 5) AS FirstFiveCharacters
FROM #Employees;


-- Extract characters starting from position 3.

SELECT
    EmployeeName,
    SUBSTRING(EmployeeName, 3, 4) AS ExtractedText
FROM #Employees;


-- Extract the middle part of a phone number.

SELECT
    PhoneNumber,
    SUBSTRING(PhoneNumber, 4, 4) AS MiddleFourDigits
FROM #Employees;


-- =========================================================
-- SECTION 9: LTRIM() FUNCTION
-- =========================================================

-- Removes leading spaces from a string.

SELECT
    EmployeeName,
    LTRIM(EmployeeName) AS NameWithoutLeadingSpaces
FROM #Employees;


-- =========================================================
-- SECTION 10: RTRIM() FUNCTION
-- =========================================================

-- Removes trailing spaces from a string.

SELECT
    EmployeeName,
    RTRIM(EmployeeName) AS NameWithoutTrailingSpaces
FROM #Employees;


-- =========================================================
-- SECTION 11: TRIM() FUNCTION
-- =========================================================

-- Removes leading and trailing spaces.
-- Available in SQL Server 2017 and later.

SELECT
    EmployeeName,
    TRIM(EmployeeName) AS CleanName
FROM #Employees;


-- Difference:
-- LTRIM() -> Removes spaces from the left.
-- RTRIM() -> Removes spaces from the right.
-- TRIM()  -> Removes spaces from both sides.


-- =========================================================
-- SECTION 12: REPLACE() FUNCTION
-- =========================================================

-- Replaces a particular text with another text.
--
-- Syntax:
-- REPLACE(expression, old_value, new_value)

SELECT
    EmployeeName,
    REPLACE(EmployeeName, 'a', 'A') AS ReplacedName
FROM #Employees;


-- Replace Gmail with Outlook in email addresses.

SELECT
    Email,
    REPLACE(Email, 'gmail.com', 'outlook.com') AS NewEmail
FROM #Employees;


-- Remove spaces between names.

SELECT
    EmployeeName,
    REPLACE(EmployeeName, ' ', '') AS NameWithoutSpaces
FROM #Employees;


-- Replace Pune with Hyderabad.

SELECT
    City,
    REPLACE(City, 'Pune', 'Hyderabad') AS UpdatedCity
FROM #Employees;


-- =========================================================
-- SECTION 13: CONCAT() FUNCTION
-- =========================================================

-- Combines two or more strings.
--
-- CONCAT() converts NULL values into empty strings.

SELECT
    CONCAT(EmployeeName, ' - ', Department) AS EmployeeDetails
FROM #Employees;


-- Combine name and city.

SELECT
    CONCAT(EmployeeName, ' lives in ', City) AS EmployeeInformation
FROM #Employees;


-- Combine first and last name.
-- Example only: assume the first part is before the space
-- and the remaining part is the last name.

SELECT
    LEFT(EmployeeName, CHARINDEX(' ', TRIM(EmployeeName) + ' ') - 1)
        AS FirstName,
    LTRIM(SUBSTRING(
        TRIM(EmployeeName),
        CHARINDEX(' ', TRIM(EmployeeName) + ' '),
        LEN(TRIM(EmployeeName))
    )) AS RemainingName
FROM #Employees;


-- =========================================================
-- SECTION 14: CHARINDEX() FUNCTION
-- =========================================================

-- Finds the position of a character or substring.
--
-- Syntax:
-- CHARINDEX(search_expression, expression)
--
-- Returns:
-- Position of the first match.
-- 0 if the text is not found.

SELECT
    EmployeeName,
    CHARINDEX('a', EmployeeName) AS PositionOfA
FROM #Employees;


-- Find the position of @ in email addresses.

SELECT
    Email,
    CHARINDEX('@', Email) AS AtSymbolPosition
FROM #Employees;


-- Find names containing 'ha'.

SELECT *
FROM #Employees
WHERE CHARINDEX('ha', EmployeeName) > 0;


-- Extract email username (before @).

SELECT
    Email,
    LEFT(Email, CHARINDEX('@', Email) - 1) AS EmailUsername
FROM #Employees
WHERE CHARINDEX('@', Email) > 0;


-- =========================================================
-- SECTION 15: REVERSE() FUNCTION
-- =========================================================

-- Reverses the order of characters in a string.

SELECT
    EmployeeName,
    REVERSE(EmployeeName) AS ReversedName
FROM #Employees;


-- Example:
-- 'RAHUL' becomes 'LUHAR'.


-- =========================================================
-- SECTION 16: COMBINING STRING FUNCTIONS
-- =========================================================

-- 1. Clean names and convert them to uppercase.

SELECT
    EmployeeName,
    UPPER(TRIM(EmployeeName)) AS CleanUppercaseName
FROM #Employees;


-- 2. Convert emails to lowercase and remove extra spaces.

SELECT
    Email,
    LOWER(TRIM(Email)) AS CleanEmail
FROM #Employees;


-- 3. Extract the first four characters from cleaned names.

SELECT
    EmployeeName,
    LEFT(TRIM(EmployeeName), 4) AS FirstFourCharacters
FROM #Employees;


-- 4. Extract email usernames and standardize their case.

SELECT
    Email,
    LOWER(LEFT(Email, CHARINDEX('@', Email) - 1)) AS EmailUsername
FROM #Employees
WHERE Email IS NOT NULL
AND CHARINDEX('@', Email) > 0;


-- 5. Count characters after removing leading and trailing spaces.

SELECT
    EmployeeName,
    LEN(TRIM(EmployeeName)) AS CleanNameLength
FROM #Employees;


-- 6. Replace multiple spaces between words with one space.
-- This example handles repeated double spaces once.
-- Repeat or use a more advanced cleaning approach if
-- a value contains more than two consecutive spaces.

SELECT
    EmployeeName,
    TRIM(REPLACE(EmployeeName, '  ', ' ')) AS CleanedName
FROM #Employees;


-- =========================================================
-- SECTION 17: PRACTICE QUESTIONS
-- =========================================================

/*
Q1. Convert all employee names into uppercase.

Q2. Convert all email addresses into lowercase.

Q3. Find the length of every employee name.

Q4. Extract the first three characters of each name.

Q5. Extract the last three characters of each name.

Q6. Extract characters from position 2 to position 5.

Q7. Remove leading spaces from employee names.

Q8. Remove trailing spaces from employee names.

Q9. Remove leading and trailing spaces from employee names.

Q10. Replace 'gmail.com' with 'company.com' in emails.

Q11. Combine employee name and department into one column.

Q12. Find the position of the letter 'a' in every name.

Q13. Find employees whose names contain 'an'.

Q14. Extract the username from each email address.

Q15. Reverse all employee names.

Q16. Display employee names in uppercase after trimming spaces.

Q17. Display the last four digits of every phone number.

Q18. Find the number of characters in each email address.

Q19. Extract the first name from each employee name.

Q20. Find employees whose cleaned names contain more than
     10 characters.
*/


-- =========================================================
-- SECTION 18: SOLUTIONS
-- =========================================================

-- Q1
SELECT UPPER(EmployeeName) AS UppercaseName
FROM #Employees;


-- Q2
SELECT LOWER(Email) AS LowercaseEmail
FROM #Employees;


-- Q3
SELECT EmployeeName, LEN(EmployeeName) AS NameLength
FROM #Employees;


-- Q4
SELECT EmployeeName, LEFT(EmployeeName, 3) AS FirstThree
FROM #Employees;


-- Q5
SELECT EmployeeName, RIGHT(EmployeeName, 3) AS LastThree
FROM #Employees;


-- Q6
SELECT EmployeeName, SUBSTRING(EmployeeName, 2, 4) AS ExtractedText
FROM #Employees;


-- Q7
SELECT LTRIM(EmployeeName) AS CleanName
FROM #Employees;


-- Q8
SELECT RTRIM(EmployeeName) AS CleanName
FROM #Employees;


-- Q9
SELECT TRIM(EmployeeName) AS CleanName
FROM #Employees;


-- Q10
SELECT REPLACE(Email, 'gmail.com', 'company.com') AS UpdatedEmail
FROM #Employees;


-- Q11
SELECT CONCAT(EmployeeName, ' - ', Department) AS EmployeeDetails
FROM #Employees;


-- Q12
SELECT EmployeeName, CHARINDEX('a', EmployeeName) AS PositionOfA
FROM #Employees;


-- Q13
SELECT *
FROM #Employees
WHERE CHARINDEX('an', EmployeeName) > 0;


-- Q14
SELECT
    Email,
    LEFT(Email, CHARINDEX('@', Email) - 1) AS EmailUsername
FROM #Employees
WHERE Email IS NOT NULL
AND CHARINDEX('@', Email) > 0;


-- Q15
SELECT EmployeeName, REVERSE(EmployeeName) AS ReversedName
FROM #Employees;


-- Q16
SELECT UPPER(TRIM(EmployeeName)) AS CleanUppercaseName
FROM #Employees;


-- Q17
SELECT PhoneNumber, RIGHT(PhoneNumber, 4) AS LastFourDigits
FROM #Employees;


-- Q18
SELECT Email, LEN(Email) AS EmailLength
FROM #Employees;


-- Q19
SELECT
    EmployeeName,
    LEFT(
        TRIM(EmployeeName),
        CHARINDEX(' ', TRIM(EmployeeName) + ' ') - 1
    ) AS FirstName
FROM #Employees;


-- Q20
SELECT *
FROM #Employees
WHERE LEN(TRIM(EmployeeName)) > 10;


-- =========================================================
-- SECTION 19: INTERVIEW QUICK REVISION
-- =========================================================

/*
1. UPPER() and LOWER()
   Convert text into uppercase and lowercase.

2. LEN()
   Returns the number of characters.
   Ignores trailing spaces in SQL Server.

3. DATALENGTH()
   Returns the number of bytes used by an expression.
   It is not the same as LEN().

4. LEFT() and RIGHT()
   Extract characters from the beginning and end.

5. SUBSTRING()
   Extracts characters using a starting position and length.

6. LTRIM(), RTRIM() and TRIM()
   Remove spaces from the left, right, or both sides.

7. REPLACE()
   Replaces all occurrences of a specified substring.

8. CONCAT()
   Combines strings and treats NULL as an empty string.

9. CHARINDEX()
   Returns the position of a substring.
   Returns 0 when no match is found.

10. REVERSE()
    Reverses the characters in a string.

IMPORTANT:
- SQL Server string positions start from 1.
- CHARINDEX() returns 0 when no match is found.
- LEN() ignores trailing spaces.
- TRIM() requires SQL Server 2017 or later.
- Most string functions return NULL when their input is NULL,
  except CONCAT(), which treats NULL as an empty string.
- String comparison case sensitivity depends on collation.

============================================================
END OF PRACTICE FILE
============================================================
*/