/*
============================================================
SQL PRACTICE 02: SELF JOIN AND CROSS JOIN

Topics:
1. SELF JOIN
2. Employee-manager relationship
3. Joining a table with itself
4. INNER SELF JOIN
5. LEFT SELF JOIN
6. CROSS JOIN
7. Cartesian product
8. Practical business examples
9. Interview questions and solutions
============================================================
*/


-- =========================================================
-- SECTION 1: CREATE EMPLOYEE TABLE
-- =========================================================

DROP TABLE IF EXISTS #Employees;

CREATE TABLE #Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    ManagerID INT NULL,
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);


INSERT INTO #Employees
VALUES
(101, 'Rahul', NULL, 'IT', 90000),
(102, 'Priya', 101, 'IT', 60000),
(103, 'Amit', 101, 'IT', 65000),
(104, 'Sneha', 102, 'HR', 55000),
(105, 'Neha', 102, 'HR', 50000),
(106, 'Karan', 103, 'IT', 70000),
(107, 'Pooja', 103, 'Finance', 58000),
(108, 'Rohan', 101, 'Sales', 45000),
(109, 'Anjali', 104, 'HR', 52000),
(110, 'Varun', NULL, 'Finance', 85000);


SELECT *
FROM #Employees;


-- =========================================================
-- SECTION 2: UNDERSTANDING SELF JOIN
-- =========================================================

/*
SELF JOIN means joining a table with itself.

Why do we need it?

Suppose an Employee table contains:

EmployeeID | EmployeeName | ManagerID

Here:
EmployeeID identifies an employee.
ManagerID stores the EmployeeID of that employee's manager.

Both employees and managers are stored in the same table.

To display an employee's manager name,
we join the Employees table with itself.

We use different aliases:

E = Employee
M = Manager
*/


-- =========================================================
-- SECTION 3: BASIC SELF JOIN
-- =========================================================

-- Display employee names with their manager names.

SELECT
    E.EmployeeName AS EmployeeName,
    M.EmployeeName AS ManagerName
FROM #Employees E
INNER JOIN #Employees M
    ON E.ManagerID = M.EmployeeID;


-- Explanation:
-- E represents the employee.
-- M represents the manager.
-- E.ManagerID matches M.EmployeeID.


-- =========================================================
-- SECTION 4: LEFT SELF JOIN
-- =========================================================

-- Display all employees, including those without managers.

SELECT
    E.EmployeeID,
    E.EmployeeName AS EmployeeName,
    M.EmployeeName AS ManagerName
FROM #Employees E
LEFT JOIN #Employees M
    ON E.ManagerID = M.EmployeeID;


-- Find employees who do not have a manager.

SELECT
    E.EmployeeID,
    E.EmployeeName
FROM #Employees E
LEFT JOIN #Employees M
    ON E.ManagerID = M.EmployeeID
WHERE M.EmployeeID IS NULL;


-- =========================================================
-- SECTION 5: SELF JOIN WITH CONDITIONS
-- =========================================================

-- Find employees whose salary is greater than their manager's salary.

SELECT
    E.EmployeeName AS EmployeeName,
    E.Salary AS EmployeeSalary,
    M.EmployeeName AS ManagerName,
    M.Salary AS ManagerSalary
FROM #Employees E
INNER JOIN #Employees M
    ON E.ManagerID = M.EmployeeID
WHERE E.Salary > M.Salary;


-- Find employees and their managers
-- who work in the same department.

SELECT
    E.EmployeeName AS EmployeeName,
    M.EmployeeName AS ManagerName,
    E.Department
FROM #Employees E
INNER JOIN #Employees M
    ON E.ManagerID = M.EmployeeID
WHERE E.Department = M.Department;


-- Find employees whose manager earns more than 70000.

SELECT
    E.EmployeeName AS EmployeeName,
    M.EmployeeName AS ManagerName,
    M.Salary AS ManagerSalary
FROM #Employees E
INNER JOIN #Employees M
    ON E.ManagerID = M.EmployeeID
WHERE M.Salary > 70000;


-- =========================================================
-- SECTION 6: SELF JOIN TO FIND RELATED RECORDS
-- =========================================================

-- Find pairs of employees working in the same department.

-- E.EmployeeID < E2.EmployeeID avoids duplicate pairs
-- and prevents an employee from matching themselves.

SELECT
    E.EmployeeName AS Employee1,
    E2.EmployeeName AS Employee2,
    E.Department
FROM #Employees E
INNER JOIN #Employees E2
    ON E.Department = E2.Department
   AND E.EmployeeID < E2.EmployeeID;


-- Find employees who earn the same salary.

SELECT
    E.EmployeeName AS Employee1,
    E2.EmployeeName AS Employee2,
    E.Salary
FROM #Employees E
INNER JOIN #Employees E2
    ON E.Salary = E2.Salary
   AND E.EmployeeID < E2.EmployeeID;


-- =========================================================
-- SECTION 7: INTRODUCTION TO CROSS JOIN
-- =========================================================

/*
CROSS JOIN combines every row from the first table
with every row from the second table.

It does not require an ON condition.

Example:

Table A has 3 rows.
Table B has 4 rows.

Result = 3 * 4 = 12 rows.

This is called a CARTESIAN PRODUCT.
*/


-- =========================================================
-- SECTION 8: CREATE SAMPLE TABLES FOR CROSS JOIN
-- =========================================================

DROP TABLE IF EXISTS #Products;
DROP TABLE IF EXISTS #Sizes;


CREATE TABLE #Products
(
    ProductID INT,
    ProductName VARCHAR(100)
);


CREATE TABLE #Sizes
(
    SizeID INT,
    SizeName VARCHAR(20)
);


INSERT INTO #Products
VALUES
(1, 'T-Shirt'),
(2, 'Shirt'),
(3, 'Jacket');


INSERT INTO #Sizes
VALUES
(1, 'Small'),
(2, 'Medium'),
(3, 'Large'),
(4, 'XL');


SELECT *
FROM #Products;


SELECT *
FROM #Sizes;


-- =========================================================
-- SECTION 9: BASIC CROSS JOIN
-- =========================================================

-- Generate all product and size combinations.

SELECT
    P.ProductName,
    S.SizeName
FROM #Products P
CROSS JOIN #Sizes S;


-- Number of rows in the result:

-- Products = 3
-- Sizes = 4
-- Total combinations = 3 * 4 = 12


-- =========================================================
-- SECTION 10: CROSS JOIN WITH MULTIPLE TABLES
-- =========================================================

DROP TABLE IF EXISTS #Colors;


CREATE TABLE #Colors
(
    ColorID INT,
    ColorName VARCHAR(30)
);


INSERT INTO #Colors
VALUES
(1, 'Red'),
(2, 'Blue');


-- Generate every product, size and color combination.

SELECT
    P.ProductName,
    S.SizeName,
    C.ColorName
FROM #Products P
CROSS JOIN #Sizes S
CROSS JOIN #Colors C;


-- Total combinations:
-- 3 products * 4 sizes * 2 colors = 24 rows.


-- =========================================================
-- SECTION 11: PRACTICAL USES OF CROSS JOIN
-- =========================================================

-- Example 1:
-- Generate all possible product variations.

SELECT
    P.ProductName,
    S.SizeName,
    C.ColorName
FROM #Products P
CROSS JOIN #Sizes S
CROSS JOIN #Colors C;


-- Example 2:
-- Generate combinations of working days and shifts.

DROP TABLE IF EXISTS #WorkingDays;
DROP TABLE IF EXISTS #Shifts;


CREATE TABLE #WorkingDays
(
    DayName VARCHAR(20)
);


CREATE TABLE #Shifts
(
    ShiftName VARCHAR(20)
);


INSERT INTO #WorkingDays
VALUES ('Monday'), ('Tuesday'), ('Wednesday');


INSERT INTO #Shifts
VALUES ('Morning'), ('Evening');


SELECT
    D.DayName,
    S.ShiftName
FROM #WorkingDays D
CROSS JOIN #Shifts S;


-- Example 3:
-- Generate all possible department and shift combinations.

SELECT
    D.Department,
    S.ShiftName
FROM
(
    SELECT DISTINCT Department
    FROM #Employees
) D
CROSS JOIN #Shifts S;


-- =========================================================
-- SECTION 12: SELF JOIN VS CROSS JOIN
-- =========================================================

/*
SELF JOIN:
- Joins a table with itself.
- Uses aliases to represent the same table differently.
- Usually has a relationship condition in ON.
- Useful for employee-manager relationships.

CROSS JOIN:
- Combines every row from one table with every row
  from another table.
- Does not require an ON condition.
- Produces all possible combinations.
- Useful for product variations and scheduling.
*/


-- =========================================================
-- SECTION 13: PRACTICE QUESTIONS
-- =========================================================

/*
Q1. Display employee names and their manager names.

Q2. Display all employees, including those without managers.

Q3. Find employees who do not have a manager.

Q4. Find employees whose salary is greater than
    their manager's salary.

Q5. Find employees whose manager earns more than 70000.

Q6. Find employees and their managers working
    in the same department.

Q7. Find pairs of employees working in the same department.

Q8. Find employees who have the same salary.

Q9. Generate all product and size combinations.

Q10. Generate all product, size and color combinations.

Q11. Count the total product-size combinations.

Q12. Generate all working day and shift combinations.

Q13. Find employees who report directly to Rahul.

Q14. Display each employee with their manager's department.

Q15. Find employees whose salary is less than
     their manager's salary.

Q16. Generate every department and shift combination.

Q17. Count the number of employees reporting
     directly to each manager.

Q18. Find managers who manage more than one employee.

Q19. Find employees who work in the same department
     as their manager but earn less than their manager.

Q20. Generate all possible product, size and color
     combinations and sort them by product name.
*/


-- =========================================================
-- SECTION 14: SOLUTIONS
-- =========================================================

-- Q1
SELECT
    E.EmployeeName AS Employee,
    M.EmployeeName AS Manager
FROM #Employees E
INNER JOIN #Employees M
    ON E.ManagerID = M.EmployeeID;


-- Q2
SELECT
    E.EmployeeName AS Employee,
    M.EmployeeName AS Manager
FROM #Employees E
LEFT JOIN #Employees M
    ON E.ManagerID = M.EmployeeID;


-- Q3
SELECT E.EmployeeName
FROM #Employees E
LEFT JOIN #Employees M
    ON E.ManagerID = M.EmployeeID
WHERE M.EmployeeID IS NULL;


-- Q4
SELECT
    E.EmployeeName AS Employee,
    E.Salary AS EmployeeSalary,
    M.EmployeeName AS Manager,
    M.Salary AS ManagerSalary
FROM #Employees E
INNER JOIN #Employees M
    ON E.ManagerID = M.EmployeeID
WHERE E.Salary > M.Salary;


-- Q5
SELECT
    E.EmployeeName AS Employee,
    M.EmployeeName AS Manager,
    M.Salary AS ManagerSalary
FROM #Employees E
INNER JOIN #Employees M
    ON E.ManagerID = M.EmployeeID
WHERE M.Salary > 70000;


-- Q6
SELECT
    E.EmployeeName AS Employee,
    M.EmployeeName AS Manager,
    E.Department
FROM #Employees E
INNER JOIN #Employees M
    ON E.ManagerID = M.EmployeeID
WHERE E.Department = M.Department;


-- Q7
SELECT
    E.EmployeeName AS Employee1,
    E2.EmployeeName AS Employee2,
    E.Department
FROM #Employees E
INNER JOIN #Employees E2
    ON E.Department = E2.Department
   AND E.EmployeeID < E2.EmployeeID;


-- Q8
SELECT
    E.EmployeeName AS Employee1,
    E2.EmployeeName AS Employee2,
    E.Salary
FROM #Employees E
INNER JOIN #Employees E2
    ON E.Salary = E2.Salary
   AND E.EmployeeID < E2.EmployeeID;


-- Q9
SELECT
    P.ProductName,
    S.SizeName
FROM #Products P
CROSS JOIN #Sizes S;


-- Q10
SELECT
    P.ProductName,
    S.SizeName,
    C.ColorName
FROM #Products P
CROSS JOIN #Sizes S
CROSS JOIN #Colors C;


-- Q11
SELECT COUNT(*) AS TotalCombinations
FROM #Products P
CROSS JOIN #Sizes S;


-- Q12
SELECT
    D.DayName,
    S.ShiftName
FROM #WorkingDays D
CROSS JOIN #Shifts S;


-- Q13
SELECT
    E.EmployeeName,
    M.EmployeeName AS ManagerName
FROM #Employees E
INNER JOIN #Employees M
    ON E.ManagerID = M.EmployeeID
WHERE M.EmployeeName = 'Rahul';


-- Q14
SELECT
    E.EmployeeName AS Employee,
    M.EmployeeName AS Manager,
    M.Department AS ManagerDepartment
FROM #Employees E
INNER JOIN #Employees M
    ON E.ManagerID = M.EmployeeID;


-- Q15
SELECT
    E.EmployeeName AS Employee,
    E.Salary AS EmployeeSalary,
    M.EmployeeName AS Manager,
    M.Salary AS ManagerSalary
FROM #Employees E
INNER JOIN #Employees M
    ON E.ManagerID = M.EmployeeID
WHERE E.Salary < M.Salary;


-- Q16
SELECT
    D.Department,
    S.ShiftName
FROM
(
    SELECT DISTINCT Department
    FROM #Employees
) D
CROSS JOIN #Shifts S;


-- Q17
SELECT
    M.EmployeeName AS ManagerName,
    COUNT(E.EmployeeID) AS DirectReports
FROM #Employees M
INNER JOIN #Employees E
    ON M.EmployeeID = E.ManagerID
GROUP BY M.EmployeeID, M.EmployeeName;


-- Q18
SELECT
    M.EmployeeName AS ManagerName,
    COUNT(E.EmployeeID) AS DirectReports
FROM #Employees M
INNER JOIN #Employees E
    ON M.EmployeeID = E.ManagerID
GROUP BY M.EmployeeID, M.EmployeeName
HAVING COUNT(E.EmployeeID) > 1;


-- Q19
SELECT
    E.EmployeeName AS Employee,
    E.Salary AS EmployeeSalary,
    M.EmployeeName AS Manager,
    M.Salary AS ManagerSalary
FROM #Employees E
INNER JOIN #Employees M
    ON E.ManagerID = M.EmployeeID
WHERE E.Department = M.Department
  AND E.Salary < M.Salary;


-- Q20
SELECT
    P.ProductName,
    S.SizeName,
    C.ColorName
FROM #Products P
CROSS JOIN #Sizes S
CROSS JOIN #Colors C
ORDER BY P.ProductName, S.SizeName, C.ColorName;


-- =========================================================
-- SECTION 15: INTERVIEW QUICK REVISION
-- =========================================================

/*
1. What is SELF JOIN?
   Joining a table with itself.

2. Why do we use SELF JOIN?
   To compare related records within the same table,
   such as employees and their managers.

3. Is SELF JOIN a separate JOIN keyword?
   No. It is a technique using a table more than once
   with different aliases.

4. What is CROSS JOIN?
   It combines every row from the first table with
   every row from the second table.

5. What is a Cartesian product?
   The result of combining every row from one table
   with every row from another table.

6. Does CROSS JOIN require an ON condition?
   No.

7. How many rows does a CROSS JOIN produce?
   If table A has M rows and table B has N rows,
   the result contains M * N rows.

8. Can we use SELF JOIN with LEFT JOIN?
   Yes.

9. Can we use CROSS JOIN with more than two tables?
   Yes.

10. What is the difference between SELF JOIN and CROSS JOIN?
    SELF JOIN relates records within the same table.
    CROSS JOIN generates all possible combinations.

IMPORTANT:
CROSS JOIN can generate a very large result set.
Always consider the number of rows in each input table
before using it on large datasets.

============================================================
END OF PRACTICE FILE
============================================================
*/