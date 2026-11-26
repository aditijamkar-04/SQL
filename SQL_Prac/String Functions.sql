/* String Functions: UPPER , LOWER , LEN

Q1
Display each employee's name in uppercase.
Columns: EmployeeName, UpperName

Q2
Display each employee's name in lowercase.
Columns: EmployeeName, LowerName

Q3
Display each employee's name along with the number of characters in their name.
Columns: EmployeeName, NameLength

Q4
Display employee names in uppercase and their departments in lowercase.
Columns: EmployeeName, UpperName, Department, LowerDepartment

Q5
Find employees whose names contain more than 4 characters.
Display: EmployeeName, NameLength

Q6
Find employees whose names contain fewer than 5 characters.
Display: EmployeeName, NameLength

Q7
Display employee names in uppercase, their departments in lowercase, and the length of each employee's name.
Columns: EmployeeName, UpperName, Department, LowerDepartment, NameLength

Q8
Find employees whose names have exactly 4 characters.
Display: EmployeeID, EmployeeName, NameLength

Q9
Find employees whose names have at least 5 characters and display their names in lowercase.
Display: EmployeeName, LowerName, NameLength

Q10
Find employees whose department names have more than 3 characters.
Display: EmployeeName, Department, DepartmentLength

Q11
Display employees whose names have between 4 and 5 characters (inclusive). Display their names in uppercase.
Columns: EmployeeName, UpperName, NameLength

Q12 – 
Display employees whose:
- Name length is greater than 3 characters.
- Department name length is less than 7 characters.
Display:
EmployeeID, EmployeeName, UpperName, Department, DepartmentLength

*/

--1
SELECT EmployeeName,
       UPPER(EmployeeName) AS UpperName
FROM Employees;

--2
SELECT EmployeeName,
       Lower(EmployeeName) AS LowerName
FROM Employees;

--3
SELECT EmployeeName,
       Len(EmployeeName) AS NameLength
FROM Employees;

--4
SELECT EmployeeName,
       upper(EmployeeName) As uppername , department,lower(department) as lowerdepartment
FROM Employees;

--5
1. SELECT EmployeeName,
          Len(EmployeeName) AS NameLength
   FROM Employees
    where len(employeename)>4;

--6
6. SELECT EmployeeName,
          Len(EmployeeName) AS NameLength
   FROM Employees
  where len(employeename) <5;

--7
SELECT EmployeeName,
       upper(EmployeeName) As uppername , lower(department) as lowerdepartment, len(employeename) as namelength
FROM Employees;

--8
SELECT EmployeeName, employeeid, len(employeename) as namelength
FROM Employees
where len(employeename) =4;

--9
SELECT EmployeeName, lower(employeename) as lowername, len(employeename) as namelength
   FROM Employees
     where len(employeename) >=5;

--10
SELECT EmployeeName, department, len(department) as departmentlength
    FROM Employees
     where len(department) >3;

--11
SELECT EmployeeName,
       UPPER(EmployeeName) AS UpperName,
       LEN(EmployeeName) AS NameLength
FROM Employees
WHERE LEN(EmployeeName) BETWEEN 4 AND 5;

--12
12. SELECT employeeid,  EmployeeName, upper(employeename) as uppername, department, len(department) as departmentlength
    FROM Employees
     where len(employeename) >3 and len(department) <7;
