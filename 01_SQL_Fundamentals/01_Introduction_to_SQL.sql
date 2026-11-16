# 01. Introduction to SQL

## 1. What is SQL?

**SQL (Structured Query Language)** is a standard language used to communicate with relational databases.

It allows us to:
- Create databases and tables.
- Insert new records.
- Retrieve data.
- Update existing records.
- Delete records.
- Filter and sort data.
- Perform calculations and aggregations.
- Manage database objects and permissions.

**Example:**

```sql
SELECT *
FROM Employees;
```

This query retrieves all columns and records from the `Employees` table.

## 2. Why Do We Use SQL?

SQL is used because databases store large amounts of structured data, and we need an efficient way to manage and retrieve that data.

Common uses:

| Purpose | SQL operation |
|---|---|
| Retrieve data | SELECT |
| Add records | INSERT |
| Modify records | UPDATE |
| Remove records | DELETE |
| Create tables | CREATE |
| Modify table structure | ALTER |
| Remove database objects | DROP |
| Group data | GROUP BY |
| Filter grouped results | HAVING |
| Combine tables | JOIN |

## 3. Where Is SQL Used?

SQL is widely used in:

1. Banking – managing customer accounts and transactions.
2. E-commerce – managing products, orders and customers.
3. Healthcare – managing patient and appointment records.
4. Education – managing student and examination records.
5. Data Analytics – analysing business data and generating reports.
6. Data Science – extracting and preparing data for analysis.
7. Web Applications – storing and retrieving application data.

## 4. How Does SQL Work?

A simplified database interaction:

1. Data is stored in database tables.
2. A user or application sends an SQL query.
3. The database management system processes the query.
4. The database returns the requested result or performs the requested operation.

**Example:**

```sql
SELECT EmployeeName, Salary
FROM Employees
WHERE Salary > 50000;
```

Explanation:
- SELECT specifies the columns to retrieve.
- FROM specifies the source table.
- WHERE filters records.
- The result contains employees whose salary is greater than 50,000.

## 5. What Is a Database?

A **database** is an organised collection of data that can be stored, accessed, managed and updated.

Example: An organisation may maintain a database containing:
- Employee information
- Department details
- Customer records
- Salary information

## 6. What Is DBMS?

**DBMS (Database Management System)** is software used to create, store, manage and retrieve data from databases.

Examples:
- Microsoft Access
- MySQL
- Microsoft SQL Server
- Oracle Database
- PostgreSQL

## 7. What Is RDBMS?

**RDBMS (Relational Database Management System)** is a type of DBMS that stores data in related tables.

Important characteristics:
- Data is organised into rows and columns.
- Tables can be connected using relationships.
- Primary keys uniquely identify records.
- Foreign keys help establish relationships.
- Constraints help maintain data integrity.

Examples:
- Microsoft SQL Server
- MySQL
- Oracle Database
- PostgreSQL

## 8. DBMS vs RDBMS

| DBMS | RDBMS |
|---|---|
| General database management system | Relational database management system |
| May use different data models | Uses relational tables |
| Relationships are not a defining requirement | Supports relationships between tables |
| May not enforce relational constraints | Supports relational constraints |
| Example: file-based database systems | Example: SQL Server, MySQL |

**Interview point:** Every RDBMS is a DBMS, but not every DBMS is an RDBMS.

## 9. SQL vs MySQL vs SQL Server

These terms are different:

| Term | Meaning |
|---|---|
| SQL | Language used to communicate with relational databases |
| MySQL | A relational database management system |
| Microsoft SQL Server | A relational database management system developed by Microsoft |

**Important:** SQL is a language, whereas MySQL and SQL Server are database management systems.

Different database systems may support different SQL dialects.

For example, Microsoft SQL Server uses T-SQL (Transact-SQL).

## 10. What Is a Table?

A table stores data in rows and columns.

Example: Employees

| EmployeeID | EmployeeName | Department | Salary |
|---|---|---|---:|
| 1 | Rahul | IT | 55000 |
| 2 | Priya | HR | 45000 |
| 3 | Amit | IT | 65000 |

- Row: A complete record.
- Column: A particular attribute.
- Cell: A single value.
- Primary Key: A column or combination of columns that uniquely identifies a row.

## 11. Important SQL Terminology

| Term | Meaning |
|---|---|
| Database | Organised collection of data |
| Table | Data organised into rows and columns |
| Row | Individual record |
| Column | Attribute or field |
| Schema | Logical container for database objects |
| Primary Key | Uniquely identifies a record |
| Foreign Key | Establishes a relationship between tables |
| Query | Instruction sent to a database |
| Constraint | Rule applied to data |
| NULL | Represents a missing or unknown value |

## 12. SQL Interview Questions

**Q1. What is SQL?**

SQL is a standard language used to communicate with relational databases