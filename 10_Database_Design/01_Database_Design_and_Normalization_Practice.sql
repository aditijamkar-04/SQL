/*
============================================================
SQL PRACTICE 01: DATABASE DESIGN AND NORMALIZATION
============================================================

Topics:
1. Database Design Fundamentals
2. Entities and Attributes
3. Primary Keys and Foreign Keys
4. Database Relationships
5. ER Diagram Concepts
6. Normalization
7. First Normal Form (1NF)
8. Second Normal Form (2NF)
9. Third Normal Form (3NF)
10. Boyce-Codd Normal Form (BCNF)
11. Denormalization
12. Practical Database Design
13. Practice Questions and Solutions

============================================================
*/


-- =========================================================
-- SECTION 1: DATABASE DESIGN FUNDAMENTALS
-- =========================================================

/*
WHAT IS DATABASE DESIGN?

Database design is the process of organising data
into tables and defining relationships between them.

WHY IS DATABASE DESIGN IMPORTANT?

1. Avoid duplicate data.
2. Maintain data consistency.
3. Reduce data redundancy.
4. Improve data integrity.
5. Make data retrieval easier.
6. Make databases easier to maintain.

EXAMPLE:

Imagine a college database.

It may contain:

Students
Courses
Teachers
Departments
Enrollments

Instead of storing everything in one large table,
we divide the information into related tables.


IMPORTANT TERMS:

1. Entity:
   A real-world object about which we store data.
   Example: Student, Employee, Department.

2. Attribute:
   A property of an entity.
   Example: StudentID, StudentName, Age.

3. Record:
   A single row in a table.

4. Field:
   A column or an individual data value,
   depending on the context.

5. Relationship:
   A connection between two entities.

6. Schema:
   The logical structure of a database.
*/


-- =========================================================
-- SECTION 2: ENTITIES AND ATTRIBUTES
-- =========================================================

/*
EXAMPLE: STUDENT ENTITY

Entity: Student

Attributes:

StudentID
StudentName
Email
Age
City

A possible table:

StudentID | StudentName | Email
----------|-------------|----------------
1         | Rahul       | rahul@email.com
2         | Priya       | priya@email.com

Here:

Student = Entity
StudentID, StudentName, Email = Attributes
Each row = Record
Each column = Attribute
*/


CREATE TABLE dbo.Design_Students
(
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Age INT,
    City VARCHAR(50)
);


INSERT INTO dbo.Design_Students
VALUES
(1, 'Rahul', 'rahul@email.com', 21, 'Pune'),
(2, 'Priya', 'priya@email.com', 22, 'Mumbai'),
(3, 'Amit', 'amit@email.com', 20, 'Nagpur');


SELECT *
FROM dbo.Design_Students;


-- =========================================================
-- SECTION 3: KEYS IN DATABASE DESIGN
-- =========================================================

/*
WHAT IS A KEY?

A key is an attribute or combination of attributes
used to identify records or establish relationships.


1. SUPER KEY

Any column or combination of columns that uniquely
identifies a row.

Example:

StudentID
Email
StudentID + StudentName

If StudentID is unique, all three can be super keys
provided the combination remains unique.


2. CANDIDATE KEY

A minimal super key.

It uniquely identifies a row and contains no
unnecessary attributes.

Example:

StudentID
Email

Assuming both are individually unique.


3. PRIMARY KEY

The candidate key selected to identify each row.

Properties:
- Must be unique.
- Cannot contain NULL.
- Only one PRIMARY KEY constraint per table.
- Can contain multiple columns (composite key).


4. ALTERNATE KEY

A candidate key that was not selected as
the primary key.

Example:

StudentID is the primary key.
Email is an alternate candidate key.


5. FOREIGN KEY

A column or group of columns that references
a candidate key, commonly a primary key,
in another table.

It maintains referential integrity.


6. COMPOSITE KEY

A key consisting of two or more columns.

Example:

StudentID + CourseID

Together they uniquely identify an enrollment.


7. UNIQUE KEY / UNIQUE CONSTRAINT

Ensures that duplicate values are not allowed
in the constrained key.

SQL Server UNIQUE constraints can allow NULL,
but the exact behaviour depends on the number
of constrained columns and the index design.
For a single-column UNIQUE constraint, only
one NULL is allowed.
*/


-- Candidate and alternate key example.

CREATE TABLE dbo.Design_Users
(
    UserID INT PRIMARY KEY,
    Username VARCHAR(50) UNIQUE,
    Email VARCHAR(100) UNIQUE
);


INSERT INTO dbo.Design_Users
VALUES
(1, 'rahul01', 'rahul@example.com'),
(2, 'priya02', 'priya@example.com');


SELECT *
FROM dbo.Design_Users;


-- Composite primary key example.

CREATE TABLE dbo.Design_Enrollments
(
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,

    CONSTRAINT PK_Design_Enrollments
        PRIMARY KEY (StudentID, CourseID)
);


INSERT INTO dbo.Design_Enrollments
VALUES
(1, 101, '2025-01-10'),
(1, 102, '2025-01-12'),
(2, 101, '2025-01-15');


SELECT *
FROM dbo.Design_Enrollments;


-- The following duplicate combination is invalid.
-- Uncomment to test.

/*
INSERT INTO dbo.Design_Enrollments
VALUES
(1, 101, '2025-02-01');
*/


-- =========================================================
-- SECTION 4: RELATIONSHIPS IN DATABASE DESIGN
-- =========================================================

/*
A relationship defines how two entities are connected.

THREE COMMON TYPES:


1. ONE-TO-ONE (1:1)

One record in Table A is related to
at most one record in Table B.

Example:

Person ---- Passport

One person has one passport in this simplified model.
One passport belongs to one person.

SQL implementation:
Use a FOREIGN KEY with a UNIQUE constraint
on the referencing column.


2. ONE-TO-MANY (1:M)

One record in Table A can be related to
multiple records in Table B.

Example:

Department ---- Employees

One department can have many employees.
Each employee belongs to one department.

SQL implementation:
Place the foreign key on the MANY side.


3. MANY-TO-MANY (M:N)

Multiple records in Table A can be related to
multiple records in Table B.

Example:

Students ---- Courses

One student can join many courses.
One course can contain many students.

SQL implementation:
Create a junction table (also called a bridge
or associative table).
*/


-- ---------------------------------------------------------
-- 4.1 ONE-TO-ONE RELATIONSHIP
-- ---------------------------------------------------------

CREATE TABLE dbo.Design_Persons
(
    PersonID INT PRIMARY KEY,
    PersonName VARCHAR(100)
);


CREATE TABLE dbo.Design_Passports
(
    PassportID INT PRIMARY KEY,
    PassportNumber VARCHAR(30) UNIQUE NOT NULL,
    PersonID INT UNIQUE NOT NULL,

    FOREIGN KEY (PersonID)
        REFERENCES dbo.Design_Persons(PersonID)
);


INSERT INTO dbo.Design_Persons
VALUES
(1, 'Rahul'),
(2, 'Priya');


INSERT INTO dbo.Design_Passports
VALUES
(101, 'P123456', 1),
(102, 'P789012', 2);


SELECT *
FROM dbo.Design_Persons;

SELECT *
FROM dbo.Design_Passports;


-- ---------------------------------------------------------
-- 4.2 ONE-TO-MANY RELATIONSHIP
-- ---------------------------------------------------------

CREATE TABLE dbo.Design_Departments
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);


CREATE TABLE dbo.Design_Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT,

    FOREIGN KEY (DepartmentID)
        REFERENCES dbo.Design_Departments(DepartmentID)
);


INSERT INTO dbo.Design_Departments
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance');


INSERT INTO dbo.Design_Employees
VALUES
(101, 'Amit', 1),
(102, 'Sneha', 1),
(103, 'Neha', 2),
(104, 'Rohan', 3);


-- Find employees with their departments.

SELECT
    E.EmployeeName,
    D.DepartmentName
FROM dbo.Design_Employees AS E
INNER JOIN dbo.Design_Departments AS D
    ON E.DepartmentID = D.DepartmentID;


-- ---------------------------------------------------------
-- 4.3 MANY-TO-MANY RELATIONSHIP
-- ---------------------------------------------------------

CREATE TABLE dbo.Design_Courses
(
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100)
);


CREATE TABLE dbo.Design_StudentCourse
(
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,

    PRIMARY KEY (StudentID, CourseID),

    FOREIGN KEY (StudentID)
        REFERENCES dbo.Design_Students(StudentID),

    FOREIGN KEY (CourseID)
        REFERENCES dbo.Design_Courses(CourseID)
);


INSERT INTO dbo.Design_Courses
VALUES
(101, 'Python'),
(102, 'SQL'),
(103, 'Machine Learning');


INSERT INTO dbo.Design_StudentCourse
VALUES
(1, 101, '2025-01-10'),
(1, 102, '2025-01-12'),
(2, 102, '2025-01-15'),
(2, 103, '2025-01-20'),
(3, 101, '2025-01-25');


-- Find students and their courses.

SELECT
    S.StudentName,
    C.CourseName,
    SC.EnrollmentDate
FROM dbo.Design_StudentCourse AS SC
INNER JOIN dbo.Design_Students AS S
    ON SC.StudentID = S.StudentID
INNER JOIN dbo.Design_Courses AS C
    ON SC.CourseID = C.CourseID;


-- =========================================================
-- SECTION 5: ER DIAGRAM CONCEPTS
-- =========================================================

/*
ER = ENTITY RELATIONSHIP

An ER diagram visually represents entities,
their attributes and their relationships.

COMMON SYMBOLS (CONCEPTUALLY):

Rectangle  = Entity
Oval       = Attribute
Diamond    = Relationship
Line       = Connection

CARDINALITY:

1:1 = One-to-One
1:M = One-to-Many
M:N = Many-to-Many


EXAMPLE: COLLEGE DATABASE

+----------+       +------------------+       +---------+
| STUDENT  | 1   M | STUDENT_COURSE   | M   1 | COURSE  |
+----------+-------+------------------+-------+---------+
|StudentID |       | StudentID (FK)   |       |CourseID |
|Name      |       | CourseID (FK)    |       |Name     |
|Email     |       | EnrollmentDate  |       |Fees     |
+----------+       +------------------+       +---------+

Student and Course have a many-to-many relationship.

The junction table converts it into two
one-to-many relationships.
*/


-- =========================================================
-- SECTION 6: WHAT IS NORMALIZATION?
-- =========================================================

/*
Normalization is the process of organising data
into tables to reduce unnecessary duplication
and avoid data anomalies.

WHY NORMALIZATION?

1. Reduce data redundancy.
2. Avoid inconsistent data.
3. Prevent insertion anomalies.
4. Prevent update anomalies.
5. Prevent deletion anomalies.
6. Improve data organisation.


THREE COMMON ANOMALIES:


1. INSERTION ANOMALY

You cannot insert information about one entity
without providing unrelated information.

Example:
You cannot add a new course unless a student
has enrolled in it, because both are stored
in the same table.


2. UPDATE ANOMALY

The same information is stored in multiple rows.

If it changes, every duplicate occurrence
must be updated.

Missing even one row creates inconsistent data.


3. DELETION ANOMALY

Deleting one record accidentally removes
other important information.

Example:
Deleting the last student enrolled in a course
also removes the only stored details about
that course.


NORMAL FORMS:

1NF = First Normal Form
2NF = Second Normal Form
3NF = Third Normal Form
BCNF = Boyce-Codd Normal Form
*/


-- =========================================================
-- SECTION 7: FIRST NORMAL FORM (1NF)
-- =========================================================

/*
RULES OF 1NF:

1. Each cell must contain one atomic value.
2. No repeating groups.
3. Each row must be identifiable.
4. Each column should contain values of
   the same logical type.

ATOMIC VALUE:

A value that is treated as a single unit
for the purpose of the database design.

NOT IN 1NF:

StudentID | StudentName | Courses
----------|-------------|--------------------
1         | Rahul       | Python, SQL
2         | Priya       | SQL, ML

Problem:
The Courses column stores multiple values.

CONVERT INTO 1NF:

StudentID | StudentName | Course
----------|-------------|--------
1         | Rahul       | Python
1         | Rahul       | SQL
2         | Priya       | SQL
2         | Priya       | ML

Each cell now contains one course value.
*/


CREATE TABLE dbo.Design_StudentCourses_1NF
(
    StudentID INT,
    StudentName VARCHAR(100),
    CourseName VARCHAR(100),

    PRIMARY KEY (StudentID, CourseName)
);


INSERT INTO dbo.Design_StudentCourses_1NF
VALUES
(1, 'Rahul', 'Python'),
(1, 'Rahul', 'SQL'),
(2, 'Priya', 'SQL'),
(2, 'Priya', 'Machine Learning');


SELECT *
FROM dbo.Design_StudentCourses_1NF;


-- =========================================================
-- SECTION 8: SECOND NORMAL FORM (2NF)
-- =========================================================

/*
RULES OF 2NF:

1. The table must already be in 1NF.
2. Every non-key attribute must depend on
   the whole candidate key, not just part of it.

2NF is especially important when a table has
a composite candidate key.

WHAT IS PARTIAL DEPENDENCY?

A non-key attribute depends on only part
of a composite candidate key.


EXAMPLE: NOT IN 2NF

StudentID | CourseID | StudentName | CourseName
----------|----------|-------------|-----------
1         | 101      | Rahul       | Python
1         | 102      | Rahul       | SQL
2         | 101      | Priya       | Python

Composite key:
(StudentID, CourseID)

Dependencies:

StudentID -> StudentName
CourseID  -> CourseName

StudentName depends only on StudentID.
CourseName depends only on CourseID.

Both are partial dependencies.


CONVERT INTO 2NF:

STUDENTS

StudentID | StudentName

COURSES

CourseID | CourseName

ENROLLMENTS

StudentID | CourseID

Now student details and course details
are stored separately.
*/


CREATE TABLE dbo.Design_Students_2NF
(
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100)
);


CREATE TABLE dbo.Design_Courses_2NF
(
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100)
);


CREATE TABLE dbo.Design_Enrollments_2NF
(
    StudentID INT,
    CourseID INT,

    PRIMARY KEY (StudentID, CourseID),

    FOREIGN KEY (StudentID)
        REFERENCES dbo.Design_Students_2NF(StudentID),

    FOREIGN KEY (CourseID)
        REFERENCES dbo.Design_Courses_2NF(CourseID)
);


INSERT INTO dbo.Design_Students_2NF
VALUES
(1, 'Rahul'),
(2, 'Priya');


INSERT INTO dbo.Design_Courses_2NF
VALUES
(101, 'Python'),
(102, 'SQL');


INSERT INTO dbo.Design_Enrollments_2NF
VALUES
(1, 101),
(1, 102),
(2, 101);


SELECT *
FROM dbo.Design_Students_2NF;

SELECT *
FROM dbo.Design_Courses_2NF;

SELECT *
FROM dbo.Design_Enrollments_2NF;


-- =========================================================
-- SECTION 9: THIRD NORMAL FORM (3NF)
-- =========================================================

/*
RULES OF 3NF:

1. The table must already be in 2NF.
2. No transitive dependency of non-key attributes
   on a candidate key.

WHAT IS TRANSITIVE DEPENDENCY?

A non-key attribute depends on another
non-key attribute instead of depending
directly on the key.


EXAMPLE: NOT IN 3NF

EmployeeID | EmployeeName | DepartmentID | DepartmentName
-----------|--------------|--------------|---------------
101        | Amit         | 1            | IT
102        | Sneha        | 1            | IT
103        | Neha         | 2            | HR

Dependencies:

EmployeeID -> EmployeeName
EmployeeID -> DepartmentID
DepartmentID -> DepartmentName

DepartmentName depends on DepartmentID,
which is not the key of the employee table.

This is a transitive dependency.


CONVERT INTO 3NF:

EMPLOYEES

EmployeeID | EmployeeName | DepartmentID

DEPARTMENTS

DepartmentID | DepartmentName

Now department information is stored separately.
*/


CREATE TABLE dbo.Design_Departments_3NF
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);


CREATE TABLE dbo.Design_Employees_3NF
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT,

    FOREIGN KEY (DepartmentID)
        REFERENCES dbo.Design_Departments_3NF(DepartmentID)
);


INSERT INTO dbo.Design_Departments_3NF
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Finance');


INSERT INTO dbo.Design_Employees_3NF
VALUES
(101, 'Amit', 1),
(102, 'Sneha', 1),
(103, 'Neha', 2);


SELECT
    E.EmployeeID,
    E.EmployeeName,
    D.DepartmentName
FROM dbo.Design_Employees_3NF AS E
INNER JOIN dbo.Design_Departments_3NF AS D
    ON E.DepartmentID = D.DepartmentID;


-- =========================================================
-- SECTION 10: BOYCE-CODD NORMAL FORM (BCNF)
-- =========================================================

/*
BCNF is a stronger version of 3NF.

RULE:

For every non-trivial functional dependency:

X -> Y

X must be a super key.

In simple words:

Every determinant must be a super key.


IMPORTANT TERMS:

Functional Dependency:

X -> Y means that the value of X uniquely
determines the value of Y.

Determinant:

The attribute or set of attributes on the
left side of a functional dependency.


EXAMPLE:

Consider a table:

Student | Course | Instructor

Assume:
- A student can take many courses.
- Each instructor teaches only one course.
- A course may be taught by multiple instructors.
- A student has one instructor for a given course.

Possible candidate keys:
(Student, Course)

(Student, Instructor)

Functional dependency:
Instructor -> Course

If Instructor is not a super key, this dependency
violates BCNF.

Decompose the table into:

INSTRUCTOR_COURSE
Instructor | Course

STUDENT_INSTRUCTOR
Student | Instructor

The decomposition is suitable under the stated
assumptions.

NOTE:
BCNF decomposition must be checked against the
actual functional dependencies and candidate keys.
*/


-- Example structure.

CREATE TABLE dbo.Design_InstructorCourse
(
    InstructorID INT PRIMARY KEY,
    CourseName VARCHAR(100)
);


CREATE TABLE dbo.Design_StudentInstructor
(
    StudentID INT,
    InstructorID INT,

    PRIMARY KEY (StudentID, InstructorID),

    FOREIGN KEY (InstructorID)
        REFERENCES dbo.Design_InstructorCourse(InstructorID)
);


-- =========================================================
-- SECTION 11: DENORMALIZATION
-- =========================================================

/*
WHAT IS DENORMALIZATION?

Denormalization is the intentional introduction
of some redundancy into a database design.

WHY USE IT?

1. Reduce the number of joins for certain queries.
2. Improve read performance in selected workloads.
3. Store precomputed or frequently used values.
4. Support reporting and analytical workloads.

EXAMPLE:

NORMALIZED DESIGN:

Employees:
EmployeeID, EmployeeName, DepartmentID

Departments:
DepartmentID, DepartmentName

To get employee and department names,
we need a JOIN.

DENORMALIZED DESIGN:

EmployeeID, EmployeeName, DepartmentID, DepartmentName

DepartmentName is repeated for multiple employees.

TRADE-OFF:

Advantages:
- Some reads can become simpler.
- May improve performance for specific workloads.

Disadvantages:
- More storage.
- Duplicate data.
- Updates may become harder.
- Risk of inconsistent data.

IMPORTANT:

Denormalization should be based on measured
performance needs, not guesswork.
*/


-- =========================================================
-- SECTION 12: PRACTICAL DATABASE DESIGN
-- =========================================================

/*
SCENARIO: ONLINE SHOPPING DATABASE

We need to store:

1. Customers
2. Products
3. Orders
4. Order Details
5. Categories


RELATIONSHIPS:

Customer 1 ---- M Orders

Order 1 ---- M OrderDetails

Product 1 ---- M OrderDetails

Category 1 ---- M Products


WHY ORDER DETAILS?

One order can contain multiple products.
One product can appear in multiple orders.

Therefore, Orders and Products have
a many-to-many relationship.

OrderDetails acts as the junction table.
*/


CREATE TABLE dbo.Design_Customers
(
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    City VARCHAR(50)
);


CREATE TABLE dbo.Design_Categories
(
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE dbo.Design_Products
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT,
    Price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (CategoryID)
        REFERENCES dbo.Design_Categories(CategoryID),

    CHECK (Price >= 0)
);


CREATE TABLE dbo.Design_Orders
(
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,

    FOREIGN KEY (CustomerID)
        REFERENCES dbo.Design_Customers(CustomerID)
);


CREATE TABLE dbo.Design_OrderDetails
(
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (OrderID, ProductID),

    FOREIGN KEY (OrderID)
        REFERENCES dbo.Design_Orders(OrderID),

    FOREIGN KEY (ProductID)
        REFERENCES dbo.Design_Products(ProductID),

    CHECK (Quantity > 0),
    CHECK (UnitPrice >= 0)
);


-- Insert customers.

INSERT INTO dbo.Design_Customers
VALUES
(1, 'Rahul', 'rahul@example.com', 'Pune'),
(2, 'Priya', 'priya@example.com', 'Mumbai'),
(3, 'Amit', 'amit@example.com', 'Nagpur');


-- Insert categories.

INSERT INTO dbo.Design_Categories
VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Accessories');


-- Insert products.

INSERT INTO dbo.Design_Products
VALUES
(101, 'Laptop', 1, 60000),
(102, 'SQL Book', 2, 500),
(103, 'Keyboard', 3, 1200),
(104, 'Mouse', 3, 700);


-- Insert orders.

INSERT INTO dbo.Design_Orders
VALUES
(1001, 1, '2025-01-10'),
(1002, 2, '2025-01-12'),
(1003, 1, '2025-01-15');


-- Insert order details.

INSERT INTO dbo.Design_OrderDetails
VALUES
(1001, 101, 1, 60000),
(1001, 103, 2, 1200),
(1002, 102, 1, 500),
(1002, 104, 1, 700),
(1003, 103, 1, 1200);


-- View all tables.

SELECT * FROM dbo.Design_Customers;
SELECT * FROM dbo.Design_Categories;
SELECT * FROM dbo.Design_Products;
SELECT * FROM dbo.Design_Orders;
SELECT * FROM dbo.Design_OrderDetails;


-- ---------------------------------------------------------
-- 12.1 FIND CUSTOMER ORDERS
-- ---------------------------------------------------------

SELECT
    C.CustomerName,
    O.OrderID,
    O.OrderDate
FROM dbo.Design_Customers AS C
INNER JOIN dbo.Design_Orders AS O
    ON C.CustomerID = O.CustomerID;


-- ---------------------------------------------------------
-- 12.2 FIND ORDER DETAILS
-- ---------------------------------------------------------

SELECT
    O.OrderID,
    P.ProductName,
    OD.Quantity,
    OD.UnitPrice,
    OD.Quantity * OD.UnitPrice AS LineTotal
FROM dbo.Design_Orders AS O
INNER JOIN dbo.Design_OrderDetails AS OD
    ON O.OrderID = OD.OrderID
INNER JOIN dbo.Design_Products AS P
    ON OD.ProductID = P.ProductID;


-- ---------------------------------------------------------
-- 12.3 TOTAL AMOUNT PER ORDER
-- ---------------------------------------------------------

SELECT
    OrderID,
    SUM(Quantity * UnitPrice) AS OrderTotal
FROM dbo.Design_OrderDetails
GROUP BY OrderID;


-- ---------------------------------------------------------
-- 12.4 CUSTOMER-WISE TOTAL SPENDING
-- ---------------------------------------------------------

SELECT
    C.CustomerID,
    C.CustomerName,
    SUM(OD.Quantity * OD.UnitPrice) AS TotalSpending
FROM dbo.Design_Customers AS C
INNER JOIN dbo.Design_Orders AS O
    ON C.CustomerID = O.CustomerID
INNER JOIN dbo.Design_OrderDetails AS OD
    ON O.OrderID = OD.OrderID
GROUP BY
    C.CustomerID,
    C.CustomerName;


-- =========================================================
-- SECTION 13: PRACTICE QUESTIONS
-- =========================================================

/*
DATABASE DESIGN FUNDAMENTALS

Q1. What is database design?

Q2. What is an entity?

Q3. What is an attribute?

Q4. What is a relationship?

Q5. What is a schema?

KEYS

Q6. What is a super key?

Q7. What is a candidate key?

Q8. What is a primary key?

Q9. What is an alternate key?

Q10. What is a foreign key?

Q11. What is a composite key?

Q12. Difference between PRIMARY KEY and UNIQUE?

RELATIONSHIPS

Q13. Explain one-to-one relationship with an example.

Q14. Explain one-to-many relationship with an example.

Q15. Explain many-to-many relationship with an example.

Q16. Why do we need a junction table?

Q17. Where should we place a foreign key in
     a one-to-many relationship?

NORMALIZATION

Q18. What is normalization?

Q19. What is data redundancy?

Q20. What is insertion anomaly?

Q21. What is update anomaly?

Q22. What is deletion anomaly?

Q23. Explain First Normal Form (1NF).

Q24. Explain Second Normal Form (2NF).

Q25. Explain Third Normal Form (3NF).

Q26. What is partial dependency?

Q27. What is transitive dependency?

Q28. Explain BCNF.

Q29. Difference between 3NF and BCNF.

Q30. What is denormalization?

PRACTICAL DESIGN

Q31. Design a college database with Students,
     Courses and Enrollments.

Q32. Design an employee database with Departments.

Q33. Design an online shopping database.

Q34. Identify primary and foreign keys
     in an online shopping database.

Q35. Explain how you would normalise a table
     containing student and course information.


-- =========================================================
-- SECTION 14: PRACTICE SOLUTIONS
-- ========================================================= */


-- Q1. What is database design?
-- Answer:
-- Organising data into tables, defining keys,
-- relationships and constraints to maintain
-- consistency and reduce redundancy.


-- Q2. What is an entity?
-- Answer:
-- A real-world object about which data is stored.
-- Example: Student, Employee, Product.


-- Q3. What is an attribute?
-- Answer:
-- A property of an entity.
-- Example: StudentName, Age, Email.


-- Q4. What is a relationship?
-- Answer:
-- A connection between two entities.


-- Q5. What is a schema?
-- Answer:
-- The logical structure of database objects.


-- Q6. What is a super key?
-- Answer:
-- Any attribute set that uniquely identifies a row.


-- Q7. What is a candidate key?
-- Answer:
-- A minimal super key.


-- Q8. What is a primary key?
-- Answer:
-- The selected candidate key used to identify rows.


-- Q9. What is an alternate key?
-- Answer:
-- A candidate key not selected as the primary key.


-- Q10. What is a foreign key?
-- Answer:
-- A column or group of columns that references
-- a candidate key in another table.


-- Q11. What is a composite key?
-- Answer:
-- A key formed using multiple columns.


-- Q12. PRIMARY KEY vs UNIQUE:

-- PRIMARY KEY:
-- - Unique.
-- - Cannot contain NULL.
-- - One primary key constraint per table.

-- UNIQUE:
-- - Enforces uniqueness.
-- - SQL Server allows one NULL for a single-column
--   UNIQUE constraint.
-- - Multiple UNIQUE constraints can exist.


-- Q13. One-to-one:
-- One person has one passport in the simplified model.


-- Q14. One-to-many:
-- One department has multiple employees.


-- Q15. Many-to-many:
-- Multiple students can take multiple courses.


-- Q16. Junction table:
-- It breaks a many-to-many relationship into
-- two one-to-many relationships.


-- Q17. Foreign key location:
-- Place the foreign key on the MANY side.


-- Q18. Normalization:
-- Organising tables to reduce redundancy
-- and avoid data anomalies.


-- Q19. Data redundancy:
-- Unnecessary repetition of the same information.


-- Q20. Insertion anomaly:
-- Difficulty inserting one piece of information
-- without unrelated information.


-- Q21. Update anomaly:
-- Updating repeated information in multiple rows
-- and risking inconsistent values.


-- Q22. Deletion anomaly:
-- Deleting one record unintentionally removes
-- other required information.


-- Q23. 1NF:
-- Each cell contains one atomic value,
-- with no repeating groups.


-- Q24. 2NF:
-- The table is in 1NF and every non-key attribute
-- depends on the whole candidate key.


-- Q25. 3NF:
-- The table is in 2NF and has no transitive
-- dependency of non-key attributes on a candidate key.


-- Q26. Partial dependency:
-- A non-key attribute depends on only part
-- of a composite candidate key.


-- Q27. Transitive dependency:
-- A non-key attribute depends on another
-- non-key attribute through a functional dependency.


-- Q28. BCNF:
-- Every determinant in every non-trivial
-- functional dependency must be a super key.


-- Q29. 3NF vs BCNF:
-- BCNF is stricter than 3NF.
-- BCNF requires every determinant to be a super key.
-- 3NF permits certain dependencies where the
-- right-hand side is a prime attribute.


-- Q30. Denormalization:
-- Intentionally introducing redundancy
-- to improve selected read workloads.


-- Q31-Q35:
-- Refer to the practical college, employee and
-- online shopping database designs in this file.
-- Build the relationships and test them using JOINs.


-- =========================================================
-- SECTION 15: FINAL INTERVIEW REVISION
-- =========================================================

/*
DATABASE DESIGN:
Organising data into tables and defining
relationships and constraints.

ENTITY:
A real-world object.

ATTRIBUTE:
A property of an entity.

PRIMARY KEY:
Uniquely identifies each row and cannot be NULL.

FOREIGN KEY:
Maintains referential integrity between tables.

COMPOSITE KEY:
A key containing multiple columns.

1:1:
One-to-one relationship.

1:M:
One-to-many relationship.

M:N:
Many-to-many relationship, normally implemented
using a junction table.

NORMALIZATION:
Reduces unnecessary redundancy and anomalies.

1NF:
Atomic values and no repeating groups.

2NF:
1NF + no partial dependency of non-key attributes
on a candidate key.

3NF:
2NF + no transitive dependency of non-key attributes
on a candidate key.

BCNF:
Every determinant in a non-trivial functional
dependency must be a super key.

DENORMALIZATION:
Intentional redundancy for selected performance needs.

INTERVIEW TIP:

Do not memorise only the definitions.

Be ready to explain normalization using a real example:
Student -> Course -> Enrollment.

Interviewers often ask you to take one unnormalised
table and convert it into 1NF, 2NF and 3NF.

============================================================
END OF DATABASE DESIGN PRACTICE
============================================================
*/