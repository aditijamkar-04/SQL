# 05. SQL Server Data Types

Whenever we create a table, we need to decide what kind of data each column will store.

For example, an employee table may contain:
- EmployeeID – numbers
- EmployeeName – text
- Salary – decimal values
- JoiningDate – date values
- IsActive – True or False

SQL Server provides different data types for storing these values. Choosing the correct data type is important because it affects storage, accuracy, performance and the kind of operations we can perform.

## 1. Numeric Data Types

Numeric data types are used to store numbers. They are mainly divided into two groups: exact numeric and approximate numeric.

### 1.1 Integer Data Types

These are used when we need to store whole numbers without decimal values.

| Data type | Storage | Range |
|---|---:|---|
| TINYINT | 1 byte | 0 to 255 |
| SMALLINT | 2 bytes | -32,768 to 32,767 |
| INT | 4 bytes | -2,147,483,648 to 2,147,483,647 |
| BIGINT | 8 bytes | -9 quintillion to 9 quintillion approximately |

Example:

```sql
CREATE TABLE Employees
(
    EmployeeID INT,
    Age TINYINT,
    DepartmentID SMALLINT,
    TotalTransactions BIGINT
);
```

**When should we use them?**

- `TINYINT`: Small positive values, such as a rating from 0 to 5.
- `SMALLINT`: Values with a smaller range than INT, such as certain counts.
- `INT`: Commonly used for IDs and general whole-number values.
- `BIGINT`: Very large counts or identifiers.

Don't choose BIGINT just because it sounds more powerful. Choose it when the expected values require its larger range.

### 1.2 Exact Numeric Data Types

These data types store numbers with a defined precision.

| Data type | Purpose |
|---|---|
| DECIMAL(p,s) | Stores exact decimal values |
| NUMERIC(p,s) | Equivalent to DECIMAL in SQL Server |
| MONEY | Stores monetary values |
| SMALLMONEY | Stores smaller monetary values |

Here:
- `p` = Precision (total number of digits).
- `s` = Scale (number of digits after the decimal point).

Example:

```sql
DECLARE @Salary DECIMAL(10,2) = 55000.75;

SELECT @Salary AS Salary;
```

Here, `DECIMAL(10,2)` means:
- Total digits = 10
- Digits after decimal = 2
- Digits before decimal = 8

Another example:

```sql
DECIMAL(5,2)
```

Can store values such as `123.45` and `999.99`.

**When should we use DECIMAL?**

Use it when accuracy matters, especially for:
- Salary
- Product prices
- Financial calculations
- Tax amounts

For most financial applications, DECIMAL is generally preferred over FLOAT.

### 1.3 Approximate Numeric Data Types

These data types store approximate floating-point values.

| Data type | Storage | Purpose |
|---|---:|---|
| REAL | 4 bytes | Approximate numbers |
| FLOAT | 8 bytes by default | Approximate numbers |

Example:

```sql
DECLARE @Percentage FLOAT = 89.56789;

SELECT @Percentage AS Percentage;
```

**When should we use FLOAT or REAL?**

They are useful for:
- Scientific calculations
- Measurements
- Engineering calculations
- Values where a small approximation is acceptable

**Important:** FLOAT and REAL may produce small precision differences because they store approximate values.

For example, financial calculations should generally use DECIMAL instead.

## 2. Character and String Data Types

These data types are used to store text, names, addresses and other character-based information.

| Data type | Description |
|---|---|
| CHAR(n) | Fixed-length non-Unicode character data |
| VARCHAR(n) | Variable-length non-Unicode character data |
| NCHAR(n) | Fixed-length Unicode character data |
| NVARCHAR(n) | Variable-length Unicode character data |

### 2.1 CHAR

CHAR stores fixed-length character data.

Example:

```sql
DECLARE @Gender CHAR(10) = 'Male';

SELECT @Gender AS Gender;
```

If we declare `CHAR(10)` and store `Male`, SQL Server pads the value with spaces to the declared length.

**When should we use CHAR?**

When values generally have a fixed length, such as:
- Country codes
- Fixed-format codes
- Certain status codes

### 2.2 VARCHAR

VARCHAR stores variable-length non-Unicode character data.

Example:

```sql
DECLARE @Name VARCHAR(50) = 'Rahul';

SELECT @Name AS Name;
```

It stores the characters supplied rather than padding every value to the full declared length.

**When should we use VARCHAR?**

When storing text of varying lengths, such as:
- Employee names
- Email addresses
- City names
- Descriptions

### 2.3 NCHAR

NCHAR stores fixed-length Unicode character data.

Example:

```sql
DECLARE @Name NCHAR(20) = N'Rahul';

SELECT @Name AS Name;
```

The `N` before the string literal indicates a Unicode string literal.

### 2.4 NVARCHAR

NVARCHAR stores variable-length Unicode character data.

Example:

```sql
DECLARE @Name NVARCHAR(100) = N'नमस्ते';

SELECT @Name AS Greeting;
```

It supports text from different writing systems, including Hindi and other languages.

**When should we use NVARCHAR?**

When the application needs to store Unicode text, such as:
- Hindi names
- International names
- Multiple languages
- Special Unicode characters

### 2.5 CHAR vs VARCHAR

| CHAR | VARCHAR |
|---|---|
| Fixed length | Variable length |
| Pads shorter values with spaces | Does not pad values to the declared length |
| Useful for fixed-format values | Useful for variable-length text |
| Can use more space for shorter values | Usually more space-efficient for varying lengths |

### 2.6 VARCHAR vs NVARCHAR

| VARCHAR | NVARCHAR |
|---|---|
| Non-Unicode character data | Unicode character data |
| Uses the database/code-page encoding | Supports Unicode |
| Useful for suitable non-Unicode text | Useful for multilingual text |
| Maximum declared length is 8,000 bytes | Maximum declared length is 4,000 byte-pairs |

For large variable-length values, SQL Server also provides `VARCHAR(MAX)` and `NVARCHAR(MAX)`.

**Interview tip:** In SQL Server, NVARCHAR(n) defines a limit in byte-pairs, not necessarily the number of visible characters for every Unicode character.

## 3. Date and Time Data Types

These data types are used to store dates, times and timestamps.

| Data type | Stores |
|---|---|
| DATE | Date only |
| TIME | Time only |
| DATETIME | Date and time |
| SMALLDATETIME | Date and time with lower precision |
| DATETIME2 | Date and time with higher precision |
| DATETIMEOFFSET | Date, time and time-zone offset |

### 3.1 DATE

Stores only the date.

```sql
DECLARE @JoiningDate DATE = '2026-11-03';

SELECT @JoiningDate AS JoiningDate;
```

### 3.2 TIME

Stores only the time.

```sql
DECLARE @StartTime TIME = '10:30:00';

SELECT @StartTime AS StartTime;
```

### 3.3 DATETIME

Stores both date and time.

```sql
DECLARE @CreatedAt DATETIME = '2026-11-03 10:30:00';

SELECT @CreatedAt AS CreatedAt;
```

### 3.4 DATETIME2

Stores date and time with configurable fractional-second precision.

```sql
DECLARE @CreatedAt DATETIME2(7) =
'2026-11-03 10:30:15.1234567';

SELECT @CreatedAt AS CreatedAt;
```

DATETIME2 is generally preferred over DATETIME for new SQL Server applications because it offers a wider date range and higher precision.

### 3.5 DATETIMEOFFSET

Stores date and time along with a time-zone offset.

```sql
DECLARE @MeetingTime DATETIMEOFFSET =
'2026-11-03 10:30:00 +05:30';

SELECT @MeetingTime AS MeetingTime;
```

It is useful when time-zone offset information needs to be preserved.

## 4. Other Important Data Types

### 4.1 BIT

BIT is used to store Boolean-like values.

It can store:
- 0
- 1
- NULL

Example:

```sql
CREATE TABLE Employees
(
    EmployeeID INT,
    IsActive BIT
);
```

```sql
INSERT INTO Employees
VALUES (1, 1), (2, 0);
```

Here:
- 1 represents active.
- 0 represents inactive.

These meanings are application-defined; SQL Server itself does not label them TRUE and FALSE.

### 4.2 UNIQUEIDENTIFIER

Stores a globally unique identifier (GUID).

Example:

```sql
DECLARE @ID UNIQUEIDENTIFIER = NEWID();

SELECT @ID AS UniqueID;
```

`NEWID()` generates a new GUID.

It is useful when we need identifiers that are designed to be globally unique.

### 4.3 BINARY and VARBINARY

These data types store binary data rather than ordinary text.

| Data type | Purpose |
|---|---|
| BINARY(n) | Fixed-length binary data |
| VARBINARY(n) | Variable-length binary data |
| VARBINARY(MAX) | Large binary data |

Example:

```sql
DECLARE @Data VARBINARY(10) = 0x414243;

SELECT @Data AS BinaryData;
```

They can be used for binary values and certain file-related data.

## 5. How to Choose the Correct Data Type?

Before creating a table, think about what kind of values a column will contain.

| Column | Suitable data type | Reason |
|---|---|---|
| EmployeeID | INT | Whole-number identifier |
| EmployeeName | NVARCHAR(100) | Supports Unicode names |
| Age | TINYINT | Small whole-number range |
| Salary | DECIMAL(10,2) | Exact decimal value |
| JoiningDate | DATE | Only date is required |
| LoginTime | TIME | Only time is required |
| CreatedAt | DATETIME2 | Date and time |
| IsActive | BIT | 0 or 1 |
| UniqueID | UNIQUEIDENTIFIER | GUID |

The important thing is not to select a data type randomly. Consider the expected range, precision, text requirements and storage.

## 6. Practical Example: Employee Table

Let's combine what we have learned and create a table using different data types.

```sql
CREATE TABLE EmployeeDetails
(
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    Age TINYINT,
    Salary DECIMAL(10,2),
    JoiningDate DATE,
    IsActive BIT,
    CreatedAt DATETIME2
);
```

Insert some sample records:

```sql
INSERT INTO EmployeeDetails
VALUES
(1, N'Rahul', 24, 55000.50, '2025-01-15', 1, SYSDATETIME()),
(2, N'Priya', 23, 45000.75, '2025-03-10', 1, SYSDATETIME()),
(3, N'Amit', 25, 65000.00, '2024-08-20', 0, SYSDATETIME());
```

Retrieve the records:

```sql
SELECT *
FROM EmployeeDetails;
```

## 7. Common Mistakes to Avoid

1. Using FLOAT for salary or financial amounts when exact decimal values are needed.
2. Using VARCHAR when multilingual Unicode text must be preserved.
3. Choosing INT for a value that may exceed its range.
4. Using DATETIME when only a date is needed.
5. Assuming CHAR and VARCHAR behave the same way.
6. Forgetting that NULL is different from zero, an empty string or a blank space.

## 8. Important Interview Questions

**Q1. What is a data type in SQL?**

A data type defines what kind of value a column can store, such as numbers, text, dates or binary data.

**Q2. What is the difference between INT and BIGINT?**

INT uses 4 bytes, whereas BIGINT uses 8 bytes and supports a much larger range of integer values.

**Q3. What is the difference between DECIMAL and FLOAT?**

DECIMAL stores exact numeric values with defined precision and scale. FLOAT stores approximate numeric values.

**Q4. What is the difference between CHAR and VARCHAR?**

CHAR is fixed-length, whereas VARCHAR is variable-length.

**Q5. What is the difference between VARCHAR and NVARCHAR?**

VARCHAR stores non-Unicode character data, while NVARCHAR supports Unicode character data.

**Q6. Which data type is suitable for salary?**

DECIMAL is generally suitable because it stores exact decimal values.

**Q7. What is the difference between DATE and DATETIME?**

DATE stores only the date, whereas DATETIME stores both date and time.

**Q8. What is DATETIME2?**

DATETIME2 is a SQL Server date and time data type that supports configurable fractional-second precision and a wider date range than DATETIME.

**Q9. What is BIT used for?**

BIT stores 0, 1 or NULL and is commonly used for Boolean-like columns such as IsActive.

**Q10. What is UNIQUEIDENTIFIER?**

It is a SQL Server data type used to store a GUID, a 128-bit globally unique identifier.

---

## Quick Revision

| Category | Data types |
|---|---|
| Integer | TINYINT, SMALLINT, INT, BIGINT |
| Exact numeric | DECIMAL, NUMERIC, MONEY |
| Approximate numeric | FLOAT, REAL |
| Character | CHAR, VARCHAR, NCHAR, NVARCHAR |
| Date and time | DATE, TIME, DATETIME, DATETIME2 |
| Other | BIT, UNIQUEIDENTIFIER, VARBINARY |