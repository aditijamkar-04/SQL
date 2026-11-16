# 02. DBMS vs RDBMS

## 1. What is DBMS?

DBMS stands for Database Management System. It is software that helps us store, manage, access and update data.

Think about a college that maintains information about students, teachers, fees and attendance. Managing all this information manually would be difficult. A DBMS makes it easier to store and work with this data.

In simple words, a DBMS acts as a medium between users and the database.

**Examples:** Microsoft Access, file-based database systems and other database management software.

## 2. What is RDBMS?

RDBMS stands for Relational Database Management System.

It stores data in the form of tables, where each table contains rows and columns. We can also connect different tables using relationships.

For example, a college database might have two tables:

**Students table**

| StudentID | StudentName | DepartmentID |
|---|---|---|
| 1 | Rahul | 101 |
| 2 | Priya | 102 |

**Departments table**

| DepartmentID | DepartmentName |
|---|---|
| 101 | Computer |
| 102 | Mechanical |

Here, `DepartmentID` connects the two tables. Instead of repeating department details for every student, we can maintain them separately and retrieve them using JOINs.

Examples include Microsoft SQL Server, MySQL, Oracle and PostgreSQL.