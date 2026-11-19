/*Level 3 –

Question 1: Salary Increment with Performance Bonus

A company calculates employee compensation as follows:
- Basic salary = Current salary
- Increment = 12% of current salary
- Performance bonus = 8% of current salary
- Final salary = Basic salary + Increment + Performance bonus
Write a SQL query displaying:
1. EmployeeName
2. Salary
3. Increment_Amount
4. Bonus_Amount
5. Final_Salary


Questin 2: A company wants to calculate an employee's yearly salary after a 15% increment, then deduct ₹5,000 as an annual tax adjustment.

Display:
- EmployeeName
- Salary
- Annual_Salary (Salary × 12)
- Final_Annual_Salary (Annual Salary + 15% increment − ₹5,000)


Question 3 (Final Challenge)
An employee receives:
- 20% increment on monthly salary.
- 10% bonus on monthly salary.
- ₹2,000 monthly deduction.
Calculate the final monthly salary and final annual salary.

Display:
1. EmployeeName
2. Salary
3. Increment
4. Bonus
5. Final_Monthly_Salary
6. Final_Annual_Salary
*/

-- 1
SELECT
    EmployeeName,
    Salary,
    (Salary * 12.0 / 100) AS Increment_Amount,
    (Salary * 8.0 / 100) AS Bonus_Amount,
    (Salary + (Salary * 12.0 / 100) + (Salary * 8.0 / 100)) AS Final_Salary
FROM Employees;

-- 2
SELECT
    EmployeeName,
    Salary,
    (Salary * 12) AS Annual_Salary,
    (Salary * 12 + (Salary * 15.0 / 100) - 5000) AS Final_Annual_Salary
FROM Employees;

-- 3
SELECT
    EmployeeName,
    Salary,
    (Salary * 20.0 / 100) AS Increment,
    (Salary * 10.0 / 100) AS Bonus,
    (Salary + (Salary * 20.0 / 100) + (Salary * 10.0 / 100) - 2000) AS Final_Monthly_Salary,
    ((Salary + (Salary * 20.0 / 100) + (Salary * 10.0 / 100) - 2000) * 12) AS Final_Annual_Salary
FROM Employees;
