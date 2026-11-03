-- 3rd NOV 2026

-- JOINS   ---->
-- TYPES OF JOINS
-- 1) inner join   ----> equi join, non equi join, self join
-- 2) outer join   ----> left outer , right outer, full outer
-- 3) cross join

--CREATE DEPT TABLE
CREATE TABLE DEPT
(
DEPTNO INT primary key,
DNAME VARCHAR(14),
LOC VARCHAR(13) 
)

INSERT INTO DEPT VALUES (10, 'ACCOUNTS', 'NEW YORK')
INSERT INTO DEPT VALUES (20, 'RESEARCH', 'DALLAS')
INSERT INTO DEPT VALUES (30, 'SALES', 'CHICAGO')
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON')


-- Equi Join --->

-- display  emp details with dept details?
SELECT empno,ename,sal,deptno,dname,loc     ---- Ambiguous column name deptno  error occurs when we select common field
FROM EMP1 INNER JOIN dept
ON emp1.deptno=dept.deptno  

SELECT empno,ename,sal,dname,loc             -- correct one
FROM EMP1 INNER JOIN dept
ON emp1.deptno=dept.deptno 

-- or we can use 
SELECT e.empno,e.ename,e.sal,d.deptno,d.dname,d.loc    -- ALias it will not give the ambiguity error and time consuming and faster execution
FROM EMP1 as e INNER JOIN dept as d
ON e.deptno=d.deptno 

-- display  emp details with the dept details working at new york loc?
SELECT empno,ename,sal,dname,loc   
FROM EMP1 INNER JOIN dept
ON emp1.deptno=dept.deptno 
WHERE loc='NEW YORK'

SELECT COUNT(*)                        -- 3    -- TO SEE THE COUNT
FROM EMP1 as e INNER JOIN dept as d
ON e.deptno=d.deptno                    /* JOIN CONDITION */
WHERE d.loc='NEW YORK'                  -- FILTER CONDITION

-- 