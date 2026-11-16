# 03. Types of SQL Commands

When working with SQL, we use different commands for different purposes. Some commands help us create database objects, some help us manage records, and others control transactions and permissions.

SQL commands are commonly divided into five categories:

1. DDL – Data Definition Language
2. DML – Data Manipulation Language
3. DQL – Data Query Language
4. DCL – Data Control Language
5. TCL – Transaction Control Language

Let's understand each one with examples.

## 1. DDL (Data Definition Language)

DDL commands are used when we want to create or change the structure of database objects, such as tables.

For example, suppose we want to create an `Employees` table. We use DDL for that.

**Important DDL commands:**

| Command | Use |
|---|---|
| CREATE | Creates a database object |
| ALTER | Changes the structure of an existing object |
| DROP | Removes a database object |
| TRUNCATE | Removes all rows from a table |
| RENAME | Changes an object's name (syntax depends on the DBMS) |

**Example: CREATE**

```sql
CREATE TABLE Employees
(
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10,2)
);
```

This creates a table named `Employees` with three columns.

**Example: ALTER**

```sql
ALTER TABLE Employees
ADD Department VARCHAR(50);
```

This adds a new column called `Department`.

**Example: TRUNCATE**

```sql
TRUNCATE TABLE Employees;
```

This removes all rows from the table, but keeps the table structure.

**Example: DROP**

```sql
DROP TABLE Employees;
```

This removes the table itself, including its structure and data.

**Remember:** Use `DROP` carefully. Once an object is dropped, you cannot use it unless you recreate or restore it.

## 2. DML (Data Manipulation Language)

DML commands are used to work with the actual records stored inside tables.

For example, after creating an Employees table, we may want to insert a new employee, update a salary or delete a record.

**Important DML commands:**

| Command | Use |
|---|---|
| INSERT | Adds new records |
| UPDATE | Modifies existing records |
| DELETE | Removes selected records |
| MERGE | Performs insert, update or delete actions based on a source-target match |

**Example: INSERT**

```sql
INSERT INTO Employees
(EmployeeID, EmployeeName, Salary)
VALUES
(1, 'Rahul', 55000);
```

This inserts a new employee record.

**Example: UPDATE**

```sql
UPDATE Employees
SET Salary = 60000
WHERE EmployeeID = 1;
```

This changes Rahul's salary to 60,000.

**Example: DELETE**

```sql
DELETE FROM Employees
WHERE EmployeeID = 1;
```

This removes the employee whose ID is 1.

**Important:** Always check your `WHERE` condition before running UPDATE or DELETE. Without it, you may affect every row in the table.

## 3. DQL (Data