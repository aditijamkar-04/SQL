/* String_Function: LEFT · RIGHT · SUBSTRING

Function -->	Purpose -->	Example	--> Result
LEFT() -->	Extracts characters from the beginning -->	LEFT('Rahul', 2) -->	Ra
RIGHT() -->	Extracts characters from the end	--> RIGHT('Rahul', 3) -->	hul
SUBSTRING() -->	Extracts characters from a specified position -->	SUBSTRING('Rahul', 2, 3)	--> ahu

SUBSTRING syntax:
SUBSTRING(expression, start, length)

where , expression – the text or column.
start – starting position (SQL starts counting at 1).
length – number of characters to extract.


Q1. Display the first 2 characters of every employee name.
Columns: EmployeeName, FirstTwoCharacters

Q2. Display the last 3 characters of every employee name.
Columns: EmployeeName, LastThreeCharacters

Q3. Extract 3 characters from every employee name, starting at position 2.
Columns: EmployeeName, ExtractedName

Q4. Display the first 3 characters of every department name.
Columns: Department, DepartmentPrefix

Q5. Display the last 2 characters of every department name.
Columns: Department, DepartmentSuffix

Q6. Extract 2 characters from every employee name, starting at position 2, and convert the extracted text into uppercase.
Columns: EmployeeName, ExtractedName, UpperExtractedName

Q7. Display employee names whose first 2 characters are Ra.
Columns: EmployeeID, EmployeeName

Q8. Find employees whose last 2 characters are ah.
Display: EmployeeName, LastTwoCharacters

Q9. Extract 3 characters from each employee name, starting at position 2. Display only the employees whose extracted text is ahu.
Columns: EmployeeName, ExtractedName

Q10. Display employee names in uppercase along with their first 3 and last 2 characters.
Columns: EmployeeName, UpperName, FirstThreeCharacters, LastTwoCharacters

Q11. Find employees whose first 2 characters are either Ra or Pr, and display the last 3 characters of their names.
Columns: EmployeeID, EmployeeName, LastThreeCharacters

Q12 – Final Challenge 
Find employees whose:
- First 2 characters are Am or Ne.
- Last 2 characters are it or ha.
Display:
EmployeeID, EmployeeName, FirstTwoCharacters, LastTwoCharacters

*/

--1
SELECT EmployeeName,
       LEFT(EmployeeName, 2) AS FirstTwoCharacters
FROM Employees;

--2
SELECT EmployeeName,
       RIGHT(EmployeeName, 3) AS LastThreeCharacters
FROM Employees;

--3
SELECT EmployeeName,
       SUBSTRING(EmployeeName, 2, 3) AS ExtractedName
FROM Employees;

--4
SELECT Department  ,
       LEFT(department, 3) AS DepartmentPrefix  
FROM Employees;

--5
SELECT Department  ,
       right(department, 2) AS DepartmentSuffix  
FROM Employees;

--6
SELECT EmployeeName, substring(employeename,2,2) as ExtractedName, upper(substring(employeename,2,2)) as UpperExtractedName  
FROM Employees;

--7
SELECT EmployeeName, EmployeeID
FROM Employees
WHERE EmployeeName LIKE 'Ra%';

--8
SELECT EmployeeName, right(Employeename,2) as LastTwoCharacters  
FROM Employees
WHERE EmployeeName LIKE '%ah';

--9
SELECT EmployeeName, substring(Employeename,2,3) as extractedname 
FROM Employees
WHERE substring(Employeename,2,3)  ='ahu';

--10
SELECT EmployeeName,
       UPPER(EmployeeName) AS UpperName,
       LEFT(EmployeeName, 3) AS FirstThreeCharacters,
       RIGHT(EmployeeName, 2) AS LastTwoCharacters
FROM Employees;

--11
SELECT EmployeeID,
       EmployeeName,
       RIGHT(EmployeeName, 3) AS LastThreeCharacters
FROM Employees
WHERE LEFT(EmployeeName, 2) IN ('Ra', 'Pr');

--12
SELECT EmployeeID,
       EmployeeName,
       LEFT(EmployeeName, 2) AS FirstTwoCharacters,
       RIGHT(EmployeeName, 2) AS LastTwoCharacters
FROM Employees
WHERE LEFT(EmployeeName, 2) IN ('Am', 'Ne')
  AND RIGHT(EmployeeName, 2) IN ('it', 'ha');

-- OR

select EmployeeID, EmployeeName, 
  left(employeename,2) as FirstTwoCharacters  ,
  right(employeename,2) as LastTwoCharacters 
  from employees 
  where (left(employeename,2) like "am%" 
  or left(employeename,2) like "ne%") 
  and (right(employeename,2) like "it%" 
  or right(employeename,2) like "ha%") ;
