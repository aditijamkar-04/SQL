/* Level 1:

Question 1
Using the Employees table:
EmployeeID	EmployeeName	Department	Salary
101	        Rahul	        IT	        45000
102        	Priya	        HR	        35000
103        	Amit	        IT	        55000
104        	Neha	        Finance	    40000

Task: Write a SQL query to display all employees whose salary is greater than ₹40,000.

Question 2
Display employees whose salary is less than ₹40,000.

Question 3
Display employees whose salary is greater than or equal to ₹40,000.

*/

-- 1
SELECT *
FROM Employees
WHERE Salary > 40000;

-- 2
SELECT *
FROM Employees
WHERE Salary < 40000;

--3 
SELECT *
FROM Employees
WHERE Salary >= 40000;
