/* Special Operation:IN / NOT IN and BETWEEN 

Question 1
Find employees who work in the IT or HR departments.

Display:
- EmployeeID
- EmployeeName
- Department
- Salary

Que 2
Find employees who do not work in the HR or Finance departments.

Display:
- EmployeeName
- Department
- Salary

Que 3
Find employees whose names are exactly one of the following:
- Rahul
- Priya
- Neha
Display:
- EmployeeID
- EmployeeName
- Salary

Question 4
Find employees who do not belong to any of these departments:
- IT
- HR
- Finance
Display:
- EmployeeID
- EmployeeName
- Department
And whose salaries are greater than ₹40,000.

Que 5
Find employees who:
- Do NOT belong to HR or Finance.
- Have salaries between ₹35,000 and ₹55,000.
- Their names are NOT Rahul or Neha.
- Display only EmployeeName, Department, and Salary.

Que 6
Find employees whose salary is between ₹30,000 and ₹45,000 (inclusive).
Display: EmployeeName, Salary.

Que 7
Find employees whose salary is NOT between ₹35,000 and ₹50,000 and whose department is HR or Finance.
Display: EmployeeID, EmployeeName, Salary, Department

Que 8
Find employees whose salary is between ₹30,000 and ₹60,000 but NOT between ₹40,000 and ₹50,000.
Display: EmployeeName, Department, Salary.

Que 9
Find employees whose salary is NOT between ₹30,000 and ₹50,000, but whose EmployeeID is between 101 and 104.
Display: EmployeeName, Department, Salary, EmployeeID.

Que 10
Find employees who:
- Have a salary between ₹30,000 and ₹60,000.
- Have an EmployeeID NOT between 102 and 103.
- Work in IT or Finance.
- Their salary must NOT be between ₹40,000 and ₹45,000.

*/

--1
SELECT EmployeeID, EmployeeName, Department, Salary
FROM Employees
WHERE Department IN ('IT', 'HR');

--2
SELECT EmployeeID, EmployeeName, Department, Salary
FROM Employees
WHERE Department NOT IN ('IT', 'Finance');

--3
SELECT EmployeeID, EmployeeName, Salary
FROM Employees
WHERE EmployeeName IN ('Rahul', 'Priya', 'Neha');

--4
SELECT EmployeeID, EmployeeName, Department
FROM Employees
WHERE Department NOT IN ('IT', 'HR', 'Finance')
  AND Salary >40000;

--5
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE Department NOT IN ('HR', 'Finance')
  AND Salary BETWEEN 35000 AND 55000
  AND EmployeeName NOT IN ('Rahul', 'Neha');

--6
SELECT EmployeeName,Salary
FROM Employees
WHERE Salary BETWEEN 30000 AND 50000;

--7
SELECT EmployeeID, EmployeeName, Salary, Department
FROM Employees
WHERE Salary NOT BETWEEN 35000 AND 50000
  AND (Department = 'HR' OR Department = 'Finance');

--8
SELECT EmployeeID, EmployeeName, Department
FROM Employees
WHERE Salary BETWEEN 30000 AND 60000
  AND Salary NOT BETWEEN 40000 AND 50000;

--9
SELECT EmployeeID, EmployeeName, Department, Salary
FROM Employees
WHERE Salary NOT BETWEEN 30000 AND 50000
  AND EmployeeID BETWEEN 101 AND 104;

--10
SELECT EmployeeID, EmployeeName, Department, Salary
FROM Employees
WHERE Salary BETWEEN 30000 AND 60000
  AND EmployeeID NOT BETWEEN 102 AND 103
  AND Department IN ('IT', 'Finance')
  AND Salary NOT BETWEEN 40000 AND 45000;
