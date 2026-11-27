/* String_Functions: CHARINDEX() and PATINDEX()

1. CHARINDEX(): Finds the starting position of a specific character or substring.
    Syntax: CHARINDEX(search_expression, expression [, start_location])
    EX: SELECT CHARINDEX('a', 'Rahul') AS Position;

    - search_expression: What you want to find.
    - expression: The string in which you want to search.
    - start_location: Optional position from which searching should begin.

2. PATINDEX(): Finds the position of a pattern inside a string.
              The special thing about PATINDEX() is that it supports wildcard patterns, similar to LIKE.
    Syntax: PATINDEX('%pattern%', expression)
    EX: SELECT PATINDEX('%a%', 'Rahul') AS Position;

-----
Important PATINDEX patterns:

Pattern	            Meaning
%a%	                Find a anywhere
%[aeiou]%	          Find any vowel
%[0-9]%	            Find any digit
%[a-z]%	            Find any lowercase alphabet character
%[A-Z]%	            Find any uppercase alphabet character
%[^0-9]%	          Find any non-digit character
%[ae]%	            Find either a or e

PATINDEX() also returns 0 when no matching pattern is found.

-----

CHARINDEX() vs PATINDEX():

CHARINDEX()	                            PATINDEX()
Searches for specific text	            Searches using patterns
Does not support LIKE wildcards	        Supports wildcard patterns
Can specify start location	            No start-location argument
Returns position	                      Returns position

Tip: LIKE checks whether a pattern matches; CHARINDEX() and PATINDEX() return the position where a match begins.

------

WHERE CHARINDEX('a', EmployeeName) > 0   ---->
- Position greater than 0 → character exists.
- Position equal to 0 → character doesn't exist.
- NULL → search result is unknown.

-----

PATINDEX('%[ae]%', EmployeeName)   -----> Finds either a or e anywhere.
PATINDEX('[NR]%', EmployeeName)    -----> Finds names starting with N or R.

*/

/*

Employees table:
EmployeeID	EmployeeName	Department	Salary
101	        Rahul	        IT	        45000
102	        Priya	        HR	        35000
103	        Amit	        IT	        55000
104	        Neha	        Finance	    40000


Q1. Display each employee's name and the position of the letter 'a' in their name.

Q2. Display each department and the position of the letter 'e' in its name.

Q3. Display each employee's name and find the position of the letter 'h' using a pattern-based search.

Q4. Display employees whose names contain the letter 'a', along with the position where it first appears.

Q5. Display each department and the position of the letter 'i' in its name. Return only departments where that letter exists.

Q6. Display employee names and the position of the first vowel in each name.

Q7. Display employees whose names contain 'a' and show the position of its first occurrence.

Q8. Find the position of the first occurrence of 'a' in each employee name, but start searching from position 3.

Q9. Display employee names and find the position of the first occurrence of any digit in their names.

Q10. Display employee names and find the position of the first occurrence of either 'a' or 'e'.

Q11. Display employees whose names begin with either 'N' or 'R'. Also display their names and the matching position.

Q12. Display employee names, departments, the position of 'a' in employee names, and the position of 'n' in departments. Return only records where both characters exist.

*/


--1
SELECT EmployeeName,
       CHARINDEX('a', EmployeeName) AS Position
FROM Employees;

--2
SELECT Department,
       CHARINDEX('e', Department) AS Position
FROM Employees;

--3
SELECT EmployeeName,
       PATINDEX('%h%', EmployeeName) AS Position
FROM Employees;

--4
SELECT EmployeeName,
       CHARINDEX('a', EmployeeName) AS Position
FROM Employees
WHERE CHARINDEX('a', EmployeeName) > 0;

--5
SELECT Department,
       CHARINDEX('i', Department) AS Position
FROM Employees
WHERE CHARINDEX('i', Department) > 0;

--6
SELECT EmployeeName,
       PATINDEX('%[aeiou]%', EmployeeName) AS VowelPosition
FROM Employees;

--7
SELECT EmployeeName,
       CHARINDEX('a', EmployeeName) AS Position
FROM Employees
WHERE CHARINDEX('a', EmployeeName) > 0;

--8
SELECT EmployeeName,
       CHARINDEX('a', EmployeeName, 3) AS Position
FROM Employees;

--9
SELECT EmployeeName,
       PATINDEX('%[0-9]%', EmployeeName) AS DigitPosition
FROM Employees;

--10
SELECT EmployeeName,
       PATINDEX('%[ae]%', EmployeeName) AS Position
FROM Employees;

--11
SELECT EmployeeName,
       PATINDEX('[NR]%', EmployeeName) AS Position
FROM Employees
WHERE PATINDEX('[NR]%', EmployeeName) > 0;

--12
SELECT EmployeeName,
       Department,
       CHARINDEX('a', EmployeeName) AS NamePosition,
       CHARINDEX('n', Department) AS DepartmentPosition
FROM Employees
WHERE CHARINDEX('a', EmployeeName) > 0
  AND CHARINDEX('n', Department) > 0;
