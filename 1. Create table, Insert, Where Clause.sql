-- 6th OCT 2026

DROP TABLE EMP;

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



-- 7th OCT 2026

-- WHERE clause ------>
SELECT * FROM EMP WHERE empid=103;

SELECT ename, job FROM EMP WHERE empid=103;
SELECT * FROM EMP WHERE ename= 'Vijay';
SELECT * FROM EMP WHERE sal>5000;
-- display employee joined after 2020
-- date is incomplatible with smallint --> so it gives the error
SELECT * FROM EMP WHERE hiredate>2020;
-- correct way
SELECT * FROM EMP WHERE hiredate>'2020-12-31';

-- display employee joined before 2020
SELECT * FROM EMP WHERE hiredate<'2020-01-01';

-- display employee not working as clerk
SELECT * FROM EMP WHERE job!='clerk';

-- in sql language and data is not case sensitive
SELECT * FROM EMP WHERE job<>'CLERK';

-- Compound condition ---->
-- display employee working as clerk,manager
SELECT * FROM EMP WHERE job='clerk' OR job='manager';

-- display employee whose id =100,104,105
SELECT * FROM EMP WHERE empid=100 OR empid=103 OR empid=105;

-- display employee who working for HR dept and earing more than 5000
SELECT * FROM EMP WHERE dept='HR' AND sal>5000;

-- display employee sales manager details
SELECT * FROM EMP WHERE dept='sales' AND job='manager';

-- display employees earning more than 6000 and less 10000
SELECT * FROM EMP WHERE sal>6000 AND sal<10000;

-- display employee who joined in 2020
SELECT * FROM EMP WHERE hiredate>'2020-01-01'AND hiredate<'2020-12-31';

-- display employee working as clerk , manager and earinning more than 5000
-- this query displays emp as clerk and earning less than 5000 bcz sal >5000 is applied only to manager but not to clerk 
-- bcz operator AND has more priority than OR  
SELECT * FROM EMP WHERE job='clerk' OR job='manager' AND sal>5000;
-- to over comes this group condition using ()
SELECT * FROM EMP WHERE (job='clerk' OR job='manager') AND sal>5000;









/*
This is a comment.
I can write multiple lines here.
SQL Server will ignore it.
*/

-- Shortcut in SSMS: Select the lines and press Ctrl + K, Ctrl + C to comment them.

