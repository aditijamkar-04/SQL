/*
============================================================
SQL PRACTICE 02: LOGICAL AND SPECIAL OPERATORS
Level: Beginner to Intermediate

Topics:
1. AND
2. OR
3. NOT
4. IN and NOT IN
5. BETWEEN and NOT BETWEEN
6. LIKE and NOT LIKE
7. SQL Server LIKE wildcards
8. Operator precedence
9. Practice questions
============================================================
*/


-- =========================================================
-- SECTION 1: CREATE SAMPLE TABLE
-- =========================================================

CREATE TABLE #Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    Salary DECIMAL(10,2),
    Department VARCHAR(50),
    City VARCHAR(50),
    Email VARCHAR(100),
    JoiningDate DATE
);


-- =========================================================
-- SECTION 2: INSERT SAMPLE DATA
-- =========================================================

INSERT INTO #Employees
VALUES
(101, 'Rahul', 24, 'Male', 55000, 'IT', 'Pune', 'rahul@gmail.com', '2022-01-15'),
(102, 'Priya', 23, 'Female', 45000, 'HR', 'Mumbai', 'priya@gmail.com', '2023-03-10'),
(103, 'Amit', 28, 'Male', 65000, 'IT', 'Pune', 'amit@gmail.com', '2021-06-20'),
(104, 'Sneha', 25, 'Female', 60000, 'Finance', 'Nagpur', 'sneha@gmail.com', '2020-11-05'),
(105, 'Neha', 24, 'Female', 50000, 'HR', 'Mumbai', 'neha@gmail.com', '2022-08-12'),
(106, 'Karan', 30, 'Male', 75000, 'Marketing', 'Hyderabad', 'karan@gmail.com', '2019-04-18'),
(107, 'Pooja', 27, 'Female', 70000, 'IT', 'Pune', 'pooja@gmail.com', '2021-09-25'),
(108, 'Rohan', 22, 'Male', 35000, 'Sales', 'Delhi', 'rohan@gmail.com', '2024-01-08'),
(109, 'Anjali', 26, 'Female', 58000, 'Finance', 'Nagpur', NULL, '2022-05-14'),
(110, 'Varun', 29, 'Male', 80000, 'Marketing', 'Hyderabad', 'varun@gmail.com', '2018-12-01'),
(111, 'Meera', 23, 'Female', 42000, 'HR', 'Mumbai', NULL, '2023-07-19'),
(112, 'Arjun', 31, 'Male', 90000, 'IT', 'Pune', 'arjun@gmail.com', '2017-02-11'),
(113, 'Kavya', 25, 'Female', 55000, 'Sales', 'Delhi', 'kavya@gmail.com', '2021-10-30'),
(114, 'Nikhil', 27, 'Male', 62000, 'Finance', 'Nagpur', 'nikhil@gmail.com', '2020-03-22'),
(115, 'Isha', 22, 'Female', 38000, 'Sales', 'Delhi', 'isha@gmail.com', '2024-06-15'),
(116, 'Manish', 32, 'Male', 85000, 'IT', 'Pune', 'manish@gmail.com', '2016-08-09'),
(117, 'Riya', 24, 'Female', 48000, 'HR', 'Mumbai', NULL, '2022-12-17'),
(118, 'Sahil', 28, 'Male', 72000, 'Marketing', 'Hyderabad', 'sahil@gmail.com', '2019-07-21'),
(119, 'Tina', 26, 'Female', 51000, 'Finance', 'Nagpur', 'tina@gmail.com', '2023-02-03'),
(120, 'Dev', 30, 'Male', 67000, 'IT', 'Pune', 'dev@gmail.com', '2020-09-13');


-- Check the data

SELECT *
FROM #Employees;


-- =========================================================
-- SECTION 3: AND OPERATOR
-- =========================================================

-- AND: All conditions must be TRUE.

-- 1. Employees working in IT AND earning more than 60000.

SELECT *
FROM #Employees
WHERE Department = 'IT'
AND Salary > 60000;


-- 2. Female employees aged above 24.

SELECT *
FROM #Employees
WHERE Gender = 'Female'
AND Age > 24;


-- 3. Employees from Pune AND earning at least 70000.

SELECT *
FROM #Employees
WHERE City = 'Pune'
AND Salary >= 70000;


-- 4. Employees aged between 25 and 30
-- AND belonging to Finance.

SELECT *
FROM #Employees
WHERE Age >= 25
AND Age <= 30
AND Department = 'Finance';


-- =========================================================
-- SECTION 4: OR OPERATOR
-- =========================================================

-- OR: At least one condition must be TRUE.

-- 5. Employees belonging to IT OR HR.

SELECT *
FROM #Employees
WHERE Department = 'IT'
OR Department = 'HR';


-- 6. Employees living in Pune OR Mumbai.

SELECT *
FROM #Employees
WHERE City = 'Pune'
OR City = 'Mumbai';


-- 7. Employees earning more than 80000
-- OR aged below 23.

SELECT *
FROM #Employees
WHERE Salary > 80000
OR Age < 23;


-- =========================================================
-- SECTION 5: NOT OPERATOR
-- =========================================================

-- NOT reverses a condition.

-- 8. Employees who are NOT female.

SELECT *
FROM #Employees
WHERE NOT Gender = 'Female';


-- 9. Employees who are NOT from IT.

SELECT *
FROM #Employees
WHERE NOT Department = 'IT';


-- 10. Employees who are NOT earning more than 60000.

SELECT *
FROM #Employees
WHERE NOT Salary > 60000;


-- =========================================================
-- SECTION 6: IN OPERATOR
-- =========================================================

-- IN checks whether a value matches any value in a list.

-- 11. Employees from IT, HR or Finance.

SELECT *
FROM #Employees
WHERE Department IN ('IT', 'HR', 'Finance');


-- 12. Employees living in Pune or Delhi.

SELECT *
FROM #Employees
WHERE City IN ('Pune', 'Delhi');


-- 13. Employees aged 22, 25 or 30.

SELECT *
FROM #Employees
WHERE Age IN (22, 25, 30);


-- 14. Employees earning exactly 45000, 55000 or 75000.

SELECT *
FROM #Employees
WHERE Salary IN (45000, 55000, 75000);


-- =========================================================
-- SECTION 7: NOT IN OPERATOR
-- =========================================================

-- NOT IN excludes the specified values.

-- 15. Employees who are not from IT or HR.

SELECT *
FROM #Employees
WHERE Department NOT IN ('IT', 'HR');


-- 16. Employees who do not live in Pune or Mumbai.

SELECT *
FROM #Employees
WHERE City NOT IN ('Pune', 'Mumbai');


-- 17. Employees whose age is not 22, 23 or 24.

SELECT *
FROM #Employees
WHERE Age NOT IN (22, 23, 24);


-- IMPORTANT:
-- NOT IN can produce unexpected results if its list
-- contains NULL. SQL comparisons involving NULL
-- evaluate to UNKNOWN.

-- Example:
-- WHERE DepartmentID NOT IN (1, 2, NULL)
-- will not return the expected remaining departments.


-- =========================================================
-- SECTION 8: BETWEEN OPERATOR
-- =========================================================

-- BETWEEN checks whether a value falls within a range.
-- Both boundary values are included.

-- 18. Employees earning between 50000 and 70000.

SELECT *
FROM #Employees
WHERE Salary BETWEEN 50000 AND 70000;


-- 19. Employees aged between 23 and 27.

SELECT *
FROM #Employees
WHERE Age BETWEEN 23 AND 27;


-- 20. Employees who joined between 2020 and 2022.

SELECT *
FROM #Employees
WHERE JoiningDate BETWEEN '2020-01-01' AND '2022-12-31';


-- =========================================================
-- SECTION 9: NOT BETWEEN OPERATOR
-- =========================================================

-- NOT BETWEEN excludes the specified range.

-- 21. Employees whose salary is outside 40000 to 60000.

SELECT *
FROM #Employees
WHERE Salary NOT BETWEEN 40000 AND 60000;


-- 22. Employees whose age is outside 23 to 28.

SELECT *
FROM #Employees
WHERE Age NOT BETWEEN 23 AND 28;


-- =========================================================
-- SECTION 10: LIKE OPERATOR
-- =========================================================

-- LIKE is used for pattern matching in text columns.

-- SQL Server wildcards:
--
-- %      = Zero or more characters
-- _      = Exactly one character
-- []     = Any one character from the specified set
-- [^]    = Any one character NOT in the specified set


-- 23. Names starting with 'A'.

SELECT *
FROM #Employees
WHERE EmployeeName LIKE 'A%';


-- 24. Names ending with 'a'.

SELECT *
FROM #Employees
WHERE EmployeeName LIKE '%a';


-- 25. Names containing 'an'.

SELECT *
FROM #Employees
WHERE EmployeeName LIKE '%an%';


-- 26. Names having exactly four characters.

SELECT *
FROM #Employees
WHERE EmployeeName LIKE '____';


-- 27. Names whose second character is 'a'.

SELECT *
FROM #Employees
WHERE EmployeeName LIKE '_a%';


-- =========================================================
-- SECTION 11: LIKE WITH BRACKET WILDCARDS
-- =========================================================

-- [] matches one character from a given set.

-- 28. Names starting with A, R or S.

SELECT *
FROM #Employees
WHERE EmployeeName LIKE '[ARS]%';


-- 29. Names starting with letters between A and M.

SELECT *
FROM #Employees
WHERE EmployeeName LIKE '[A-M]%';


-- 30. Names starting with any character except A or R.

SELECT *
FROM #Employees
WHERE EmployeeName LIKE '[^AR]%';


-- 31. Names whose first character is A
-- and second character is either m or n.

SELECT *
FROM #Employees
WHERE EmployeeName LIKE 'A[mn]%';


-- =========================================================
-- SECTION 12: NOT LIKE OPERATOR
-- =========================================================

-- NOT LIKE excludes a particular text pattern.

-- 32. Names that do not start with A.

SELECT *
FROM #Employees
WHERE EmployeeName NOT LIKE 'A%';


-- 33. Names that do not end with a.

SELECT *
FROM #Employees
WHERE EmployeeName NOT LIKE '%a';


-- 34. Names that do not contain 'an'.

SELECT *
FROM #Employees
WHERE EmployeeName NOT LIKE '%an%';


-- =========================================================
-- SECTION 13: COMBINING OPERATORS
-- =========================================================

-- 35. Employees from IT or HR earning more than 50000.

SELECT *
FROM #Employees
WHERE Department IN ('IT', 'HR')
AND Salary > 50000;


-- 36. Female employees from Pune or Mumbai.

SELECT *
FROM #Employees
WHERE Gender = 'Female'
AND City IN ('Pune', 'Mumbai');


-- 37. Employees earning between 40000 and 70000
-- and not belonging to HR.

SELECT *
FROM #Employees
WHERE Salary BETWEEN 40000 AND 70000
AND Department <> 'HR';


-- 38. Employees whose names start with A or R
-- and whose salary is above 50000.

SELECT *
FROM #Employees
WHERE
(
    EmployeeName LIKE 'A%'
    OR EmployeeName LIKE 'R%'
)
AND Salary > 50000;


-- 39. Employees who are not from IT or HR
-- and earn more than 50000.

SELECT *
FROM #Employees
WHERE Department NOT IN ('IT', 'HR')
AND Salary > 50000;


-- =========================================================
-- SECTION 14: OPERATOR PRECEDENCE
-- =========================================================

-- SQL Server evaluates NOT before AND, and AND before OR.

-- 40. Understand how this query is evaluated.

SELECT *
FROM #Employees
WHERE Department = 'IT'
OR Department = 'HR'
AND Salary > 60000;


-- The above query is interpreted as:

SELECT *
FROM #Employees
WHERE Department = 'IT'
OR
(
    Department = 'HR'
    AND Salary > 60000
);


-- If we want employees from IT or HR
-- who earn more than 60000, use parentheses.

SELECT *
FROM #Employees
WHERE
(
    Department = 'IT'
    OR Department = 'HR'
)
AND Salary > 60000;


-- =========================================================
-- SECTION 15: PRACTICE QUESTIONS
-- Solve these yourself before checking the solutions.
-- =========================================================

/*
Q1. Find employees from IT AND earning more than 60000.

Q2. Find employees from HR OR Finance.

Q3. Find employees who are NOT from Marketing.

Q4. Find employees belonging to IT, HR or Sales using IN.

Q5. Find employees who are NOT from IT, HR or Sales.

Q6. Find employees earning between 45000 and 75000.

Q7. Find employees whose salary is NOT between 50000 and 70000.

Q8. Find employees aged between 24 and 30.

Q9. Find employees whose names start with 'S'.

Q10. Find employees whose names end with 'a'.

Q11. Find employees whose names contain 'ar'.

Q12. Find employees whose names have exactly five characters.

Q13. Find employees whose second character is 'a'.

Q14. Find employees whose names start with A, K or R.

Q15. Find employees whose names do not start with A.

Q16. Find employees living in Pune, Mumbai or Delhi.

Q17. Find female employees earning between 40000 and 60000.

Q18. Find employees from IT or Finance who are older than 25.

Q19. Find employees whose email is NULL.

Q20. Find employees whose names start with A or S
     and whose salary is above 50000.

Q21. Find employees who are not from IT or HR
     and earn between 50000 and 80000.

Q22. Find employees who joined between
     2021-01-01 and 2023-12-31.

Q23. Find employees whose names start with a letter
     from A to M.

Q24. Find employees whose names do not contain 'a'.

Q25. Find employees who are either from HR
     or earn more than 80000, but exclude employees
     younger than 23.
*/


-- =========================================================
-- SECTION 16: SOLUTIONS
-- =========================================================

-- Q1
SELECT *
FROM #Employees
WHERE Department = 'IT'
AND Salary > 60000;


-- Q2
SELECT *
FROM #Employees
WHERE Department IN ('HR', 'Finance');


-- Q3
SELECT *
FROM #Employees
WHERE NOT Department = 'Marketing';


-- Q4
SELECT *
FROM #Employees
WHERE Department IN ('IT', 'HR', 'Sales');


-- Q5
SELECT *
FROM #Employees
WHERE Department NOT IN ('IT', 'HR', 'Sales');


-- Q6
SELECT *
FROM #Employees
WHERE Salary BETWEEN 45000 AND 75000;


-- Q7
SELECT *
FROM #Employees
WHERE Salary NOT BETWEEN 50000 AND 70000;


-- Q8
SELECT *
FROM #Employees
WHERE Age BETWEEN 24 AND 30;


-- Q9
SELECT *
FROM #Employees
WHERE EmployeeName LIKE 'S%';


-- Q10
SELECT *
FROM #Employees
WHERE EmployeeName LIKE '%a';


-- Q11
SELECT *
FROM #Employees
WHERE EmployeeName LIKE '%ar%';


-- Q12
SELECT *
FROM #Employees
WHERE EmployeeName LIKE '_____';


-- Q13
SELECT *
FROM #Employees
WHERE EmployeeName LIKE '_a%';


-- Q14
SELECT *
FROM #Employees
WHERE EmployeeName LIKE '[AKR]%';


-- Q15
SELECT *
FROM #Employees
WHERE EmployeeName NOT LIKE 'A%';


-- Q16
SELECT *
FROM #Employees
WHERE City IN ('Pune', 'Mumbai', 'Delhi');


-- Q17
SELECT *
FROM #Employees
WHERE Gender = 'Female'
AND Salary BETWEEN 40000 AND 60000;


-- Q18
SELECT *
FROM #Employees
WHERE Department IN ('IT', 'Finance')
AND Age > 25;


-- Q19
SELECT *
FROM #Employees
WHERE Email IS NULL;


-- Q20
SELECT *
FROM #Employees
WHERE
(
    EmployeeName LIKE 'A%'
    OR EmployeeName LIKE 'S%'
)
AND Salary > 50000;


-- Q21
SELECT *
FROM #Employees
WHERE Department NOT IN ('IT', 'HR')
AND Salary BETWEEN 50000 AND 80000;


-- Q22
SELECT *
FROM #Employees
WHERE JoiningDate BETWEEN '2021-01-01' AND '2023-12-31';


-- Q23
SELECT *
FROM #Employees
WHERE EmployeeName LIKE '[A-M]%';


-- Q24
SELECT *
FROM #Employees
WHERE EmployeeName NOT LIKE '%a%';


-- Q25
SELECT *
FROM #Employees
WHERE
(
    Department = 'HR'
    OR Salary > 80000
)
AND Age >= 23;


-- =========================================================
-- SECTION 17: QUICK REVISION
-- =========================================================

/*
AND          -> All conditions must be TRUE.
OR           -> At least one condition must be TRUE.
NOT          -> Reverses a condition.
IN           -> Matches any value from a list.
NOT IN       -> Excludes values from a list.
BETWEEN      -> Checks an inclusive range.
NOT BETWEEN -> Excludes an inclusive range.
LIKE         -> Searches for a text pattern.
NOT LIKE     -> Excludes a text pattern.

LIKE WILDCARDS:

%            -> Zero or more characters.
_            -> Exactly one character.
[]           -> One character from a specified set.
[^]          -> One character outside a specified set.

Important:
BETWEEN includes both boundary values.
AND has higher precedence than OR.
Use parentheses to make combined conditions clear.
NOT IN requires special care when the list contains NULL.
NULL values need IS NULL or IS NOT NULL.

============================================================
END OF PRACTICE FILE
============================================================
*/