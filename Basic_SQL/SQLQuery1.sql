
-- Create employee table
CREATE TABLE EMP
(
    -- Employee ID
    empid SMALLINT,
    -- Job/Designation
    ename VARCHAR(10),
    -- Employee salary
    job VARCHAR(10),
    -- Employee salary
    sal SMALLMONEY,
    -- Date when employee joined
    hiredate DATE,
     -- Employee department
    dept VARCHAR(10)
);


-- Insert first employee data  in single row 
INSERT INTO EMP
VALUES(100,'Sachin','clerk',4000,'2020-04-10','HR');


-- GETDATE() gives the current date
INSERT INTO EMP
VALUES(101,'Priya','analyst',9000,GETDATE(),'IT');


-- Insert multiple employees at the same time
INSERT INTO EMP
VALUES
(102,'Arvind','manager',8000,'2018-02-20','HR'),
(103,'David','clerk',6000,'2019-09-05','Sales');


-- Insert employee with NULL values for job and salary
INSERT INTO EMP
VALUES(104,'Vijay',NULL,NULL,'2021-05-12','IT');

INSERT INTO EMP VALUES(105,'Kumar','2022-03-18','Sales');


-- Insert employee by specifying column names
-- job and salary are not provided, so they will be NULL
INSERT INTO EMP (empid, ename, hiredate, dept)
VALUES(105,'Kumar','2022-03-18','Sales');


-- Display only employee name and job
SELECT ename, job
FROM EMP;

-- Display all columns and all rows from EMP
SELECT *
FROM EMP;

/*
This is a comment.
I can write multiple lines here.
SQL Server will ignore it.
*/

--Shortcut in SSMS: Select the lines and press Ctrl + K, Ctrl + C to comment them.
