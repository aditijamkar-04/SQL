/*
============================================================
SQL PRACTICE 01: SQL COMMANDS
============================================================

Topics:
1. DDL - Data Definition Language
2. DML - Data Manipulation Language
3. DQL - Data Query Language
4. DCL - Data Control Language
5. TCL - Transaction Control Language

Commands covered:

DDL:
CREATE, ALTER, DROP, TRUNCATE

DML:
INSERT, UPDATE, DELETE, MERGE

DQL:
SELECT

DCL:
GRANT, REVOKE, DENY

TCL:
BEGIN TRANSACTION, COMMIT, ROLLBACK, SAVE TRANSACTION

============================================================
*/


-- =========================================================
-- SECTION 1: UNDERSTANDING SQL COMMAND CATEGORIES
-- =========================================================

/*
SQL commands are commonly divided into five categories.

1. DDL - Data Definition Language
   Used to create and modify database structures.

2. DML - Data Manipulation Language
   Used to insert, update and delete table data.

3. DQL - Data Query Language
   Used to retrieve data.

4. DCL - Data Control Language
   Used to manage database permissions.

5. TCL - Transaction Control Language
   Used to manage transactions.


QUICK REVISION:

DDL  = Structure
DML  = Data modification
DQL  = Data retrieval
DCL  = Permissions
TCL  = Transactions
*/


-- =========================================================
-- SECTION 2: DDL - DATA DEFINITION LANGUAGE
-- =========================================================

/*
DDL commands work with database objects such as:
- Tables
- Views
- Schemas
- Indexes

Main commands:

CREATE  - Creates an object.
ALTER   - Changes an existing object.
DROP    - Removes an object.
TRUNCATE - Removes all rows from a table.
*/


-- ---------------------------------------------------------
-- 2.1 CREATE
-- ---------------------------------------------------------

/*
CREATE is used to create database objects.

Example:
CREATE TABLE table_name
(
    column_name datatype
);
*/


CREATE TABLE #Departments
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL,
    Location VARCHAR(50)
);


CREATE TABLE #Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10,2),
    JoiningDate DATE,
    FOREIGN KEY (DepartmentID)
        REFERENCES #Departments(DepartmentID)
);


INSERT INTO #Departments
VALUES
(1, 'IT', 'Pune'),
(2, 'HR', 'Mumbai'),
(3, 'Finance', 'Hyderabad'),
(4, 'Sales', 'Delhi');


INSERT INTO #Employees
VALUES
(101, 'Rahul', 1, 75000, '2022-01-10'),
(102, 'Priya', 2, 55000, '2021-05-15'),
(103, 'Amit', 1, 85000, '2020-08-20'),
(104, 'Sneha', 3, 65000, '2023-02-10'),
(105, 'Neha', 4, 50000, '2022-11-05'),
(106, 'Karan', 3, 80000, '2021-09-12'),
(107, 'Pooja', 2, 60000, '2023-06-18'),
(108, 'Rohan', 1, 90000, '2019-04-25');


SELECT * FROM #Departments;
SELECT * FROM #Employees;


-- ---------------------------------------------------------
-- 2.2 ALTER
-- ---------------------------------------------------------

/*
ALTER modifies the structure of an existing object.

Common operations:

ADD COLUMN
ALTER COLUMN
DROP COLUMN
ADD CONSTRAINT
DROP CONSTRAINT
*/


-- Add a new column.

ALTER TABLE #Employees
ADD Email VARCHAR(100);


-- Add another column with a default value.

ALTER TABLE #Employees
ADD IsActive BIT NOT NULL
    CONSTRAINT DF_TempEmployees_IsActive DEFAULT 1;


-- Change the datatype or size of a column.

ALTER TABLE #Employees
ALTER COLUMN EmployeeName VARCHAR(150) NOT NULL;


-- Add a new column with a default value to existing rows.

ALTER TABLE #Employees
ADD City VARCHAR(50) NULL;


-- Update values in the newly added columns.

UPDATE #Employees
SET
    Email = LOWER(EmployeeName) + '@company.com',
    City = 'Pune';


SELECT * FROM #Employees;


-- Drop a column.

ALTER TABLE #Employees
DROP COLUMN City;


-- Add a CHECK constraint.

ALTER TABLE #Employees
ADD CONSTRAINT CK_TempEmployees_Salary
CHECK (Salary >= 0);


-- Check the table structure.

EXEC sp_help '#Employees';


-- ---------------------------------------------------------
-- 2.3 DROP
-- ---------------------------------------------------------

/*
DROP permanently removes a database object.

Example:
DROP TABLE table_name;

After dropping a table:
- The table structure is removed.
- Its data is removed.
- The table cannot be queried.
*/


-- Create a sample table.

CREATE TABLE #DropPractice
(
    ID INT,
    Name VARCHAR(50)
);


INSERT INTO #DropPractice
VALUES
(1, 'Rahul'),
(2, 'Priya');


SELECT * FROM #DropPractice;


-- Remove the table.

DROP TABLE #DropPractice;


-- Uncomment to test the error:
-- SELECT * FROM #DropPractice;


-- ---------------------------------------------------------
-- 2.4 TRUNCATE
-- ---------------------------------------------------------

/*
TRUNCATE removes all rows from a table.

Important:
- Table structure remains.
- All rows are removed.
- WHERE cannot be used.
- It is generally more efficient than deleting
  every row individually.
- SQL Server resets an IDENTITY counter to its seed
  when the table is successfully truncated.

SQL Server restriction:
A table referenced by a FOREIGN KEY constraint
cannot be truncated, even if the referencing table
currently contains no rows.
*/


CREATE TABLE #TruncatePractice
(
    ID INT IDENTITY(1,1),
    Name VARCHAR(50)
);


INSERT INTO #TruncatePractice
VALUES
('Rahul'),
('Priya'),
('Amit');


SELECT * FROM #TruncatePractice;


-- Remove all records but retain the table.

TRUNCATE TABLE #TruncatePractice;


-- Check the table after truncation.

SELECT * FROM #TruncatePractice;


-- Insert again to observe the IDENTITY value.

INSERT INTO #TruncatePractice
VALUES ('Sneha');


SELECT * FROM #TruncatePractice;


-- =========================================================
-- SECTION 3: DELETE VS TRUNCATE VS DROP
-- =========================================================

/*
DELETE:
- DML command.
- Removes selected rows or all rows.
- Supports WHERE.
- Table structure remains.
- SQL Server logs row deletions.
- Does not automatically reset IDENTITY.

TRUNCATE:
- Commonly classified as DDL.
- Removes all rows.
- Does not support WHERE.
- Table structure remains.
- Uses page deallocation rather than logging
  each deleted row individually.
- Resets IDENTITY to its seed.
- Has FOREIGN KEY restrictions.

DROP:
- DDL command.
- Removes the table object itself.
- Removes its data and structure.
- The table no longer exists.


IMPORTANT INTERVIEW POINT:

TRUNCATE is generally faster for removing all rows,
but it is not universally interchangeable with DELETE.

SQL Server can roll back DELETE, TRUNCATE and DROP
when executed inside an explicit transaction,
provided the transaction is still active.
*/


-- =========================================================
-- SECTION 4: DML - DATA MANIPULATION LANGUAGE
-- =========================================================

/*
DML is used to modify data stored inside tables.

Main commands:

INSERT - Adds records.
UPDATE - Modifies existing records.
DELETE - Removes records.
MERGE  - Performs insert/update/delete actions
         based on a source-target comparison.
*/


-- ---------------------------------------------------------
-- 4.1 INSERT
-- ---------------------------------------------------------

/*
INSERT adds new rows to a table.

Syntax:

INSERT INTO table_name (column1, column2)
VALUES (value1, value2);
*/


-- Insert one row.

INSERT INTO #Employees
(
    EmployeeID,
    EmployeeName,
    DepartmentID,
    Salary,
    JoiningDate
)
VALUES
(109, 'Anjali', 2, 58000, '2024-01-15');


-- Insert multiple rows.

INSERT INTO #Employees
(
    EmployeeID,
    EmployeeName,
    DepartmentID,
    Salary,
    JoiningDate
)
VALUES
(110, 'Varun', 1, 72000, '2023-08-10'),
(111, 'Meera', 4, 62000, '2024-03-20');


-- Insert records from another table.

CREATE TABLE #NewEmployees
(
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10,2),
    JoiningDate DATE
);


INSERT INTO #NewEmployees
VALUES
(112, 'Arjun', 3, 68000, '2024-05-10'),
(113, 'Isha', 2, 57000, '2024-06-15');


INSERT INTO #Employees
(
    EmployeeID,
    EmployeeName,
    DepartmentID,
    Salary,
    JoiningDate
)
SELECT
    EmployeeID,
    EmployeeName,
    DepartmentID,
    Salary,
    JoiningDate
FROM #NewEmployees;


SELECT * FROM #Employees;


-- ---------------------------------------------------------
-- 4.2 UPDATE
-- ---------------------------------------------------------

/*
UPDATE modifies existing records.

Syntax:

UPDATE table_name
SET column = value
WHERE condition;

IMPORTANT:
Without WHERE, every row in the table is updated.
*/


-- Update one employee's salary.

UPDATE #Employees
SET Salary = 80000
WHERE EmployeeID = 101;


-- Update multiple columns.

UPDATE #Employees
SET
    Salary = 85000,
    EmployeeName = 'Rahul Sharma'
WHERE EmployeeID = 101;


-- Increase salary by 10% for IT employees.

UPDATE #Employees
SET Salary = Salary * 1.10
WHERE DepartmentID = 1;


-- Update using a condition.

UPDATE #Employees
SET Salary = Salary + 5000
WHERE Salary < 60000;


SELECT * FROM #Employees;


-- ---------------------------------------------------------
-- 4.3 DELETE
-- ---------------------------------------------------------

/*
DELETE removes rows from a table.

Syntax:

DELETE FROM table_name
WHERE condition;

IMPORTANT:
Without WHERE, every row is deleted,
but the table structure remains.
*/


-- Delete one employee.

DELETE FROM #Employees
WHERE EmployeeID = 113;


-- Delete employees whose salary is below 55000.

DELETE FROM #Employees
WHERE Salary < 55000;


-- Delete all rows from a sample table.

CREATE TABLE #DeletePractice
(
    ID INT,
    Name VARCHAR(50)
);


INSERT INTO #DeletePractice
VALUES
(1, 'Rahul'),
(2, 'Priya'),
(3, 'Amit');


DELETE FROM #DeletePractice;


SELECT * FROM #DeletePractice;


-- =========================================================
-- SECTION 5: MERGE
-- =========================================================

/*
MERGE compares a source table with a target table
using a matching condition.

It can perform:

WHEN MATCHED:
    UPDATE or DELETE.

WHEN NOT MATCHED BY TARGET:
    INSERT.

WHEN NOT MATCHED BY SOURCE:
    DELETE or UPDATE rows in the target that
    have no matching source row.

Typical uses:
- Synchronising data.
- Updating records from a staging table.
- Loading data into a target table.

IMPORTANT:
MERGE requires careful matching conditions and
concurrency testing in production.
For some workloads, separate INSERT and UPDATE
statements may be easier to maintain.
*/


CREATE TABLE #TargetEmployees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10,2)
);


CREATE TABLE #SourceEmployees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10,2)
);


-- Existing target data.

INSERT INTO #TargetEmployees
VALUES
(1, 'Rahul', 50000),
(2, 'Priya', 60000),
(3, 'Amit', 55000);


-- Incoming source data.

INSERT INTO #SourceEmployees
VALUES
(2, 'Priya Sharma', 65000),
(3, 'Amit', 55000),
(4, 'Sneha', 70000);


SELECT * FROM #TargetEmployees;
SELECT * FROM #SourceEmployees;


-- Perform MERGE.

MERGE INTO #TargetEmployees AS Target
USING #SourceEmployees AS Source
ON Target.EmployeeID = Source.EmployeeID

WHEN MATCHED THEN
    UPDATE SET
        Target.EmployeeName = Source.EmployeeName,
        Target.Salary = Source.Salary

WHEN NOT MATCHED BY TARGET THEN
    INSERT
    (
        EmployeeID,
        EmployeeName,
        Salary
    )
    VALUES
    (
        Source.EmployeeID,
        Source.EmployeeName,
        Source.Salary
    );


-- Check updated target table.

SELECT * FROM #TargetEmployees;


-- Example of deleting target rows that are missing
-- from the source.
-- Run this separately if you want to test it.
-- It removes target rows 1 because ID 1 is absent
-- from the source table.

/*
MERGE INTO #TargetEmployees AS Target
USING #SourceEmployees AS Source
ON Target.EmployeeID = Source.EmployeeID

WHEN MATCHED THEN
    UPDATE SET Target.Salary = Source.Salary

WHEN NOT MATCHED BY TARGET THEN
    INSERT (EmployeeID, EmployeeName, Salary)
    VALUES (Source.EmployeeID, Source.EmployeeName, Source.Salary)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
*/


-- =========================================================
-- SECTION 6: DQL - DATA QUERY LANGUAGE
-- =========================================================

/*
DQL is used to retrieve data.

Main command:

SELECT

SELECT can retrieve:
- All columns.
- Specific columns.
- Filtered rows.
- Sorted rows.
- Grouped data.
- Aggregated results.
- Joined records.
*/


-- Retrieve all records.

SELECT *
FROM #Employees;


-- Retrieve selected columns.

SELECT
    EmployeeID,
    EmployeeName,
    Salary
FROM #Employees;


-- Retrieve employees earning more than 70000.

SELECT *
FROM #Employees
WHERE Salary > 70000;


-- Sort employees by salary.

SELECT *
FROM #Employees
ORDER BY Salary DESC;


-- Department-wise average salary.

SELECT
    DepartmentID,
    AVG(Salary) AS AverageSalary
FROM #Employees
GROUP BY DepartmentID;


-- =========================================================
-- SECTION 7: DCL - DATA CONTROL LANGUAGE
-- =========================================================

/*
DCL manages database permissions.

Main commands:

GRANT:
Gives permission.

REVOKE:
Removes a permission grant or denial.

DENY:
Explicitly denies permission.

These commands operate on database security
principals such as users and roles.

IMPORTANT:
The following examples use a database user
that must already exist.

Do not create a real user or grant permissions
without understanding the security impact.
*/


-- Check database users.

SELECT
    name,
    type_desc
FROM sys.database_principals
WHERE principal_id > 4;


-- ---------------------------------------------------------
-- 7.1 GRANT
-- ---------------------------------------------------------

/*
GRANT provides permission to a user or role.

Example:

GRANT SELECT
ON OBJECT::dbo.Employees
TO UserName;
*/


-- Example syntax:
-- Replace PracticeUser with an existing database user.

/*
GRANT SELECT
ON OBJECT::dbo.Employees
TO PracticeUser;
*/


-- Grant multiple permissions.

/*
GRANT SELECT, INSERT
ON OBJECT::dbo.Employees
TO PracticeUser;
*/


-- ---------------------------------------------------------
-- 7.2 DENY
-- ---------------------------------------------------------

/*
DENY explicitly prevents a permission.

Example:

DENY DELETE
ON OBJECT::dbo.Employees
TO PracticeUser;

A DENY normally overrides a GRANT for the same
permission, subject to SQL Server permission
hierarchy and ownership exceptions.
*/


/*
DENY DELETE
ON OBJECT::dbo.Employees
TO PracticeUser;
*/


-- ---------------------------------------------------------
-- 7.3 REVOKE
-- ---------------------------------------------------------

/*
REVOKE removes a GRANT or DENY permission.

It does not necessarily give access.

If another permission source still grants or denies
access, that permission source continues to apply.
*/


/*
REVOKE SELECT
ON OBJECT::dbo.Employees
FROM PracticeUser;
*/


-- =========================================================
-- SECTION 8: GRANT VS DENY VS REVOKE
-- =========================================================

/*
GRANT:
Allows a permission.

DENY:
Explicitly blocks a permission.

REVOKE:
Removes an explicit GRANT or DENY.

Example:

GRANT SELECT TO PracticeUser;

The user receives SELECT permission.

DENY SELECT TO PracticeUser;

The user is explicitly denied SELECT permission.

REVOKE SELECT FROM PracticeUser;

The explicit permission entry is removed.
Other permissions inherited through roles or other
security mechanisms may still apply.


INTERVIEW TIP:

REVOKE does not mean GRANT.

Removing a DENY is not the same as explicitly
granting permission.
*/


-- =========================================================
-- SECTION 9: TCL - TRANSACTION CONTROL LANGUAGE
-- =========================================================

/*
TCL manages transactions.

A transaction is a logical unit of work.

Example:
Suppose we transfer 5000 from Account A to Account B.

Two operations must happen:

1. Deduct 5000 from Account A.
2. Add 5000 to Account B.

Both should succeed together.

If one operation fails, we should be able to
undo the transaction.

Main commands:

BEGIN TRANSACTION
COMMIT
ROLLBACK
SAVE TRANSACTION
*/


-- ---------------------------------------------------------
-- 9.1 CREATE ACCOUNT TABLE
-- ---------------------------------------------------------

CREATE TABLE #Accounts
(
    AccountID INT PRIMARY KEY,
    AccountHolder VARCHAR(100),
    Balance DECIMAL(12,2)
);


INSERT INTO #Accounts
VALUES
(1, 'Rahul', 20000),
(2, 'Priya', 15000),
(3, 'Amit', 10000);


SELECT * FROM #Accounts;


-- ---------------------------------------------------------
-- 9.2 BEGIN TRANSACTION
-- ---------------------------------------------------------

/*
BEGIN TRANSACTION starts an explicit transaction.

Changes are not committed until COMMIT is executed.
They can be undone using ROLLBACK while the
transaction is active.
*/


BEGIN TRANSACTION;

UPDATE #Accounts
SET Balance = Balance - 5000
WHERE AccountID = 1;

UPDATE #Accounts
SET Balance = Balance + 5000
WHERE AccountID = 2;

SELECT * FROM #Accounts;


-- ---------------------------------------------------------
-- 9.3 COMMIT
-- ---------------------------------------------------------

/*
COMMIT makes the transaction changes permanent.

Execute COMMIT to complete the transaction.
*/


COMMIT TRANSACTION;

SELECT * FROM #Accounts;


-- ---------------------------------------------------------
-- 9.4 ROLLBACK
-- ---------------------------------------------------------

/*
ROLLBACK undoes the changes made in the active
transaction.

Use it when an operation fails or when you
want to cancel the transaction.
*/


BEGIN TRANSACTION;

UPDATE #Accounts
SET Balance = Balance - 3000
WHERE AccountID = 1;

UPDATE #Accounts
SET Balance = Balance + 3000
WHERE AccountID = 3;

SELECT * FROM #Accounts;


-- Undo both updates.

ROLLBACK TRANSACTION;

SELECT * FROM #Accounts;


-- ---------------------------------------------------------
-- 9.5 SAVE TRANSACTION
-- ---------------------------------------------------------

/*
SAVE TRANSACTION creates a savepoint inside
an active transaction.

You can roll back to that savepoint without
rolling back the entire transaction.

SQL Server uses:

SAVE TRANSACTION SavepointName;

ROLLBACK TRANSACTION SavepointName;
*/


BEGIN TRANSACTION;

-- First operation.

UPDATE #Accounts
SET Balance = Balance - 1000
WHERE AccountID = 1;


-- Create a savepoint.

SAVE TRANSACTION FirstSavepoint;


-- Second operation.

UPDATE #Accounts
SET Balance = Balance + 2000
WHERE AccountID = 2;


SELECT * FROM #Accounts;


-- Undo only the changes after the savepoint.

ROLLBACK TRANSACTION FirstSavepoint;


SELECT * FROM #Accounts;


-- Commit the remaining transaction.

COMMIT TRANSACTION;


SELECT * FROM #Accounts;


-- =========================================================
-- SECTION 10: TRANSACTION WITH TRY...CATCH
-- =========================================================

/*
TRY...CATCH handles errors.

A common transaction pattern:

1. Begin transaction.
2. Execute operations.
3. Commit if successful.
4. Catch errors.
5. Roll back if the transaction is still active.

XACT_STATE():

 1  = Active and committable transaction.
 0  = No active transaction.
-1  = Active but uncommittable transaction.

@@TRANCOUNT:
Returns the number of active transactions
in the current session.
*/


BEGIN TRY

    BEGIN TRANSACTION;

    UPDATE #Accounts
    SET Balance = Balance - 2000
    WHERE AccountID = 1;

    UPDATE #Accounts
    SET Balance = Balance + 2000
    WHERE AccountID = 2;

    COMMIT TRANSACTION;

    PRINT 'Transaction completed successfully.';

END TRY

BEGIN CATCH

    IF XACT_STATE() <> 0
    BEGIN
        ROLLBACK TRANSACTION;
    END;

    PRINT 'Transaction failed.';
    PRINT ERROR_MESSAGE();

END CATCH;


SELECT * FROM #Accounts;


-- =========================================================
-- SECTION 11: DELETE, TRUNCATE AND DROP IN TRANSACTIONS
-- =========================================================

/*
In SQL Server, DELETE, TRUNCATE and DROP can be
rolled back when performed inside an explicit
transaction that is still active.

Let's test with a temporary table.
*/


CREATE TABLE #TransactionPractice
(
    ID INT,
    Name VARCHAR(50)
);


INSERT INTO #TransactionPractice
VALUES
(1, 'Rahul'),
(2, 'Priya'),
(3, 'Amit');


-- Test DELETE rollback.

BEGIN TRANSACTION;

DELETE FROM #TransactionPractice
WHERE ID = 1;

SELECT * FROM #TransactionPractice;

ROLLBACK TRANSACTION;

SELECT * FROM #TransactionPractice;


-- Test TRUNCATE rollback.

BEGIN TRANSACTION;

TRUNCATE TABLE #TransactionPractice;

SELECT * FROM #TransactionPractice;

ROLLBACK TRANSACTION;

SELECT * FROM #TransactionPractice;


-- Test DROP rollback.

BEGIN TRANSACTION;

DROP TABLE #TransactionPractice;

ROLLBACK TRANSACTION;


-- The table exists again after rollback.

SELECT * FROM #TransactionPractice;


-- =========================================================
-- SECTION 12: AUTOCOMMIT VS EXPLICIT TRANSACTION
-- =========================================================

/*
SQL Server normally operates in autocommit mode.

AUTOCOMMIT:
Each individual statement is treated as a transaction
and committed automatically if successful.

EXPLICIT TRANSACTION:
You control when the transaction starts and ends.

Example:

UPDATE #Accounts
SET Balance = Balance + 1000
WHERE AccountID = 1;

Without an explicit transaction, this successful
statement is committed automatically.

With BEGIN TRANSACTION, you can COMMIT or ROLLBACK
the group of statements.
*/


-- =========================================================
-- SECTION 13: IMPORTANT DIFFERENCES
-- =========================================================

/*
1. DDL VS DML

DDL:
Works with database structure.

DML:
Works with table data.


2. DELETE VS TRUNCATE

DELETE:
Can remove selected rows.
Supports WHERE.
Does not reset IDENTITY automatically.

TRUNCATE:
Removes all rows.
Does not support WHERE.
Resets IDENTITY to its seed.


3. TRUNCATE VS DROP

TRUNCATE:
Removes rows but keeps the table.

DROP:
Removes the table object.


4. COMMIT VS ROLLBACK

COMMIT:
Saves transaction changes.

ROLLBACK:
Undoes transaction changes.


5. GRANT VS DENY

GRANT:
Allows access.

DENY:
Explicitly blocks access.


6. REVOKE VS DENY

REVOKE:
Removes a permission grant or denial.

DENY:
Explicitly denies a permission.


7. SAVE TRANSACTION VS COMMIT

SAVE TRANSACTION:
Creates a savepoint.

COMMIT:
Finishes and commits the transaction.


8. INSERT VS MERGE

INSERT:
Adds rows.

MERGE:
Can insert, update or delete based on
matching source and target records.
*/


-- =========================================================
-- SECTION 14: PRACTICE QUESTIONS
-- =========================================================

/*
Q1. Create a table named Students with:
    StudentID, StudentName, Age, City.

Q2. Add an Email column to Students.

Q3. Change the size of StudentName to VARCHAR(150).

Q4. Remove the Email column.

Q5. Create a table named Courses.

Q6. Insert five student records.

Q7. Update the city of one student.

Q8. Increase the age of all students by 1.

Q9. Delete one student using StudentID.

Q10. Delete all records without dropping the table.

Q11. Explain the difference between DELETE and TRUNCATE.

Q12. Explain the difference between TRUNCATE and DROP.

Q13. Create a source table and target table.

Q14. Use MERGE to update matching records and
     insert new records.

Q15. Retrieve all students using SELECT.

Q16. Explain DDL, DML and DQL with examples.

Q17. Explain GRANT, REVOKE and DENY.

Q18. Create an explicit transaction.

Q19. Update a record and COMMIT the transaction.

Q20. Update a record and ROLLBACK the transaction.

Q21. Create a savepoint and roll back to it.

Q22. Explain autocommit mode.

Q23. Can TRUNCATE be rolled back in SQL Server?

Q24. Can DROP be rolled back in SQL Server?

Q25. What is the purpose of TRY...CATCH in transactions?

Q26. What is @@TRANCOUNT?

Q27. What is XACT_STATE()?

Q28. What happens if UPDATE is executed without WHERE?

Q29. What is the difference between SAVE TRANSACTION
     and COMMIT?

Q30. Explain a real-world bank transfer using TCL.


-- =========================================================
-- SECTION 15: PRACTICE QUESTION SOLUTIONS
-- ========================================================= */


-- Q1. Create Students table.

CREATE TABLE #Students
(
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100),
    Age INT,
    City VARCHAR(50)
);


-- Q2. Add Email column.

ALTER TABLE #Students
ADD Email VARCHAR(100);


-- Q3. Change StudentName size.

ALTER TABLE #Students
ALTER COLUMN StudentName VARCHAR(150);


-- Q4. Remove Email column.

ALTER TABLE #Students
DROP COLUMN Email;


-- Q5. Create Courses table.

CREATE TABLE #Courses
(
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100)
);


-- Q6. Insert five students.

INSERT INTO #Students
VALUES
(1, 'Rahul', 21, 'Pune'),
(2, 'Priya', 22, 'Mumbai'),
(3, 'Amit', 20, 'Delhi'),
(4, 'Sneha', 23, 'Hyderabad'),
(5, 'Neha', 21, 'Nagpur');


-- Q7. Update one student's city.

UPDATE #Students
SET City = 'Pune'
WHERE StudentID = 2;


-- Q8. Increase everyone's age by one.

UPDATE #Students
SET Age = Age + 1;


-- Q9. Delete one student.

DELETE FROM #Students
WHERE StudentID = 5;


-- Q10. Delete all rows but keep the table.

DELETE FROM #Students;


-- Q13 and Q14. MERGE example.

CREATE TABLE #StudentTarget
(
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100),
    City VARCHAR(50)
);


CREATE TABLE #StudentSource
(
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100),
    City VARCHAR(50)
);


INSERT INTO #StudentTarget
VALUES
(1, 'Rahul', 'Pune'),
(2, 'Priya', 'Mumbai');


INSERT INTO #StudentSource
VALUES
(2, 'Priya Sharma', 'Delhi'),
(3, 'Amit', 'Nagpur');


MERGE INTO #StudentTarget AS Target
USING #StudentSource AS Source
ON Target.StudentID = Source.StudentID

WHEN MATCHED THEN
    UPDATE SET
        Target.StudentName = Source.StudentName,
        Target.City = Source.City

WHEN NOT MATCHED BY TARGET THEN
    INSERT
    (
        StudentID,
        StudentName,
        City
    )
    VALUES
    (
        Source.StudentID,
        Source.StudentName,
        Source.City
    );


SELECT * FROM #StudentTarget;


-- Q15. Retrieve students.

SELECT * FROM #Students;


-- Q18 and Q19. Create a transaction and commit.

BEGIN TRANSACTION;

UPDATE #Accounts
SET Balance = Balance + 1000
WHERE AccountID = 1;

COMMIT TRANSACTION;


-- Q20. Rollback a transaction.

BEGIN TRANSACTION;

UPDATE #Accounts
SET Balance = Balance + 5000
WHERE AccountID = 2;

ROLLBACK TRANSACTION;


-- Q21. Savepoint and rollback.

BEGIN TRANSACTION;

UPDATE #Accounts
SET Balance = Balance - 500
WHERE AccountID = 1;

SAVE TRANSACTION StudentSavepoint;

UPDATE #Accounts
SET Balance = Balance + 500
WHERE AccountID = 2;

ROLLBACK TRANSACTION StudentSavepoint;

COMMIT TRANSACTION;


-- Q22. Check active transaction count.

SELECT @@TRANCOUNT AS ActiveTransactionCount;


-- Q23. Check transaction state.

SELECT XACT_STATE() AS TransactionState;


-- =========================================================
-- SECTION 16: FINAL INTERVIEW REVISION
-- =========================================================

/*
DDL:
CREATE, ALTER, DROP, TRUNCATE

DML:
INSERT, UPDATE, DELETE, MERGE

DQL:
SELECT

DCL:
GRANT, REVOKE, DENY

TCL:
BEGIN TRANSACTION, COMMIT, ROLLBACK,
SAVE TRANSACTION


IMPORTANT SQL SERVER NOTES:

1. TRUNCATE is commonly classified as DDL.

2. DELETE, TRUNCATE and DROP can be rolled back
   in an active SQL Server transaction.

3. TRUNCATE cannot be used on a table referenced
   by a FOREIGN KEY constraint.

4. TRUNCATE does not support WHERE.

5. DELETE does not automatically reset IDENTITY.

6. TRUNCATE resets IDENTITY to its seed.

7. DROP removes the database object.

8. SAVE TRANSACTION creates a savepoint,
   not a separate independent transaction.

9. COMMIT completes the transaction.

10. ROLLBACK without a savepoint rolls back
    the entire active transaction.

11. SQL Server supports TRY...CATCH for error handling.

12. XACT_STATE() helps identify transaction state.

13. @@TRANCOUNT reports the number of active
    transaction nesting levels.

============================================================
END OF SQL COMMANDS PRACTICE
============================================================
*/