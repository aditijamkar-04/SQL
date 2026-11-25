/* Special Operator (IS NULL and IS NOT NULL):

Question 1
A company maintains an Employees table with an optional Email column.

Find all employees who have not provided an email address.

Display EmployeeName, Department, and Email.

Question 2
Find all employees who have provided an email address.

Display EmployeeName, Department, and Email.

Question 3
A company maintains an Employees table with these columns:

EmployeeID, EmployeeName, Department, Salary, Email

Find employees whose Salary is missing.

Display EmployeeName, Department, and Salary.

Question 4 – Level 2
Find employees who have provided an email address but whose salary is missing.

Display EmployeeName, Email, and Salary.

Question 5 – Level 2
Find employees whose Department and Email are both missing.

Display EmployeeID, EmployeeName, Department, and Email.

Question 6 – Level 2
Find employees whose:
- Email address is missing.
- Salary is greater than ₹40,000.
Display EmployeeName, Department, Salary, and Email.


Question 7 – Level 3
Find employees whose:
- Email address is available.
- Department is missing.
- Salary is between ₹30,000 and ₹50,000, inclusive.
Display EmployeeID, EmployeeName, Department, Email, and Salary.

Question 8 – Level 3
Find employees whose:
- Email address is missing OR Department is missing.
- Salary is greater than ₹35,000.
- Salary is not exactly ₹45,000.
Display EmployeeName, Department, Email, and Salary.

Question 9 – Level 3
Find employees whose:
- Both Email and Department are available.
- Salary is either less than ₹40,000 or greater than ₹50,000.
- EmployeeName must not be missing.
Display EmployeeID, EmployeeName, Department, Email, and Salary.

Question 10 – Level 3 (Final Challenge)
Find employees whose:
- Email is missing OR Department is missing.
- Salary is between ₹30,000 and ₹60,000, inclusive.
- EmployeeName is available.
- Salary must not be exactly ₹35,000 or ₹45,000.
Display EmployeeID, EmployeeName, Department, Email, and Salary.
*/

--1
SELECT EmployeeName, Department, Email
FROM Employees
WHERE Email IS NULL;

--2
SELECT EmployeeName, Department, Email
FROM Employees
WHERE Email IS NOT NULL;

--3
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE Salary IS NULL;

--4
SELECT EmployeeName, Email, Salary
FROM Employees
WHERE Email IS NOT NULL
  AND Salary IS NULL;

--5
SELECT EmployeeID, EmployeeName, Department, Email
FROM Employees
WHERE Department IS NULL
  AND Email IS NULL;

--6
SELECT EmployeeName, Department, Salary, Email
FROM Employees
WHERE Email IS NULL
  AND Salary > 40000;

--7
SELECT EmployeeID, EmployeeName, Department, Email, Salary
FROM Employees
WHERE Email IS NOT NULL
  AND Department IS NULL
  AND Salary BETWEEN 30000 AND 50000;

--8
SELECT EmployeeName, Department, Email, Salary
FROM Employees
WHERE (Email IS NULL OR Department IS NULL)
  AND Salary > 35000
  AND Salary <> 45000;

--9
SELECT EmployeeID, EmployeeName, Department, Email, Salary
FROM Employees
WHERE Email IS NOT NULL
  AND Department IS NOT NULL
  AND (Salary < 40000 OR Salary > 50000)
  AND EmployeeName IS NOT NULL;

--10
SELECT EmployeeID, EmployeeName, Department, Email, Salary
FROM Employees
WHERE (Email IS NULL OR Department IS NULL)
  AND Salary BETWEEN 30000 AND 60000
  AND EmployeeName IS NOT NULL
  AND Salary <> 35000
  AND Salary <> 45000;
