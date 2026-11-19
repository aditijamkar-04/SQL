/* Level 1:

Using the Employees table:
EmployeeName	Salary
Rahul	45000
Priya	35000
Amit	55000
Neha	40000

Que1.Write a query to display:
1. EmployeeName
2. Salary
3. Salary after a 10% increment

Que2.Using the same Employees table, write a query to display:
1. EmployeeName
2. Salary
3. Salary_After_Deduction (after deducting ₹2,000)
Example: If Rahul's salary is ₹45,000, the new salary should be ₹43,000.

Que3.Display each employee's name, salary, and annual salary (monthly salary × 12).

*/

-- 1
SELECT EmployeeName, Salary,
       (Salary + ((Salary * 10) / 100)) AS Salary_After_Increment
FROM Employees;

-- 2
SELECT EmployeeName, Salary,
       (Salary - 2000) AS Salary_After_Deduction
FROM Employees;

--3
SELECT EmployeeName, Salary,
       (Salary * 12) AS Annual_Salary
FROM Employees;
