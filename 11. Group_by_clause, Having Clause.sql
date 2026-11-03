-- 31ST OCT 2026
-- GROUP BY CLAUSE --->

-- Display dept wise total salary
SELECT SUM(sal)
FROM EMP1
GROUP BY deptno

-- JOB WISE SALARY
SELECT job,min(sal) as minsal,
           max(sal) as maxsal,
           sum(sal) as sumsal,
           avg(sal) as avgsal,
           COUNT(*) AS CNT
FROM EMP1
GROUP BY JOB

--display year wise  NO. OF EMP JOINED?
SELECT DATEPART(YY,hiredate)AS year, COUNT(*) AS CNT
FROM EMP1
GROUP BY DATEPART(YY,hiredate)

SELECT DATEPART(DW,hiredate)AS year, COUNT(*) AS CNT
FROM EMP1
GROUP BY DATEPART(DW,hiredate)    -- DAY WISE


-- 2nd NOV 2026


-- display dep wise total salary only for the dept =10,20?
SELECT deptno,SUM(sal) AS total
FROM EMP1
WHERE deptno IN (10,20)
GROUP BY deptno

-- dispaly dept having more than 3 emp
SELECT deptno COUNT(*)
FROM EMP1
WHERE COUNT(*) >3       -- sql server cannot calculate dept wise count before group by and it can calculate only after group by , 
                        -- so apply the condition count(*)>3 after group by using having clause
GROUP BY deptno         -- ERROR  -- aggregate func are not allowed in where clause

SELECT deptno, count(*) AS CNT
FROM EMP1
GROUP BY deptno
HAVING COUNT(*)>3

-- display the dept wise total salary only for the dept=10,20 and total sal>10000
SELECT deptno, SUM(sal) AS total
FROM EMP1
WHERE deptno IN (10,20)
GROUP BY deptno
HAVING SUM(sal)>10000

-- find the customer placed more than the 5 orders in last 6 months
-- ORDER TABLE ---> ordid   orddt   deldt   cid
SELECT cid, COUNT(*)
FROM orders
WHERE ORDDT BETWEEN DATEADD(MM,-6,GETDATE()) AND GETDATE()
GROUP BY cid
HAVING COUNT(*)>5

-- display southern states more than 5 cr aadhar cards 
SELECT state,COUNT(*)
FROM persons
WHERE state in ('AP','TG','TL','KA','KL')
GROUP BY state
HAVING COUNT(*) >50000000

-- dispaly dept wise and job wise total salary
SELECT deptno,job,SUM(sal) AS total
FROM EMP1
GROUP BY deptno,job
ORDER BY deptno ASC



-- 3rd NOV 2026

-- display year wise and with in year quarter wise no of employees joined 
SELECT DATEPART(YY,hiredate) AS year,
       DATEPART(QQ,hiredate) AS qrt,
       COUNT(*) AS cnt
FROM EMP1
GROUP BY DATEPART(YY,hiredate),DATEPART(QQ,hiredate)
ORDER BY year ASC
-- ORDER BY year,QRT ==> INVALID,  ORDER BY year ASC ==> VALID
--  column alias cannot be used in  group by because group by clause is executed 
--before select and column alias can be used in order by because order  by clause is executed after select.

-- in person table ---> aadheno   name    dob   addr    city  state
-- display state wise no. of persons
-- display gender wise no. of persons
-- display state and gender wise no. of persons
-- display age group wise no. of persons       0-20  21-40  41-60  >60