/*
============================================================
SQL PRACTICE 01: TRANSACTIONS AND PERFORMANCE
============================================================

Topics:
1. Transactions
2. ACID Properties
3. BEGIN TRANSACTION
4. COMMIT and ROLLBACK
5. SAVE TRANSACTION
6. TRY...CATCH
7. XACT_STATE() and @@TRANCOUNT
8. Isolation Levels
9. Dirty Reads
10. Non-Repeatable Reads
11. Phantom Reads
12. Locks and Blocking
13. Deadlocks
14. Indexes
15. Execution Plans
16. Query Optimization
17. Practical Exercises and Solutions

============================================================
*/


-- =========================================================
-- SECTION 1: WHAT IS A TRANSACTION?
-- =========================================================

/*
WHAT IS A TRANSACTION?

A transaction is a logical unit of work consisting
of one or more SQL operations.

Either all required operations should succeed,
or the transaction should be rolled back.

WHY USE TRANSACTIONS?

1. Maintain data consistency.
2. Protect important database operations.
3. Prevent incomplete updates.
4. Handle multiple related operations safely.
5. Support concurrent users.


REAL-WORLD EXAMPLE: BANK TRANSFER

Rahul transfers Rs. 5,000 to Priya.

Initial balance:

Rahul = 20,000
Priya = 10,000

Operations:

1. Deduct 5,000 from Rahul.
2. Add 5,000 to Priya.

Expected result:

Rahul = 15,000
Priya = 15,000

What if the first operation succeeds but the
second operation fails?

Without a transaction, money could disappear
from Rahul's account without reaching Priya.

A transaction protects both operations.
*/


-- =========================================================
-- SECTION 2: CREATE SAMPLE TABLES
-- =========================================================

/*
This practice section uses temporary tables.
They are automatically removed when the session ends.
*/


DROP TABLE IF EXISTS #Accounts;
DROP TABLE IF EXISTS #Employees;


CREATE TABLE #Accounts
(
    AccountID INT PRIMARY KEY,
    AccountHolder VARCHAR(100),
    Balance DECIMAL(12,2)
);


INSERT INTO #Accounts
VALUES
(1, 'Rahul', 20000),
(2, 'Priya', 10000),
(3, 'Amit', 15000);


SELECT *
FROM #Accounts;


CREATE TABLE #Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);


INSERT INTO #Employees
VALUES
(101, 'Rahul', 'IT', 75000),
(102, 'Priya', 'HR', 55000),
(103, 'Amit', 'IT', 85000),
(104, 'Sneha', 'Finance', 65000),
(105, 'Neha', 'HR', 60000),
(106, 'Rohan', 'IT', 90000);


SELECT *
FROM #Employees;


-- =========================================================
-- SECTION 3: ACID PROPERTIES
-- =========================================================

/*
ACID represents four important transaction properties.

A = ATOMICITY
C = CONSISTENCY
I = ISOLATION
D = DURABILITY


1. ATOMICITY

All operations in a transaction succeed together,
or the transaction is rolled back.

Example:
Both sides of a bank transfer must succeed.


2. CONSISTENCY

A transaction must move the database from
one valid state to another valid state.

All applicable constraints and rules must
remain satisfied.

Example:
Account balance should not become negative
if the business rules prohibit negative balances.


3. ISOLATION

Concurrent transactions should not interfere
with one another in ways that violate the
selected isolation guarantees.

Example:
Two users updating the same account must not
produce an incorrect balance.


4. DURABILITY

Once a transaction is committed, its changes
are durable even after a system failure,
subject to the database's durability guarantees.


INTERVIEW SHORTCUT:

A = All or nothing
C = Consistent data
I = Independent concurrent execution
D = Data remains committed
*/


-- =========================================================
-- SECTION 4: BEGIN TRANSACTION, COMMIT, ROLLBACK
-- =========================================================

/*
BEGIN TRANSACTION:
Starts an explicit transaction.

COMMIT:
Makes the transaction's changes permanent.

ROLLBACK:
Undoes the transaction's uncommitted changes.

SYNTAX:

BEGIN TRANSACTION;

SQL statements;

COMMIT TRANSACTION;

OR

ROLLBACK TRANSACTION;
*/


-- ---------------------------------------------------------
-- 4.1 BEGIN TRANSACTION AND COMMIT
-- ---------------------------------------------------------

SELECT *
FROM #Accounts;


BEGIN TRANSACTION;

UPDATE #Accounts
SET Balance = Balance - 5000
WHERE AccountID = 1;

UPDATE #Accounts
SET Balance = Balance + 5000
WHERE AccountID = 2;

COMMIT TRANSACTION;


SELECT *
FROM #Accounts;


-- Result:
-- Rahul = 15000
-- Priya = 15000


-- ---------------------------------------------------------
-- 4.2 BEGIN TRANSACTION AND ROLLBACK
-- ---------------------------------------------------------

BEGIN TRANSACTION;

UPDATE #Accounts
SET Balance = Balance - 2000
WHERE AccountID = 1;

UPDATE #Accounts
SET Balance = Balance + 2000
WHERE AccountID = 2;


-- Check changes before rollback.

SELECT *
FROM #Accounts;


-- Undo both updates.

ROLLBACK TRANSACTION;


-- Original committed balances are restored.

SELECT *
FROM #Accounts;


-- ---------------------------------------------------------
-- 4.3 ROLLBACK WHEN A CONDITION FAILS
-- ---------------------------------------------------------

/*
A transaction can check business rules
before committing its changes.
*/


DECLARE @TransferAmount DECIMAL(12,2) = 3000;
DECLARE @SenderBalance DECIMAL(12,2);


BEGIN TRANSACTION;

SELECT
    @SenderBalance = Balance
FROM #Accounts
WHERE AccountID = 1;

IF @SenderBalance IS NULL
   OR @TransferAmount <= 0
   OR @SenderBalance < @TransferAmount
BEGIN
    ROLLBACK TRANSACTION;

    SELECT 'Transfer rejected.' AS Message;
END
ELSE
BEGIN
    UPDATE #Accounts
    SET Balance = Balance - @TransferAmount
    WHERE AccountID = 1;

    UPDATE #Accounts
    SET Balance = Balance + @TransferAmount
    WHERE AccountID = 2;

    COMMIT TRANSACTION;

    SELECT 'Transfer successful.' AS Message;
END;


SELECT *
FROM #Accounts;


-- =========================================================
-- SECTION 5: SAVE TRANSACTION (SAVEPOINT)
-- =========================================================

/*
SAVE TRANSACTION creates a savepoint inside
an active transaction.

You can roll back to that savepoint without
rolling back the entire transaction.

SYNTAX:

SAVE TRANSACTION SavepointName;

ROLLBACK TRANSACTION SavepointName;


IMPORTANT:

SQL Server does not support independently
committing a savepoint.

A savepoint is not a separate transaction.
*/


SELECT *
FROM #Accounts;


BEGIN TRANSACTION;

UPDATE #Accounts
SET Balance = Balance + 1000
WHERE AccountID = 1;


SAVE TRANSACTION AfterFirstUpdate;


UPDATE #Accounts
SET Balance = Balance + 2000
WHERE AccountID = 2;


-- Check both changes.

SELECT *
FROM #Accounts;


-- Undo only the second update.

ROLLBACK TRANSACTION AfterFirstUpdate;


SELECT *
FROM #Accounts;


-- Commit the first update.

COMMIT TRANSACTION;


SELECT *
FROM #Accounts;


-- =========================================================
-- SECTION 6: TRY...CATCH WITH TRANSACTIONS
-- =========================================================

/*
TRY...CATCH is used for error handling.

BEGIN TRY:
Contains statements that may generate errors.

BEGIN CATCH:
Handles errors raised in the TRY block.

XACT_STATE():

 1  = Active transaction that can be committed.
 0  = No active user transaction.
-1  = Active but uncommittable transaction.

@@TRANCOUNT:
Returns the number of active transaction
nesting levels.


IMPORTANT:

A transaction with XACT_STATE() = -1
cannot be committed.

It must be rolled back.
*/


-- ---------------------------------------------------------
-- 6.1 BASIC TRY...CATCH
-- ---------------------------------------------------------

BEGIN TRY

    SELECT 10 / 2 AS Result;

END TRY

BEGIN CATCH

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;

END CATCH;


-- ---------------------------------------------------------
-- 6.2 HANDLE DIVIDE-BY-ZERO ERROR
-- ---------------------------------------------------------

BEGIN TRY

    SELECT 10 / 0 AS Result;

END TRY

BEGIN CATCH

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_LINE() AS ErrorLine;

END CATCH;


-- ---------------------------------------------------------
-- 6.3 TRY...CATCH WITH TRANSACTION
-- ---------------------------------------------------------

BEGIN TRY

    BEGIN TRANSACTION;

    UPDATE #Accounts
    SET Balance = Balance - 1000
    WHERE AccountID = 1;

    -- Deliberately generate an error.

    DECLARE @InvalidCalculation INT = 10 / 0;

    UPDATE #Accounts
    SET Balance = Balance + 1000
    WHERE AccountID = 2;

    COMMIT TRANSACTION;

END TRY

BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        XACT_STATE() AS TransactionState;

END CATCH;


SELECT *
FROM #Accounts;


-- =========================================================
-- SECTION 7: IMPLICIT AND EXPLICIT TRANSACTIONS
-- =========================================================

/*
EXPLICIT TRANSACTION:

You manually control the transaction.

BEGIN TRANSACTION
COMMIT
ROLLBACK


IMPLICIT TRANSACTION:

SQL Server automatically starts a transaction
for certain statements when IMPLICIT_TRANSACTIONS
is ON.

You must explicitly COMMIT or ROLLBACK it.

IMPORTANT:

Do not enable implicit transactions casually
in a practice session. An open transaction can
hold locks and block other users.

Check the setting:

DBCC USEROPTIONS;

The setting can be controlled using:

SET IMPLICIT_TRANSACTIONS ON;
SET IMPLICIT_TRANSACTIONS OFF;
*/


-- =========================================================
-- SECTION 8: TRANSACTION ISOLATION LEVELS
-- =========================================================

/*
Isolation levels control how transactions
interact when multiple users access data
at the same time.

SQL Server isolation levels:

1. READ UNCOMMITTED
2. READ COMMITTED
3. REPEATABLE READ
4. SERIALIZABLE
5. SNAPSHOT


1. READ UNCOMMITTED

Allows reading uncommitted changes from
another transaction.

Dirty reads are possible.

2. READ COMMITTED

Prevents dirty reads.

This is the default isolation level in
SQL Server unless changed.

Non-repeatable reads and phantom reads
can still occur.

3. REPEATABLE READ

Prevents dirty reads and non-repeatable reads.

Phantom reads can still occur.

4. SERIALIZABLE

Provides the strongest traditional locking-based
isolation level.

Prevents dirty reads, non-repeatable reads
and phantom reads by using appropriate locks.

5. SNAPSHOT

Reads a transactionally consistent row-versioned
snapshot of data.

Readers generally do not block writers in the
same way as locking-based isolation.

Snapshot isolation must be enabled for the database.


COMPARISON:

Isolation Level    Dirty Read    Non-repeatable    Phantom

READ UNCOMMITTED      Yes             Yes            Yes
READ COMMITTED        No              Yes            Yes
REPEATABLE READ       No              No             Yes
SERIALIZABLE          No              No             No
SNAPSHOT              No              No             No

NOTE:
READ COMMITTED can use locking or row versioning
depending on database settings.
*/


-- ---------------------------------------------------------
-- 8.1 SET ISOLATION LEVEL
-- ---------------------------------------------------------

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT *
FROM #Accounts;


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT *
FROM #Accounts;


SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT *
FROM #Accounts;


-- Restore the usual default for this session.

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


-- ---------------------------------------------------------
-- 8.2 READ UNCOMMITTED
-- ---------------------------------------------------------

/*
NOLOCK is equivalent to READ UNCOMMITTED
for the referenced table in common SQL Server usage.

It can return:
- Uncommitted data.
- Rows more than once.
- Missing rows.
- Inconsistent results.

Do not use NOLOCK as a universal performance fix.
*/


SELECT *
FROM #Employees WITH (NOLOCK);


-- Alternative session-level setting:

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT *
FROM #Employees;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


-- =========================================================
-- SECTION 9: CONCURRENCY PROBLEMS
-- =========================================================

/*
These examples are conceptual.

To observe concurrency issues, open two separate
SSMS query windows connected to the same database.

Use permanent tables in a practice database
for the two-session experiments, because local
temporary tables such as #Accounts are visible
only to the session that created them.


1. DIRTY READ

Transaction A modifies data but has not committed.

Transaction B reads that uncommitted data.

If A rolls back, B has read a value that
was never committed.


2. NON-REPEATABLE READ

Transaction A reads the same row twice.

Transaction B updates and commits that row
between the two reads.

Transaction A gets different values
for the same row.


3. PHANTOM READ

Transaction A runs the same range query twice.

Transaction B inserts or deletes rows that
match the range and commits.

The second query in A returns a different
set of rows.


4. LOST UPDATE

Two transactions read the same original value.

Both calculate a new value.

One transaction overwrites the other's change
because the update was based on stale data.

Proper locking, isolation and atomic updates
help prevent lost-update problems.
*/


-- =========================================================
-- SECTION 10: LOCKS AND BLOCKING
-- =========================================================

/*
WHAT IS A LOCK?

A lock controls access to database resources
while transactions are running.

WHY USE LOCKS?

To maintain consistency when multiple users
access or modify the same data.


COMMON LOCK TYPES:

1. SHARED LOCK (S)

Used mainly for reading data.

Multiple transactions can usually hold
shared locks on the same resource.


2. EXCLUSIVE LOCK (X)

Used for modifying data.

Only one transaction can hold an exclusive
lock on a resource at a time.


3. UPDATE LOCK (U)

Used when SQL Server plans to update a resource.
It helps reduce certain conversion deadlocks.


4. INTENT LOCK

Indicates that a transaction intends to acquire
locks at a lower level of the object hierarchy.


5. SCHEMA LOCKS

Control access during schema-related operations.


LOCK GRANULARITY:

- Row
- Key
- Page
- Table
- Database

SQL Server chooses locks based on the operation,
isolation level, plan and other factors.


BLOCKING:

One transaction waits because another transaction
holds an incompatible lock.

Blocking is not automatically an error.
It can be normal in a transactional system.
*/


-- ---------------------------------------------------------
-- 10.1 DEMONSTRATE BLOCKING
-- ---------------------------------------------------------

/*
For this example, create a permanent practice table
in a dedicated database and use two SSMS windows.

SESSION A:

BEGIN TRANSACTION;

UPDATE dbo.TransactionDemo
SET Balance = Balance + 100
WHERE AccountID = 1;

-- Keep this transaction open.

SESSION B:

SELECT *
FROM dbo.TransactionDemo
WHERE AccountID = 1;

Under locking READ COMMITTED, Session B may wait
until Session A commits or rolls back.

SESSION A:

COMMIT TRANSACTION;


IMPORTANT:
Do not leave transactions open unnecessarily.
*/


-- ---------------------------------------------------------
-- 10.2 VIEW CURRENT REQUESTS AND BLOCKING
-- ---------------------------------------------------------

/*
Run this when you suspect blocking.

Requires appropriate server permissions.
*/


SELECT
    session_id,
    blocking_session_id,
    wait_type,
    wait_time,
    status,
    command
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;


-- =========================================================
-- SECTION 11: DEADLOCKS
-- =========================================================

/*
WHAT IS A DEADLOCK?

A deadlock occurs when two or more transactions
are waiting for resources held by one another,
creating a cycle of dependencies.

SQL Server detects the deadlock and chooses
one transaction as the victim.

The victim transaction is rolled back.

EXAMPLE:

Transaction A:
Locks Account 1.
Waits for Account 2.

Transaction B:
Locks Account 2.
Waits for Account 1.

Both wait for each other.

SQL Server detects the cycle and chooses
a victim.


HOW TO REDUCE DEADLOCKS?

1. Access tables in a consistent order.
2. Keep transactions short.
3. Avoid unnecessary user interaction
   inside transactions.
4. Create appropriate indexes.
5. Update only required rows.
6. Handle deadlock error 1205 with a retry strategy
   when the operation is safe to retry.

IMPORTANT:
A deadlock is different from ordinary blocking.
Blocking may resolve when a lock is released.
A deadlock involves a cycle, so SQL Server
must break it by choosing a victim.
*/


-- =========================================================
-- SECTION 12: INDEXES
-- =========================================================

/*
WHAT IS AN INDEX?

An index is a database structure that helps SQL Server
locate rows more efficiently.

Think of an index in a book.

Without an index:
You may need to search page by page.

With an index:
You can quickly find the relevant page.


WHY USE INDEXES?

1. Improve data retrieval.
2. Speed up suitable WHERE conditions.
3. Improve JOIN performance.
4. Help ORDER BY and GROUP BY in some cases.
5. Support unique constraints.


TYPES:

1. CLUSTERED INDEX
2. NONCLUSTERED INDEX
3. UNIQUE INDEX
4. COMPOSITE INDEX
5. FILTERED INDEX
6. COLUMNSTORE INDEX


CLUSTERED INDEX:

Determines the row organisation of the table
through its clustered index structure.

A table can have only one clustered index.


NONCLUSTERED INDEX:

A separate index structure containing key values
and row locators to find the underlying rows.

A table can have multiple nonclustered indexes.


IMPORTANT:

A PRIMARY KEY does not always have to be
a clustered index.

SQL Server normally creates a clustered index
for a primary key unless a different choice
or existing index design is specified.
*/


-- ---------------------------------------------------------
-- 12.1 CLUSTERED INDEX
-- ---------------------------------------------------------

/*
The primary key on #Employees is already created
as a clustered index by default in this example.

Inspect the indexes:

sp_helpindex '#Employees';
*/


EXEC tempdb.sys.sp_helpindex '#Employees';


-- Create a separate table to demonstrate
-- clustered and nonclustered index creation.

CREATE TABLE #IndexDemo
(
    EmployeeID INT NOT NULL,
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);


INSERT INTO #IndexDemo
VALUES
(101, 'Rahul', 'IT', 75000),
(102, 'Priya', 'HR', 55000),
(103, 'Amit', 'IT', 85000),
(104, 'Sneha', 'Finance', 65000),
(105, 'Neha', 'HR', 60000);


-- Create clustered index.

CREATE CLUSTERED INDEX IX_IndexDemo_EmployeeID
ON #IndexDemo(EmployeeID);


SELECT *
FROM #IndexDemo
WHERE EmployeeID = 103;


-- ---------------------------------------------------------
-- 12.2 NONCLUSTERED INDEX
-- ---------------------------------------------------------

CREATE NONCLUSTERED INDEX IX_IndexDemo_Department
ON #IndexDemo(Department);


SELECT *
FROM #IndexDemo
WHERE Department = 'IT';


-- ---------------------------------------------------------
-- 12.3 COMPOSITE INDEX
-- ---------------------------------------------------------

/*
A composite index uses more than one key column.

Column order matters.

Example:

(Department, Salary)

Useful for queries that filter by Department
and may also filter or sort by Salary.
*/


CREATE NONCLUSTERED INDEX IX_IndexDemo_Department_Salary
ON #IndexDemo(Department, Salary);


SELECT *
FROM #IndexDemo
WHERE Department = 'IT'
  AND Salary > 70000;


-- ---------------------------------------------------------
-- 12.4 UNIQUE INDEX
-- ---------------------------------------------------------

CREATE UNIQUE NONCLUSTERED INDEX UX_IndexDemo_EmployeeID
ON #IndexDemo(EmployeeID);


-- This fails because EmployeeID 101 already exists.
-- Uncomment to test.

/*
INSERT INTO #IndexDemo
VALUES
(101, 'Duplicate', 'IT', 50000);
*/


-- ---------------------------------------------------------
-- 12.5 FILTERED INDEX
-- ---------------------------------------------------------

/*
A filtered index contains only rows that satisfy
the filter predicate.

It can reduce index size and improve queries
that frequently access a particular subset.
*/


CREATE NONCLUSTERED INDEX IX_IndexDemo_ITEmployees
ON #IndexDemo(EmployeeID)
INCLUDE (EmployeeName, Salary)
WHERE Department = 'IT';


SELECT
    EmployeeID,
    EmployeeName,
    Salary
FROM #IndexDemo
WHERE Department = 'IT';


-- ---------------------------------------------------------
-- 12.6 INCLUDE COLUMNS
-- ---------------------------------------------------------

/*
INCLUDE columns are non-key columns stored
at the leaf level of a nonclustered index.

They can help cover a query without making
every selected column an index key.
*/


CREATE NONCLUSTERED INDEX IX_IndexDemo_Department_Include
ON #IndexDemo(Department)
INCLUDE (EmployeeName, Salary);


-- ---------------------------------------------------------
-- 12.7 DROP INDEX
-- ---------------------------------------------------------

-- DROP INDEX IX_IndexDemo_Department ON #IndexDemo;


-- =========================================================
-- SECTION 13: INDEX SEEK VS INDEX SCAN
-- =========================================================

/*
INDEX SEEK:

SQL Server navigates an index to find
a qualifying range or set of keys.

INDEX SCAN:

SQL Server reads all or a large part of
an index structure.

TABLE SCAN:

SQL Server reads the table's data pages
without using a nonclustered index to locate
the requested rows.


IMPORTANT:

A scan is not always bad.

For a query returning a large percentage of rows,
a scan may be more efficient than many lookups.

A seek is not always better in every situation.

The execution plan and actual workload matter.
*/


-- Query that may use an index seek.

SELECT *
FROM #IndexDemo
WHERE EmployeeID = 103;


-- Query that may use an index scan.

SELECT *
FROM #IndexDemo;


-- =========================================================
-- SECTION 14: EXECUTION PLANS
-- =========================================================

/*
WHAT IS AN EXECUTION PLAN?

An execution plan shows how SQL Server intends
to retrieve or modify data.

It includes operations such as:

1. Index Seek
2. Index Scan
3. Table Scan
4. Nested Loops
5. Hash Match
6. Merge Join
7. Sort
8. Key Lookup


TYPES:

1. Estimated Execution Plan
   Shows the plan SQL Server expects to use.

2. Actual Execution Plan
   Shows the plan used during execution,
   including actual runtime information.


HOW TO VIEW IN SSMS:

Estimated Execution Plan:
Ctrl + L

Actual Execution Plan:
Ctrl + M, then execute the query.


IMPORTANT:

An execution plan helps identify expensive operations.
Do not optimise based only on one operator's name.
Check actual rows, estimated rows, reads,
CPU time and elapsed time.
*/


-- Query 1.

SELECT *
FROM #Employees
WHERE EmployeeID = 103;


-- Query 2.

SELECT *
FROM #Employees
WHERE Department = 'IT';


-- Query 3.

SELECT
    Department,
    AVG(Salary) AS AverageSalary
FROM #Employees
GROUP BY Department;


-- =========================================================
-- SECTION 15: QUERY OPTIMIZATION
-- =========================================================

/*
WHAT IS QUERY OPTIMIZATION?

Query optimization is the process of improving
query performance while preserving correct results.


COMMON TECHNIQUES:

1. Avoid SELECT * when unnecessary.
2. Create indexes based on actual query patterns.
3. Filter rows early when appropriate.
4. Avoid unnecessary DISTINCT.
5. Avoid unnecessary sorting.
6. Use suitable JOIN conditions.
7. Avoid functions on indexed filter columns
   when they prevent efficient index access.
8. Check actual execution plans.
9. Avoid returning unnecessary rows.
10. Keep statistics updated.


EXAMPLE 1: SELECT *

LESS PRECISE:

SELECT *
FROM #Employees;


BETTER WHEN ONLY TWO COLUMNS ARE NEEDED:

SELECT
    EmployeeName,
    Salary
FROM #Employees;


EXAMPLE 2: FUNCTION ON FILTER COLUMN

LESS INDEX-FRIENDLY:

SELECT *
FROM #Employees
WHERE YEAR(EmployeeID) = 101;


BETTER:

SELECT *
FROM #Employees
WHERE EmployeeID = 101;


NOTE:
The first example is intentionally unsuitable:
EmployeeID is an integer, so YEAR(EmployeeID)
does not represent a meaningful date filter.
*/


-- ---------------------------------------------------------
-- 15.1 AVOID FUNCTION ON DATE COLUMN
-- ---------------------------------------------------------

CREATE TABLE #Sales
(
    SaleID INT PRIMARY KEY,
    SaleDate DATETIME2,
    Amount DECIMAL(10,2)
);


INSERT INTO #Sales
VALUES
(1, '2025-01-10 10:30:00', 1000),
(2, '2025-01-15 14:00:00', 2000),
(3, '2025-02-01 09:00:00', 1500),
(4, '2025-02-20 17:30:00', 3000),
(5, '2025-03-05 12:00:00', 2500);


-- Less index-friendly for a large indexed table.

SELECT *
FROM #Sales
WHERE YEAR(SaleDate) = 2025
  AND MONTH(SaleDate) = 1;


-- More index-friendly date range.

SELECT *
FROM #Sales
WHERE SaleDate >= '2025-01-01'
  AND SaleDate < '2025-02-01';


-- Create an index on SaleDate.

CREATE NONCLUSTERED INDEX IX_Sales_SaleDate
ON #Sales(SaleDate);


-- ---------------------------------------------------------
-- 15.2 USE EXISTS WHEN ONLY EXISTENCE MATTERS
-- ---------------------------------------------------------

-- Find employees who belong to a department.

SELECT
    E.EmployeeID,
    E.EmployeeName
FROM #Employees AS E
WHERE EXISTS
(
    SELECT 1
    FROM #Employees AS E2
    WHERE E2.Department = E.Department
);


-- NOTE:
-- This example checks whether a department value
-- exists among employee rows. It is not a substitute
-- for a real Departments table relationship.


-- ---------------------------------------------------------
-- 15.3 AVOID UNNECESSARY DISTINCT
-- ---------------------------------------------------------

-- DISTINCT removes duplicate result rows.
-- It may require additional work such as sorting
-- or hashing.

SELECT DISTINCT Department
FROM #Employees;


-- If duplicates are required, do not use DISTINCT.

SELECT Department
FROM #Employees;


-- =========================================================
-- SECTION 16: STATISTICS AND PERFORMANCE CHECKS
-- =========================================================

/*
STATISTICS:

SQL Server uses statistics to estimate how many
rows a query may return.

These estimates help the optimizer choose
an execution plan.

Useful commands:

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

IO:
Shows logical and physical read information.

TIME:
Shows CPU time and elapsed time.
*/


SET STATISTICS IO ON;
SET STATISTICS TIME ON;


SELECT *
FROM #Employees
WHERE Department = 'IT';


SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


-- Update statistics on a permanent table:
-- UPDATE STATISTICS dbo.Employees;


-- Rebuild an index on a permanent table:
-- ALTER INDEX IX_Employees_Department
-- ON dbo.Employees REBUILD;


-- =========================================================
-- SECTION 17: PRACTICE QUESTIONS
-- =========================================================

/*
TRANSACTIONS

Q1. What is a transaction?

Q2. Explain ACID properties.

Q3. What is BEGIN TRANSACTION?

Q4. Difference between COMMIT and ROLLBACK.

Q5. What is SAVE TRANSACTION?

Q6. Can a savepoint be committed independently?

Q7. What is the difference between implicit
    and explicit transactions?

Q8. What is @@TRANCOUNT?

Q9. What is XACT_STATE()?

Q10. Why do we use TRY...CATCH with transactions?


ISOLATION LEVELS

Q11. What is an isolation level?

Q12. Explain READ UNCOMMITTED.

Q13. Explain READ COMMITTED.

Q14. Explain REPEATABLE READ.

Q15. Explain SERIALIZABLE.

Q16. What is SNAPSHOT isolation?

Q17. What is a dirty read?

Q18. What is a non-repeatable read?

Q19. What is a phantom read?

Q20. What is a lost update?


LOCKING AND DEADLOCKS

Q21. What is a lock?

Q22. Difference between shared and exclusive locks.

Q23. What is blocking?

Q24. What is a deadlock?

Q25. How can deadlocks be reduced?


INDEXES AND PERFORMANCE

Q26. What is an index?

Q27. Clustered vs nonclustered index.

Q28. Can a table have multiple clustered indexes?

Q29. What is a composite index?

Q30. What is a unique index?

Q31. What is a filtered index?

Q32. What are INCLUDE columns?

Q33. Index seek vs index scan.

Q34. What is an execution plan?

Q35. Estimated vs actual execution plan.

Q36. What is query optimization?

Q37. What are SQL Server statistics?

Q38. Why should SELECT * be avoided when possible?

Q39. Why can functions on indexed columns
     affect query performance?

Q40. Is an index always beneficial?


-- =========================================================
-- SECTION 18: PRACTICE SOLUTIONS
-- ========================================================= */


-- Q1. What is a transaction?
-- Answer:
-- A logical unit of work containing one or more
-- database operations that are handled together.


-- Q2. ACID:
-- Atomicity: All or nothing.
-- Consistency: Valid database state.
-- Isolation: Controlled concurrent execution.
-- Durability: Committed changes remain durable.


-- Q3. BEGIN TRANSACTION:
-- Starts an explicit transaction.


-- Q4. COMMIT vs ROLLBACK:
-- COMMIT saves the transaction's changes.
-- ROLLBACK undoes uncommitted changes.


-- Q5. SAVE TRANSACTION:
-- Creates a savepoint inside an active transaction.


-- Q6. Can a savepoint be committed independently?
-- No. SQL Server savepoints cannot be committed
-- independently.


-- Q7. Implicit vs explicit:
-- Explicit: Developer starts and ends the transaction.
-- Implicit: SQL Server automatically starts a transaction
-- when implicit transaction mode is enabled.


-- Q8. @@TRANCOUNT:
-- Returns the number of active transaction
-- nesting levels.


-- Q9. XACT_STATE():
--  1 = Active and committable.
--  0 = No active user transaction.
-- -1 = Active but uncommittable.


-- Q10. TRY...CATCH:
-- Handles errors and allows appropriate rollback
-- or error reporting.


-- Q11. Isolation level:
-- Defines how transactions interact with
-- concurrent transactions.


-- Q12. READ UNCOMMITTED:
-- Allows dirty reads.


-- Q13. READ COMMITTED:
-- Prevents dirty reads.


-- Q14. REPEATABLE READ:
-- Prevents dirty reads and non-repeatable reads.


-- Q15. SERIALIZABLE:
-- Prevents dirty reads, non-repeatable reads
-- and phantom reads.


-- Q16. SNAPSHOT:
-- Uses row versioning to provide a transactionally
-- consistent snapshot of data.


-- Q17. Dirty read:
-- Reading uncommitted changes from another transaction.


-- Q18. Non-repeatable read:
-- Reading the same row twice and getting different
-- values because another transaction updated it.


-- Q19. Phantom read:
-- Repeating a range query and getting a different
-- set of rows because another transaction inserted
-- or deleted matching rows.


-- Q20. Lost update:
-- One transaction overwrites another transaction's
-- change using stale data.


-- Q21. Lock:
-- A mechanism that controls concurrent access
-- to database resources.


-- Q22. Shared vs exclusive:
-- Shared locks are primarily used for reading.
-- Exclusive locks are used for modifications.


-- Q23. Blocking:
-- A transaction waits because another transaction
-- holds an incompatible lock.


-- Q24. Deadlock:
-- Transactions wait on one another in a cycle.
-- SQL Server selects a victim to break the cycle.


-- Q25. Reduce deadlocks:
-- Keep transactions short, access resources in
-- consistent order, use suitable indexes and
-- handle deadlock retries safely.


-- Q26. Index:
-- A database structure that helps locate rows
-- more efficiently.


-- Q27. Clustered vs nonclustered:
-- Clustered index defines the table's row
-- organisation through its index structure.
-- Nonclustered index is a separate structure
-- containing keys and row locators.


-- Q28. Multiple clustered indexes?
-- No. A table can have only one clustered index.


-- Q29. Composite index:
-- An index containing multiple key columns.


-- Q30. Unique index:
-- An index that prevents duplicate key values.


-- Q31. Filtered index:
-- An index containing only rows that satisfy
-- a specified filter condition.


-- Q32. INCLUDE columns:
-- Non-key columns stored at the leaf level
-- of a nonclustered index.


-- Q33. Seek vs scan:
-- Seek navigates to matching index keys.
-- Scan reads all or a large part of an index
-- or table structure.


-- Q34. Execution plan:
-- Shows the operations SQL Server uses
-- to execute a query.


-- Q35. Estimated vs actual:
-- Estimated shows the expected plan.
-- Actual includes runtime information from
-- the executed query.


-- Q36. Query optimization:
-- Improving query performance without changing
-- the intended result.


-- Q37. Statistics:
-- Information about data distribution used
-- by the query optimizer to estimate row counts.


-- Q38. Avoid SELECT *:
-- It may retrieve unnecessary columns,
-- increasing data transfer and resource usage.


-- Q39. Functions on indexed columns:
-- They can prevent efficient index access
-- when SQL Server cannot use a suitable seek.


-- Q40. Are indexes always beneficial?
-- No. Indexes require storage and add work
-- to INSERT, UPDATE and DELETE operations.
-- Use indexes based on actual workload.


-- =========================================================
-- SECTION 19: FINAL INTERVIEW REVISION
-- =========================================================

/*
TRANSACTION:
A logical unit of database work.

ACID:
Atomicity, Consistency, Isolation, Durability.

COMMIT:
Makes changes permanent.

ROLLBACK:
Undoes uncommitted changes.

SAVE TRANSACTION:
Creates a savepoint.

DIRTY READ:
Reading uncommitted data.

NON-REPEATABLE READ:
The same row returns different values
within a transaction.

PHANTOM READ:
A repeated range query returns a different
set of rows.

LOCK:
Controls concurrent access.

BLOCKING:
One transaction waits for another.

DEADLOCK:
A cycle of waiting transactions.

CLUSTERED INDEX:
The table has one clustered index structure
that defines its row organisation.

NONCLUSTERED INDEX:
A separate index structure with keys
and row locators.

INDEX SEEK:
Navigates to qualifying keys.

INDEX SCAN:
Reads all or a large part of an index.

EXECUTION PLAN:
Shows how SQL Server executes a query.

QUERY OPTIMIZATION:
Improving performance while preserving results.

INTERVIEW TIP:

When asked how you optimize a slow query,
do not immediately say "create an index."

A stronger answer:

1. Check the actual execution plan.
2. Check logical reads and execution time.
3. Verify estimated vs actual row counts.
4. Inspect JOIN and WHERE conditions.
5. Check existing indexes and statistics.
6. Test a suitable index or query rewrite.
7. Compare performance before and after.

============================================================
END OF TRANSACTIONS AND PERFORMANCE PRACTICE
============================================================
*/