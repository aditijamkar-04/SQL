-- Basic SELECT Queries

-- Display all records
SELECT *
FROM Employees;

-- Display selected columns
SELECT EmployeeID, EmployeeName, Salary
FROM Employees;

-- Filter employees by salary
SELECT *
FROM Employees
WHERE Salary > 30000;

-- Sort employees by salary
SELECT *
FROM Employees
ORDER BY Salary DESC;