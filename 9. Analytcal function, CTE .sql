-- 27TH OCT 2026



-- ANALYTICAL / WINDOW FUNC  ---->
	-- 1) RANK & DENSE_RANK
	-- 2) ROW_NUMBER
	-- 3) LAG & LEAD
	-- 4) NTILE


-- RANK() & DENSE_RANK()  ---->
-- BOTH FUNCTION IS USED TO FIND THE RANK AND RANKING IS BASED ON ONE OR MORE COLUMNS  EXAMPLE SAL,EXPERIENCE , TOTAL MARKS ,..,ETC.

-- FIND the rank of the emp based on the sal and higher paid should be get the 1st rank?
SELECT empno,ename,sal,
	RANK() OVER (ORDER BY sal DESC) AS MK     -- IF RANK ARE 1,2,2,2,4,5,6,7,7,7,10,....
FROM EMP1

SELECT empno,ename,sal,
	DENSE_RANK() OVER (ORDER BY sal DESC) AS MK   -- IF RANK ARE 1,2,2,2,3,4,5,6,7,7,7,8,......
FROM EMP1


-- 28th OCT 2026

--Analytical functions
--RANK & DENSE RANK

--find ranks of the employees based on sal and highest paid should get 1st rank?
SELECT EMPNO,ENAME,SAL,
RANK()OVER(ORDER BY SAL DESC) as rnk FROM EMP1

SELECT EMPNO,ENAME,SAL,
DENSE_RANK()OVER(ORDER BY SAL DESC) as rnk FROM EMP1


--CTE- common table expression
--display top 5 employees based on salary?
WITH E
AS
(SELECT EMPNO,ENAME,SAL,
DENSE_RANK()OVER(ORDER BY SAL DESC) as rnk
FROM EMP1)
SELECT * FROM E WHERE rnk<=5

--display top 3 salary? no duplicates
WITH E
AS
(SELECT  sal,
DENSE_RANK()OVER(ORDER BY SAL DESC) as rnk
FROM EMP)
SELECT DISTINCT SAL FROM E WHERE rnk<=3 ORDER BY sal DESC

--display 5th salary
WITH E
AS
(SELECT  sal,
DENSE_RANK()OVER(ORDER BY SAL DESC) as rnk
FROM EMP1)
SELECT DISTINCT SAL FROM E WHERE rnk=5 ORDER BY sal DESC

--PARTITION BY Clause-
--display ranks of the employees with dept based on sal?
SELECT empno,ename,sal,deptno,
DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) as rnk 
FROM EMP1

--top 3 employees in each dept?
WITH E
AS
(SELECT empno,ename,sal,deptno,
DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) as rnk 
FROM EMP1)
SELECT * FROM E WHERE rnk<=3

--row number based on salary
SELECT empno, ename, sal,
ROW_NUMBER() OVER(ORDER BY sal DESC) as rno
FROM EMP1

-- row o according to table
SELECT empno, ename, sal,
ROW_NUMBER() OVER(ORDER BY empno ASC) as rno
FROM EMP1


-- 29TH OCT 2026

-- display 1st 5 rows
WITH E
AS(
SELECT empno, ename, sal,
ROW_NUMBER() OVER(ORDER BY sal ASC) as rno
FROM EMP1)
SELECT * FROM E WHERE rno <=5

-- 
WITH E
AS(
SELECT empno, ename, sal,
ROW_NUMBER() OVER(ORDER BY sal DESC) as rno
FROM EMP1)
SELECT * FROM E WHERE rno IN (5,10,15)

--
WITH E
AS(
SELECT empno, ename, sal,
ROW_NUMBER() OVER(ORDER BY sal ASC) as rno
FROM EMP1)
SELECT * FROM E WHERE rno BETWEEN 5 AND 10

-- even no. rows
WITH E
AS(
SELECT empno, ename, sal,
ROW_NUMBER() OVER(ORDER BY sal ASC) as rno
FROM EMP1)
SELECT * FROM E WHERE rno%2=0

-- odd no. rows
WITH E
AS(
SELECT empno, ename, sal,
ROW_NUMBER() OVER(ORDER BY sal ASC) as rno
FROM EMP1)
SELECT * FROM E WHERE rno%2=1


-- LAG() AND LEAD()  --->


-- LAG()  -->
-- EX 1:
SELECT empno,ename,sal,
	LAG(sal,1) OVER (ORDER BY empno ASC) AS prev_sal
FROM EMP1

-- EX 2:
CREATE TABLE population
(
year INT,
population NUMERIC
)

INSERT INTO population VALUES(2020,1328024498),
							  (2021,1402617695),
							  (2022,1425423212),
							  (2023,1438069596),
							  (2024,1450935791),
							  (2025,1470935791)

-- display year population growth
SELECT year,population,
	population-LAG(population,1) OVER (ORDER BY year ASC) as growth 
FROM population

-- display year population  growth pct(%)
-- pct = ((curr year population - prev year population )/(prev year population ))*100
WITH P
AS(
SELECT year,population as curr_year_pop,
	LAG(population,1) OVER (ORDER BY year ASC)as prev_year_pop
FROM population
)
SELECT year,curr_year_pop,prev_year_pop,
	curr_year_pop-prev_year_pop as growth,
	((curr_year_pop-prev_year_pop)/(prev_year_pop))*100 as pct
FROM P

-- ONLY 1 DECIMAL PLACE 
WITH P
AS(
SELECT year,population as curr_year_pop,
	LAG(population,1) OVER (ORDER BY year ASC)as prev_year_pop
FROM population
)
SELECT year,curr_year_pop,prev_year_pop,
	curr_year_pop-prev_year_pop as growth,
	((curr_year_pop-prev_year_pop)/(prev_year_pop))*100 as pct
FROM P


-- NTILE() --->
-- EX:
SELECT ename,sal,
	NTILE(3) OVER (ORDER BY sal DESC) AS bucket
FROM EMP1 


	






