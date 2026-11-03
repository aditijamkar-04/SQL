-- 29TH OCT 2026

-- AGGREGATE FUNCTIONS ---->
-- MAX()   MIN()  SUM()   AVG()   COUNT()   COUNT(*)


-- 30th oct 2026

-- MAX() --->
SELECT MAX(sal) FROM EMP1             -- 5000.00    max sal
SELECT MAX(hiredate) FROM EMP1       -- 1983-01-12    recently join emp
SELECT MAX(ename) FROM EMP1          -- WARD

-- MIN() --->
SELECT MIN(SAL) FROM EMP1           -- 800.00
SELECT MIN(hiredate) FROM EMP1      -- 1980-12-17
SELECT MIN(ename) FROM EMP1         -- ADAMS


-- SUM()  -->
SELECT SUM(sal) FROM EMP1           -- 29025.00

-- ROUND THE TOTAL salary to the thousands
SELECT ROUND(1250,-1) FROM EMP1           -- -1 MEANS ROUNDED TO 10S
-- -2 MEANS 100S    AND -3 MEANS 1000S
SELECT ROUND(SUM(sal),-3) FROM EMP1           -- 29000.00

-- AFTER ROUNDNG display total 
SELECT FORMAT(5000,'C','en-in')           -- C= CRRENCY   en-in= india     en-us=usa    en-jp=japan
SELECT FORMAT(ROUND(SUM(sal),-3),'C','en-in') FROM EMP1      -- ₹ 29,000.00

-- AVG()  -->   TOTAL sal/no.of emp
SELECT AVG(sal) FROM EMP1      -- 2073.2142
SELECT SUM(SAL)/14 FROM EMP1   -- 2073.2142

-- DISPLAY avg sal of managers?
SELECT sal FROM EMP1 WHERE job='manager'
SELECT (2975.00+2850.00+2450.00)/3 FROM EMP1
SELECT AVG(sal) FROM EMP1 WHERE job='manager'     -- 2758.3333


-- 
SELECT SUM(ename) FROM EMP1
SELECT SUM(hiradate) FROM EMP1
-- same for avg

-- COUNT()  --->
SELECT COUNT(empno) FROM EMP1   -- 14
SELECT COUNT(comm) FROM EMP1    -- 4  NULL ARE NOT COUNTED
SELECT COUNT(deptno) FROM EMP1  -- 14

-- COUNT(*) ---->
SELECT COUNT(*) FROM EMP1   -- 14    -- ROWS IN THE TABLE

-- DISPLAY no of emp join in 1981 year
SELECT COUNT(*) FROM EMP1 WHERE hiredate=1981   -- Operand type clash: date is incompatible with smallint
SELECT COUNT(*) FROM EMP1 WHERE DATEPART(yy,hiredate)=1981   -- 10

-- NO of emp join on sunday
SELECT COUNT(*) FROM EMP1 WHERE DATEPART(dw,hiredate)=1   -- 1
SELECT COUNT(*) FROM EMP1 WHERE DATENAME(dw,hiredate)='sunday'   -- 1

-- DETails of the emp
SELECT * FROM EMP1 WHERE DATEPART(dw,hiredate)=1   -- 7521	WARD	SALESMAN	7698	1981-02-22	1250.00	500.00	30

-- display no of emp joined in 2nd quarter of 1981 year
SELECT COUNT(*) FROM EMP1 WHERE year=1981
	and 
	quarter=2   -- error    Invalid column name 'quarter'AND 'year'. 

SELECT COUNT(*) FROM EMP1 WHERE DATEPART(yy,hiredate)=1981
	and 
	DATEPART(qq,hiredate)=2    -- 3

-- DETAILS
SELECT * FROM EMP1 WHERE DATEPART(yy,hiredate)=1981
	and 
	DATEPART(qq,hiredate)=2 

 

-- GROUP BY() AND JOINS()   ---->

