/*
============================================================
SQL PRACTICE 01: SELECT AND WHERE CLAUSE
Platform: Microsoft SQL Server (T-SQL)
Level: Beginner to Intermediate

Topics:
1. SELECT statement
2. Selecting specific columns
3. Column aliases
4. DISTINCT
5. TOP
6. WHERE clause
7. Comparison operators
8. Text, numeric and date filtering
9. NULL and NOT NULL

Note:
We are using temporary tables (#Employees and #Departments).
They exist only for your current SQL Server session.
============================================================
*/


-- =========================================================
-- SECTION 1: CREATE SAMPLE TABLES
-- =========================================================

CREATE TABLE #Departments
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL,
    Location VARCHAR(50)
);


CREATE TABLE #Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    Age INT,
    Gender VARCHAR(10),
    Salary DECIMAL(10,2),
    DepartmentID INT,
    JoiningDate DATE,
    Email VARCHAR(100),

    FOREIGN KEY (DepartmentID)
        REFERENCES #Departments(DepartmentID)
);


-- =========================================================
-- SECTION 2: INSERT SAMPLE DATA
-- =========================================================

INSERT INTO #Departments
(DepartmentID, DepartmentName, Location)
VALUES
(1, 'IT', 'Pune'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Nagpur'),
(4, 'Marketing', 'Hyderabad'),
(5, 'Sales', 'Delhi');


INSERT INTO #Employees
(EmployeeID, EmployeeName, Age, Gender, Salary,
 DepartmentID, JoiningDate, Email)
VALUES
(101, 'Rahul', 24, 'Male', 55000, 1, '2022-01-15', 'rahul@gmail.com'),
(102, 'Priya', 23, 'Female', 45000, 2, '2023-03-10', 'priya@gmail.com'),
(103, 'Amit', 28, 'Male', 65000, 1, '2021-06-20', 'amit@gmail.com'),
(104, 'Sneha', 25, 'Female', 60000, 3, '2020-11-05', 'sneha@gmail.com'),
(105, 'Neha', 24, 'Female', 50000, 2, '2022-08-12', 'neha@gmail.com'),
(106, 'Karan', 30, 'Male', 75000, 4, '2019-04-18', 'karan@gmail.com'),
(107, 'Pooja', 27, 'Female', 70000, 1, '2021-09-25', 'pooja@gmail.com'),
(108, 'Rohan', 22, 'Male', 35000, 5, '2024-01-08', 'rohan@gmail.com'),
(109, 'Anjali', 26, 'Female', 58000, 3, '2022-05-14', NULL),
(110, 'Varun', 29, 'Male', 80000, 4, '2018-12-01', 'varun@gmail.com'),
(111, 'Meera', 23, 'Female', 42000, 2, '2023-07-19', NULL),
(112, 'Arjun', 31, 'Male', 90000, 1, '2017-02-11', 'arjun@gmail.com'),
(113, 'Kavya', 25, 'Female', 55000, 5, '2021-10-30', 'kavya@gmail.com'),
(114, 'Nikhil', 27, 'Male', 62000, 3, '2020-03-22', 'nikhil@gmail.com'),
(115, 'Isha', 22, 'Female', 38000, 5, '2024-06-15', 'isha@gmail.com'),
(116, 'Manish', 32, 'Male', 85000, 1, '2016-08-09', 'manish@gmail.com'),
(117, 'Riya', 24, 'Female', 48000, 2, '2022-12-17', NULL),
(118, 'Sahil', 28, 'Male', 72000, 4, '2019-07-21', 'sahil@gmail.com'),
(119, 'Tina', 26, 'Female', 51000, 3, '2023-02-03', 'tina@gmail.com'),
(120, 'Dev', 30, 'Male', 67000, 1, '2020-09-13', 'dev@gmail.com');


-- =========================================================
-- SECTION 3: CHECK THE SAMPLE DATA
-- =========================================================

SELECT * FROM #Departments;

SELECT * FROM #Employees;


-- =========================================================
-- SECTION 4: BASIC SELECT QUERIES
-- =========================================================

-- 1. Retrieve all columns and rows.

SELECT *
FROM #Employees;


-- 2. Retrieve only employee names.

SELECT EmployeeName
FROM #Employees;


-- 3. Retrieve employee names and salaries.

SELECT EmployeeName, Salary
FROM #Employees;


-- 4. Retrieve employee ID, name, age and department ID.

SELECT EmployeeID, EmployeeName, Age, DepartmentID
FROM #Employees;


-- 5. Display employee names with meaningful column headings.

SELECT
    EmployeeName AS [Employee Name],
    Salary AS [Monthly Salary]
FROM #Employees;


-- 6. Display department names and locations.

SELECT DepartmentName, Location
FROM #Departments;


-- =========================================================
-- SECTION 5: DISTINCT
-- =========================================================

-- 7. Find all unique department IDs.

SELECT DISTINCT DepartmentID
FROM #Employees;


-- 8. Find all unique genders.

SELECT DISTINCT Gender
FROM #Employees;


-- 9. Find unique combinations of department and gender.

SELECT DISTINCT DepartmentID, Gender
FROM #Employees;


-- 10. Find all unique employee ages.

SELECT DISTINCT Age
FROM #Employees;


-- =========================================================
-- SECTION 6: TOP
-- =========================================================

-- 11. Retrieve the first five rows.
-- Without ORDER BY, the selected rows are not guaranteed.

SELECT TOP (5) *
FROM #Employees;


-- 12. Retrieve the five highest-paid employees.

SELECT TOP (5)
    EmployeeName,
    Salary
FROM #Employees
ORDER BY Salary DESC;


-- 13. Retrieve the three youngest employees.

SELECT TOP (3)
    EmployeeName,
    Age
FROM #Employees
ORDER BY Age ASC;


-- 14. Retrieve the top 25 percent of employees by salary.

SELECT TOP (25) PERCENT
    EmployeeName,
    Salary
FROM #Employees
ORDER BY Salary DESC;


-- 15. Retrieve the top three salary values, including ties.

SELECT TOP (3) WITH TIES
    EmployeeName,
    Salary
FROM #Employees
ORDER BY Salary DESC;


-- =========================================================
-- SECTION 7: WHERE - COMPARISON OPERATORS
-- =========================================================

-- 16. Equal to (=)
-- Find employees belonging to Department 1.

SELECT *
FROM #Employees
WHERE DepartmentID = 1;


-- 17. Not equal to (<>)
-- Find employees who do not belong to Department 1.

SELECT *
FROM #Employees
WHERE DepartmentID <> 1;


-- 18. Not equal to (!=)
-- Same result as <> in SQL Server.

SELECT *
FROM #Employees
WHERE DepartmentID != 1;


-- 19. Greater than (>)
-- Find employees earning more than 60000.

SELECT *
FROM #Employees
WHERE Salary > 60000;


-- 20. Less than (<)
-- Find employees earning less than 50000.

SELECT *
FROM #Employees
WHERE Salary < 50000;


-- 21. Greater than or equal to (>=)
-- Find employees aged 25 or above.

SELECT *
FROM #Employees
WHERE Age >= 25;


-- 22. Less than or equal to (<=)
-- Find employees aged 25 or below.

SELECT *
FROM #Employees
WHERE Age <= 25;


-- =========================================================
-- SECTION 8: FILTERING TEXT VALUES
-- =========================================================

-- 23. Find the employee named Rahul.

SELECT *
FROM #Employees
WHERE EmployeeName = 'Rahul';


-- 24. Find employees belonging to the IT department.

SELECT *
FROM #Employees
WHERE DepartmentID = 1;


-- 25. Find employees whose gender is Female.

SELECT *
FROM #Employees
WHERE Gender = 'Female';


-- 26. Find employees whose gender is not Male.

SELECT *
FROM #Employees
WHERE Gender <> 'Male';


-- =========================================================
-- SECTION 9: FILTERING NUMERIC VALUES
-- =========================================================

-- 27. Find employees earning exactly 55000.

SELECT *
FROM #Employees
WHERE Salary = 55000;


-- 28. Find employees earning at least 60000.

SELECT *
FROM #Employees
WHERE Salary >= 60000;


-- 29. Find employees aged between 25 and 30
-- using comparison operators.

SELECT *
FROM #Employees
WHERE Age >= 25 AND Age <= 30;


-- 30. Find employees whose salary is not equal to 50000.

SELECT *
FROM #Employees
WHERE Salary <> 50000;


-- =========================================================
-- SECTION 10: FILTERING DATE VALUES
-- =========================================================

-- 31. Find employees who joined after 2022-01-01.

SELECT *
FROM #Employees
WHERE JoiningDate > '2022-01-01';


-- 32. Find employees who joined before 2021-01-01.

SELECT *
FROM #Employees
WHERE JoiningDate < '2021-01-01';


-- 33. Find employees who joined on 2022-01-15.

SELECT *
FROM #Employees
WHERE JoiningDate = '2022-01-15';


-- 34. Find employees who joined on or after 2023-01-01.

SELECT *
FROM #Employees
WHERE JoiningDate >= '2023-01-01';


-- =========================================================
-- SECTION 11: NULL FILTERING
-- =========================================================

-- 35. Find employees whose email is missing.

SELECT *
FROM #Employees
WHERE Email IS NULL;


-- 36. Find employees whose email is available.

SELECT *
FROM #Employees
WHERE Email IS NOT NULL;


-- 37. Count employees with missing email addresses.

SELECT COUNT(*) AS MissingEmailCount
FROM #Employees
WHERE Email IS NULL;


-- =========================================================
-- SECTION 12: COMBINING CONDITIONS
-- =========================================================

-- 38. Employees earning more than 50000
-- AND belonging to Department 1.

SELECT *
FROM #Employees
WHERE Salary > 50000
AND DepartmentID = 1;


-- 39. Employees belonging to Department 1 OR Department 2.

SELECT *
FROM #Employees
WHERE DepartmentID = 1
OR DepartmentID = 2;


-- 40. Employees who are Female AND earn more than 50000.

SELECT *
FROM #Employees
WHERE Gender = 'Female'
AND Salary > 50000;


-- 41. Employees who are either younger than 25
-- OR earning more than 70000.

SELECT *
FROM #Employees
WHERE Age < 25
OR Salary > 70000;


-- 42. Employees from Department 1 or 2
-- who earn more than 50000.

SELECT *
FROM #Employees
WHERE
(
    DepartmentID = 1
    OR DepartmentID = 2
)
AND Salary > 50000;


-- =========================================================
-- SECTION 13: PRACTICE QUESTIONS
-- Try these yourself before looking at the solutions.
-- =========================================================

/*
Q1. Display all columns from the Employees table.

Q2. Display only EmployeeName, Age and Salary.

Q3. Display EmployeeName as Name and Salary as Income.

Q4. Find all unique DepartmentIDs.

Q5. Find all unique combinations of Gender and DepartmentID.

Q6. Display the five employees with the highest salaries.

Q7. Find employees earning exactly 55000.

Q8. Find employees earning more than 45000.

Q9. Find employees earning less than or equal to 50000.

Q10. Find employees who are not from Department 2.

Q11. Find employees whose age is greater than 25.

Q12. Find female employees.

Q13. Find employees who joined after 2021-01-01.

Q14. Find employees whose email is NULL.

Q15. Find employees whose email is NOT NULL.

Q16. Find employees earning more than 50000
     and aged above 25.

Q17. Find employees from Department 3 or Department 4.

Q18. Find employees who are Female OR earn more than 80000.

Q19. Find the three youngest employees.

Q20. Find employees who joined between 2020-01-01
     and 2022-12-31, including both dates.
*/


-- =========================================================
-- SECTION 14: SOLUTIONS TO PRACTICE QUESTIONS
-- Try solving Section 13 first!
-- =========================================================

-- Q1
SELECT *
FROM #Employees;

-- Q2
SELECT EmployeeName, Age, Salary
FROM #Employees;

-- Q3
SELECT
    EmployeeName AS Name,
    Salary AS Income
FROM #Employees;

-- Q4
SELECT DISTINCT DepartmentID
FROM #Employees;

-- Q5
SELECT DISTINCT Gender, DepartmentID
FROM #Employees;

-- Q6
SELECT TOP (5) *
FROM #Employees
ORDER BY Salary DESC;

-- Q7
SELECT *
FROM #Employees
WHERE Salary = 55000;

-- Q8
SELECT *
FROM #Employees
WHERE Salary > 45000;

-- Q9
SELECT *
FROM #Employees
WHERE Salary <= 50000;

-- Q10
SELECT *
FROM #Employees
WHERE DepartmentID <> 2;

-- Q11
SELECT *
FROM #Employees
WHERE Age > 25;

-- Q12
SELECT *
FROM #Employees
WHERE Gender = 'Female';

-- Q13
SELECT *
FROM #Employees
WHERE JoiningDate > '2021-01-01';

-- Q14
SELECT *
FROM #Employees
WHERE Email IS NULL;

-- Q15
SELECT *
FROM #Employees
WHERE Email IS NOT NULL;

-- Q16
SELECT *
FROM #Employees
WHERE Salary > 50000
AND Age > 25;

-- Q17
SELECT *
FROM #Employees
WHERE DepartmentID = 3
OR DepartmentID = 4;

-- Q18
SELECT *
FROM #Employees
WHERE Gender = 'Female'
OR Salary > 80000;

-- Q19
SELECT TOP (3) *
FROM #Employees
ORDER BY Age ASC, EmployeeID ASC;

-- Q20
SELECT *
FROM #Employees
WHERE JoiningDate >= '2020-01-01'
AND JoiningDate < '2023-01-01';


-- =========================================================
-- END OF PRACTICE FILE
-- =========================================================

/*
What I practised:
- Retrieving all and selected columns
- Using aliases
- Removing duplicate results
- Limiting rows with TOP
- Filtering data using WHERE
- Applying comparison operators
- Filtering numeric, text and date values
- Handling NULL values
- Combining conditions

My next step:
Practise AND, OR, NOT, IN, BETWEEN and LIKE
with separate SQL exercises.
*/