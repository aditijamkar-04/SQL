/*
============================================================
SQL PRACTICE 01: DATABASE OBJECTS
============================================================

Topics:
1. Views
2. Stored Procedures
3. Input and Output Parameters
4. Scalar Functions
5. Table-Valued Functions
6. Triggers
7. INSERTED and DELETED Tables
8. Difference Between Database Objects
9. Practical Exercises and Solutions

============================================================
*/


-- =========================================================
-- SECTION 1: CREATE SAMPLE TABLES
-- =========================================================

DROP VIEW IF EXISTS dbo.vw_EmployeeDetails;
DROP PROCEDURE IF EXISTS dbo.usp_GetEmployees;
DROP PROCEDURE IF EXISTS dbo.usp_AddEmployee;
DROP FUNCTION IF EXISTS dbo.fn_AnnualSalary;
DROP FUNCTION IF EXISTS dbo.fn_GetEmployeesByDepartment;
DROP TRIGGER IF EXISTS dbo.trg_Employee_Insert;
DROP TRIGGER IF EXISTS dbo.trg_Employee_Update;

DROP TABLE IF EXISTS dbo.EmployeeAudit;
DROP TABLE IF EXISTS dbo.Employees;
DROP TABLE IF EXISTS dbo.Departments;


CREATE TABLE dbo.Departments
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);


CREATE TABLE dbo.Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10,2),
    JoiningDate DATE,

    FOREIGN KEY (DepartmentID)
        REFERENCES dbo.Departments(DepartmentID)
);


INSERT INTO dbo.Departments
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance'),
(4, 'Sales');


INSERT INTO dbo.Employees
VALUES
(101, 'Rahul', 1, 75000, '2022-01-10'),
(102, 'Priya', 2, 55000, '2021-05-15'),
(103, 'Amit', 1, 85000, '2020-08-20'),
(104, 'Sneha', 3, 65000, '2023-02-10'),
(105, 'Neha', 4, 50000, '2022-11-05'),
(106, 'Karan', 3, 80000, '2021-09-12'),
(107, 'Pooja', 2, 60000, '2023-06-18'),
(108, 'Rohan', 1, 90000, '2019-04-25');


SELECT * FROM dbo.Departments;
SELECT * FROM dbo.Employees;


-- =========================================================
-- SECTION 2: VIEWS
-- =========================================================

/*
WHAT IS A VIEW?

A view is a virtual table based on a SELECT query.

It stores the query definition, not a separate
copy of the underlying data in a normal view.

WHY USE VIEWS?

1. Simplify complex queries.
2. Hide unnecessary columns.
3. Provide controlled access to data.
4. Reuse frequently needed queries.
5. Present data in a convenient format.

SYNTAX:

CREATE VIEW ViewName
AS
SELECT columns
FROM table_name;
*/


-- ---------------------------------------------------------
-- 2.1 CREATE VIEW
-- ---------------------------------------------------------

CREATE VIEW dbo.vw_EmployeeDetails
AS
SELECT
    E.EmployeeID,
    E.EmployeeName,
    D.DepartmentName,
    E.Salary,
    E.JoiningDate
FROM dbo.Employees AS E
INNER JOIN dbo.Departments AS D
    ON E.DepartmentID = D.DepartmentID;


-- Retrieve data from the view.

SELECT *
FROM dbo.vw_EmployeeDetails;


-- Select specific columns.

SELECT
    EmployeeName,
    DepartmentName,
    Salary
FROM dbo.vw_EmployeeDetails;


-- Filter data from a view.

SELECT *
FROM dbo.vw_EmployeeDetails
WHERE Salary > 70000;


-- Sort data from a view.

SELECT *
FROM dbo.vw_EmployeeDetails
ORDER BY Salary DESC;


-- ---------------------------------------------------------
-- 2.2 ALTER VIEW
-- ---------------------------------------------------------

/*
ALTER VIEW changes the definition of an existing view.

It does not create another view.
*/


ALTER VIEW dbo.vw_EmployeeDetails
AS
SELECT
    E.EmployeeID,
    E.EmployeeName,
    D.DepartmentName,
    E.Salary,
    E.JoiningDate
FROM dbo.Employees AS E
INNER JOIN dbo.Departments AS D
    ON E.DepartmentID = D.DepartmentID
WHERE E.Salary >= 50000;


SELECT *
FROM dbo.vw_EmployeeDetails;


-- ---------------------------------------------------------
-- 2.3 CREATE OR ALTER VIEW
-- ---------------------------------------------------------

/*
CREATE OR ALTER VIEW:

Creates the view if it does not exist.
Modifies the view if it already exists.

Useful when maintaining database scripts.
*/


CREATE OR ALTER VIEW dbo.vw_ITEmployees
AS
SELECT
    EmployeeID,
    EmployeeName,
    Salary
FROM dbo.Employees
WHERE DepartmentID = 1;


SELECT *
FROM dbo.vw_ITEmployees;


-- ---------------------------------------------------------
-- 2.4 DROP VIEW
-- ---------------------------------------------------------

/*
DROP VIEW removes the view definition.

It does not delete the original table data.
*/


-- DROP VIEW dbo.vw_ITEmployees;


-- ---------------------------------------------------------
-- 2.5 VIEW WITH GROUP BY
-- ---------------------------------------------------------

CREATE OR ALTER VIEW dbo.vw_DepartmentSalary
AS
SELECT
    D.DepartmentName,
    COUNT(E.EmployeeID) AS EmployeeCount,
    AVG(E.Salary) AS AverageSalary,
    SUM(E.Salary) AS TotalSalary
FROM dbo.Departments AS D
LEFT JOIN dbo.Employees AS E
    ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName;


SELECT *
FROM dbo.vw_DepartmentSalary;


-- ---------------------------------------------------------
-- 2.6 VIEW WITH CHECK OPTION
-- ---------------------------------------------------------

/*
WITH CHECK OPTION prevents INSERT or UPDATE through
a view if the resulting row does not satisfy the
view's WHERE condition.

The view must be updatable for the operation.
*/


CREATE OR ALTER VIEW dbo.vw_HighSalaryEmployees
AS
SELECT
    EmployeeID,
    EmployeeName,
    DepartmentID,
    Salary
FROM dbo.Employees
WHERE Salary >= 70000
WITH CHECK OPTION;


SELECT *
FROM dbo.vw_HighSalaryEmployees;


-- This update satisfies the view condition.

UPDATE dbo.vw_HighSalaryEmployees
SET Salary = 76000
WHERE EmployeeID = 101;


-- This update violates the view condition.
-- Uncomment to test the error.

/*
UPDATE dbo.vw_HighSalaryEmployees
SET Salary = 40000
WHERE EmployeeID = 101;
*/


-- =========================================================
-- SECTION 3: STORED PROCEDURES
-- =========================================================

/*
WHAT IS A STORED PROCEDURE?

A stored procedure is a saved group of SQL statements
that can be executed whenever required.

WHY USE STORED PROCEDURES?

1. Reuse SQL logic.
2. Accept input parameters.
3. Return result sets.
4. Perform INSERT, UPDATE and DELETE.
5. Centralise business logic.
6. Control access to database operations.

SYNTAX:

CREATE PROCEDURE ProcedureName
AS
BEGIN
    SQL statements;
END;

EXEC ProcedureName;
*/


-- ---------------------------------------------------------
-- 3.1 CREATE A SIMPLE STORED PROCEDURE
-- ---------------------------------------------------------

CREATE OR ALTER PROCEDURE dbo.usp_GetAllEmployees
AS
BEGIN
    SELECT *
    FROM dbo.Employees;
END;


-- Execute stored procedure.

EXEC dbo.usp_GetAllEmployees;


-- ---------------------------------------------------------
-- 3.2 STORED PROCEDURE WITH INPUT PARAMETER
-- ---------------------------------------------------------

/*
An input parameter sends a value into a procedure.

Syntax:

CREATE PROCEDURE ProcedureName
    @ParameterName datatype
AS
BEGIN
    ...
END;
*/


CREATE OR ALTER PROCEDURE dbo.usp_GetEmployees
    @DepartmentID INT
AS
BEGIN
    SELECT
        EmployeeID,
        EmployeeName,
        Salary
    FROM dbo.Employees
    WHERE DepartmentID = @DepartmentID;
END;


-- Get employees from IT.

EXEC dbo.usp_GetEmployees
    @DepartmentID = 1;


-- Get employees from HR.

EXEC dbo.usp_GetEmployees
    @DepartmentID = 2;


-- ---------------------------------------------------------
-- 3.3 STORED PROCEDURE WITH MULTIPLE PARAMETERS
-- ---------------------------------------------------------

CREATE OR ALTER PROCEDURE dbo.usp_GetEmployeesBySalary
    @MinSalary DECIMAL(10,2),
    @MaxSalary DECIMAL(10,2)
AS
BEGIN
    SELECT *
    FROM dbo.Employees
    WHERE Salary BETWEEN @MinSalary AND @MaxSalary;
END;


EXEC dbo.usp_GetEmployeesBySalary
    @MinSalary = 50000,
    @MaxSalary = 80000;


-- ---------------------------------------------------------
-- 3.4 STORED PROCEDURE WITH DEFAULT PARAMETER
-- ---------------------------------------------------------

/*
A default value is used when the caller
does not supply that parameter.
*/


CREATE OR ALTER PROCEDURE dbo.usp_GetEmployeesByDepartment
    @DepartmentID INT = 1
AS
BEGIN
    SELECT *
    FROM dbo.Employees
    WHERE DepartmentID = @DepartmentID;
END;


-- Uses default DepartmentID = 1.

EXEC dbo.usp_GetEmployeesByDepartment;


-- Supply a different value.

EXEC dbo.usp_GetEmployeesByDepartment
    @DepartmentID = 3;


-- ---------------------------------------------------------
-- 3.5 STORED PROCEDURE WITH OUTPUT PARAMETER
-- ---------------------------------------------------------

/*
An OUTPUT parameter sends a value back
from the procedure to the caller.

The caller must also specify OUTPUT.

Syntax:

EXEC ProcedureName
    @OutputVariable = @Variable OUTPUT;
*/


CREATE OR ALTER PROCEDURE dbo.usp_GetEmployeeCount
    @TotalEmployees INT OUTPUT
AS
BEGIN
    SELECT
        @TotalEmployees = COUNT(*)
    FROM dbo.Employees;
END;


DECLARE @Count INT;


EXEC dbo.usp_GetEmployeeCount
    @TotalEmployees = @Count OUTPUT;


SELECT @Count AS TotalEmployees;


-- ---------------------------------------------------------
-- 3.6 STORED PROCEDURE WITH INSERT
-- ---------------------------------------------------------

CREATE OR ALTER PROCEDURE dbo.usp_AddEmployee
    @EmployeeID INT,
    @EmployeeName VARCHAR(100),
    @DepartmentID INT,
    @Salary DECIMAL(10,2),
    @JoiningDate DATE
AS
BEGIN
    INSERT INTO dbo.Employees
    (
        EmployeeID,
        EmployeeName,
        DepartmentID,
        Salary,
        JoiningDate
    )
    VALUES
    (
        @EmployeeID,
        @EmployeeName,
        @DepartmentID,
        @Salary,
        @JoiningDate
    );

    SELECT 'Employee added successfully.' AS Message;
END;


EXEC dbo.usp_AddEmployee
    @EmployeeID = 109,
    @EmployeeName = 'Anjali',
    @DepartmentID = 2,
    @Salary = 58000,
    @JoiningDate = '2024-01-15';


SELECT *
FROM dbo.Employees;


-- ---------------------------------------------------------
-- 3.7 STORED PROCEDURE WITH UPDATE
-- ---------------------------------------------------------

CREATE OR ALTER PROCEDURE dbo.usp_UpdateSalary
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    UPDATE dbo.Employees
    SET Salary = @NewSalary
    WHERE EmployeeID = @EmployeeID;

    IF @@ROWCOUNT = 0
        SELECT 'Employee not found.' AS Message;
    ELSE
        SELECT 'Salary updated successfully.' AS Message;
END;


EXEC dbo.usp_UpdateSalary
    @EmployeeID = 101,
    @NewSalary = 90000;


-- ---------------------------------------------------------
-- 3.8 STORED PROCEDURE WITH DELETE
-- ---------------------------------------------------------

CREATE OR ALTER PROCEDURE dbo.usp_DeleteEmployee
    @EmployeeID INT
AS
BEGIN
    DELETE FROM dbo.Employees
    WHERE EmployeeID = @EmployeeID;

    IF @@ROWCOUNT = 0
        SELECT 'Employee not found.' AS Message;
    ELSE
        SELECT 'Employee deleted successfully.' AS Message;
END;


-- Example execution:
-- EXEC dbo.usp_DeleteEmployee @EmployeeID = 109;


-- ---------------------------------------------------------
-- 3.9 STORED PROCEDURE WITH TRY...CATCH
-- ---------------------------------------------------------

CREATE OR ALTER PROCEDURE dbo.usp_SafeSalaryUpdate
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        UPDATE dbo.Employees
        SET Salary = @NewSalary
        WHERE EmployeeID = @EmployeeID;

        IF @@ROWCOUNT = 0
            THROW 50001, 'Employee not found.', 1;

        COMMIT TRANSACTION;

        SELECT 'Salary updated successfully.' AS Message;

    END TRY

    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;


-- Example:
-- EXEC dbo.usp_SafeSalaryUpdate 101, 95000;


-- =========================================================
-- SECTION 4: FUNCTIONS
-- =========================================================

/*
WHAT IS A FUNCTION?

A function is a reusable database object that
accepts input values and returns a value or table.

Functions are useful for:
1. Reusing calculations.
2. Standardising business logic.
3. Performing data transformations.
4. Returning calculated values.
5. Returning filtered table results.

Types:

1. Scalar Function
   Returns one value.

2. Inline Table-Valued Function
   Returns a table using one SELECT statement.

3. Multi-Statement Table-Valued Function
   Returns a table variable populated using
   multiple statements.
*/


-- ---------------------------------------------------------
-- 4.1 SCALAR FUNCTION
-- ---------------------------------------------------------

/*
A scalar function returns a single value.

Example:
Calculate annual salary from monthly salary.
*/


CREATE OR ALTER FUNCTION dbo.fn_AnnualSalary
(
    @MonthlySalary DECIMAL(10,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    RETURN @MonthlySalary * 12;
END;


-- Use the function.

SELECT
    EmployeeName,
    Salary AS MonthlySalary,
    dbo.fn_AnnualSalary(Salary) AS AnnualSalary
FROM dbo.Employees;


-- ---------------------------------------------------------
-- 4.2 SCALAR FUNCTION WITH MULTIPLE PARAMETERS
-- ---------------------------------------------------------

CREATE OR ALTER FUNCTION dbo.fn_CalculateBonus
(
    @Salary DECIMAL(10,2),
    @BonusPercentage DECIMAL(5,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    RETURN @Salary * @BonusPercentage / 100.0;
END;


SELECT
    EmployeeName,
    Salary,
    dbo.fn_CalculateBonus(Salary, 10) AS Bonus
FROM dbo.Employees;


-- ---------------------------------------------------------
-- 4.3 INLINE TABLE-VALUED FUNCTION
-- ---------------------------------------------------------

/*
An inline table-valued function returns a table
from a single SELECT statement.

It can be used in the FROM clause.

RETURNS TABLE
*/


CREATE OR ALTER FUNCTION dbo.fn_GetEmployeesByDepartment
(
    @DepartmentID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        EmployeeID,
        EmployeeName,
        DepartmentID,
        Salary
    FROM dbo.Employees
    WHERE DepartmentID = @DepartmentID
);


-- Use the function.

SELECT *
FROM dbo.fn_GetEmployeesByDepartment(1);


-- Use it with WHERE.

SELECT *
FROM dbo.fn_GetEmployeesByDepartment(2)
WHERE Salary > 50000;


-- ---------------------------------------------------------
-- 4.4 MULTI-STATEMENT TABLE-VALUED FUNCTION
-- ---------------------------------------------------------

/*
A multi-statement table-valued function:

1. Declares a return table variable.
2. Inserts data into that table variable.
3. Returns the table variable.

Useful when the result requires multiple steps.
*/


CREATE OR ALTER FUNCTION dbo.fn_GetHighSalaryEmployees
(
    @MinimumSalary DECIMAL(10,2)
)
RETURNS @Result TABLE
(
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10,2)
)
AS
BEGIN

    INSERT INTO @Result
    (
        EmployeeID,
        EmployeeName,
        Salary
    )
    SELECT
        EmployeeID,
        EmployeeName,
        Salary
    FROM dbo.Employees
    WHERE Salary >= @MinimumSalary;

    RETURN;

END;


SELECT *
FROM dbo.fn_GetHighSalaryEmployees(70000);


-- =========================================================
-- SECTION 5: TRIGGERS
-- =========================================================

/*
WHAT IS A TRIGGER?

A trigger is a special stored database object
that automatically executes when a specified
database event occurs.

Triggers can be used for:

1. Auditing changes.
2. Maintaining history.
3. Enforcing business rules.
4. Monitoring data modifications.
5. Maintaining related data.

Common DML trigger events:

INSERT
UPDATE
DELETE

Types:

1. AFTER trigger (also called FOR trigger).
2. INSTEAD OF trigger.
*/


-- ---------------------------------------------------------
-- 5.1 CREATE AUDIT TABLE
-- ---------------------------------------------------------

CREATE TABLE dbo.EmployeeAudit
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    ActionType VARCHAR(20),
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    ActionDate DATETIME2 DEFAULT SYSDATETIME()
);


-- ---------------------------------------------------------
-- 5.2 AFTER INSERT TRIGGER
-- ---------------------------------------------------------

/*
An AFTER INSERT trigger executes after a successful
INSERT statement.

INSERTED:
A logical table containing the newly inserted rows.

DELETED:
A logical table containing the old rows for DELETE
and the old versions of rows for UPDATE.

Important:
These are logical tables available inside triggers.
They are not permanent database tables.
*/


CREATE OR ALTER TRIGGER dbo.trg_Employee_Insert
ON dbo.Employees
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.EmployeeAudit
    (
        EmployeeID,
        ActionType,
        NewSalary
    )
    SELECT
        EmployeeID,
        'INSERT',
        Salary
    FROM INSERTED;

END;


-- Test INSERT trigger.

INSERT INTO dbo.Employees
VALUES
(110, 'Varun', 1, 72000, '2024-08-10');


SELECT *
FROM dbo.EmployeeAudit;


-- ---------------------------------------------------------
-- 5.3 AFTER UPDATE TRIGGER
-- ---------------------------------------------------------

/*
During an UPDATE:

DELETED contains the old versions.
INSERTED contains the new versions.

Rows are matched using their primary key.

A trigger must handle multiple rows because
one UPDATE statement can modify many records.
*/


CREATE OR ALTER TRIGGER dbo.trg_Employee_Update
ON dbo.Employees
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.EmployeeAudit
    (
        EmployeeID,
        ActionType,
        OldSalary,
        NewSalary
    )
    SELECT
        I.EmployeeID,
        'UPDATE',
        D.Salary,
        I.Salary
    FROM INSERTED AS I
    INNER JOIN DELETED AS D
        ON I.EmployeeID = D.EmployeeID;

END;


-- Test UPDATE trigger.

UPDATE dbo.Employees
SET Salary = Salary + 5000
WHERE DepartmentID = 1;


SELECT *
FROM dbo.EmployeeAudit
ORDER BY AuditID;


-- ---------------------------------------------------------
-- 5.4 AFTER DELETE TRIGGER
-- ---------------------------------------------------------

CREATE OR ALTER TRIGGER dbo.trg_Employee_Delete
ON dbo.Employees
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.EmployeeAudit
    (
        EmployeeID,
        ActionType,
        OldSalary
    )
    SELECT
        EmployeeID,
        'DELETE',
        Salary
    FROM DELETED;

END;


-- Test DELETE trigger.

DELETE FROM dbo.Employees
WHERE EmployeeID = 110;


SELECT *
FROM dbo.EmployeeAudit
ORDER BY AuditID;


-- ---------------------------------------------------------
-- 5.5 INSTEAD OF TRIGGER
-- ---------------------------------------------------------

/*
An INSTEAD OF trigger executes instead of the
original INSERT, UPDATE or DELETE operation.

It is useful when you need custom behaviour
before performing the actual operation.

Example:
Instead of deleting an employee, block the deletion.
*/


CREATE OR ALTER TRIGGER dbo.trg_PreventEmployeeDelete
ON dbo.Employees
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    THROW 50002,
          'Employee deletion is not allowed.',
          1;
END;


-- Test the trigger.
-- Uncomment to see the error.

/*
DELETE FROM dbo.Employees
WHERE EmployeeID = 101;
*/


-- Remove the trigger so normal DELETE can work again.

DROP TRIGGER IF EXISTS dbo.trg_PreventEmployeeDelete;


-- =========================================================
-- SECTION 6: INSERTED VS DELETED
-- =========================================================

/*
TRIGGER EVENT       INSERTED       DELETED

INSERT              New rows       No rows
UPDATE              New versions   Old versions
DELETE              No rows        Deleted rows


Example:

Before update:
Salary = 50000

After update:
Salary = 60000

Inside UPDATE trigger:

DELETED.Salary = 50000
INSERTED.Salary = 60000


IMPORTANT:
INSERTED and DELETED can contain multiple rows.
Never assume a trigger fires only once per row.
*/


-- =========================================================
-- SECTION 7: DIFFERENCE BETWEEN DATABASE OBJECTS
-- =========================================================

/*
VIEW:
- Virtual table based on a SELECT query.
- Normally does not accept parameters.
- Used to simplify and present data.
- Can sometimes be updated, depending on its definition.

STORED PROCEDURE:
- Saved group of SQL statements.
- Can accept input and output parameters.
- Can perform INSERT, UPDATE and DELETE.
- Executed using EXEC or EXECUTE.

SCALAR FUNCTION:
- Returns one value.
- Can be used in expressions.
- Generally cannot modify database state.

TABLE-VALUED FUNCTION:
- Returns a table.
- Can be used in the FROM clause.

TRIGGER:
- Executes automatically when its configured
  event occurs.
- Often used for auditing and enforcing rules.


INTERVIEW TIP:

A stored procedure is executed explicitly.

A trigger is executed automatically when its
configured event occurs.
*/


-- =========================================================
-- SECTION 8: USEFUL SYSTEM QUERIES
-- =========================================================

-- View all views in the current database.

SELECT
    name,
    create_date,
    modify_date
FROM sys.views;


-- View stored procedures.

SELECT
    name,
    create_date,
    modify_date
FROM sys.procedures;


-- View user-defined functions.

SELECT
    name,
    type_desc
FROM sys.objects
WHERE type IN ('FN', 'IF', 'TF');


-- View triggers.

SELECT
    name,
    OBJECT_NAME(parent_id) AS TableName
FROM sys.triggers;


-- View a stored procedure definition.

EXEC sp_helptext 'dbo.usp_GetEmployees';


-- View a function definition.

EXEC sp_helptext 'dbo.fn_AnnualSalary';


-- View a trigger definition.

EXEC sp_helptext 'dbo.trg_Employee_Insert';


-- =========================================================
-- SECTION 9: PRACTICE QUESTIONS
-- =========================================================

/*
Q1. Create a view showing employee name and salary.

Q2. Create a view joining Employees and Departments.

Q3. Create a view showing department-wise employee count.

Q4. Alter an existing view.

Q5. Drop a view.

Q6. Create a stored procedure to retrieve all employees.

Q7. Create a stored procedure that accepts DepartmentID.

Q8. Create a stored procedure with two input parameters:
    minimum salary and maximum salary.

Q9. Create a procedure with a default parameter.

Q10. Create a stored procedure using an OUTPUT parameter
     to return total employee count.

Q11. Create a procedure to insert an employee.

Q12. Create a procedure to update employee salary.

Q13. Create a scalar function to calculate annual salary.

Q14. Create a scalar function to calculate bonus.

Q15. Create an inline table-valued function to retrieve
     employees by department.

Q16. Create a multi-statement table-valued function
     to retrieve employees above a given salary.

Q17. Create an AFTER INSERT trigger to record new employees.

Q18. Create an AFTER UPDATE trigger to store old and
     new salary values.

Q19. Create an AFTER DELETE trigger to store deleted
     employee details.

Q20. Create an INSTEAD OF DELETE trigger.

Q21. Explain INSERTED and DELETED logical tables.

Q22. Explain AFTER trigger vs INSTEAD OF trigger.

Q23. Explain scalar function vs table-valued function.

Q24. Explain stored procedure vs function.

Q25. Explain view vs stored procedure.

Q26. Can a stored procedure have OUTPUT parameters?

Q27. Can a function return a table?

Q28. Why should triggers handle multiple rows?

Q29. What is the use of SET NOCOUNT ON?

Q30. What is the difference between CREATE VIEW
     and CREATE OR ALTER VIEW?


-- =========================================================
-- SECTION 10: PRACTICE QUESTION SOLUTIONS
-- ========================================================= */


-- Q1. View showing employee name and salary.

CREATE OR ALTER VIEW dbo.vw_EmployeeSalary
AS
SELECT
    EmployeeName,
    Salary
FROM dbo.Employees;


SELECT * FROM dbo.vw_EmployeeSalary;


-- Q2. View joining Employees and Departments.

CREATE OR ALTER VIEW dbo.vw_EmployeeDepartment
AS
SELECT
    E.EmployeeID,
    E.EmployeeName,
    D.DepartmentName,
    E.Salary
FROM dbo.Employees AS E
INNER JOIN dbo.Departments AS D
    ON E.DepartmentID = D.DepartmentID;


SELECT * FROM dbo.vw_EmployeeDepartment;


-- Q3. Department-wise employee count.

CREATE OR ALTER VIEW dbo.vw_DepartmentEmployeeCount
AS
SELECT
    D.DepartmentName,
    COUNT(E.EmployeeID) AS EmployeeCount
FROM dbo.Departments AS D
LEFT JOIN dbo.Employees AS E
    ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName;


SELECT * FROM dbo.vw_DepartmentEmployeeCount;


-- Q4. Alter an existing view.

ALTER VIEW dbo.vw_EmployeeSalary
AS
SELECT
    EmployeeID,
    EmployeeName,
    Salary
FROM dbo.Employees
WHERE Salary >= 60000;


-- Q5. Drop a view.

-- DROP VIEW dbo.vw_EmployeeSalary;


-- Q6. Procedure to retrieve all employees.

CREATE OR ALTER PROCEDURE dbo.usp_AllEmployees
AS
BEGIN
    SELECT * FROM dbo.Employees;
END;


EXEC dbo.usp_AllEmployees;


-- Q7. Procedure with DepartmentID.

CREATE OR ALTER PROCEDURE dbo.usp_EmployeesByDepartment
    @DepartmentID INT
AS
BEGIN
    SELECT *
    FROM dbo.Employees
    WHERE DepartmentID = @DepartmentID;
END;


EXEC dbo.usp_EmployeesByDepartment 1;


-- Q8. Procedure with minimum and maximum salary.

CREATE OR ALTER PROCEDURE dbo.usp_SalaryRange
    @MinSalary DECIMAL(10,2),
    @MaxSalary DECIMAL(10,2)
AS
BEGIN
    SELECT *
    FROM dbo.Employees
    WHERE Salary BETWEEN @MinSalary AND @MaxSalary;
END;


EXEC dbo.usp_SalaryRange 50000, 80000;


-- Q9. Procedure with default parameter.

CREATE OR ALTER PROCEDURE dbo.usp_DefaultDepartment
    @DepartmentID INT = 1
AS
BEGIN
    SELECT *
    FROM dbo.Employees
    WHERE DepartmentID = @DepartmentID;
END;


EXEC dbo.usp_DefaultDepartment;


-- Q10. OUTPUT parameter.

CREATE OR ALTER PROCEDURE dbo.usp_TotalEmployeeCount
    @TotalCount INT OUTPUT
AS
BEGIN
    SELECT @TotalCount = COUNT(*)
    FROM dbo.Employees;
END;


DECLARE @Total INT;

EXEC dbo.usp_TotalEmployeeCount
    @TotalCount = @Total OUTPUT;

SELECT @Total AS TotalEmployees;


-- Q11. Insert employee using procedure.

CREATE OR ALTER PROCEDURE dbo.usp_InsertStudentEmployee
    @EmployeeID INT,
    @EmployeeName VARCHAR(100),
    @DepartmentID INT,
    @Salary DECIMAL(10,2),
    @JoiningDate DATE
AS
BEGIN
    INSERT INTO dbo.Employees
    VALUES
    (
        @EmployeeID,
        @EmployeeName,
        @DepartmentID,
        @Salary,
        @JoiningDate
    );
END;


-- Example:
-- EXEC dbo.usp_InsertStudentEmployee
-- 111, 'Isha', 2, 57000, '2024-06-15';


-- Q12. Update salary using procedure.

CREATE OR ALTER PROCEDURE dbo.usp_ChangeSalary
    @EmployeeID INT,
    @Salary DECIMAL(10,2)
AS
BEGIN
    UPDATE dbo.Employees
    SET Salary = @Salary
    WHERE EmployeeID = @EmployeeID;
END;


-- Example:
-- EXEC dbo.usp_ChangeSalary 101, 95000;


-- Q13. Scalar function for annual salary.

CREATE OR ALTER FUNCTION dbo.fn_CalculateAnnualSalary
(
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    RETURN @Salary * 12;
END;


SELECT
    EmployeeName,
    dbo.fn_CalculateAnnualSalary(Salary) AS AnnualSalary
FROM dbo.Employees;


-- Q14. Scalar function for bonus.

CREATE OR ALTER FUNCTION dbo.fn_Bonus
(
    @Salary DECIMAL(10,2),
    @Percentage DECIMAL(5,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    RETURN @Salary * @Percentage / 100.0;
END;


SELECT
    EmployeeName,
    dbo.fn_Bonus(Salary, 10) AS Bonus
FROM dbo.Employees;


-- Q15. Inline table-valued function.

CREATE OR ALTER FUNCTION dbo.fn_DepartmentEmployees
(
    @DepartmentID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM dbo.Employees
    WHERE DepartmentID = @DepartmentID
);


SELECT *
FROM dbo.fn_DepartmentEmployees(1);


-- Q16. Multi-statement table-valued function.

CREATE OR ALTER FUNCTION dbo.fn_EmployeesAboveSalary
(
    @MinimumSalary DECIMAL(10,2)
)
RETURNS @Employees TABLE
(
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10,2)
)
AS
BEGIN

    INSERT INTO @Employees
    SELECT
        EmployeeID,
        EmployeeName,
        Salary
    FROM dbo.Employees
    WHERE Salary > @MinimumSalary;

    RETURN;

END;


SELECT *
FROM dbo.fn_EmployeesAboveSalary(70000);


-- Q17. AFTER INSERT trigger.

CREATE OR ALTER TRIGGER dbo.trg_AuditInsert
ON dbo.Employees
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.EmployeeAudit
    (
        EmployeeID,
        ActionType,
        NewSalary
    )
    SELECT
        EmployeeID,
        'INSERT',
        Salary
    FROM INSERTED;
END;


-- Q18. AFTER UPDATE trigger.

CREATE OR ALTER TRIGGER dbo.trg_AuditUpdate
ON dbo.Employees
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.EmployeeAudit
    (
        EmployeeID,
        ActionType,
        OldSalary,
        NewSalary
    )
    SELECT
        I.EmployeeID,
        'UPDATE',
        D.Salary,
        I.Salary
    FROM INSERTED AS I
    INNER JOIN DELETED AS D
        ON I.EmployeeID = D.EmployeeID;
END;


-- Q19. AFTER DELETE trigger.

CREATE OR ALTER TRIGGER dbo.trg_AuditDelete
ON dbo.Employees
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.EmployeeAudit
    (
        EmployeeID,
        ActionType,
        OldSalary
    )
    SELECT
        EmployeeID,
        'DELETE',
        Salary
    FROM DELETED;
END;


-- Q20. INSTEAD OF DELETE trigger.

CREATE OR ALTER TRIGGER dbo.trg_BlockDelete
ON dbo.Employees
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    THROW 50003, 'Delete operation is blocked.', 1;
END;


-- Remove this demonstration trigger afterward.

DROP TRIGGER IF EXISTS dbo.trg_BlockDelete;


-- Q21-Q30: Conceptual questions are explained in
-- the comments throughout this practice file.


-- =========================================================
-- SECTION 11: FINAL INTERVIEW REVISION
-- =========================================================

/*
VIEW:
A saved SELECT query presented as a virtual table.

STORED PROCEDURE:
A saved set of SQL statements executed explicitly.

SCALAR FUNCTION:
Returns one value.

INLINE TABLE-VALUED FUNCTION:
Returns a table from one SELECT statement.

MULTI-STATEMENT TABLE-VALUED FUNCTION:
Builds and returns a table variable.

TRIGGER:
Executes automatically when its configured
database event occurs.

INSERTED:
Contains new row versions in INSERT and UPDATE triggers.

DELETED:
Contains deleted row versions and old row versions
in DELETE and UPDATE triggers.

AFTER TRIGGER:
Runs after the triggering DML operation succeeds.

INSTEAD OF TRIGGER:
Runs instead of the triggering DML operation.

SET NOCOUNT ON:
Suppresses row-count messages such as
"(N rows affected)" from being sent to the client.

IMPORTANT:
Functions have restrictions on side effects and
database modifications. Do not assume a function
can perform every operation that a procedure can.

============================================================
END OF DATABASE OBJECTS PRACTICE
============================================================
*/