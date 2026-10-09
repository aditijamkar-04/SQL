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












