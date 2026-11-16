# 01. SELECT Statement in SQL

The `SELECT` statement is used to retrieve data from one or more tables in a database.

Whenever we want to view, analyse or fetch information from a table, we use SELECT.

For example, suppose we have an Employees table containing employee details. We can use SELECT to retrieve employee names, salaries, departments or all available columns.

## 1. Basic Syntax

```sql
SELECT column_name
FROM table_name;
```

To retrieve multiple columns:

```sql
SELECT column1, column2, column3
FROM table_name;
```

**Example:**

```sql
SELECT EmployeeName, Salary
FROM Employees;
```

This retrieves only EmployeeName and Salary from the Employees table.

## 2. SELECT * – Retrieve All Columns

The `*` symbol is used to retrieve all columns from a table.

```sql
SELECT *
FROM Employees;
```

This returns every column and row from the Employees table.

**When should we use it?**

- While exploring a new dataset.
- During initial testing.
- When we genuinely need all columns.

**Interview tip:** In production queries, selecting only the required columns is generally better than using `SELECT *`. It makes queries easier to maintain and avoids retrieving unnecessary data.

## 3. SELECT Specific Columns

We can retrieve only the columns we need.

```sql
SELECT EmployeeID, EmployeeName, Salary
FROM Employees;
```

Suppose the table contains these columns:

- EmployeeID
- EmployeeName
- DepartmentID
- Salary
- JoiningDate
- Email

If we only need employee names and salaries, there is no need to retrieve all six columns.

## 4. Column Alias – AS

An alias is a temporary name given to a column in the query result.

We use aliases to make column headings easier to understand.

**Syntax:**

```sql
SELECT column_name AS alias_name
FROM table_name;
```

**Example:**

```sql
SELECT
    EmployeeName AS Name,
    Salary AS MonthlySalary
FROM Employees;
```

We can also write an alias without using AS:

```sql
SELECT
    EmployeeName Name,
    Salary MonthlySalary
FROM Employees;
```

**Alias with spaces:**

```sql
SELECT
    EmployeeName AS [Employee Name],
    Salary AS [Monthly Salary]
FROM Employees;
```

**Important points:**

- AS is optional for column aliases.
- An alias changes the displayed column heading, not the actual column name.
- SQL Server allows square brackets around aliases containing spaces or special characters.

## 5. DISTINCT – Remove Duplicate Values

The `DISTINCT` keyword returns unique combinations of the selected columns.

Suppose the Employees table contains:

| EmployeeID | EmployeeName | DepartmentID |
|---|---|---|
| 1 | Rahul | 1 |
| 2 | Priya | 2 |
| 3 | Amit | 1 |
| 4 | Sneha | 3 |
| 5 | Neha | 2 |

If we want to see which departments are present:

```sql
SELECT DISTINCT DepartmentID
FROM Employees;
```

Output:

| DepartmentID |
|---|
| 1 |
| 2 |
| 3 |

Duplicate department IDs are removed.

**DISTINCT on multiple columns:**

```sql
SELECT DISTINCT DepartmentID, Salary
FROM Employees;
```

Here, SQL Server considers the combination of DepartmentID and Salary.

It does not make each column independently unique.

**Difference between DISTINCT and UNIQUE:**

- DISTINCT is used in a SELECT query to remove duplicate result combinations.
- UNIQUE is a constraint that prevents duplicate key values from being stored.

## 6. TOP – Retrieve a Limited Number of Rows

The `TOP` keyword is used to return a specified number or percentage of rows.

**Syntax:**

```sql
SELECT TOP (number)
column_name
FROM table_name;
```

**Example:**

```sql
SELECT TOP (3) *
FROM Employees;
```

This returns three rows.

**TOP with ORDER BY:**

```sql
SELECT TOP (3)
EmployeeName,
Salary
FROM Employees
ORDER BY Salary DESC;
```

This returns the three employees with the highest salaries.

**TOP PERCENT:**

```sql
SELECT TOP (50) PERCENT *
FROM Employees;
```

This returns approximately 50% of the rows.

**WITH TIES:**

```sql
SELECT TOP (3) WITH TIES
EmployeeName,
Salary
FROM Employees
ORDER BY Salary DESC;
```

WITH TIES includes additional rows that have the same ORDER BY value as the last selected row.

For example, if the third-highest salary is shared by two employees, both employees are included.

**Important interview point:**

TOP without ORDER BY does not guarantee which rows will be returned.

## 7. WHERE – Filter Records

The WHERE clause is used to filter rows based on a specified condition.

**Syntax:**

```sql
SELECT column_name
FROM table_name
WHERE condition;
```

**Example 1: Employees with salary greater than 50000**

```sql
SELECT *
FROM Employees
WHERE Salary > 50000;
```

**Example 2: Employees belonging to Department 1**

```sql
SELECT *
FROM Employees
WHERE DepartmentID = 1;
```

**Example 3: Employees with a specific name**

```sql
SELECT *
FROM Employees
WHERE EmployeeName = 'Rahul';
```

The WHERE clause is commonly used with comparison, logical and special operators. We will study those separately.

## 8. Combining SELECT, DISTINCT, WHERE and ORDER BY

We can combine different SQL clauses in a single query.

**Example: Find unique department IDs for employees earning more than 40000.**

```sql
SELECT DISTINCT DepartmentID
FROM Employees
WHERE Salary > 40000
ORDER BY DepartmentID;
```

**Example: Find the top two highest-paid employees in Department 1.**

```sql
SELECT TOP (2)
EmployeeName,
Salary
FROM Employees
WHERE DepartmentID = 1
ORDER BY Salary DESC;
```

## 9. Logical Execution Order of a SELECT Query

This is an important interview concept.

Although we write SELECT first, SQL Server logically processes the main clauses in a different order.

| Order | Clause | Purpose |
|---|---|---|
| 1 | FROM | Identifies the source table |
| 2 | WHERE | Filters rows |
| 3 | GROUP BY | Groups rows |
| 4 | HAVING | Filters groups |
| 5 | SELECT | Selects expressions and columns |
| 6 | DISTINCT | Removes duplicate result rows |
| 7 | ORDER BY | Sorts the result |
| 8 | TOP | Limits the final result set |

This is a simplified logical processing order for common SELECT queries. Advanced features can introduce additional processing steps.

**Why is this important?**

For example, a SELECT alias is generally not available in the WHERE clause because WHERE is logically processed before SELECT.

This will not work:

```sql
SELECT
    Salary * 12 AS AnnualSalary
FROM Employees
WHERE AnnualSalary > 600000;
```

Instead, write:

```sql
SELECT
    Salary * 12 AS AnnualSalary
FROM Employees
WHERE Salary * 12 > 600000;
```

## 10. Common Interview Questions

**Q1. What is the SELECT statement?**

SELECT is used to retrieve data from database tables.

**Q2. What is the difference between SELECT * and SELECT column_name?**

SELECT * retrieves all columns, whereas selecting specific columns retrieves only the required columns.

**Q3. What is the purpose of DISTINCT?**

DISTINCT removes duplicate combinations from the result set.

**Q4. What is the difference between DISTINCT and GROUP BY?**

DISTINCT removes duplicate result rows. GROUP BY groups rows and is commonly used with aggregate functions such as COUNT, SUM and AVG.

**Q5. What is an alias?**

An alias is a temporary name given to a column or table in a query.

**Q6. What is the purpose of TOP?**

TOP limits the number or percentage of rows returned by a query.

**Q7. Why should we use ORDER BY with TOP?**

Without ORDER BY, SQL Server does not guarantee which rows TOP will return.

**Q8. Can we use a SELECT alias in WHERE?**

Generally, no. WHERE is logically processed before SELECT.

**Q9. Can DISTINCT be used with multiple columns?**

Yes. It removes duplicate combinations of all selected columns.

**Q10. Does SELECT modify the original table?**

No. SELECT retrieves data and does not modify the stored records.

---

## Quick Revision

| Keyword | Purpose |
|---|---|
| SELECT | Retrieve data |
| * | Select all columns |
| AS | Give a temporary alias |
| DISTINCT | Remove duplicate result combinations |
| TOP | Limit returned rows |
| WHERE | Filter rows |
| ORDER BY | Sort the result |

**Remember:** SELECT is the foundation of SQL querying. Once you understand it properly, learning filtering, sorting, grouping and joins becomes much easier.