-- ======================================================
-- 1. CREATE DATABASE
-- ======================================================

CREATE DATABASE SQL_Fundamentals_Practice;

-- Select the database
USE SQL_Fundamentals_Practice;


-- ======================================================
-- 2. CREATE DEPARTMENTS TABLE (PARENT TABLE)
-- ======================================================

CREATE TABLE Departments
(
    DepartmentID INT IDENTITY(1,1),

    DepartmentName VARCHAR(100) NOT NULL,

    Location VARCHAR(100) DEFAULT 'Not Assigned',

    CONSTRAINT PK_Departments
        PRIMARY KEY (DepartmentID),

    CONSTRAINT UQ_Departments_Name
        UNIQUE (DepartmentName)
);


-- View table structure
EXEC sp_help 'Departments';


-- ======================================================
-- 3. CREATE EMPLOYEES TABLE (CHILD TABLE)
-- ======================================================

CREATE TABLE Employees
(
    EmployeeID INT IDENTITY(1,1),

    EmployeeName VARCHAR(100) NOT NULL,

    Email VARCHAR(150) NOT NULL,

    Age INT,

    Salary DECIMAL(10,2) NOT NULL,

    DepartmentID INT,

    IsActive BIT DEFAULT 1,

    JoiningDate DATE DEFAULT (CONVERT(DATE, GETDATE())),

    CONSTRAINT PK_Employees
        PRIMARY KEY (EmployeeID),

    CONSTRAINT UQ_Employees_Email
        UNIQUE (Email),

    CONSTRAINT CK_Employees_Age
        CHECK (Age >= 18),

    CONSTRAINT CK_Employees_Salary
        CHECK (Salary >= 0),

    CONSTRAINT FK_Employees_Departments
        FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID)
);


-- View table structure
EXEC sp_help 'Employees';


-- ======================================================
-- 4. INSERT DATA INTO DEPARTMENTS
-- ======================================================

INSERT INTO Departments
(DepartmentName, Location)
VALUES
('IT', 'Pune'),
('HR', 'Mumbai'),
('Finance', 'Nagpur'),
('Marketing', 'Hyderabad');


-- Check inserted records
SELECT *
FROM Departments;


-- ======================================================
-- 5. INSERT DATA INTO EMPLOYEES
-- ======================================================

-- We are not providing EmployeeID because IDENTITY
-- generates it automatically.

-- We are not providing IsActive and JoiningDate
-- because DEFAULT values will be used.

INSERT INTO Employees
(EmployeeName, Email, Age, Salary, DepartmentID)
VALUES
('Rahul', 'rahul@gmail.com', 24, 55000, 1),
('Priya', 'priya@gmail.com', 23, 45000, 2),
('Amit', 'amit@gmail.com', 25, 65000, 1),
('Sneha', 'sneha@gmail.com', 22, 60000, 3),
('Neha', 'neha@gmail.com', 24, 50000, 2);


-- Check inserted records
SELECT *
FROM Employees;


-- ======================================================
-- 6. TEST NOT NULL CONSTRAINT
-- ======================================================

-- EmployeeName cannot be NULL.
-- Expected result: Constraint violation.

-- INSERT INTO Employees
-- (EmployeeName, Email, Age, Salary, DepartmentID)
-- VALUES
-- (NULL, 'test@gmail.com', 25, 40000, 1);


-- ======================================================
-- 7. TEST UNIQUE CONSTRAINT
-- ======================================================

-- Email must be unique.
-- Expected result: Duplicate key error.

-- INSERT INTO Employees
-- (EmployeeName, Email, Age, Salary, DepartmentID)
-- VALUES
-- ('Rohan', 'rahul@gmail.com', 25, 40000, 1);


-- ======================================================
-- 8. TEST CHECK CONSTRAINT
-- ======================================================

-- Age must be at least 18.
-- Expected result: CHECK constraint violation.

-- INSERT INTO Employees
-- (EmployeeName, Email, Age, Salary, DepartmentID)
-- VALUES
-- ('Karan', 'karan@gmail.com', 16, 40000, 1);


-- Salary cannot be negative.
-- Expected result: CHECK constraint violation.

-- INSERT INTO Employees
-- (EmployeeName, Email, Age, Salary, DepartmentID)
-- VALUES
-- ('Riya', 'riya@gmail.com', 22, -5000, 1);


-- ======================================================
-- 9. TEST FOREIGN KEY CONSTRAINT
-- ======================================================

-- DepartmentID 100 does not exist.
-- Expected result: FOREIGN KEY constraint violation.

-- INSERT INTO Employees
-- (EmployeeName, Email, Age, Salary, DepartmentID)
-- VALUES
-- ('Varun', 'varun@gmail.com', 25, 50000, 100);


-- ======================================================
-- 10. TEST DEFAULT CONSTRAINT
-- ======================================================

-- IsActive and JoiningDate are omitted.
-- Their DEFAULT values will be applied.

INSERT INTO Employees
(EmployeeName, Email, Age, Salary, DepartmentID)
VALUES
('Kavya', 'kavya@gmail.com', 23, 48000, 4);


-- Check the newly inserted record
SELECT *
FROM Employees
WHERE Email = 'kavya@gmail.com';


-- ======================================================
-- 11. UNDERSTANDING IDENTITY
-- ======================================================

-- EmployeeID is generated automatically.

SELECT
    EmployeeID,
    EmployeeName
FROM Employees
ORDER BY EmployeeID;


-- ======================================================
-- 12. UNDERSTANDING PRIMARY KEY AND FOREIGN KEY
-- ======================================================

-- EmployeeID identifies each employee.
-- DepartmentID connects Employees with Departments.

SELECT
    E.EmployeeID,
    E.EmployeeName,
    E.Email,
    E.Salary,
    D.DepartmentName,
    D.Location
FROM Employees AS E
INNER JOIN Departments AS D
    ON E.DepartmentID = D.DepartmentID;


-- ======================================================
-- 13. ADD A NEW CONSTRAINT USING ALTER TABLE
-- ======================================================

-- Add a CHECK constraint to ensure Salary
-- does not exceed 1000000.

ALTER TABLE Employees
ADD CONSTRAINT CK_Employees_MaxSalary
CHECK (Salary <= 1000000);


-- ======================================================
-- 14. REMOVE A CONSTRAINT
-- ======================================================

-- Remove the constraint added above.

ALTER TABLE Employees
DROP CONSTRAINT CK_Employees_MaxSalary;


-- ======================================================
-- 15. VIEW ALL CONSTRAINTS
-- ======================================================

-- View constraints of Employees table.

SELECT
    name AS ConstraintName,
    type_desc AS ConstraintType
FROM sys.objects
WHERE parent_object_id = OBJECT_ID('dbo.Employees')
AND type IN ('PK', 'UQ', 'F', 'C', 'D');


-- ======================================================
-- 16. FINAL DATA CHECK
-- ======================================================

SELECT *
FROM Departments;

SELECT *
FROM Employees;
