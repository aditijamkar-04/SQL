--13th OCT 2026

-- Case Statement
-- Simple case
-- display ename job?
SELECT ename,
	CASE job
	WHEN 'clerk' THEN 'Worker'
	WHEN 'saleseman' THEN 'Executive'
	WHEN 'manager' THEN 'Boss'
	WHEN 'president' THEN 'Big Boss'
	ELSE 'Employee'
	END as job
FROM EMP1

-- display ename sal salrange?
-- salary range (salrange)
SELECT ename, sal
	CASE 
	WHEN sal>3000 THEN 'Hisal'
	WHEN sal<3000 THEN 'Losal'
	ELSE 'Avgsal'
	END as Salrange
FROM EMP1

--display SNO TOTAL AVG RESULT
SELECT SNO, 
s1+s2+s3 as total,
(s1+s2+s3)/3 as avg,
CASE 
WHEN s1>=35 AND s2>=35 AND s3>=35 THEN 'PASS'
ELSE 'FAIL'
END as result
FROM student



--DML commands
SET IMPLICIT_TRANSACTIONS ON

--update all employee commision with 500?
UPDATE EMP1 SET comm=500
ROLLBACK


--update employees comm with 500 whose comm=null?
UPDATE EMP1 SET comm=500 WHERE comm is NULL
ROLLBACK


--increment comm by 200 whose comm not equal to null?
UPDATE EMP1 SET comm=comm+200 WHERE comm IS NOT NULL
ROLLBACK

--increment sal by 20% and comm by 10% those working as salesman and joined in 1981 year?
UPDATE EMP1
SET sal=sal + (sal*0.2),comm=comm+(comm*0.1)
WHERE job='SALESMAN' 
AND
hiredate BETWEEN '1981-01-01' AND '1981-12-31'

--increment sal as follows?

UPDATE EMP1
SET sal=CASE job
	WHEN 'clerk' THEN sal+(sal*0.1)
	WHEN 'salesman' THEN sal+(sal*0.1)
	WHEN 'manager' THEN sal+(sal*0.1)
	ELSE sal+(sal*0.05)
	END


-- 14th OCT 2026
DROP TABLE CUSTOMER
-- write a query to standerdize the gender
CREATE TABLE CUSTOMER(
CUSTID INT,
CNAME VARCHAR(50),
GENDER VARCHAR(20)
)

INSERT INTO CUSTOMER VALUES (101, 'Rahul',   'M');
INSERT INTO CUSTOMER VALUES (102, 'Priya',   'F');
INSERT INTO CUSTOMER VALUES (103, 'Arun',    'MALE');
INSERT INTO CUSTOMER VALUES (104, 'Sneha',   'FEMALE');
INSERT INTO CUSTOMER VALUES (105, 'Kiran',   'BOY');
INSERT INTO CUSTOMER VALUES (106, 'Anjali',  'GIRL');
INSERT INTO CUSTOMER VALUES (107, 'Ramesh',  'MAN');
INSERT INTO CUSTOMER VALUES (108, 'Lakshmi', 'WOMAN');
INSERT INTO CUSTOMER VALUES (109, 'Vijay',   'Male');
INSERT INTO CUSTOMER VALUES (110, 'Pooja',   'Female');
INSERT INTO CUSTOMER VALUES (111, 'Suresh',  'm');
INSERT INTO CUSTOMER VALUES (112, 'Divya',   'f');
INSERT INTO CUSTOMER VALUES (113, 'Ravi',    'Man');
INSERT INTO CUSTOMER VALUES (114, 'Swathi',  'Woman');
INSERT INTO CUSTOMER VALUES (115, 'Ajay',    'MALE');
INSERT INTO CUSTOMER VALUES (116, 'Kavya',   'female');
INSERT INTO CUSTOMER VALUES (117, 'Naveen',  'Boy');
INSERT INTO CUSTOMER VALUES (118, 'Meena',   'Girl');
INSERT INTO CUSTOMER VALUES (119, 'Mahesh',  'M');
INSERT INTO CUSTOMER VALUES (120, 'Sravani', 'F');

UPDATE CUSTOMER
SET GENDER = CASE
	WHEN GENDER IN ('M%','m%','B%') THEN 'Male'
	



-- set implicite_transaction on
delete from emp
rollback
select * from emp


-- delete emp whose empno=7499.7521
DELETE FROM EMP WHERE empno in (7499,7521)

-- delete emp joined in 1981 4th quarter
DELETE FROM EMP WHERE hiredate BETWEEN '1981-10-01' and '1981-12-31'

-- DDL commands --->
rollback

SELECT * FROM emp

sp_help emp    --- table size, table structure 

-- Adding columns
-- ALTER TABLE

-- add column gender to emp table
ALTER TABLE emp 
 ADD gender CHAR(1)

-- after adding by default the new cols is filled with null values to insert data in to new cols update command
UPDATE emp SET gender ='M' WHERE empno = 7499
SELECT * FROM emp 


-- Droping the columns
-- drop column gender from emp
ALTER TABLE emp DROP COLUMN gender

-- modifying column
-- modify the column empno datatype to int 
ALTER TABLE emp
ALTER COLUMN empno INT

ALTER TABLE emp
ALTER COLUMN empno SMALLINT

ALTER TABLE emp              --  ERROR   -- existing values in empno column are out of range
ALTER COLUMN empno TINYINT   -- Tinyint range is 0 to 255 but the empno is value are 7499,7581,.. that's why it wont accept

ALTER TABLE emp
ALTER COLUMN comm SMALLMONEY
sp_help emp 

-- INCRESE Size of ename to 20ALTER TABLE emp
ALTER TABLE emp
ALTER COLUMN ename VARCHAR(20)

ALTER TABLE emp
ALTER COLUMN ename VARCHAR(5)     -- ERROR  -- varchar field is upto 6 to 8000 (some name containes more than 5 char)


-- DROP command
DROP TABLE EMP
SELECT * FROM EMP



-- 15th OCT 2026

-- TRUNCATE
TRUNCATE TABLE EMP

-- SP_RENAME
-- RENAME table emp to employees 
SP_RENAME 'EMP','EMPLOYEES'
SELECT * FROM EMP
SELECT * FROM EMPLOYEES

SP_RENAME 'EMPLOYEES.COMM','BONUS'   --- FOR CHANGING THE column name 


