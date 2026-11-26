/* String Functions: LTRIM · RTRIM · TRIM

Function -->	Purpose	--> Example
LTRIM()-->	Removes leading spaces -->	LTRIM('  Rahul') → 'Rahul'
RTRIM()-->	Removes trailing spaces -->	RTRIM('Rahul  ') → 'Rahul'
TRIM()-->	Removes leading and trailing spaces -->	TRIM('  Rahul  ') → 'Rahul'


Q1. Display employee names after removing leading spaces.
Columns: EmployeeName, CleanName

Q2. Display employee names after removing trailing spaces.
Columns: EmployeeName, CleanName

Q3. Display employee names after removing spaces from both ends.
Columns: EmployeeName, CleanName

Q4. Display employee names after removing leading spaces and show the length of the cleaned names.
Columns: EmployeeName, CleanName, CleanLength

Q5. Display employee names after removing trailing spaces and show the length of the cleaned names.
Columns: EmployeeName, CleanName, CleanLength

Q6. Display employee names after removing spaces from both ends and convert the cleaned names into uppercase.
Columns: EmployeeName, CleanName, UpperName

Q7. Display employee names after removing spaces from both ends and convert the cleaned names into lowercase.
Columns: EmployeeName, CleanName, LowerName

Q8. Display employees whose cleaned names have more than 4 characters.
Columns: EmployeeID, EmployeeName, CleanName, CleanLength

Q9. Display employee names after removing spaces from both ends. Show only names whose cleaned length is exactly 4.
Columns: EmployeeName, CleanName, CleanLength

Q10. Display employee names after removing leading and trailing spaces, convert them into uppercase, and show their cleaned length.
Columns: EmployeeName, CleanName, UpperName, CleanLength

Q11. Find employees whose cleaned names have between 4 and 5 characters (inclusive). Display their cleaned names in lowercase.
Columns: EmployeeID, EmployeeName, LowerName, CleanLength

Q12 – Final Challenge 
Display employees whose:
- Cleaned employee name has more than 3 characters.
- Cleaned department name has fewer than 7 characters.
Display:
EmployeeID, EmployeeName, CleanName, Department, CleanDepartment, DepartmentLength

*/

--1
SELECT EmployeeName,
      ltrim(employeename) as cleanname
FROM Employees;

--2
SELECT EmployeeName,
      rtrim(employeename) as cleanname
FROM Employees;
--3
SELECT EmployeeName,
      trim(employeename) as cleanname
FROM Employees;

--4
SELECT EmployeeName,
       LTRIM(EmployeeName) AS CleanName,
       LEN(LTRIM(EmployeeName)) AS CleanLength
FROM Employees;

--5
SELECT EmployeeName,
       RTRIM(EmployeeName) AS CleanName,
       LEN(RTRIM(EmployeeName)) AS CleanLength
FROM Employees;

--6
SELECT EmployeeName,
       TRIM(EmployeeName) AS CleanName,
       UPPER(TRIM(EmployeeName)) AS UpperName
FROM Employees;

--7
SELECT EmployeeName,
       TRIM(EmployeeName) AS CleanName,
       LOWER(TRIM(EmployeeName)) AS LowerName
FROM Employees;

--8
SELECT EmployeeName, EmployeeID,
       TRIM(EmployeeName) AS CleanName,
       LEN(TRIM(EmployeeName)) AS CleanLength
FROM Employees
WHERE LEN(TRIM(EmployeeName)) > 4;

--9
SELECT EmployeeName,
       TRIM(EmployeeName) AS CleanName,
       LEN(TRIM(EmployeeName)) AS CleanLength
FROM Employees
WHERE LEN(TRIM(EmployeeName)) = 4;

--10
SELECT EmployeeName, EmployeeID,
       TRIM(EmployeeName) AS CleanName,
       UPPER(TRIM(EmployeeName)) AS UpperName,
       LEN(TRIM(EmployeeName)) AS CleanLength
FROM Employees;

--11
SELECT EmployeeName, employeeid, lower(employeename) as lowername
      , len(trim(employeename)) as cleanlength
FROM Employees  
  where len(trim(employeename)) between 4 and 5;

--12
SELECT EmployeeName, employeeid, trim(employeename) as cleanname, 
  department, trim(department) as cleandepartment, 
  len(department) as departmentlength
FROM Employees  
  where len(trim(employeename))>3 and len(trim(department))<7;

