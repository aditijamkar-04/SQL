/*
============================================================
SQL PRACTICE 04: RECURSIVE CTE
============================================================

Topics:
1. What is a Recursive CTE?
2. Anchor Member
3. Recursive Member
4. UNION ALL
5. Generating Number Sequences
6. Generating Date Sequences
7. Employee-Manager Hierarchy
8. Finding Subordinates
9. MAXRECURSION
10. Common Errors
11. Practice Questions and Solutions

============================================================
*/


-- =========================================================
-- SECTION 1: INTRODUCTION TO RECURSIVE CTE
-- =========================================================

/*
A recursive CTE is a Common Table Expression that
references itself.

In simple words:

A recursive CTE repeatedly executes a query using
the result of the previous execution until a stopping
condition is reached.

WHY DO WE USE IT?

1. Generate number sequences.
2. Generate date sequences.
3. Display employee-manager hierarchies.
4. Find all employees reporting to a manager.
5. Explore parent-child relationships.
6. Work with hierarchical data.

A recursive CTE has three important parts:

1. ANCHOR MEMBER
   - The starting query.
   - Executes first.
   - Does not reference the CTE itself.

2. RECURSIVE MEMBER
   - References the CTE itself.
   - Uses the previous result to generate the next result.

3. TERMINATION CONDITION
   - Controls when recursion stops.
   - Without a proper stopping condition, recursion
     may continue until SQL Server's recursion limit.

GENERAL SYNTAX:

;WITH CTE_Name AS
(
    -- Anchor member
    SELECT ...

    UNION ALL

    -- Recursive member
    SELECT ...
    FROM CTE_Name
    WHERE stopping_condition
)
SELECT *
FROM CTE_Name;

IMPORTANT:
The semicolon before WITH terminates the previous
SQL statement if necessary.
*/


-- =========================================================
-- SECTION 2: FIRST RECURSIVE CTE
-- =========================================================

-- Generate numbers from 1 to 10.

;WITH Numbers AS
(
    -- Anchor member
    SELECT 1 AS Number

    UNION ALL

    -- Recursive member
    SELECT Number + 1
    FROM Numbers
    WHERE Number < 10
)
SELECT *
FROM Numbers
OPTION (MAXRECURSION 100);


/*
HOW DOES IT WORK?

Execution:

Anchor:
1

First recursive execution:
1 + 1 = 2

Second recursive execution:
2 + 1 = 3

Third recursive execution:
3 + 1 = 4

It continues until Number becomes 10.

When Number = 10:
The condition Number < 10 becomes FALSE.

Recursion stops.

OUTPUT:

Number
------
1
2
3
...
10
*/


-- =========================================================
-- SECTION 3: GENERATE NUMBERS IN DESCENDING ORDER
-- =========================================================

-- Generate numbers from 10 down to 1.

;WITH Numbers AS
(
    SELECT 10 AS Number

    UNION ALL

    SELECT Number - 1
    FROM Numbers
    WHERE Number > 1
)
SELECT *
FROM Numbers
OPTION (MAXRECURSION 100);


-- =========================================================
-- SECTION 4: GENERATE EVEN NUMBERS
-- =========================================================

-- Generate even numbers from 2 to 20.

;WITH EvenNumbers AS
(
    SELECT 2 AS Number

    UNION ALL

    SELECT Number + 2
    FROM EvenNumbers
    WHERE Number < 20
)
SELECT *
FROM EvenNumbers
OPTION (MAXRECURSION 100);


-- =========================================================
-- SECTION 5: GENERATE ODD NUMBERS
-- =========================================================

-- Generate odd numbers from 1 to 19.

;WITH OddNumbers AS
(
    SELECT 1 AS Number

    UNION ALL

    SELECT Number + 2
    FROM OddNumbers
    WHERE Number < 19
)
SELECT *
FROM OddNumbers
OPTION (MAXRECURSION 100);


-- =========================================================
-- SECTION 6: GENERATE MULTIPLES OF A NUMBER
-- =========================================================

-- Generate multiples of 5 from 5 to 50.

;WITH Multiples AS
(
    SELECT 5 AS Number

    UNION ALL

    SELECT Number + 5
    FROM Multiples
    WHERE Number < 50
)
SELECT *
FROM Multiples
OPTION (MAXRECURSION 100);


-- =========================================================
-- SECTION 7: GENERATE DATE SEQUENCES
-- =========================================================

/*
Recursive CTEs can generate dates.

This is useful when:
- You need a calendar.
- You need every date in a range.
- Some dates have no transactions.
- You want to compare daily sales.
*/


-- Generate dates from 1 November 2026 to 10 November 2026.

;WITH DateSequence AS
(
    SELECT CAST('2026-11-01' AS DATE) AS CalendarDate

    UNION ALL

    SELECT DATEADD(DAY, 1, CalendarDate)
    FROM DateSequence
    WHERE CalendarDate < '2026-11-10'
)
SELECT *
FROM DateSequence
OPTION (MAXRECURSION 100);


-- Generate the first day of every month in 2026.

;WITH MonthSequence AS
(
    SELECT CAST('2026-01-01' AS DATE) AS MonthStart

    UNION ALL

    SELECT DATEADD(MONTH, 1, MonthStart)
    FROM MonthSequence
    WHERE MonthStart < '2026-12-01'
)
SELECT *
FROM MonthSequence
OPTION (MAXRECURSION 100);


-- =========================================================
-- SECTION 8: CREATE EMPLOYEE-MANAGER HIERARCHY
-- =========================================================

/*
In companies, employees may report to managers.

Example:

Rahul (CEO)
    |
    |---- Priya (Manager)
    |        |
    |        |---- Sneha
    |        |
    |        |---- Neha
    |
    |---- Amit (Manager)
             |
             |---- Karan
             |
             |---- Pooja

ManagerID stores the EmployeeID of the manager.

If ManagerID is NULL, the employee has no manager
in this sample hierarchy.
*/


DROP TABLE IF EXISTS #Employees;


CREATE TABLE #Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    ManagerID INT NULL,
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);


INSERT INTO #Employees
VALUES
(101, 'Rahul', NULL, 'Management', 150000),
(102, 'Priya', 101, 'IT', 100000),
(103, 'Amit', 101, 'Finance', 110000),
(104, 'Sneha', 102, 'IT', 70000),
(105, 'Neha', 102, 'HR', 65000),
(106, 'Karan', 103, 'Finance', 75000),
(107, 'Pooja', 103, 'IT', 80000),
(108, 'Rohan', 104, 'IT', 55000),
(109, 'Anjali', 104, 'Sales', 60000),
(110, 'Varun', 105, 'HR', 50000),
(111, 'Meera', 107, 'IT', 58000),
(112, 'Arjun', 107, 'Finance', 62000);


SELECT *
FROM #Employees;


-- =========================================================
-- SECTION 9: DISPLAY EMPLOYEE-MANAGER DETAILS
-- =========================================================

-- A normal self join displays each employee and their manager.

SELECT
    E.EmployeeName AS Employee,
    M.EmployeeName AS Manager
FROM #Employees E
LEFT JOIN #Employees M
    ON E.ManagerID = M.EmployeeID;


-- =========================================================
-- SECTION 10: RECURSIVE CTE FOR EMPLOYEE HIERARCHY
-- =========================================================

/*
We want to display the complete hierarchy starting
from Rahul.

Anchor member:
Select Rahul, whose EmployeeID is 101.

Recursive member:
Find employees whose ManagerID matches the
EmployeeID from the previous level.

Level:
Shows how far an employee is from Rahul.

0 = Rahul
1 = Direct reports
2 = Second-level reports
3 = Third-level reports
*/


;WITH EmployeeHierarchy AS
(
    -- Anchor member
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        Department,
        0 AS HierarchyLevel
    FROM #Employees
    WHERE EmployeeID = 101

    UNION ALL

    -- Recursive member
    SELECT
        E.EmployeeID,
        E.EmployeeName,
        E.ManagerID,
        E.Department,
        EH.HierarchyLevel + 1
    FROM #Employees E
    INNER JOIN EmployeeHierarchy EH
        ON E.ManagerID = EH.EmployeeID
)
SELECT *
FROM EmployeeHierarchy
ORDER BY HierarchyLevel, EmployeeID
OPTION (MAXRECURSION 100);


/*
EXPECTED STRUCTURE:

Rahul     Level 0
Priya     Level 1
Amit      Level 1
Sneha     Level 2
Neha      Level 2
Karan     Level 2
Pooja     Level 2
Rohan     Level 3
Anjali    Level 3
Varun     Level 3
Meera     Level 3
Arjun     Level 3
*/


-- =========================================================
-- SECTION 11: DISPLAY HIERARCHY WITH INDENTATION
-- =========================================================

/*
REPLICATE() repeats a character a specified number
of times.

We use it to visually represent hierarchy levels.
*/


;WITH EmployeeHierarchy AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        0 AS HierarchyLevel
    FROM #Employees
    WHERE EmployeeID = 101

    UNION ALL

    SELECT
        E.EmployeeID,
        E.EmployeeName,
        E.ManagerID,
        EH.HierarchyLevel + 1
    FROM #Employees E
    INNER JOIN EmployeeHierarchy EH
        ON E.ManagerID = EH.EmployeeID
)
SELECT
    EmployeeID,
    REPLICATE('    ', HierarchyLevel)
        + EmployeeName AS EmployeeHierarchy,
    HierarchyLevel
FROM EmployeeHierarchy
ORDER BY HierarchyLevel, EmployeeID
OPTION (MAXRECURSION 100);


-- =========================================================
-- SECTION 12: FIND ALL EMPLOYEES REPORTING TO A MANAGER
-- =========================================================

-- Find all employees directly or indirectly
-- reporting to Priya (EmployeeID 102).

;WITH Subordinates AS
(
    -- Anchor: Direct reports of Priya
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        1 AS LevelNumber
    FROM #Employees
    WHERE ManagerID = 102

    UNION ALL

    -- Recursive: Reports of the previous employees
    SELECT
        E.EmployeeID,
        E.EmployeeName,
        E.ManagerID,
        S.LevelNumber + 1
    FROM #Employees E
    INNER JOIN Subordinates S
        ON E.ManagerID = S.EmployeeID
)
SELECT *
FROM Subordinates
ORDER BY LevelNumber, EmployeeID
OPTION (MAXRECURSION 100);


-- =========================================================
-- SECTION 13: FIND THE MANAGEMENT CHAIN
-- =========================================================

/*
Now we move upward instead of downward.

We start with an employee and repeatedly find
their manager.

Find the management chain of Rohan (EmployeeID 108).
*/


;WITH ManagementChain AS
(
    -- Anchor: Start with Rohan
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        0 AS LevelNumber
    FROM #Employees
    WHERE EmployeeID = 108

    UNION ALL

    -- Recursive: Find the manager of the previous row
    SELECT
        M.EmployeeID,
        M.EmployeeName,
        M.ManagerID,
        MC.LevelNumber + 1
    FROM #Employees M
    INNER JOIN ManagementChain MC
        ON M.EmployeeID = MC.ManagerID
)
SELECT *
FROM ManagementChain
ORDER BY LevelNumber
OPTION (MAXRECURSION 100);


-- =========================================================
-- SECTION 14: MAXRECURSION
-- =========================================================

/*
SQL Server has a default recursion limit of 100.

MAXRECURSION controls how many recursive levels
are allowed.

Examples:

OPTION (MAXRECURSION 10)
    Allows at most 10 recursive levels.

OPTION (MAXRECURSION 100)
    Allows at most 100 recursive levels.

OPTION (MAXRECURSION 0)
    Removes the recursion limit.

IMPORTANT:
MAXRECURSION 0 does not mean recursion stops automatically.
You must provide a correct termination condition.

An incorrect recursive query can continue indefinitely
and consume resources.
*/


-- Example: Generate numbers from 1 to 150.

;WITH Numbers AS
(
    SELECT 1 AS Number

    UNION ALL

    SELECT Number + 1
    FROM Numbers
    WHERE Number < 150
)
SELECT *
FROM Numbers
OPTION (MAXRECURSION 200);


-- =========================================================
-- SECTION 15: UNION ALL IN RECURSIVE CTE
-- =========================================================

/*
A recursive CTE uses an anchor member and a recursive
member.

UNION ALL combines their results.

The anchor and recursive members must return
the same number of columns, in the same order,
with compatible data types.

UNION ALL is commonly used because it preserves
all generated rows and avoids duplicate elimination.

SQL Server recursive CTE syntax uses UNION ALL
or UNION between the last anchor member and
the first recursive member. UNION ALL is the
standard choice for these examples.
*/


-- =========================================================
-- SECTION 16: COMMON RECURSIVE CTE ERRORS
-- =========================================================

/*
ERROR 1: Missing termination condition.

Wrong:
    SELECT Number + 1
    FROM Numbers;

Why?
There is no condition to stop recursion.

Correct:
    SELECT Number + 1
    FROM Numbers
    WHERE Number < 10;


ERROR 2: Mismatched columns.

Anchor:
    SELECT 1 AS Number

Recursive:
    SELECT Number + 1, 'Extra'
    FROM Numbers

Why?
Both members must return the same number of columns.


ERROR 3: Incompatible data types.

Anchor:
    SELECT 1 AS Number

Recursive:
    SELECT 'Two'
    FROM Numbers

Why?
The corresponding columns must have compatible
data types.


ERROR 4: Using an aggregate or GROUP BY in the
recursive member.

SQL Server restricts many operations in the
recursive member, including GROUP BY, scalar
aggregation, DISTINCT, TOP and outer joins.

Perform such operations outside the recursive member
or in a separate query layer when appropriate.


ERROR 5: Assuming ORDER BY inside the CTE controls
the final output.

Always use ORDER BY in the final SELECT
when a particular output order is required.
*/


-- =========================================================
-- SECTION 17: PRACTICE QUESTIONS
-- =========================================================

/*
Q1. Generate numbers from 1 to 20.

Q2. Generate numbers from 20 down to 1.

Q3. Generate even numbers from 2 to 50.

Q4. Generate odd numbers from 1 to 49.

Q5. Generate multiples of 7 up to 70.

Q6. Generate dates from 1 January 2026
    to 31 January 2026.

Q7. Generate the first day of every month
    in 2026.

Q8. Display the complete employee hierarchy
    starting from Rahul.

Q9. Display only direct reports of Rahul.

Q10. Find all employees directly or indirectly
     reporting to Rahul.

Q11. Find all employees reporting to Priya.

Q12. Find the management chain of Rohan.

Q13. Display employee names with their hierarchy levels.

Q14. Display the hierarchy with indentation.

Q15. Find all employees at hierarchy level 2.

Q16. Generate numbers from 1 to 100 using recursion.

Q17. Find all employees under Amit.

Q18. Find the management chain of Anjali.

Q19. Find the maximum hierarchy level under Rahul.

Q20. Find all employees who have at least one subordinate.

Q21. Find employees who have no subordinates.

Q22. Generate a sequence of dates for the next
     15 days starting from 1 November 2026.

Q23. Generate numbers from 5 to 50 in steps of 5.

Q24. Display each employee with their manager's name
     and hierarchy level.

Q25. Find all descendants of employee 103,
     including employees at every lower level.


-- =========================================================
-- SECTION 18: SOLUTIONS
-- ========================================================= */


-- Q1. Numbers from 1 to 20

;WITH Numbers AS
(
    SELECT 1 AS Number

    UNION ALL

    SELECT Number + 1
    FROM Numbers
    WHERE Number < 20
)
SELECT *
FROM Numbers
OPTION (MAXRECURSION 100);


-- Q2. Numbers from 20 down to 1

;WITH Numbers AS
(
    SELECT 20 AS Number

    UNION ALL

    SELECT Number - 1
    FROM Numbers
    WHERE Number > 1
)
SELECT *
FROM Numbers
OPTION (MAXRECURSION 100);


-- Q3. Even numbers from 2 to 50

;WITH EvenNumbers AS
(
    SELECT 2 AS Number

    UNION ALL

    SELECT Number + 2
    FROM EvenNumbers
    WHERE Number < 50
)
SELECT *
FROM EvenNumbers
OPTION (MAXRECURSION 100);


-- Q4. Odd numbers from 1 to 49

;WITH OddNumbers AS
(
    SELECT 1 AS Number

    UNION ALL

    SELECT Number + 2
    FROM OddNumbers
    WHERE Number < 49
)
SELECT *
FROM OddNumbers
OPTION (MAXRECURSION 100);


-- Q5. Multiples of 7 up to 70

;WITH Multiples AS
(
    SELECT 7 AS Number

    UNION ALL

    SELECT Number + 7
    FROM Multiples
    WHERE Number < 70
)
SELECT *
FROM Multiples
OPTION (MAXRECURSION 100);


-- Q6. Dates from 1 January to 31 January 2026

;WITH DateSequence AS
(
    SELECT CAST('2026-01-01' AS DATE) AS CalendarDate

    UNION ALL

    SELECT DATEADD(DAY, 1, CalendarDate)
    FROM DateSequence
    WHERE CalendarDate < '2026-01-31'
)
SELECT *
FROM DateSequence
OPTION (MAXRECURSION 100);


-- Q7. First day of every month in 2026

;WITH MonthSequence AS
(
    SELECT CAST('2026-01-01' AS DATE) AS MonthStart

    UNION ALL

    SELECT DATEADD(MONTH, 1, MonthStart)
    FROM MonthSequence
    WHERE MonthStart < '2026-12-01'
)
SELECT *
FROM MonthSequence
OPTION (MAXRECURSION 100);


-- Q8. Complete hierarchy starting from Rahul

;WITH EmployeeHierarchy AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        0 AS HierarchyLevel
    FROM #Employees
    WHERE EmployeeID = 101

    UNION ALL

    SELECT
        E.EmployeeID,
        E.EmployeeName,
        E.ManagerID,
        EH.HierarchyLevel + 1
    FROM #Employees E
    INNER JOIN EmployeeHierarchy EH
        ON E.ManagerID = EH.EmployeeID
)
SELECT *
FROM EmployeeHierarchy
ORDER BY HierarchyLevel, EmployeeID
OPTION (MAXRECURSION 100);


-- Q9. Direct reports of Rahul

SELECT
    EmployeeID,
    EmployeeName,
    ManagerID
FROM #Employees
WHERE ManagerID = 101;


-- Q10. All employees reporting directly or indirectly to Rahul

;WITH Subordinates AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        1 AS LevelNumber
    FROM #Employees
    WHERE ManagerID = 101

    UNION ALL

    SELECT
        E.EmployeeID,
        E.EmployeeName,
        E.ManagerID,
        S.LevelNumber + 1
    FROM #Employees E
    INNER JOIN Subordinates S
        ON E.ManagerID = S.EmployeeID
)
SELECT *
FROM Subordinates
ORDER BY LevelNumber, EmployeeID
OPTION (MAXRECURSION 100);


-- Q11. All employees reporting to Priya

;WITH Subordinates AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        1 AS LevelNumber
    FROM #Employees
    WHERE ManagerID = 102

    UNION ALL

    SELECT
        E.EmployeeID,
        E.EmployeeName,
        E.ManagerID,
        S.LevelNumber + 1
    FROM #Employees E
    INNER JOIN Subordinates S
        ON E.ManagerID = S.EmployeeID
)
SELECT *
FROM Subordinates
ORDER BY LevelNumber, EmployeeID
OPTION (MAXRECURSION 100);


-- Q12. Management chain of Rohan

;WITH ManagementChain AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        0 AS LevelNumber
    FROM #Employees
    WHERE EmployeeID = 108

    UNION ALL

    SELECT
        M.EmployeeID,
        M.EmployeeName,
        M.ManagerID,
        MC.LevelNumber + 1
    FROM #Employees M
    INNER JOIN ManagementChain MC
        ON M.EmployeeID = MC.ManagerID
)
SELECT *
FROM ManagementChain
ORDER BY LevelNumber
OPTION (MAXRECURSION 100);


-- Q13. Employee names with hierarchy levels

;WITH EmployeeHierarchy AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        0 AS HierarchyLevel
    FROM #Employees
    WHERE EmployeeID = 101

    UNION ALL

    SELECT
        E.EmployeeID,
        E.EmployeeName,
        E.ManagerID,
        EH.HierarchyLevel + 1
    FROM #Employees E
    INNER JOIN EmployeeHierarchy EH
        ON E.ManagerID = EH.EmployeeID
)
SELECT
    EmployeeName,
    HierarchyLevel
FROM EmployeeHierarchy
ORDER BY HierarchyLevel, EmployeeID
OPTION (MAXRECURSION 100);


-- Q14. Hierarchy with indentation

;WITH EmployeeHierarchy AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        0 AS HierarchyLevel
    FROM #Employees
    WHERE EmployeeID = 101

    UNION ALL

    SELECT
        E.EmployeeID,
        E.EmployeeName,
        E.ManagerID,
        EH.HierarchyLevel + 1
    FROM #Employees E
    INNER JOIN EmployeeHierarchy EH
        ON E.ManagerID = EH.EmployeeID
)
SELECT
    REPLICATE('    ', HierarchyLevel)
        + EmployeeName AS EmployeeHierarchy
FROM EmployeeHierarchy
ORDER BY HierarchyLevel, EmployeeID
OPTION (MAXRECURSION 100);


-- Q15. Employees at hierarchy level 2

;WITH EmployeeHierarchy AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        0 AS HierarchyLevel
    FROM #Employees
    WHERE EmployeeID = 101

    UNION ALL

    SELECT
        E.EmployeeID,
        E.EmployeeName,
        E.ManagerID,
        EH.HierarchyLevel + 1
    FROM #Employees E
    INNER JOIN EmployeeHierarchy EH
        ON E.ManagerID = EH.EmployeeID
)
SELECT *
FROM EmployeeHierarchy
WHERE HierarchyLevel = 2
OPTION (MAXRECURSION 100);


-- Q16. Numbers from 1 to 100

;WITH Numbers AS
(
    SELECT 1 AS Number

    UNION ALL

    SELECT Number + 1
    FROM Numbers
    WHERE Number < 100
)
SELECT *
FROM Numbers
OPTION (MAXRECURSION 100);


-- Q17. All employees under Amit

;WITH Subordinates AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        1 AS LevelNumber
    FROM #Employees
    WHERE ManagerID = 103

    UNION ALL

    SELECT
        E.EmployeeID,
        E.EmployeeName,
        E.ManagerID,
        S.LevelNumber + 1
    FROM #Employees E
    INNER JOIN Subordinates S
        ON E.ManagerID = S.EmployeeID
)
SELECT *
FROM Subordinates
ORDER BY LevelNumber, EmployeeID
OPTION (MAXRECURSION 100);


-- Q18. Management chain of Anjali

;WITH ManagementChain AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        0 AS LevelNumber
    FROM #Employees
    WHERE EmployeeID = 109

    UNION ALL

    SELECT
        M.EmployeeID,
        M.EmployeeName,
        M.ManagerID,
        MC.LevelNumber + 1
    FROM #Employees M
    INNER JOIN ManagementChain MC
        ON M.EmployeeID = MC.ManagerID
)
SELECT *
FROM ManagementChain
ORDER BY LevelNumber
OPTION (MAXRECURSION 100);


-- Q19. Maximum hierarchy level under Rahul

;WITH EmployeeHierarchy AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        0 AS HierarchyLevel
    FROM #Employees
    WHERE EmployeeID = 101

    UNION ALL

    SELECT
        E.EmployeeID,
        E.EmployeeName,
        E.ManagerID,
        EH.HierarchyLevel + 1
    FROM #Employees E
    INNER JOIN EmployeeHierarchy EH
        ON E.ManagerID = EH.EmployeeID
)
SELECT MAX(HierarchyLevel) AS MaximumHierarchyLevel
FROM EmployeeHierarchy
OPTION (MAXRECURSION 100);


-- Q20. Employees who have at least one subordinate

SELECT
    M.EmployeeID,
    M.EmployeeName
FROM #Employees M
WHERE EXISTS
(
    SELECT 1
    FROM #Employees E
    WHERE E.ManagerID = M.EmployeeID
);


-- Q21. Employees who have no subordinates

SELECT
    E.EmployeeID,
    E.EmployeeName
FROM #Employees E
WHERE NOT EXISTS
(
    SELECT 1
    FROM #Employees S
    WHERE S.ManagerID = E.EmployeeID
);


-- Q22. Generate 15 dates starting from 1 November 2026

;WITH DateSequence AS
(
    SELECT CAST('2026-11-01' AS DATE) AS CalendarDate

    UNION ALL

    SELECT DATEADD(DAY, 1, CalendarDate)
    FROM DateSequence
    WHERE CalendarDate < '2026-11-15'
)
SELECT *
FROM DateSequence
OPTION (MAXRECURSION 100);


-- Q23. Multiples of 5 from 5 to 50

;WITH Multiples AS
(
    SELECT 5 AS Number

    UNION ALL

    SELECT Number + 5
    FROM Multiples
    WHERE Number < 50
)
SELECT *
FROM Multiples
OPTION (MAXRECURSION 100);


-- Q24. Employee, manager and hierarchy level

;WITH EmployeeHierarchy AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        0 AS HierarchyLevel
    FROM #Employees
    WHERE EmployeeID = 101

    UNION ALL

    SELECT
        E.EmployeeID,
        E.EmployeeName,
        E.ManagerID,
        EH.HierarchyLevel + 1
    FROM #Employees E
    INNER JOIN EmployeeHierarchy EH
        ON E.ManagerID = EH.EmployeeID
)
SELECT
    EH.EmployeeName AS Employee,
    M.EmployeeName AS Manager,
    EH.HierarchyLevel
FROM EmployeeHierarchy EH
LEFT JOIN #Employees M
    ON EH.ManagerID = M.EmployeeID
ORDER BY EH.HierarchyLevel, EH.EmployeeID
OPTION (MAXRECURSION 100);


-- Q25. All descendants of employee 103

;WITH Descendants AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        1 AS LevelNumber
    FROM #Employees
    WHERE ManagerID = 103

    UNION ALL

    SELECT
        E.EmployeeID,
        E.EmployeeName,
        E.ManagerID,
        D.LevelNumber + 1
    FROM #Employees E
    INNER JOIN Descendants D
        ON E.ManagerID = D.EmployeeID
)
SELECT *
FROM Descendants
ORDER BY LevelNumber, EmployeeID
OPTION (MAXRECURSION 100);


-- =========================================================
-- SECTION 19: INTERVIEW REVISION
-- =========================================================

/*
Q1. What is a recursive CTE?

A CTE that references itself to repeatedly process
data until a termination condition is reached.


Q2. What are the three main parts of a recursive CTE?

1. Anchor member.
2. Recursive member.
3. Termination condition.


Q3. What is an anchor member?

The starting query that produces the initial result.


Q4. What is a recursive member?

The query that references the CTE and produces
the next set of results.


Q5. Why do we use UNION ALL?

It combines anchor and recursive results while
preserving duplicate rows.


Q6. What is MAXRECURSION?

An option that controls the maximum number of
recursive levels SQL Server permits.


Q7. What is the default MAXRECURSION value?

100.


Q8. What does MAXRECURSION 0 mean?

It removes the recursion limit. It does not provide
an automatic stopping condition.


Q9. Can recursive CTEs generate dates?

Yes.


Q10. Can recursive CTEs generate number sequences?

Yes.


Q11. Can recursive CTEs handle employee hierarchies?

Yes. They can follow ManagerID and EmployeeID
relationships.


Q12. What happens if the recursive member has
no stopping condition?

The query may continue until SQL Server reaches
the recursion limit and returns an error.


Q13. What is the difference between a normal CTE
and a recursive CTE?

Normal CTE:
- Does not reference itself.
- Used to organize query logic.

Recursive CTE:
- References itself.
- Used for hierarchical or iterative data.


Q14. Must the anchor and recursive members return
the same number of columns?

Yes. Corresponding columns must have compatible
data types.


Q15. Can we use GROUP BY in the recursive member?

SQL Server does not allow GROUP BY in the recursive
member. Perform aggregation outside it.


Q16. What is a common real-world use of recursive CTE?

Employee-manager hierarchy, category trees,
organizational structures and parent-child relationships.


============================================================
END OF RECURSIVE CTE PRACTICE
============================================================
*/