 -- 9th OCT 2026

-- IS OPERATOR ---->

-- display emp who are not earning the salary
SELECT * FROM EMP WHERE sal= NULL   -- wrong ans 
SELECT * FROM EMP WHERE sal IS NULL

-- who are earning the salary
SELECT * FROM EMP WHERE sal IS NOT NULL

-- job is null
SELECT * FROM EMP WHERE job IS NULL

-- job is not null
SELECT * FROM EMP WHERE job IS NOT NULL


-- ALIAS  ---> 

-- annual sal and ename of the emp
SELECT ename,sal*12 FROM EMP                 -- without name to the col
SELECT ename,sal*12 as annual sal FROM EMP   -- space is not allowed
SELECT ename,sal*12 as annualsal FROM EMP    -- with name to the column
SELECT ename,sal*12 as [annual sal] FROM EMP  -- of we give it in [] it will not check and it is correct ans

-- display ename,sal,hra,da,tax,total salary
-- HRA = house rent alowance = 20% on sal
-- DA = dearness allowance = 40% on sal
-- TAX = 10% on sal
-- Toat salary = sal + hra + da - tax              -- when there is no WHERE clause then it will execute for all rows in the table even for NULL 
SELECT ename, sal, sal*0.2 as HRA, sal*0.4 as DA, sal*0.1 as TAX, sal+(sal*0.2) + (sal*0.4) - (sal*0.1) as [Total Salary] FROM EMP


-- diaplay pname , actual price, discounted price
-- discount=10%              
SELECT pname , price, price-(price*0.1) as Price_after_Discount FROM product


-- ORDER BY Clause ---->

-- Arrange emp listbname wise ascending
SELECT * FROM EMP ORDER BY ename 
SELECT * FROM EMP ORDER BY ename ASC  -- gives the same o/p bcz ASC is by default in ORDER BY

-- arrange emp list sal wise desc order
SELECT * FROM EMP ORDER BY sal DESC 

-- arrange emp list based on hiredate and emp  who joined first then display first?
SELECT * FROM EMP ORDER BY hiredate 



-- 12th OCT 2026

CREATE TABLE EMP
(
EMPNO 	SMALLINT ,
ENAME 	VARCHAR(10),
JOB 	VARCHAR(9),
MGR	 NUMERIC(4),
HIREDATE DATE,
SAL 	MONEY,
COMM 	MONEY,
DEPTNO TINYINT
 )

INSERT INTO EMP VALUES
(7369, 'SMITH', 'CLERK', 7902, '1980-12-17', 800, NULL, 20)

INSERT INTO EMP VALUES
(7499, 'ALLEN', 'SALESMAN', 7698, '20-FEB-1981', 1600, 300, 30)

INSERT INTO EMP VALUES
(7521, 'WARD', 'SALESMAN', 7698, '22-FEB-1981', 1250, 500, 30)

INSERT INTO EMP VALUES
(7566, 'JONES', 'MANAGER', 7839, '2-APR-1981', 2975, NULL, 20)

INSERT INTO EMP VALUES
(7654, 'MARTIN', 'SALESMAN', 7698, '28-SEP-1981', 1250, 1400, 30)

INSERT INTO EMP VALUES
(7698, 'BLAKE', 'MANAGER', 7839, '1-MAY-1981', 2850, NULL, 30)

INSERT INTO EMP VALUES
(7782, 'CLARK', 'MANAGER', 7839, '9-JUN-1981', 2450, NULL, 10)

INSERT INTO EMP VALUES
(7788, 'SCOTT', 'ANALYST', 7566, '09-DEC-1982', 3000, NULL, 20)

INSERT INTO EMP VALUES
(7839, 'KING', 'PRESIDENT', NULL, '17-NOV-1981', 5000, NULL, 10)

INSERT INTO EMP VALUES
(7844, 'TURNER', 'SALESMAN', 7698, '8-SEP-1981', 1500, 0, 30)

INSERT INTO EMP VALUES
(7876, 'ADAMS', 'CLERK', 7788, '12-JAN-1983', 1100, NULL, 20)

INSERT INTO EMP VALUES
(7900, 'JAMES', 'CLERK', 7698, '3-DEC-1981', 950, NULL, 30)

INSERT INTO EMP VALUES
(7902, 'FORD', 'ANALYST', 7566, '3-DEC-1981', 3000, NULL, 20)

INSERT INTO EMP VALUES
(7934, 'MILLER', 'CLERK', 7782, '23-JAN-1982', 1300, NULL, 10)


SELECT * FROM EMP ORDER BY deptno ASC


SELECT empno,ename,sal,deptno FROM EMP ORDER BY deptno ASC

-- arrange emp list dept wise asc and with in dept sal wise desc?
SELECT empno, ename, sal, deptno FROM EMP ORDER BY deptno ASC, sal DESC

-- DISTINCT Clause


SELECT DISTINCT job FROM EMP

SELECT DISTINCT deptno FROM EMP


-- TOP clause


-- display 1st 5 rows from emp table
SELECT TOP 5 * FROM EMP 

-- DSPLAY top 5 highest paid emp
SELECT * FROM EMP ORDER BY sal DESC    -- SIMPLE
SELECT TOP 5 * FROM EMP ORDER BY sal DESC

-- top 3 max SALARY   -- APPLY distinct to remove duplicates
SELECT DISTINCT TOP 3 sal FROM EMP ORDER BY sal DESC

-- display top 3 Emp based on experience
SELECT * FROM EMP ORDER BY hiredate ASC
SELECT TOP 3 * FROM EMP ORDER BY hiredate ASC

-- DIAPLAY TOP 3 maxmum sal from 20th dept 
SELECT DISTINCT TOP 3 sal FROM EMP WHERE deptno=20 ORDER BY sal DESC
SELECT DISTINCT TOP 3 * FROM EMP WHERE deptno=20 ORDER BY sal DESC

