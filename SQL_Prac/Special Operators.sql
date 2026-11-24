/* Special Operators(LIKE):

Question 1
A company wants to find employees whose names begin with the letter 'A'.

Display:
- EmployeeName
- Department
- Salary

Question 2
A company wants to find employees whose names end with the letter 'a'.

Display EmployeeName, Department, and Salary.

Question 3
A company wants to find employees whose names contain the letter 'h' anywhere in their names.

Display EmployeeName, Department, and Salary.

Question 4
A company wants to find employees whose names contain exactly 5 characters.

Display EmployeeName, Department, and Salary.

Question 5
A company wants to find employees whose names have the letter 'a' as their second character.

Display EmployeeName, Department, and Salary.

Question 6
A company wants to find employees whose names contain the letter 'a', but do not begin with 'A'.

Display EmployeeName, Department, and Salary.

Question 7
A company wants to find employees whose names:
- Start with 'P' or 'N'.
- Contain at least 4 characters.
Display EmployeeName, Department, and Salary.

Question 8
A company wants to find employees whose names do not contain the letter 'i' anywhere.

Display EmployeeName, Department, and Salary.

Question 9
A company wants to find employees whose names:
- Start with 'A' or 'R'.
- End with 'l' or 't'.
Display EmployeeName, Department, and Salary.

Question 10
A company wants to find employees whose names contain exactly two occurrences of the letter 'a'.

Display EmployeeName, Department, and Salary.


*/

--1 
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE EmployeeName LIKE 'A%';

--2
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE EmployeeName LIKE '%A';

--3
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE EmployeeName LIKE '%h%';

--4
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE EmployeeName LIKE '_____';

--5
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE EmployeeName LIKE '_a%';

--6
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE EmployeeName NOT LIKE 'A%'
  AND EmployeeName LIKE '%a%';

--7
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE EmployeeName LIKE 'P___%'
   OR EmployeeName LIKE 'N___%';

--8
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE EmployeeName NOT LIKE '%i%';

--9
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE (EmployeeName LIKE 'A%' OR EmployeeName LIKE 'R%')
  AND (EmployeeName LIKE '%l' OR EmployeeName LIKE '%t');

--10
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE EmployeeName LIKE '%a%a%';
-- query finds names containing at least two occurrences of 'a', but the requirement is exactly two.
-- correct ome
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE EmployeeName LIKE '%a%a%'
  AND EmployeeName NOT LIKE '%a%a%a%';
-- OR
SELECT EmployeeName, Department, Salary
FROM Employees
WHERE LEN(EmployeeName) - LEN(REPLACE(EmployeeName, 'a', '')) = 2;
