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

Question 4:
Display employees whose salary is less than or equal to ₹40,000 using

Question 5 – Level 1
Display employees whose salary is exactly ₹45,000.

Question 6 – Level 1
Display employees whose salary is not equal to ₹40,000.

Question 7 – Level 1 (Final)
Display employees whose salary is between ₹35,000 and ₹45,000, inclusive.

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

-- 4 
SELECT *
FROM Employees
WHERE Salary <= 40000;

-- 5
SELECT *
FROM Employees
WHERE Salary = 45000;

-- 6
SELECT *
FROM Employees
WHERE Salary != 40000;

--7
SELECT *
FROM Employees
WHERE Salary BETWEEN 35000 AND 45000;

