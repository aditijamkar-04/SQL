/*
============================================================
SQL PRACTICE 01: INNER, LEFT, RIGHT AND FULL OUTER JOIN

Topics:
1. Understanding table relationships
2. Primary Key and Foreign Key
3. INNER JOIN
4. LEFT JOIN
5. RIGHT JOIN
6. FULL OUTER JOIN
7. JOIN with aliases
8. ON vs WHERE
9. Finding unmatched records
10. Multiple table joins
11. Practical business problems
12. Interview questions and solutions
============================================================
*/


-- =========================================================
-- SECTION 1: UNDERSTANDING TABLE RELATIONSHIPS
-- =========================================================

/*
Suppose a company has two tables:

Employees:
EmployeeID | EmployeeName | DepartmentID

Departments:
DepartmentID | DepartmentName

Relationship:

Employees.DepartmentID = Departments.DepartmentID

DepartmentID in Departments is the PRIMARY KEY.
DepartmentID in Employees is the FOREIGN KEY.

One department can have multiple employees.

This is a ONE-TO-MANY relationship.
*/


-- =========================================================
-- SECTION 2: CREATE SAMPLE TABLES
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
    DepartmentID INT NULL,
    Salary DECIMAL(10,2)
);


INSERT INTO #Departments
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Marketing'),
(5, 'Sales'),
(6, 'Operations');


INSERT INTO #Employees
VALUES
(101, 'Rahul', 1, 55000),
(102, 'Priya', 2, 45000),
(103, 'Amit', 1, 65000),
(104, 'Sneha', 3, 60000),
(105, 'Neha', 2, 50000),
(106, 'Karan', 4, 75000),
(107, 'Pooja', 1, 70000),
(108, 'Rohan', 5, 35000),
(109, 'Anjali', 3, 58000),
(110, 'Varun', NULL, 80000),
(111, 'Meera', 1, 62000),
(112, 'Arjun', NULL, 42000);


SELECT *
FROM #Employees;


SELECT *
FROM #Departments;


-- =========================================================
-- SECTION 3: INNER JOIN
-- =========================================================

-- INNER JOIN returns only matching records from both tables.

-- Syntax:

-- SELECT columns
-- FROM Table1
-- INNER JOIN Table2
-- ON Table1.CommonColumn = Table2.CommonColumn;


-- Example 1: Display employee names with department names.

SELECT
    E.EmployeeID,
    E.EmployeeName,
    D.DepartmentName
FROM #Employees AS E
INNER JOIN #Departments AS D
    ON E.DepartmentID = D.DepartmentID;


-- Example 2: Display employee details and salary
-- along with their department.

SELECT
    E.EmployeeID,
    E.EmployeeName,
    E.Salary,
    D.DepartmentName
FROM #Employees AS E
INNER JOIN #Departments AS D
    ON E.DepartmentID = D.DepartmentID;


-- Example 3: Find employees working in IT.

SELECT
    E.EmployeeName,
    D.DepartmentName
FROM #Employees AS E
INNER JOIN #Departments AS D
    ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'IT';


-- Example 4: Find employees earning more than 60000
-- and display their department names.

SELECT
    E.EmployeeName,
    E.Salary,
    D.DepartmentName
FROM #Employees AS E
INNER JOIN #Departments AS D
    ON E.DepartmentID = D.DepartmentID
WHERE E.Salary > 60000;


-- =========================================================
-- SECTION 4: LEFT JOIN
-- =========================================================

-- LEFT JOIN returns:
-- 1. All rows from the LEFT table.
-- 2. Matching rows from the RIGHT table.
-- 3. If no match exists, right-side columns contain NULL.

-- Example 1: Display all employees and their departments.

SELECT
    E.EmployeeID,
    E.EmployeeName,
    D.DepartmentName
FROM #Employees AS E
LEFT JOIN #Departments AS D
    ON E.DepartmentID = D.DepartmentID;


-- Example 2: Find employees who do not belong
-- to any department.

SELECT
    E.EmployeeID,
    E.EmployeeName,
    E.DepartmentID
FROM #Employees AS E
LEFT JOIN #Departments AS D
    ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentID IS NULL;


-- Example 3: Display all employees earning above 60000,
-- including their department names when available.

SELECT
    E.EmployeeName,
    E.Salary,
    D.DepartmentName
FROM #Employees AS E
LEFT JOIN #Departments AS D
    ON E.DepartmentID = D.DepartmentID
WHERE E.Salary > 60000;


-- =========================================================
-- SECTION 5: RIGHT JOIN
-- =========================================================

-- RIGHT JOIN returns:
-- 1. All rows from the RIGHT table.
-- 2. Matching rows from the LEFT table.
-- 3. If no match exists, left-side columns contain NULL.

-- Example 1: Display all departments and their employees.

SELECT
    E.EmployeeName,
    D.DepartmentID,
    D.DepartmentName
FROM #Employees AS E
RIGHT JOIN #Departments AS D
    ON E.DepartmentID = D.DepartmentID;


-- Example 2: Find departments that have no employees.

SELECT
    D.DepartmentID,
    D.DepartmentName
FROM #Employees AS E
RIGHT JOIN #Departments AS D
    ON E.DepartmentID = D.DepartmentID
WHERE E.EmployeeID IS NULL;


-- =========================================================
-- SECTION 6: FULL OUTER JOIN
-- =========================================================

-- FULL OUTER JOIN returns:
-- 1. Matching rows from both tables.
-- 2. Unmatched rows from the left table.
-- 3. Unmatched rows from the right table.
-- Missing-side columns contain NULL.

SELECT
    E.EmployeeID,
    E.EmployeeName,
    E.DepartmentID AS EmployeeDepartmentID,
    D.DepartmentID AS DepartmentTableID,
    D.DepartmentName
FROM #Employees AS E
FULL OUTER JOIN #Departments AS D
    ON E.DepartmentID = D.DepartmentID;


-- Example: Display only unmatched records from either table.

SELECT
    E.EmployeeID,
    E.EmployeeName,
    D.DepartmentID,
    D.DepartmentName
FROM #Employees AS E
FULL OUTER JOIN #Departments AS D
    ON E.DepartmentID = D.DepartmentID
WHERE E.EmployeeID IS NULL
   OR D.DepartmentID IS NULL;


-- =========================================================
-- SECTION 7: JOIN WITH ALIASES
-- =========================================================

-- Aliases make queries shorter and easier to read.

SELECT
    E.EmployeeName AS Employee,
    D.DepartmentName AS Department,
    E.Salary AS MonthlySalary
FROM #Employees E
INNER JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID;


-- =========================================================
-- SECTION 8: ON VS WHERE IN JOINS
-- =========================================================

-- Example 1:
-- Filter department rows through the ON condition.

SELECT
    E.EmployeeName,
    D.DepartmentName
FROM #Employees E
LEFT JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID
   AND D.DepartmentName = 'IT';


-- Example 2:
-- Filter the final result using WHERE.

SELECT
    E.EmployeeName,
    D.DepartmentName
FROM #Employees E
LEFT JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'IT';


/*
IMPORTANT DIFFERENCE:

In Example 1:
All employees remain in the result.
Only IT departments can match.
Employees without an IT match show NULL for DepartmentName.

In Example 2:
Only employees whose matched department is IT remain.
The WHERE condition removes rows where DepartmentName is NULL.

For INNER JOIN, moving a simple filter between ON and WHERE
usually produces the same result.

For OUTER JOINs, ON and WHERE can produce different results.
*/


-- =========================================================
-- SECTION 9: MULTIPLE CONDITIONS IN JOIN
-- =========================================================

-- We can use more than one condition in ON.

SELECT
    E.EmployeeName,
    E.Salary,
    D.DepartmentName
FROM #Employees E
INNER JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID
   AND E.Salary > 50000;


-- =========================================================
-- SECTION 10: JOIN WITH AGGREGATE FUNCTIONS
-- =========================================================

-- Find the number of employees in each department.

SELECT
    D.DepartmentName,
    COUNT(E.EmployeeID) AS TotalEmployees
FROM #Departments D
LEFT JOIN #Employees E
    ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName;


-- Find total salary in each department.

SELECT
    D.DepartmentName,
    ISNULL(SUM(E.Salary), 0) AS TotalSalary
FROM #Departments D
LEFT JOIN #Employees E
    ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName;


-- Find average salary in each department.

SELECT
    D.DepartmentName,
    AVG(E.Salary) AS AverageSalary
FROM #Departments D
LEFT JOIN #Employees E
    ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName;


-- =========================================================
-- SECTION 11: IMPORTANT JOIN DIFFERENCES
-- =========================================================

/*
INNER JOIN:
Only matching rows from both tables.

LEFT JOIN:
All left-table rows + matching right-table rows.

RIGHT JOIN:
All right-table rows + matching left-table rows.

FULL OUTER JOIN:
All rows from both tables, whether matching or not.

IMPORTANT:
A NULL result in a joined column can indicate that
no matching record was found. However, a matched row
may also contain NULL in that column if the original
column itself allows NULL values.
*/


-- =========================================================
-- SECTION 12: PRACTICE QUESTIONS
-- =========================================================

/*
Q1. Display employee names with their department names
    using INNER JOIN.

Q2. Display all employees and their department names
    using LEFT JOIN.

Q3. Display all departments and their employees
    using RIGHT JOIN.

Q4. Display all records from both tables using FULL OUTER JOIN.

Q5. Find employees who do not have a matching department.

Q6. Find departments that do not have any employees.

Q7. Display employees working in the IT department.

Q8. Display employees earning more than 60000
    along with their department names.

Q9. Find the total number of employees in each department.
    Include departments having zero employees.

Q10. Find the total salary paid by each department.
     Include departments having zero employees.

Q11. Find the average salary of each department.

Q12. Display employees working in HR or Finance.

Q13. Find employees whose salary is between 40000 and 70000.
     Display their department names.

Q14. Display all employees, but match only IT department records
     in the LEFT JOIN condition.

Q15. Find all unmatched records from both tables.

Q16. Find the department with the highest number of employees.

Q17. Find departments where total salary is greater than 100000.

Q18. Display all departments and employee counts,
     sorted by employee count in descending order.

Q19. Display employees who belong to the Finance department
     and earn more than 55000.

Q20. Find the departments that have no employees
     using LEFT JOIN instead of RIGHT JOIN.
*/


-- =========================================================
-- SECTION 13: SOLUTIONS
-- =========================================================

-- Q1
SELECT E.EmployeeName, D.DepartmentName
FROM #Employees E
INNER JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID;


-- Q2
SELECT E.EmployeeName, D.DepartmentName
FROM #Employees E
LEFT JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID;


-- Q3
SELECT E.EmployeeName, D.DepartmentName
FROM #Employees E
RIGHT JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID;


-- Q4
SELECT E.EmployeeName, D.DepartmentName
FROM #Employees E
FULL OUTER JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID;


-- Q5
SELECT E.EmployeeID, E.EmployeeName
FROM #Employees E
LEFT JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentID IS NULL;


-- Q6
SELECT D.DepartmentID, D.DepartmentName
FROM #Departments D
LEFT JOIN #Employees E
    ON D.DepartmentID = E.DepartmentID
WHERE E.EmployeeID IS NULL;


-- Q7
SELECT E.EmployeeName, D.DepartmentName
FROM #Employees E
INNER JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'IT';


-- Q8
SELECT E.EmployeeName, E.Salary, D.DepartmentName
FROM #Employees E
INNER JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID
WHERE E.Salary > 60000;


-- Q9
SELECT
    D.DepartmentName,
    COUNT(E.EmployeeID) AS TotalEmployees
FROM #Departments D
LEFT JOIN #Employees E
    ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName;


-- Q10
SELECT
    D.DepartmentName,
    ISNULL(SUM(E.Salary), 0) AS TotalSalary
FROM #Departments D
LEFT JOIN #Employees E
    ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName;


-- Q11
SELECT
    D.DepartmentName,
    AVG(E.Salary) AS AverageSalary
FROM #Departments D
LEFT JOIN #Employees E
    ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName;


-- Q12
SELECT E.EmployeeName, D.DepartmentName
FROM #Employees E
INNER JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName IN ('HR', 'Finance');


-- Q13
SELECT E.EmployeeName, E.Salary, D.DepartmentName
FROM #Employees E
INNER JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID
WHERE E.Salary BETWEEN 40000 AND 70000;


-- Q14
SELECT E.EmployeeName, D.DepartmentName
FROM #Employees E
LEFT JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID
   AND D.DepartmentName = 'IT';


-- Q15
SELECT E.EmployeeName, D.DepartmentName
FROM #Employees E
FULL OUTER JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID
WHERE E.EmployeeID IS NULL
   OR D.DepartmentID IS NULL;


-- Q16
SELECT TOP 1 WITH TIES
    D.DepartmentName,
    COUNT(E.EmployeeID) AS TotalEmployees
FROM #Departments D
LEFT JOIN #Employees E
    ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName
ORDER BY COUNT(E.EmployeeID) DESC;


-- Q17
SELECT
    D.DepartmentName,
    SUM(E.Salary) AS TotalSalary
FROM #Departments D
INNER JOIN #Employees E
    ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName
HAVING SUM(E.Salary) > 100000;


-- Q18
SELECT
    D.DepartmentName,
    COUNT(E.EmployeeID) AS TotalEmployees
FROM #Departments D
LEFT JOIN #Employees E
    ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName
ORDER BY TotalEmployees DESC;


-- Q19
SELECT E.EmployeeName, E.Salary, D.DepartmentName
FROM #Employees E
INNER JOIN #Departments D
    ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Finance'
  AND E.Salary > 55000;


-- Q20
SELECT D.DepartmentName
FROM #Departments D
LEFT JOIN #Employees E
    ON D.DepartmentID = E.DepartmentID
WHERE E.EmployeeID IS NULL;


-- =========================================================
-- SECTION 14: INTERVIEW QUICK REVISION
-- =========================================================

/*
1. What is a JOIN?
   A JOIN combines related records from two or more tables.

2. What is INNER JOIN?
   Returns only matching records from both tables.

3. What is LEFT JOIN?
   Returns all records from the left table and matching
   records from the right table.

4. What is RIGHT JOIN?
   Returns all records from the right table and matching
   records from the left table.

5. What is FULL OUTER JOIN?
   Returns matching and unmatched records from both tables.

6. How do you find unmatched records?
   Use an OUTER JOIN and check a non-NULL key from the
   opposite table using IS NULL.

7. What is the difference between ON and WHERE?
   ON specifies how tables match.
   WHERE filters rows from the resulting query.

8. Can we join more than two tables?
   Yes. We can join multiple tables in one query.

9. What is an alias?
   A temporary name given to a table or column in a query.

10. Why use LEFT JOIN to find departments without employees?
    It preserves all departments and gives NULL for
    employees where no match exists.

IMPORTANT INTERVIEW TIP:
When counting employees after a LEFT JOIN, use
COUNT(EmployeeID), not COUNT(*).

COUNT(*) also counts the preserved department row
when there is no matching employee.

============================================================
END OF PRACTICE FILE
============================================================
*/