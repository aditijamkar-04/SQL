/* Special Operators – Combined Practice:

Question 1 

A company wants to find employees who:
- Work in IT or Finance.
- Have a salary between ₹40,000 and ₹55,000, inclusive.
- Have names beginning with the letter 'A' or 'N'.
Display EmployeeName, Department, and Salary.

Question 2 – Level 1
Find employees who:
- Do not work in HR.
- Have a salary below ₹50,000.
- Have provided an email address.
Display EmployeeName, Department, Salary, and Email.

Question 3 – Level 1
Find employees who:
- Work in IT or HR.
- Have names containing the letter 'a'.
- Do not earn exactly ₹35,000.
Display EmployeeName, Department, and Salary.

Question 4 – Level 2
Find employees who:
- Work in IT or Finance.
- Have a salary between ₹35,000 and ₹60,000.
- Do not have an email address.
- Their names must not end with 'a'.
Display EmployeeName, Department, Salary, and Email.

Question 5 – Level 2
Find employees who:
- Work in HR or Finance.
- Have names starting with 'P' or 'N'.
- Earn more than ₹30,000.
- Do not have a missing department.
Display EmployeeName, Department, and Salary.

Question 6 
Find employees who:
- Do not work in HR or Finance.
- Have salaries between ₹40,000 and ₹60,000.
- Have names containing the letter a.
- Have a non-missing Email.
- Display EmployeeName, Department, Salary, and Email.

Que-7
Find employees who:
- Work in IT, HR, or Finance.
- Have salaries between ₹35,000 and ₹55,000.
- Have names starting with either A or R.
- Have a missing Email.
- Do not have a missing Department.
Display EmployeeName, Department, Salary, and Email.

Que 8
Find employees who:
- Do not work in IT.
- Have salaries either below ₹40,000 or above ₹50,000.
- Have names ending with a.
- Have a non-missing Email.
- Do not have a missing Department.
Display EmployeeName, Department, Salary, and Email.

Que 9
Find employees who:
- Work in HR or Finance.
- Have salaries between ₹30,000 and ₹60,000.
- Have names containing e.
- Do not have a missing Email.
- Their names must not start with P.
Display EmployeeName, Department, Salary, and Email.

Que 10
Find employees who:
- Do not work in HR.
- Have salaries between ₹35,000 and ₹60,000.
- Have names starting with A, N, or R.
- Have a missing Email OR a missing Department.
- Their salary must not be exactly ₹45,000.
Display EmployeeName, Department, Salary, and Email.

*/

--1
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE (Department = 'IT' OR Department = 'Finance')
  AND Salary BETWEEN 40000 AND 55000
  AND (EmployeeName LIKE 'A%' OR EmployeeName LIKE 'N%');

--2
SELECT EmployeeName, Department, Salary, Email
FROM Employees
WHERE Department <> 'HR'
  AND Salary < 50000
  AND Email IS NOT NULL;

--3
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE (Department = 'IT' OR Department = 'HR')
  AND EmployeeName LIKE '%a%'
  AND Salary <> 35000;

--4
SELECT EmployeeName, Department, Salary, Email
FROM Employees
WHERE (Department = 'IT' OR Department = 'Finance')
  AND Salary BETWEEN 35000 AND 60000
  AND Email IS NULL
  AND EmployeeName NOT LIKE '%a';

--5
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE (Department = 'hr' OR Department = 'Finance')
  AND (EmployeeName LIKE 'p%' OR EmployeeName LIKE 'n%')
  AND Salary > 30000
  AND Department IS NOT NULL;

--6
SELECT EmployeeName, Department, Salary, Email
FROM Employees
WHERE (Department <> 'HR' AND Department <> 'Finance')
  AND Salary BETWEEN 40000 AND 60000
  AND EmployeeName LIKE '%a%'
  AND Email IS NOT NULL;

--7
SELECT EmployeeName, Department, Salary, Email
FROM Employees
WHERE (Department = 'IT' OR Department = 'HR' OR Department = 'Finance')
  AND Salary BETWEEN 35000 AND 55000
  AND (EmployeeName LIKE 'A%' OR EmployeeName LIKE 'R%')
  AND Email IS NULL
  AND Department IS NOT NULL;

--8
SELECT EmployeeName, Department, Salary, Email
FROM Employees
WHERE Department <> 'IT'
  AND (Salary < 40000 OR Salary > 50000)
  AND EmployeeName LIKE '%A'
  AND Email IS NOT NULL
  AND Department IS NOT NULL;

--9
SELECT EmployeeName, Department, Salary, Email
FROM Employees
WHERE (Department = 'HR' OR Department = 'Finance')
  AND Salary BETWEEN 30000 AND 60000
  AND EmployeeName LIKE '%e%'
  AND Email IS NOT NULL
  AND EmployeeName NOT LIKE 'p%';

--10
SELECT EmployeeName, Department, Salary, Email
FROM Employees
WHERE Department <> 'HR'
  AND Salary BETWEEN 35000 AND 60000
  AND (
        EmployeeName LIKE 'A%'
        OR EmployeeName LIKE 'N%'
        OR EmployeeName LIKE 'R%'
      )
  AND (Email IS NULL OR Department IS NULL)
  AND Salary <> 45000;
