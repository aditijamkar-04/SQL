/* Level 3:

Question 1
A company wants to shortlist employees based on these conditions:
- Department must be IT or Finance.
- Salary must be between ₹40,000 and ₹60,000.
- Employee must not belong to HR.
Display:
1. EmployeeName
2. Department
3. Salary

Question 2
A company wants employees who:
- Earn more than ₹35,000.
- Do not belong to Finance.
- Have a salary that is NOT between ₹45,000 and ₹50,000.

uestion 3 (Final Advanced Challenge)
Display employees who satisfy either of these conditions:
1. Department is IT and salary is greater than ₹40,000.
2. Department is Finance and salary is exactly ₹40,000.

*/

-- 1
SELECT
    EmployeeName,
    Department,
    Salary
FROM Employees
WHERE Department IN ('IT', 'Finance')
  AND Salary BETWEEN 40000 AND 60000
  AND Department NOT IN ('HR');

-- 2
SELECT
    EmployeeName,
    Department,
    Salary
FROM Employees
WHERE Salary > 35000
  AND Department NOT IN ('Finance')
  AND Salary NOT BETWEEN 45000 AND 50000;

-- 3
SELECT *
FROM Employees
WHERE
    Department IN ('IT') AND Salary > 40000
    OR Department IN ('Finance') AND Salary = 40000;
