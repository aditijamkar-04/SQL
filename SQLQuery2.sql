-- 8th OCT 2026

-- Creating a student table 
CREATE TABLE Student
(
sno INT,
sname VARCHAR(10),
s1 INT,
s2 INT,
s3 INT
)

INSERT INTO Student VALUES(1,'A',88,90,70),(2,'B',30,60,50),(3,'C',60,20,30),(4,'D',10,20,30)

SELECT * FROM Student;

-- list of student who passed in all subject 
SELECT * FROM Student WHERE s1>=35 AND s2>=35 AND s3>=35;

-- list of student who failed in any subject
SELECT * FROM Student WHERE s1<35 OR s2<35 OR s3<35;

-- list of student who failed in exactly 1 subject 
SELECT * FROM Student WHERE (s1<35 AND s2>=35 AND s3>=35) OR (s1>=35 AND s2<35 AND s3>=35) OR (s1>=35 AND s2>=35 AND s3<35);

-- list of student who failed in only 2 subject 
SELECT * FROM Student WHERE (s1<35 AND s2<35 AND s3>=35) OR (s1>=35 AND s2<35 AND s3<35) OR (s1<35 AND s2>=35 AND s3<35);

-- list of student who failed in all 3 subject 
SELECT * FROM Student WHERE s1<35 AND s2<35 AND s3<35;




-- IN OPERATOR -->
-- display the emp whose id = 100,103,105
SELECT * FROM EMP WHERE empid IN (100,103,105);

-- display the emp whose job is clerk,manager
SELECT * FROM  EMP WHERE job IN ('clerk','manager');

-- display the emp whose job is not clerk,manager
SELECT * FROM  EMP WHERE job NOT IN ('clerk','manager');



-- BETWEEN OPERATOR ---->

-- emp whose earning is between 5000  and 10000
SELECT * FROM  EMP WHERE sal BETWEEN 5000 AND 10000;

-- emp joined in 2020
SELECT * FROM  EMP WHERE hiredate BETWEEN '2020-01-01' AND '2020-12-31';

-- emp not joined in 2020
SELECT * FROM  EMP WHERE hiredate NOT BETWEEN '2020-01-01' AND '2020-12-31';

-- emp working as clerk, manager and earning between 5000 and 10000 not joined in 2020 AND NOT working for hr,it
SELECT * FROM  EMP WHERE job IN ('clerk','manager') AND
sal BETWEEN 5000 AND 10000
AND hiredate NOT BETWEEN '2020-01-01' AND '2020-12-31'
AND dept NOT IN ('hr','it');



-- 8th OCT 2026

CREATE TABLE product
(
pid SMALLINT,
pname VARCHAR(10),
price SMALLMONEY,
category VARCHAR(10),
brand VARCHAR(10)
)


SELECT * FROM product WHERE brand IN ('samsung','redmi','realme')
AND price BETWEEN 10000 AND 20000
AND category ='mobiles'


CREATE TABLE customer
(
cid SMALLINT,
cname VARCHAR(10),
gender VARCHAR(10),
city VARCHAR(10),
age INT
)

SELECT * FROM customer WHERE gender='male'
AND city IN ('hyd','blr','mum')
AND age BETWEEN 20 and 40



-- LIKE ----->

-- emp name starts with 's'
SELECT * FROM EMP WHERE ename LIKE 's%'

-- emp name ends with 'd'
SELECT * FROM EMP WHERE ename LIKE '%d'

-- emp name contains 'a'
SELECT * FROM EMP WHERE ename LIKE '%a%'

-- emp name not starts with 's'
SELECT * FROM EMP WHERE ename NOT LIKE 'a%'

-- emp name not contains 'a'
SELECT * FROM EMP WHERE ename NOT LIKE '%a%'

-- when 'a' is the 4th char in their name
SELECT * FROM EMP WHERE ename LIKE '___a%'

-- when ;a' is the 4th char in their name from last
SELECT * FROM EMP WHERE ename LIKE '%a___'



--9th OCT 2026
-- name starts with a,d,k,s?
SELECT * FROM EMP WHERE ename LIKE 'a%' OR ename LIKE 'd%' OR ename LIKE 'k%'OR ename LIKE 's%'
SELECT * FROM EMP WHERE ename LIKE '[adks]%' 

-- name starts between a and p
SELECT * FROM EMP WHERE ename LIKE '[a-p]%' 

-- name starts not between a and p
SELECT * FROM EMP WHERE ename NOT LIKE '[a-p]%' 

--emp earning 4 digit salary
SELECT * FROM EMP WHERE sal LIKE '____.00' 

--emp earning 5 digit salary
SELECT * FROM EMP WHERE sal LIKE '_____.00' 

-- emp joined in oct month
SELECT * FROM EMP WHERE hiredate LIKE '_____10___' 
SELECT * FROM EMP WHERE hiredate LIKE '%10%'    -- this is incorrect 10 is treated as anything in this not only month
SELECT * FROM EMP WHERE hiredate LIKE '%-10-%'   -- this is also consider as month 

-- emp joined in 2020
SELECT * FROM EMP WHERE hiredate LIKE '2020%' 
