# 06. SQL Constraints

When creating a table, we don't want users to insert just any kind of data. For example, an employee should not have a negative salary, two employees should not have the same EmployeeID, and an employee should not be assigned to a department that doesn't exist.

This is where **constraints** come into the picture.

Constraints are rules applied to table columns to control the type of data that can be stored and maintain data accuracy and integrity.

## 1. Types of SQL Constraints

SQL Server provides these commonly used constraints:

1. NOT NULL
2. UNIQUE
3. PRIMARY KEY
4. FOREIGN KEY
5. CHECK
6. DEFAULT

SQL Server also supports `IDENTITY`, which is a column property used to generate values automatically. It is not technically a constraint.

## 2. NOT NULL Constraint

The NOT NULL constraint ensures that a column cannot store NULL values.

For example, an employee should have a name, so we can make EmployeeName NOT NULL.

```sql
CREATE TABLE Employees
(
    EmployeeID INT,
    EmployeeName VARCHAR(100) NOT NULL,
    Salary DECIMAL(10,2)
);
```

This is allowed:

```sql
INSERT INTO Employees
VALUES (1, 'Rahul', 55000);
```

This will fail because EmployeeName is NULL:

```sql
INSERT INTO Employees
VALUES (2, NULL, 45000);
```

**When do we use it?**

Use NOT NULL when a value is mandatory, such as an employee name, order date or product name.

## 3. UNIQUE Constraint

The UNIQUE constraint prevents duplicate values in a column or combination of columns.

For example, two employees should not have the same email address.

```sql
CREATE TABLE Employees
(
    EmployeeID INT,
    Email VARCHAR(100) UNIQUE
);
```

This is allowed:

```sql
INSERT INTO Employees
VALUES
(1, 'rahul@gmail.com'),
(2, 'priya@gmail.com');
```

But inserting the same email again will fail:

```sql
INSERT INTO Employees
VALUES (3, 'rahul@gmail.com');
```

**Important points:**
- Duplicate values are not allowed.
- SQL Server allows one NULL in a single-column UNIQUE constraint.
- A table can have multiple UNIQUE constraints.

## 4. PRIMARY KEY Constraint

A PRIMARY KEY uniquely identifies every record in a table.

For example, EmployeeID can be used to identify each employee.

```sql
CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10,2)
);
```

The following records are allowed:

```sql
INSERT INTO Employees
VALUES
(1, 'Rahul', 55000),
(2, 'Priya', 45000);
```

But these records are not allowed:

```sql
INSERT INTO Employees
VALUES (1, 'Amit', 60000);
```

The EmployeeID already exists.

**Important points:**
- Duplicate values are not allowed.
- NULL values are not allowed.
- A table can have only one PRIMARY KEY constraint.
- The primary key can consist of multiple columns.

## 5. FOREIGN KEY Constraint

A FOREIGN KEY connects two tables and maintains referential integrity.

For example, every employee belongs to a department. We don't want to assign an employee to a department that does not exist.

First, create the parent table:

```sql
CREATE TABLE Departments
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);
```

Now create the child table:

```sql
CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT,

    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID)
);
```

Insert departments first:

```sql
INSERT INTO Departments
VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance');
```

Now insert employees:

```sql
INSERT INTO Employees
VALUES
(1, 'Rahul', 101),
(2, 'Priya', 102);
```

This will fail:

```sql
INSERT INTO Employees
VALUES (3, 'Amit', 105);
```

Why?

Because DepartmentID 105 does not exist in the Departments table.

**Important points:**
- A foreign key can contain duplicate values.
- A foreign key can contain NULL if the column allows it.
- A foreign key can reference a primary key or another candidate key backed by a suitable UNIQUE constraint.
- A table can have multiple foreign keys.

## 6. CHECK Constraint

The CHECK constraint ensures that inserted or updated values satisfy a specified condition.

For example, an employee's salary should not be negative.

```sql
CREATE TABLE Employees
(
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10,2)
        CHECK (Salary >= 0)
);
```

This is allowed:

```sql
INSERT INTO Employees
VALUES (1, 'Rahul', 55000);
```

This will fail:

```sql
INSERT INTO Employees
VALUES (2, 'Priya', -5000);
```

We can also apply CHECK constraints to conditions such as age, marks and status values.

Example:

```sql
CREATE TABLE Students
(
    StudentID INT,
    StudentName VARCHAR(100),
    Age INT CHECK (Age >= 18),
    Marks INT CHECK (Marks BETWEEN 0 AND 100)
);
```

**Important:** A CHECK constraint does not reject NULL just because the condition evaluates to UNKNOWN. Use NOT NULL as well if NULL must not be allowed.

## 7. DEFAULT Constraint

The DEFAULT constraint automatically supplies a value when an INSERT statement does not provide a value for that column.

Example:

```sql
CREATE TABLE Employees
(
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Department VARCHAR(50) DEFAULT 'General'
);
```

Now insert a record without specifying Department:

```sql
INSERT INTO Employees
(EmployeeID, EmployeeName)
VALUES
(1, 'Rahul');
```

The Department will automatically be set to `General`.

**Important:** If we explicitly insert NULL, the DEFAULT value is not used. A DEFAULT applies when the column is omitted or the `DEFAULT` keyword is specified.

Example:

```sql
INSERT INTO Employees
(EmployeeID, EmployeeName, Department)
VALUES
(2, 'Priya', DEFAULT);
```

## 8. IDENTITY Property in SQL Server

IDENTITY automatically generates sequential numeric values when new rows are inserted.

Syntax:

```sql
IDENTITY(seed, increment)
```

- Seed = Starting value.
- Increment = Value added for the next generated value.

Example:

```sql
CREATE TABLE Employees
(
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeName VARCHAR(100)
);
```

Insert records:

```sql
INSERT INTO Employees (EmployeeName)
VALUES
('Rahul'),
('Priya'),
('Amit');
```

Retrieve the records:

```sql
SELECT *
FROM Employees;
```

The generated EmployeeID values will normally be 1, 2 and 3 for these successful inserts in a fresh table.

**Important points:**
- IDENTITY is not a constraint.
- It automatically generates numeric values.
- It does not guarantee uniqueness by itself.
- Use PRIMARY KEY or UNIQUE if uniqueness must be enforced.
- Gaps can occur in IDENTITY values; they are not guaranteed to be continuous.

## 9. Column-Level vs Table-Level Constraints

Constraints can be declared while defining individual columns or after defining the columns in a table.

**Column-level constraint:**

```sql
CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    Salary DECIMAL(10,2) CHECK (Salary >= 0)
);
```

Here, constraints are written alongside their respective columns.

**Table-level constraint:**

```sql
CREATE TABLE StudentCourses
(
    StudentID INT,
    CourseID INT,
    Marks INT,

    CONSTRAINT PK_StudentCourses
    PRIMARY KEY (StudentID, CourseID)
);
```

Here, the primary key is defined at the table level. This is particularly useful for composite keys.

## 10. Adding Constraints Using ALTER TABLE

Sometimes we create a table first and add constraints later.

We can use ALTER TABLE for this.

**Add a PRIMARY KEY:**

```sql
ALTER TABLE Employees
ADD CONSTRAINT PK_Employees
PRIMARY KEY (EmployeeID);
```

**Add a UNIQUE constraint:**

```sql
ALTER TABLE Employees
ADD CONSTRAINT UQ_Employees_Email
UNIQUE (Email);
```

**Add a CHECK constraint:**

```sql
ALTER TABLE Employees
ADD CONSTRAINT CK_Employees_Salary
CHECK (Salary >= 0);
```

**Add a DEFAULT constraint:**

```sql
ALTER TABLE Employees
ADD CONSTRAINT DF_Employees_Department
DEFAULT 'General' FOR Department;
```

**Add a FOREIGN KEY:**

```sql
ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_Departments
FOREIGN KEY (DepartmentID)
REFERENCES Departments(DepartmentID);
```

Before adding a constraint, check existing data. If the existing records violate the new rule, SQL Server may reject the ALTER TABLE statement.

## 11. Removing Constraints Using ALTER TABLE

We can remove a named constraint using:

```sql
ALTER TABLE Employees
DROP CONSTRAINT CK_Employees_Salary;
```

Here, `CK_Employees_Salary` is the constraint name.

**Tip:** Give meaningful names to constraints. It makes them easier to identify and manage later.

## 12. Practical Example: Combining Constraints

Let's create an employee table using multiple constraints together.

```sql
CREATE TABLE Employees
(
    EmployeeID INT IDENTITY(1,1),

    EmployeeName VARCHAR(100) NOT NULL,

    Email VARCHAR(100) NOT NULL,

    Age INT CHECK (Age >= 18),

    Salary DECIMAL(10,2)
        CHECK (Salary >= 0),

    DepartmentID INT,

    IsActive BIT DEFAULT 1,

    CONSTRAINT PK_Employees
        PRIMARY KEY (EmployeeID),

    CONSTRAINT UQ_Employees_Email
        UNIQUE (Email),

    CONSTRAINT FK_Employees_Departments
        FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID)
);
```

In this table:
- EmployeeID is generated automatically and is the primary key.
- EmployeeName and Email cannot be NULL.
- Email must be unique.
- Age must be at least 18.
- Salary cannot be negative.
- DepartmentID must reference an existing department, or be NULL.
- IsActive gets 1 when no value is supplied.

## 13. Difference Between Common Constraints

| Constraint | Main purpose |
|---|---|
| NOT NULL | Prevents NULL values |
| UNIQUE | Prevents duplicate key values |
| PRIMARY KEY | Uniquely identifies each row |
| FOREIGN KEY | Maintains relationships |
| CHECK | Enforces a condition |
| DEFAULT | Supplies a value when omitted |

## 14. Important Interview Questions

**Q1. What are constraints in SQL?**

Constraints are rules applied to table columns to maintain data accuracy and integrity.

**Q2. What is the difference between PRIMARY KEY and UNIQUE?**

Both enforce uniqueness. A primary key cannot contain NULL values, while a SQL Server UNIQUE constraint can allow one NULL in a single-column unique constraint.

**Q3. Can a table have multiple primary keys?**

No. A table can have only one PRIMARY KEY constraint, but it can contain multiple columns.

**Q4. Can a foreign key contain duplicate values?**

Yes. Multiple child records can reference the same parent record.

**Q5. What is the difference between CHECK and DEFAULT?**

CHECK validates whether a value satisfies a condition. DEFAULT supplies a value when the column is omitted or DEFAULT is specified.

**Q6. Is IDENTITY a constraint?**

No. IDENTITY is a SQL Server column property that automatically generates numeric values.

**Q7. Can we add a constraint after creating a table?**

Yes. We can use ALTER TABLE to add a constraint.

**Q8. What happens if we insert a duplicate primary key?**

SQL Server rejects the INSERT because primary key values must be unique.

**Q9. Can a table have multiple foreign keys?**

Yes. A table can reference multiple parent tables using different foreign keys.

**Q10. What is referential integrity?**

It ensures that foreign key values refer to valid records in the referenced table, unless NULL is permitted.

---

## Quick Revision

- NOT NULL → Value is mandatory.
- UNIQUE → No duplicate key values.
- PRIMARY KEY → Unique row identification.
- FOREIGN KEY → Connects related tables.
- CHECK → Validates a condition.
- DEFAULT → Supplies a default value.
- IDENTITY → Generates numeric values automatically.