-- 24TH OCT 2026


-- CONVERSION FUNCTIONS -->
-- 1) CAST
-- 2) CONVERT

-- CAST() --->
SELECT CAST(10.5 AS INT)   --> 10
SELECT CAST(GETDATE() AS DATE)   --->RETURNS ONLY THE DATE NOT THE TIME -- 2026-10-24

-- EMP JOINED TODAY
SELECT * FROM EMP1 WHERE hiredate= GETDATE()   -- IT WILL GIVE THE date and time
SELECT * FROM EMP1 WHERE hiredate= CAST(GETDATE() AS DATE)   --IT WILL GIVE THE DATE ONLY


-- DISPLAY smith earns 800
SELECT ename + 'EARNS'+sal FROM EMP1   -- Cannot convert a char value to money. The char value has incorrect syntax.
SELECT ename + 'EARNS'+CAST(sal AS VARCHAR) FROM EMP1   -- CORRECT ANSWER


--  26th OCT 2026

-- display emp joined on 1980-12-17 as clerk
SELECT ename + ' joined on ' + hiredate + 'as' + job FROM EMP1     ---- NOT CORRECT 
SELECT ename + ' joined on ' + CAST(hiredate AS VARCHAR) + ' as ' + job FROM EMP1    -- CORRECT ONE 

-- CONVERT()  --->
SELECT CONVERT(INT , 10.5)        -- 10
SELECT CONVERT(DATE,GETDATE())     ---- 2026-10-26

-- TO DISPLAY  DATE in diff formate must be converted to char type
SELECT CONVERT(VARCHAR,GETDATE(),101)     ---- 10/26/2026
SELECT CONVERT(VARCHAR,GETDATE(),102)      --- 2026.10.26
SELECT CONVERT(VARCHAR,GETDATE(),103)      ---- 26/10/2026
SELECT CONVERT(VARCHAR,GETDATE(),104)      --- 26.10.2026
SELECT CONVERT(VARCHAR,GETDATE(),105)       ---- 26-10-2026
SELECT CONVERT(VARCHAR,GETDATE(),106)     --- 26 Oct 2026
SELECT CONVERT(VARCHAR,GETDATE(),107)      --- Oct 26, 2026
SELECT CONVERT(VARCHAR,GETDATE(),108)       --- 08:01:59
SELECT CONVERT(VARCHAR,GETDATE(),109)     --- Oct 26 2026  8:02:13:740AM
SELECT CONVERT(VARCHAR,GETDATE(),110)       ---- 10-26-2026
SELECT CONVERT(VARCHAR,GETDATE(),111)      -- 2026/10/26
SELECT CONVERT(VARCHAR,GETDATE(),112)      --- 20261026
SELECT CONVERT(VARCHAR,GETDATE(),113)      --- 26 Oct 2026 08:03:14:777
SELECT CONVERT(VARCHAR,GETDATE(),114)       -- 08:03:30:573
SELECT CONVERT(VARCHAR,GETDATE(),115)     --- 080350
SELECT CONVERT(VARCHAR,GETDATE(),116)     -- 116 is not a valid style number when converting from datetime to a character string.


-- DISPLAY ename hiredate? dispaly hiredate in dd-mm-yyyy formate?
SELECT ename, CONVERT(VARCHAR,hiredate,105) AS hiredate FROM  EMP1

-- TRY_CAST() & TRY_CONVERT()  --->
SELECT CAST('ABC' AS MONEY)   -- Cannot convert a char value to money. The char value has incorrect syntax.
SELECT TRY_CAST('ABC' AS MONEY)    --- NULL

-- 
CREATE TABLE T1(AMOUNT VARCHAR(10))

INSERT INTO T1 VALUES('ABC'),('2000'),('XYZ'),('1000'),('KLM'),('3000')

-- CONVERT COLUMN DATATYPE TO MONEY
ALTER TABLE T1                        -- Cannot convert a char value to money. The char value has incorrect syntax.
	ALTER COLUMN AMOUNT MONEY

SELECT * FROM T1

-- SOLUTION -->
-- step 1: upadate t1 set amount=try_cast(amount as money)
UPDATE T1 SET AMOUNT=TRY_CAST(AMOUNT AS MONEY)
-- STEP 2:
ALTER TABLE T1
	ALTER COLUMN AMOUNT MONEY
	SP_HELP T1


-- SPECIAL FUNCTIONS --->
-- how the handle the NULL values
-- 1) ISNULL()                2) COALESCE()

-- ISNULL() -->
SELECT ISNULL(100,200)     -->100
SELECT ISNULL(NULL,200)     -->200

-- DISPLAY ename, sal, COMM , TOTALSAL?
SELECT ename,sal,comm, sal+comm AS totsal FROM EMP1
--SMITH	800.00	NULL	NULL
--ALLEN	1600.00	300.00	1900.00
SELECT ename,sal,comm, sal+ISNULL(comm, 0) AS totsal FROM EMP1
-- SMITH	800.00	NULL	800.00
-- ALLEN	1600.00	300.00	1900.00



-- 27th OCT 2026


-- DISPLAY ename,sal,comm,  if comm=NULL display n/a
SELECT ename,sal,ISNULL(comm,'N/A') as comm FROM EMP1       --- Cannot convert a char value to money. The char value has incorrect syntax.
SELECT ename,sal,ISNULL(CAST(comm AS VARCHAR),'N/A') as comm FROM EMP1

--display sno.sname,m,p,c,total?  if marks = null then display absent?
SELECT sno,sname,m,p,c,(m+p+c) AS Total FROM Student     -- correction needed




-- COALESCE() --->
SELECT COALESCE(NULL,100,NULL,200)   ---100
SELECT COALESCE(100,200,300,400)     --100

SELECT * FROM EMP1
SELECT empno,ename,COALESCE(mgr,comm) AS imp_emp FROM EMP1 




-- creating a table D
CREATE TABLE D(D VARCHAR(20))
INSERT INTO D VALUES('2026-10-27')
INSERT INTO D VALUES('10/27/2026')
INSERT INTO D VALUES('27-10-2026')
INSERT INTO D VALUES('27/10/2026')
INSERT INTO D VALUES('10-27-2026')

SELECT * FROM D

-- Standardize the dates 
-- how to convert this/other formate to sql server formate or in yyyy-mm-dd
SELECT COALESCE(
	TRY_CAST(D AS DATE),
	TRY_CONVERT(DATE,D,101),
	TRY_CONVERT(DATE,D,105),
	TRY_CONVERT(DATE,D,103),
	TRY_CONVERT(DATE,D,110)
	)
	FROM D

-- TO MAKE IT IN TABLE
UPDATE D
SET D=COALESCE(
				TRY_CAST(D AS DATE),
				TRY_CONVERT(DATE,D,101),
				TRY_CONVERT(DATE,D,105),
				TRY_CONVERT(DATE,D,103),
				TRY_CONVERT(DATE,D,110)
				)
SELECT * FROM D

-- change the column D datatype into DATE
-- changing the datatype in to 
ALTER TABLE D
	ALTER COLUMN D DATE


