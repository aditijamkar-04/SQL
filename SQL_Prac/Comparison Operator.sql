/* Level 2:

Question 1
Display employees who belong to either the IT or HR department.

Question 2 – Level 2
Display employees who do not belong to IT or HR departments.

Question 3 – Level 2
Display employees whose salary is between ₹35,000 and ₹50,000, but exclude employees from the HR department.

Question 4
Display employees whose department is either IT or Finance, and whose salary is greater than ₹40,000.

Question 5
Display employees whose salary is NOT between ₹35,000 and ₹45,000.

Question 6
Display employees whose department is not IT and whose salary is greater than or equal to ₹40,000.

Question 7 
Display employees whose salary is either:
- Less than ₹40,000, OR
- Greater than ₹50,000.

*/

-- 1
SELECT *
FROM Employees
WHERE Department IN ('IT', 'HR');
-- WHERE Department = 'IT' OR Department = 'HR';

-- 2
SELECT *
FROM Employees
WHERE Department NOT IN ('IT', 'HR');

--3 
SELECT *
FROM Employees
WHERE Salary BETWEEN 35000 AND 50000
  AND Department NOT IN ('HR');

-- 4
SELECT *
FROM Employees
WHERE Department IN ('IT', 'Finance')
  AND Salary > 40000;

-- 5
SELECT *
FROM Employees
WHERE Salary NOT BETWEEN 35000 AND 45000;

-- 6
SELECT *
FROM Employees
WHERE Department NOT IN ('IT')
  AND Salary >= 40000;

-- 7 
SELECT *
FROM Employees
WHERE Salary < 40000
   OR Salary > 50000;
