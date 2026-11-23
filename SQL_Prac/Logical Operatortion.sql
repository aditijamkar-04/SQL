/* Level 3:

Question 1

A company wants to identify employees who:
- Work in IT, HR, or Finance.
- Earn more than ₹35,000.
- Employees in IT must earn at least ₹45,000.
- Employees in Finance must earn less than ₹45,000.
- HR employees must not earn exactly ₹35,000.
Display EmployeeName, Department, and Salary.

Question 2

A company wants to identify employees who:
- Work in IT or Finance.
- Earn between ₹40,000 and ₹60,000, inclusive.
- IT employees earning exactly ₹45,000 should be excluded.
- Finance employees earning exactly ₹40,000 should be included.
- HR employees should never appear.
Display EmployeeName, Department, and Salary.

Question 3 
A company wants to identify employees who:
- Work in IT, HR, or Finance.
- Earn more than ₹30,000.
- IT employees must earn less than ₹60,000.
- HR employees must earn between ₹30,000 and ₹40,000, inclusive.
- Finance employees must not earn exactly ₹40,000.
- Employees earning exactly ₹55,000 must be excluded regardless of department.
Display EmployeeName, Department, and Salary.
*/

--1
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE (Department = 'IT' OR Department = 'HR' OR Department = 'Finance')
  AND Salary > 35000
  AND (
        (Department = 'IT' AND Salary >= 45000)
        OR (Department = 'Finance' AND Salary < 45000)
        OR (Department = 'HR' AND Salary <> 35000)
      );

--2
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE (Department = 'IT' OR Department = 'Finance')
  AND Salary BETWEEN 40000 AND 60000
  AND NOT (Department = 'IT' AND Salary = 45000);

--3
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE Salary > 30000
  AND (
        (Department = 'IT' AND Salary < 60000)
        OR (Department = 'HR' AND Salary BETWEEN 30000 AND 40000)
        OR (Department = 'Finance' AND Salary <> 40000)
      )
  AND Salary <> 55000;
