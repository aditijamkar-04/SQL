# 02. WHERE Clause and Comparison Operators

When working with a database, we usually don't need every record from a table. Sometimes we need only employees earning more than ₹50,000, students scoring above 80, or orders placed after a particular date.

To retrieve only the required records, we use the **WHERE clause**.

## 1. What is the WHERE Clause?

The WHERE clause is used to filter rows based on a specified condition.

Only the rows that satisfy the condition are returned.

**Syntax:**

```sql
SELECT column_name
FROM table_name
WHERE condition;
```

**Example:**

```sql
SELECT *
FROM Employees
WHERE Salary > 50000;
```

This query returns only those employees whose salary is greater than 50000.

## 2. Comparison Operators

Comparison operators compare two values and help us filter records.

| Operator | Meaning |
|---|---|
| `=` | Equal to |
| `<>` | Not equal to |
| `!=` | Not equal to |
| `>` | Greater than |
| `<` | Less than |
| `>=` | Greater than or equal to |
| `<=` | Less than or equal to |

### A. Equal to (=)

Used when we want to find records matching an exact value.

```sql
SELECT *
FROM Employees
WHERE DepartmentID = 1;
```

This returns employees belonging to DepartmentID 1.

### B. Not Equal to (<> or !=)

Used when we want to exclude a particular value.

```sql
SELECT *
FROM Employees
WHERE DepartmentID <> 1;
```

This returns employees who do not belong to DepartmentID 1.

We can also write:

```sql
SELECT *
FROM Employees
WHERE DepartmentID != 1;
```

In SQL Server, both `<>` and `!=` mean not equal to. However, `<>` is the standard SQL operator and is generally preferred.

### C. Greater Than (>)

Returns records where the value is greater than the specified value.

```sql
SELECT *
FROM Employees
WHERE Salary > 50000;
```

Only employees earning more than 50000 are returned.

### D. Less Than (<)

Returns records where the value is smaller than the specified value.

```sql
SELECT *
FROM Employees
WHERE Salary < 50000;
```

### E. Greater Than or Equal To (>=)

Returns records where the value is greater than or equal to the specified value.

```sql
SELECT *
FROM Employees
WHERE Salary >= 50000;
```

This includes employees earning exactly 50000 as well as those earning more.

### F. Less Than or Equal To (<=)

Returns records where the value is less than or equal to the specified value.

```sql
SELECT *
FROM Employees
WHERE Salary <= 50000;
```

This includes employees earning exactly 50000 and those earning less.

## 3. Filtering Numeric Values

We can apply comparison operators to numeric columns such as Salary, Age, Marks and Quantity.

**Example 1: Find employees earning more than 60000.**

```sql
SELECT EmployeeName, Salary
FROM Employees
WHERE Salary > 60000;
```

**Example 2: Find employees aged 25 or above.**

```sql
SELECT *
FROM Employees
WHERE Age >= 25;
```

**Example 3: Find employees whose salary is not 50000.**

```sql
SELECT *
FROM Employees
WHERE Salary <> 50000;
```

## 4. Filtering Text Values

We can also compare text values using the WHERE clause.

**Example 1: Find an employee named Rahul.**

```sql
SELECT *
FROM Employees
WHERE EmployeeName = 'Rahul';
```

**Example 2: Find employees who do not belong to the IT department.**

```sql
SELECT *
FROM Departments
WHERE DepartmentName <> 'IT';
```

**Important points:**

- Text values should be enclosed in single quotes.
- SQL Server string comparisons are often case-insensitive under common default collations, but this depends on the column or database collation.
- Numeric values should not be unnecessarily enclosed in quotes.

## 5. Filtering Date Values

We can use comparison operators with DATE, DATETIME and DATETIME2 columns.

**Example 1: Find employees who joined after 1 January 2024.**

```sql
SELECT *
FROM Employees
WHERE JoiningDate > '2024-01-01';
```

**Example 2: Find employees who joined on or before 31 December 2023.**

```sql
SELECT *
FROM Employees
WHERE JoiningDate <= '2023-12-31';
```

**Example 3: Find employees who joined on a specific date.**

```sql
SELECT *
FROM Employees
WHERE JoiningDate = '2024-01-01';
```

**Tip:** Use the ISO date format `YYYY-MM-DD` for clarity.

If a column contains date and time values, comparing it to a date literal may match midnight only. We'll cover date-range filtering in more detail when we study date functions.

## 6. Combining Conditions

We can combine multiple conditions in a WHERE clause using logical operators such as AND and OR.

We'll study AND, OR and NOT in detail in the next topic.

For now, understand these examples:

**Example: Employees earning more than 40000 and belonging to Department 1.**

```sql
SELECT *
FROM Employees
WHERE Salary > 40000
AND DepartmentID = 1;
```

**Example: Employees belonging to Department 1 or Department 2.**

```sql
SELECT *
FROM Employees
WHERE DepartmentID = 1
OR DepartmentID = 2;
```

## 7. Filtering NULL Values

NULL represents a missing or unknown value. We cannot compare NULL using the normal equality operator.

This is incorrect:

```sql
SELECT *
FROM Employees
WHERE DepartmentID = NULL;
```

Use `IS NULL` instead:

```sql
SELECT *
FROM Employees
WHERE DepartmentID IS NULL;
```

To find records where the value is not NULL:

```sql
SELECT *
FROM Employees
WHERE DepartmentID IS NOT NULL;
```

**Interview tip:** NULL is not the same as zero, an empty string or a blank space.

## 8. Operator Precedence in WHERE

When multiple conditions are used, SQL Server follows operator precedence.

For the logical operators covered here:

1. NOT
2. AND
3. OR

Consider:

```sql
SELECT *
FROM Employees
WHERE DepartmentID = 1
OR DepartmentID = 2
AND Salary > 50000;
```

SQL Server evaluates AND before OR. So this is interpreted as:

```sql
SELECT *
FROM Employees
WHERE DepartmentID = 1
OR
(
    DepartmentID = 2
    AND Salary > 50000
);
```

If we want employees from either department who earn more than 50000, use parentheses:

```sql
SELECT *
FROM Employees
WHERE
(
    DepartmentID = 1
    OR DepartmentID = 2
)
AND Salary > 50000;
```

**Remember:** Parentheses make your intended logic clear and help avoid unexpected results.

## 9. WHERE vs HAVING

Both WHERE and HAVING are used for filtering, but they work at different stages.

| WHERE | HAVING |
|---|---|
| Filters individual rows | Filters groups |
| Applied before GROUP BY | Applied after GROUP BY |
| Generally used before aggregation | Commonly used with aggregate conditions |
| Cannot directly filter using aggregate functions in the same query level | Can filter using aggregate functions |

Example using WHERE:

```sql
SELECT *
FROM Employees
WHERE Salary > 50000;
```

Example using HAVING:

```sql
SELECT DepartmentID, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > 50000;
```

We'll cover GROUP BY and HAVING separately.

## 10. Common Mistakes

**Mistake 1: Using = NULL**

Incorrect:

```sql
WHERE DepartmentID = NULL;
```

Correct:

```sql
WHERE DepartmentID IS NULL;
```

**Mistake 2: Forgetting quotes around text**

Incorrect:

```sql
WHERE EmployeeName = Rahul;
```

Correct:

```sql
WHERE EmployeeName = 'Rahul';
```

**Mistake 3: Using the wrong comparison operator**

```sql
WHERE Salary > 50000;
```

This excludes employees earning exactly 50000.

If you want to include them, use:

```sql
WHERE Salary >= 50000;
```

**Mistake 4: Ignoring AND/OR precedence**

Use parentheses when combining multiple conditions so that the query returns exactly what you intend.

## 11. Important Interview Questions

**Q1. What is the purpose of the WHERE clause?**

It filters rows based on specified conditions.

**Q2. What is the difference between `=` and `<>`?**

`=` checks equality, while `<>` checks inequality.

**Q3. What is the difference between `<>` and `!=` in SQL Server?**

Both mean not equal to. `<>` is the standard SQL operator.

**Q4. Can we use aggregate functions in WHERE?**

Not directly at the same query level. Use HAVING to filter grouped results based on aggregate values.

**Q5. Why can't we use `= NULL`?**

Because NULL represents an unknown or missing value. Use IS NULL or IS NOT NULL.

**Q6. What happens if a WHERE condition evaluates to UNKNOWN?**

The row is not returned. This is one reason comparisons involving NULL require special handling.

**Q7. What is the difference between WHERE and HAVING?**

WHERE filters rows before grouping, whereas HAVING filters groups after GROUP BY.

**Q8. Which operator is evaluated first, AND or OR?**

AND has higher precedence than OR.

**Q9. Does WHERE modify the original table?**

No. In a SELECT query, WHERE only filters the returned result. It does not change stored records.

---

## Quick Revision

| Operator / Clause | Purpose |
|---|---|
| `=` | Equal to |
| `<>` | Not equal to |
| `!=` | Not equal to |
| `>` | Greater than |
| `<` | Less than |
| `>=` | Greater than or equal to |
| `<=` | Less than or equal to |
| `IS NULL` | Find NULL values |
| `IS NOT NULL` | Exclude NULL values |
| `WHERE` | Filter rows |

**My takeaway:** WHERE is used whenever I need only specific records instead of retrieving the entire table. Choosing the correct operator is important because even a small mistake in a condition can change the query result.