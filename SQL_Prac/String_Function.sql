/* String_Functions: REPLACE(), STUFF(), REVERSE()

1. REPLACE(): replaces all occurrences of a particular text with another text.
    Syntax: REPLACE(string, old_text, new_text)
    EX: SELECT REPLACE('Rahul', 'a', 'o') AS NewName;     ---> Rohul

2. STUFF(): removes a certain number of characters from a string starting at a specified position, then inserts new text at that position.
    Syntax: STUFF(string, start_position, length, replacement_text)
    EX: SELECT STUFF('Rahul', 2, 2, 'XX') AS NewName;      ---> RXXul (Removed 'ah' starting from position 2, and inserted 'XX'.)

    Parameter	        Meaning
    string	          Original string
    start_position	  Where to begin the change
    length	          How many characters to remove
    replacement_text	What to insert in their place

    EX: SELECT STUFF('Rahul', 3, 0, '123') AS NewName;      ----> Ra123hul (Because length = 0, no characters are removed. It simply inserts text at the specified position.)
    EX: SELECT STUFF('Rahul', 1, 2, 'A') AS NewName;        ----> Ahul (It removes the first 2 characters (Ra) and inserts A.)

3. REVERSE(): reverses the order of characters in a string.
    Synatax: REVERSE(string)
    EX: SELECT REVERSE('Rahul') AS ReversedName;          ----> luhaR

-------

Function	        Purpose	                                Example
REPLACE()	        Replace matching text everywhere	      REPLACE('Banana','a','o') → Bonono
STUFF()         	Remove and insert text at a position	  STUFF('Rahul',2,2,'XX') → RXXul
REVERSE()       	Reverse the string	                    REVERSE('Rahul') → luhaR

When do we use these in real projects?
- REPLACE: Clean inconsistent data, replace abbreviations, correct text formats.
- STUFF: Insert characters into a specific location, modify strings, handle certain formatting operations.
- REVERSE: String manipulation, some data-cleaning techniques, and special pattern-searching approaches.

*/

/*

Q1. Display each employee's name and replace the letter 'a' with 'o' in their name.

Q2. Display each employee's name and show the name with its first character replaced by 'X'.

Q3. Display each employee's name in reverse order.

Q4. Replace 'IT' in the Department column with 'Technology' and display EmployeeName, original Department, and modified Department.

Q5. Remove the first 2 characters from every employee name and replace them with 'AB'. Display the original and modified names.

Q6. Insert 'SQL' into each employee name at position 3 without removing any existing characters.

Q7. Display EmployeeName, Department, and the reversed Department name.

Q8. Replace every occurrence of 'a' in EmployeeName with '@', then display the modified name in reverse order.

Q9. Remove the last 2 characters from each employee name and replace them with '99'.

Q10. Replace 'Finance' with 'Accounts' in the Department column, then display the modified department in reverse order.

Q11. Insert 'Developer' into every employee name after the first 2 characters without deleting any original characters.

Q12. Display EmployeeID, EmployeeName, a modified name where the first 2 characters are removed and replaced with 'AI', and the final modified name in reverse order.

*/
--1
SELECT EmployeeName,
       REPLACE(EmployeeName, 'a', 'o') AS NewName
FROM Employees;

--2
SELECT EmployeeName,
       STUFF(EmployeeName, 1, 1, 'X') AS NewName
FROM Employees;

--3
SELECT EmployeeName,
       REVERSE(EmployeeName) AS NewName
FROM Employees;

--4
SELECT EmployeeName,
       Department,
       REPLACE(Department, 'IT', 'Technology') AS NewDept
FROM Employees;

--5
SELECT EmployeeName,
       STUFF(EmployeeName, 1, 2, 'AB') AS NewName
FROM Employees;

--6
SELECT EmployeeName,
       STUFF(EmployeeName, 3, 0, 'SQL') AS NewName
FROM Employees;

--7
SELECT EmployeeName,
       Department,
       REVERSE(Department) AS NewDept
FROM Employees;

--8
SELECT EmployeeName,
       REPLACE(EmployeeName, 'a', '@') AS NewName,
       REVERSE(REPLACE(EmployeeName, 'a', '@')) AS ReversedName
FROM Employees;

--9
SELECT EmployeeName,
       STUFF(EmployeeName, LEN(EmployeeName) - 1, 2, '99') AS NewName
FROM Employees;

--10
SELECT EmployeeName,
       Department,
       REPLACE(Department, 'Finance', 'Accounts') AS NewDept,
       REVERSE(REPLACE(Department, 'Finance', 'Accounts')) AS ReverseDept
FROM Employees;

--11
SELECT EmployeeName,
       STUFF(EmployeeName, 3, 0, 'Developer') AS NewName
FROM Employees;

--12
SELECT EmployeeName,
       EmployeeID,
       STUFF(EmployeeName, 1, 2, 'AI') AS NewName,
       REVERSE(STUFF(EmployeeName, 1, 2, 'AI')) AS ReverseName
FROM Employees;
