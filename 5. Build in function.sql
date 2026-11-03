-- 15th OCT 2026

SELECT * FROM EMPLOYEES

-- BUILD IN FUNCTION IN SQL
-- CHARACTER function
--upper and lower case --->
SELECT UPPER('hello')
SELECT LOWER('hello')

-- display empno, ename , sal but dispaly names in lowercase
SELECT empno,LOWER(ename) as ename,sal FROM emp   -- o/p u want to change

-- convert name  to lowercase in table
UPDATE EMP SET ename=LOWER(ename)    -- in table u want to change

-- LEN()
SELECT LEN('hello welcome')

-- display emp name and name length 
SELECT ename,LEN(ename) as len FROM emp 

-- display emp name contains 5 char
SELECT * FROM emp WHERE ename LIKE '_____'
SELECT * FROM emp WHERE LEN(ename)=5

-- LEFT() AND RIGHT()
SELECT LEFT('HELLO WELCOME',5)      -- HELLO
SELECT RIGHT('HELLO WELCOME',7)     -- WELCOME

-- EMP NAME starts and ends with same char
SELECT * FROM emp WHERE LEFT(ename,1)=RIGHT(ename,1)


-- 16TH OCT 2026
-- generate the email id for emp
SELECT empno,ename,
LEFT(ename,3)+LEFT(empno,3)+'@tcs.com' as emailid
FROM EMP1

-- STORED EMAILID in database
-- ADD emailid cols to emp table
ALTER TABLE EMP1 ADD emailid VARCHAR(20)
SELECT * FROM EMP1

-- update the emailid with cols
UPDATE EMP1 SET emailid=LEFT(empno,3)+'@tcs.com'


--SUBSTRING FUNC
SELECT SUBSTRING('HELLO WELCOME',7,4)     --> WELC
SELECT SUBSTRING('HELLO WELCOME',10,3)    --> COM
SELECT SUBSTRING('HELLO WELCOME',7)       --> WELCOME

-- CHARINDEX FUNC
-- return position of char
SELECT CHARINDEX('O','HELLO WELCOME')    --> 5
SELECT CHARINDEX(' ','HELLO WELCOME')    --> 6
SELECT CHARINDEX('O','HELLO WELCOME',6)  --> 11
SELECT CHARINDEX(' ','HELLO WELCOME',6)  --> 0 


--
CREATE TABLE CUSTOMER(
CUSTID INT,
CNAME VARCHAR(50)
)

INSERT INTO CUSTOMER VALUES (101, 'Sachin ramesh tendulkar');
INSERT INTO CUSTOMER VALUES (102, 'mahendra singh dhoni');

select * from customer

-- IF WE WANTS TO divide the name into 2 parts 1st name and last name
-- FNAME=SUBSTRING(cname,1,CHARINDEX('',cname)-1)
-- LNAME=SUBSTRING(cname,CHARINDEX('',cname)+1)
SELECT custid
	SUBSTRING(CNAME,1,CHARINDEX('',cname)-1) as Fname
	SUBSTRING(CNAME,(CHARINDEX('',cname)-1)+(CHARINDEX('',cname)+1)) as Mname
	SUBSTRING(cname,CHARINDEX('',cname)+1) as Lname
FROM CUSTOMER

-- REPLICATE FUNC
SELECT REPLICATE('*',10)

SELECT * FROM EMP1
-- DONT show actual salary show xxxx
SELECT ename,REPLICATE('X',LEN(sal)-3) as SAL FROM EMP1

-- if accno= 12346774   ---> xxxx6774
SELECT REPLICATE('X',4)+RIGHT(accno,4)

-- REPLACE() FUNC
SELECT REPLACE('HELLO','ELL','ABC') --> HABCO
SELECT REPLACE('HELLO','L','ABC')   ---HEABCABCO 
SELECT REPLACE('HELLO','ELO','ABC') ---> HELLO  --> bcz string of char is not found

-- REMOVE THE unwanted char
SELECT REPLACE('@@HE@@LL@@O@@','@','')  --> HELLO