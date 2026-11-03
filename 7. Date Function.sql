-- 23rd OCT 2026

-- GAATEDATE() -->
SELECT GETDATE()

-- DATEPART()
SELECT DATEPART(YY,GETDATE())    -- year 
SELECT DATEPART(DD,GETDATE())    -- date
SELECT DATEPART(DW,GETDATE())    -- day of the week like friday is 6
SELECT DATEPART(DY,GETDATE())    -- day of the year 
SELECT DATEPART(HH,GETDATE())    -- hour
SELECT DATEPART(QQ,GETDATE())    -- quarter like octomber is 4th quarter
SELECT DATEPART(MM,GETDATE())    -- returns month
SELECT DATEPART(MI,GETDATE())    -- minutes
SELECT DATEPART(SS,GETDATE())    -- seconds


SELECT * FROM EMP1

-- EMP JOINED IN 1980,1983,1985
SELECT * FROM EMP1 WHERE DATEPART(YY,hiredate) IN(1980,1983,1985)

-- EMP JOINED IN LEAP YEAR (year%4==0)
SELECT * FROM EMP1 WHERE DATEPART(YY,hiredate)%4=0

-- emp joined in jan ,apr, deec months
SELECT * FROM EMP1 WHERE DATEPART(MM, hiredate) IN('jan','apr','dec')     -- it will give s the error
SELECT * FROM EMP1 WHERE DATEPART(MM, hiredate) IN(1,4,12)

-- emp joined in weekends
SELECT * FROM EMP1 WHERE DATEPART(DW, hiredate) IN(1,7)    -- 1 =sun and 7= sat
SELECT * ,DATEPART(DW, hiredate) as day FROM EMP1 WHERE DATEPART(DW, hiredate) IN(1,7)

-- emp joioned in week days
SELECT * FROM EMP1 WHERE DATEPART(DW, hiredate) NOT IN(1,7)

-- EMP joined in second qurter of 1981 year
SELECT * FROM EMP1 WHERE DATEPART(yy, hiredate)=1981 AND DATEPART(QQ, hiredate)=2


-- DATENAME() -->
-- THIS FUNC ALSO retrun the date like datepart

-- display ename and day
SELECT ename,DATENAME(DW, hiredate) AS day FROM EMP1

--  WRITE A QUERY TO dispaly on wich day india got independance
SELECT DATENAME(DW,'1947-08-15')


-- FORMAT()  -->
SELECT FORMAT(GETDATE(), 'dd-MM-yyyy')     -- date  (23-10-2026)
SELECT FORMAT(GETDATE(), 'dd-MM-yyyy hh:mm:ss')  -- date and time  (23-10-2026 08:27:05)
SELECT FORMAT(GETDATE(), 'dd-MMM-yyyy hh:mm:ss')   -- it will show the 1st 3 char of month like OCT   (23-Oct-2026 08:27:19)
SELECT FORMAT(GETDATE(), 'dd-MMMM-yyyy hh:mm:ss')  -- it will show the full name of the month (23-October-2026 08:27:30)
SELECT FORMAT(GETDATE(), 'dd-MM-yyyy dddd')    -- 23-10-2026 Friday

-- dispaly emp name and hiredate 
-- display hiredate in mm/dd/yyyy
SELECT ename, FORMAT(hiredate, 'MM/dd/yyyy') as hiredate FROM EMP1


INSERT INTO EMP1(empno,ename,sal,hiredate) VALUES(5555,'sachin',2000,getdate())
-- display emp joined today
SELECT * FROM EMP1 WHERE hiredate=GETDATE()   -- this query does not show any rows
SELECT * FROM EMP1 WHERE hiredate=FORMAT(GETDATE(),'yyyy-MM-dd')   -- it will work


-- 24th OCT 2026
-- DATEADD() -->
SELECT DATEADD(DD,10,GETDATE())   -- add 10 days   -- 2026-11-03 07:39:08.467
SELECT DATEADD(DD,-10,GETDATE())   -- subtract 10 days  -- 2026-10-14 07:40:20.697
SELECT DATEADD(YY,2,GETDATE())      -- add 2 year
SELECT DATEADD(MM,-6,GETDATE())

-- emp joined in last 6 months
SELECT * FROM EMP1 WHERE hiredate BETWEEN DATEADD(MM,-6,GETDATE()) AND GETDATE()
SELECT * FROM EMP1


-- display todays gold rate 
SELECT * FROM gold_rates WHERE dateid = FORMAT(GETDATE(),'yyyy-MM-dd')
-- display yesterdays gold rate 
SELECT * FROM gold_rates WHERE dateid = FORMAT(DATEADD(dd,-1.GETDATE()),'yyyy-MM-dd')
-- display LAST MONTHS SAME DAY gold rate 
SELECT * FROM gold_rates WHERE dateid = FORMAT(DATEADD(MM,-1.GETDATE()),'yyyy-MM-dd')
-- display LAST YEAR SAME DAY gold rate 
SELECT * FROM gold_rates WHERE dateid = FORMAT(DATEADD(yy,-1.GETDATE()),'yyyy-MM-dd')
-- display LAST 1 MONTHS gold rate 
SELECT * FROM gold_rates WHERE dateid BETWEEN DATEADD(MM,-1.GETDATE()) AND GETDATE()



-- DATEDIFF() -->
SELECT DATEDIFF(YY,'2025-10-24',GETDATE())   -- 1
SELECT DATEDIFF(MM,'2025-10-24',GETDATE())    -- 12
SELECT DATEDIFF(DD,'2025-10-24',GETDATE())    -- 365
SELECT DATEDIFF(DY,'2025-10-24',GETDATE())   -- 365


-- DISPLAY EMP NAME experience in years
SELECT ename, DATEDIFF(YY, hiredate,GETDATE()) as experience FROM EMP1


-- DISPLAY ename and experience m years and n months
-- years =months/12=40/12=3
SELECT 40/12   --- 3
SELECT 40/12.0  -- 3.3333..
-- MONTHS= months%12=40%12=4
SELECT ename, DATEDIFF(MM, hiredate,GETDATE())/12 as years,
			  DATEDIFF(MM, hiredate,GETDATE())%12 as months
FROM EMP1

-- 
SELECT ename, DATEDIFF(MM, hiredate,GETDATE())/12 as years,
			  DATEDIFF(MM, hiredate,GETDATE())%12 as months,
			  DATEDIFF(MM, hiredate,GETDATE())*5/18 as days
FROM EMP1


-- EOMONTH() -->
SELECT EOMONTH(GETDATE())    -- 2026-10-31
SELECT EOMONTH(GETDATE(),-1)  -- 2026-09-30
SELECT EOMONTH(GETDATE(),1)   -- 2026-11-30
SELECT EOMONTH(GETDATE(),3) AS DATE  -- 2027-01-31




