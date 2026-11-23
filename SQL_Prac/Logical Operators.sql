/* Level 1:

Question 1
Using the Employees table:
EmployeeName	Department	Salary
Rahul	IT	45000
Priya	HR	35000
Amit	IT	55000
Neha	Finance	40000

Task: Display employees who belong to the IT department AND earn more than ₹40,000.

Question 2 – 
Display employees who:
- Belong to the HR department.
- Have a salary less than ₹40,000.

Question 3 – 
Display employees who belong to either the IT department OR the HR department.

Question 4 – 
Display employees whose salary is less than ₹40,000 OR greater than ₹50,000.

Question 5
Display all employees except those who belong to the HR department.

Question 6
Display employees whose salary is at least ₹40,000 but exclude employees earning exactly ₹55,000.

Question 7
Display employees who belong to IT or Finance, but exclude anyone earning less than ₹45,000.

*/

-- 1
SELECT EmployeeName
FROM Employees
WHERE Department = 'IT'
  AND Salary > 40000;

--2
SELECT EmployeeName
FROM Employees
WHERE Department = 'HR'
  AND Salary < 40000;

--3
SELECT EmployeeName
FROM Employees
WHERE Department = 'IT'
   OR Department = 'HR';

--4
SELECT EmployeeName
FROM Employees
WHERE Salary < 40000
   OR Salary > 50000;

--5
SELECT EmployeeName
FROM Employees
WHERE Department NOT IN ('HR');

--6
SELECT EmployeeName
FROM Employees
WHERE Salary >= 40000
  AND Salary NOT IN (55000);

--7
SELECT EmployeeName
FROM Employees
WHERE (Department = 'IT'
   OR Department = 'Finance')
  AND Salary >= 45000;

