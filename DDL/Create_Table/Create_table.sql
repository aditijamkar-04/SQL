-- 1. Creating EMP table 

CREATE TABLE EMP
(
    -- Employee ID
    empid SMALLINT,
    -- Job/Designation
    ename VARCHAR(10),
    -- Employee salary
    job VARCHAR(10),
    -- Employee salary
    sal SMALLMONEY,
    -- Date when employee joined
    hiredate DATE,
     -- Employee department
    dept VARCHAR(10)
);


-- 2. Creating Students Table

CREATE TABLE Student
(
sno INT,
sname VARCHAR(10),
sub1 INT,
sub2 INT,
sub3 INT
)


-- 3. Creating Product Table

CREATE TABLE product
(
pid SMALLINT,
pname VARCHAR(10),
price SMALLMONEY,
category VARCHAR(10),
brand VARCHAR(10)
)