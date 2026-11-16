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


-- 4th nov 2026

-- Joining more than 2 tables
--Outer joins  ---->
-- Left outer join
SELECT e.ename,d.dname   
FROM EMP1 as e LEFT JOIN dept as d
ON e.deptno=d.deptno 

SELECT e.ename,d.dname          --- there is no diff bcz their is no unmatched record
FROM EMP1 as e INNER JOIN dept as d
ON e.deptno=d.deptno 

-- Right outer join
SELECT e.ename,d.dname   
FROM EMP1 as e RIGHT JOIN dept as d
ON e.deptno=d.deptno 


INSERT INTO EMP1 VALUES(abc,


-- 5th  NOV 2026


--  FULL OUTER JOIN :- 
 SELECT e.ename,d.dname
        FROM emp as e FULL JOIN dept as d
        ON e.deptno= d.deptno


-- displaying only unmatched rows
-- left side table
SELECT e.ename,d.dname   
FROM EMP1 as e LEFT JOIN dept as d
ON e.deptno=d.deptno
where d.dname is NULL

-- right side table
SELECT e.ename,d.dname   
FROM EMP1 as e RIGHT JOIN dept as d
ON e.deptno=d.deptno 
where e.ename is null

-- both tables
SELECT e.ename,d.dname   
FROM EMP1 as e FUll join dept as d
ON e.deptno=d.deptno 
where d.dname is NULL
AND                        -- both operation should be selected
e.ename is null

SELECT e.ename,d.dname   
FROM EMP1 as e FUll join dept as d
ON e.deptno=d.deptno 
where d.dname is NULL
OR                       -- only one selected
e.ename is null

-- SELF join

SELECT empno,ename,MGR FROM EMP1

-- DISPLAY ename,mgrname?
SELECT x.ename,y.ename as maanger
FROM EMP1 as x INNER JOIN EMP1 as y
ON x.mgr=y.empno
where y.ename='BLAKE'     -- display emp name reporting to blake

--display blake's manager name
SELECT x.ename,y.ename as maanger
FROM EMP1 as x INNER JOIN EMP1 as y
ON x.mgr=y.empno
where x.ename='BLAKE'

-- display emp sal earning more than their manager
SELECT x.ename,x.sal,y.ename as maanger, y.sal as mgrsal
FROM EMP1 as x INNER JOIN EMP1 as y
ON x.mgr=y.empno
where x.sal>= y.sal