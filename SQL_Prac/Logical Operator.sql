/* Level 2:

Question 1
A company wants to identify employees who:
- Belong to IT or HR.
- Earn less than ₹50,000.
- Do not have a salary of ₹35,000.
Display EmployeeName, Department, and Salary.

Question 2
A company wants to find employees who:
- Work in Finance or IT.
- Earn at least ₹40,000.
- Do not earn more than ₹50,000.
Display EmployeeName, Department, and Salary.

Question 3
A company wants to identify employees who:
- Do not work in HR.
- Earn less than ₹50,000 or more than ₹40,000.
- Do not earn exactly ₹45,000.
Display EmployeeName, Department, and Salary.

Question 4
A company wants to find employees who:
- Work in IT or Finance.
- Earn less than ₹60,000.
- Do not earn exactly ₹40,000 or ₹55,000.
Display EmployeeName, Department, and Salary.

Question 5
A company wants to identify employees who:
- Work in HR or Finance.
- Earn between ₹30,000 and ₹50,000, inclusive.
- Do not earn exactly ₹35,000.
Display EmployeeName, Department, and Salary.

Question 6
A company wants to identify employees who:
- Do not work in Finance.
- Earn less than ₹45,000 or more than ₹50,000.
- Do not earn exactly ₹35,000.
Display EmployeeName, Department, and Salary.

Question 7
A company wants to identify employees who:
- Work in IT or HR.
- Earn at least ₹35,000 but less than ₹55,000.
- Do not work in HR with a salary below ₹40,000.
Display EmployeeName, Department, and Salary.

*/

--1
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE (Department = 'IT' OR Department = 'HR')
  AND Salary < 50000
  AND Salary NOT IN (35000);

--2 
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE (Department = 'Finance' OR Department = 'IT')
  AND Salary >= 40000
  AND Salary <= 50000;

--3
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE Department NOT IN ('HR')
  AND Salary < 50000
  AND Salary > 40000
  AND Salary NOT IN (45000);

--4
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE (Department = 'IT' OR Department = 'Finance')
  AND Salary < 60000
  AND Salary NOT IN (40000,55000);

--5
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE (Department = 'HR' OR Department = 'Finance')
  AND Salary BETWEEN 30000 AND 50000
  AND Salary NOT IN (35000);

--6
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE Department NOT IN ('Finance')
  AND (Salary < 45000 OR Salary > 50000)
  AND Salary NOT IN (35000);

--7
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE (Department = 'IT' OR Department = 'HR')
  AND Salary >= 35000
  AND Salary < 55000
  AND NOT (Department = 'HR' AND Salary < 40000);
