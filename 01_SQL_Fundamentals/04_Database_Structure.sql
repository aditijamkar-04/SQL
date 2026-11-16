# 04. Database Structure

Before writing SQL queries, we should understand how data is actually organised inside a database.

Imagine a college database containing student details, department information, courses and marks. Instead of storing everything in one large table, we organise the data into separate tables and connect them wherever required.

Let's understand the basic components.

## 1. What is a Database?

A database is an organised collection of related data that can be stored, accessed, managed and updated.

For example, a college database may contain:
- Student details
- Teacher details
- Department information
- Course details
- Examination records

In SQL Server, we can create a database using:

```sql
CREATE DATABASE CollegeDB;
```

To start working inside it:

```sql
USE CollegeDB;
```

## 2. What is a Schema?

A schema is a logical container used to organise database objects such as tables, views, procedures and functions.

Think of a database as a college building and schemas as different departments inside that building.

For example:

```sql
CREATE SCHEMA College;
```

We can create a table inside this schema:

```sql
CREATE TABLE College.Students
(
    StudentID INT,
    StudentName VARCHAR(100),
    Age INT
);
```

Here:
- `CollegeDB` is the database.
- `College` is the schema.
- `Students` is the table.

The fully qualified table name is:

```sql
CollegeDB.College.Students
```

In SQL Server, the general naming format is:

`DatabaseName.SchemaName.ObjectName`

## 3. What is a Table?

A table is where we store data in the form of rows and columns.

For example, a Students table:

| StudentID | StudentName | Age | Department |
|---:|---|---:|---|
| 1 | Rahul | 21 | AI&DS |
| 2 | Priya | 22 | Computer |
| 3 | Amit | 20 | Mechanical |

Each table should represent a particular subject or entity, such as students, employees, products or orders.

## 4. Rows and Columns

**Row:**

A row represents one complete record in a table.

For example:

`1 | Rahul | 21 | AI&DS`

This represents one student's information.

**Column:**

A column represents a particular attribute of the records.

For example:
- StudentID
- StudentName
- Age
- Department

**Cell:**

A cell is the value stored at the intersection of a row and a column.

For example, `Rahul` is a cell value under the StudentName column.

## 5. What Are Keys in SQL?

Keys are used to identify records and establish relationships between tables.

Let's understand the important types.

### 5.1 Primary Key

A primary key uniquely identifies each record in a table.

Important points:
- Duplicate values are not allowed.
- NULL values are not allowed.
- A table can have only one primary key constraint.
- The primary key can contain one or multiple columns.

Example:

```sql
CREATE TABLE Students
(
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100),
    Age INT
);
```

Here, StudentID uniquely identifies each student.

### 5.2 Foreign Key

A foreign key is a column or combination of columns that references a candidate key, usually a primary key, in another table or the same table.

It helps maintain referential integrity.

Example:

```sql
CREATE TABLE Departments
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);
```

```sql
CREATE TABLE Students
(
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100),
    DepartmentID INT,

    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID)
);
```

Here, `DepartmentID` in Students references `DepartmentID` in Departments.

This means a student cannot refer to a department ID that does not exist in the referenced table, unless the foreign key value is NULL and the column allows NULL.

### 5.3 Candidate Key

A candidate key is a column or combination of columns that can uniquely identify each record.

A table may have multiple candidate keys.

Example:

Suppose an Employees table has:

- EmployeeID
- Email
- EmployeeName

If both EmployeeID and Email are unique and non-NULL, both can be candidate keys.

We can choose one of them as the primary key.

### 5.4 Alternate Key

An alternate key is a candidate key that was not selected as the primary key.

Example:

If EmployeeID is selected as the primary key and Email is another candidate key, Email becomes an alternate key.

### 5.5 Composite Key

A composite key is a key made up of two or more columns that together uniquely identify a record.

Example:

Suppose a student can enrol in multiple courses.

| StudentID | CourseID | Marks |
|---:|---:|---:|
| 1 | 101 | 85 |
| 1 | 102 | 90 |
| 2 | 101 | 78 |

Neither StudentID nor CourseID alone is unique. But their combination is unique.

```sql
CREATE TABLE StudentCourses
(
    StudentID INT,
    CourseID INT,
    Marks INT,

    PRIMARY KEY (StudentID, CourseID)
);
```

### 5.6 Unique Key

A UNIQUE constraint ensures that duplicate values are not allowed in the constrained column or combination of columns.

Example:

```sql
CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY,
    Email VARCHAR(100) UNIQUE
);
```

In SQL Server, a UNIQUE constraint allows NULL values, but only one NULL in a single-column unique constraint.

## 6. Relationships Between Tables

In a relational database, tables can be connected using keys.

There are three commonly discussed relationship types.

### 6.1 One-to-One Relationship

One record in Table A is associated with at most one record in Table B, and vice versa.

Example:

- One person has one passport record.
- One passport record belongs to one person.

### 6.2 One-to-Many Relationship

One record in Table A can be associated with multiple records in Table B.

Example:

- One department can have many employees.
- Each employee belongs to one department.

This is a very common relationship in databases.

### 6.3 Many-to-Many Relationship

Multiple records in Table A can be associated with multiple records in Table B.

Example:

- One student can enrol in many courses.
- One course can have many students.

To implement this relationship, we usually create a junction table.

For example:

Students → StudentCourses ← Courses

## 7. Practical Example: Creating Related Tables

Let's create a small college database structure.

```sql
CREATE DATABASE CollegeDB;
GO

USE CollegeDB;
GO

CREATE TABLE Departments
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Students
(
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100),
    Age INT,
    DepartmentID INT,

    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID)
);
```

Insert some sample records:

```sql
INSERT INTO Departments
VALUES
(101, 'AI & DS'),
(102, 'Computer'),
(103, 'Mechanical');

INSERT INTO Students
VALUES
(1, 'Rahul', 21, 101),
(2, 'Priya', 22, 102),
(3, 'Amit', 20, 101);
```

To see the relationship between these tables:

```sql
SELECT
    S.StudentName,
    S.Age,
    D.DepartmentName
FROM Students AS S
INNER JOIN Departments AS D
    ON S.DepartmentID = D.DepartmentID;
```

This query combines student details with their department names.

## 8. Database Objects

A database can contain different types of objects.

| Object | Purpose |
|---|---|
| Tables | Store data |
| Views | Store a reusable query definition |
| Stored Procedures | Store reusable SQL routines |
| Functions | Perform operations and return values |
| Indexes | Help improve data retrieval performance |
| Triggers | Execute automatically in response to specified database events |

We'll study these objects in detail in a later section.

## 9. Important Interview Questions

**Q1. What is the difference between a database and a schema?**

A database is a collection of data and database objects. A schema is a logical container inside a database that organises those objects.

**Q2. What is the difference between a primary key and a foreign key?**

A primary key uniquely identifies records in its own table. A foreign key references a candidate key in another or the same table to establish a relationship.

**Q3. Can a table have multiple primary keys?**

No. A table can have only one primary key constraint, but that primary key can consist of multiple columns.

**Q4. What is a composite key?**

A key consisting of two or more columns that together uniquely identify a record.

**Q5. What is the difference between a candidate key and an alternate key?**

Candidate keys are all possible minimal unique identifiers. The candidate key not selected as the primary key is called an alternate key.

**Q6. What is referential integrity?**

It ensures that foreign key values refer to valid candidate key values in the referenced table, or are NULL when permitted.

**Q7. What is a junction table?**

A junction table connects two tables to implement a many-to-many relationship.

**Q8. Can a foreign key contain duplicate values?**

Yes. Multiple records can reference the same parent record. For example, many employees can belong to the same department.

**Q9. What is the difference between UNIQUE and PRIMARY KEY?**

Both enforce uniqueness. A primary key cannot contain NULL values, while a SQL Server UNIQUE constraint can allow NULL values subject to its uniqueness rules.

---

## Quick Revision

| Concept | Remember it as |
|---|---|
| Database | Collection of data |
| Schema | Logical container |
| Table | Rows and columns |
| Row | Complete record |
| Column | Attribute |
| Primary Key | Main unique identifier |
| Foreign Key | Reference to another key |
| Candidate Key | Possible primary key |
| Alternate Key | Candidate key not selected |
| Composite Key | Combination of columns |
| UNIQUE | Prevents duplicate key values |
| Junction Table | Connects many-to-many relationships |