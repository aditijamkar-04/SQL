/* Level 2:

Question 1
Using the Employees table, display:
- EmployeeName
- Salary
- Bonus (15% of Salary)
- Total_Salary (Salary + Bonus)
Example: If Salary = ₹40,000, Bonus = ₹6,000 and Total Salary = ₹46,000.

Question 2
Display:
- EmployeeName
- Salary
- Monthly_Deduction (5% of Salary)
- Final_Salary (Salary − Monthly_Deduction)
Example: Salary = ₹50,000 → Deduction = ₹2,500 → Final Salary = ₹47,500.
*/

-- 1
SELECT EmployeeName, Salary,
       ((Salary * 15) / 100) AS Bonus,
       (Salary + ((Salary * 15) / 100)) AS Total_Salary
FROM Employees;

-- 2
SELECT EmployeeName, Salary,
       ((Salary * 5) / 100) AS Monthly_Deduction,
       (Salary - ((Salary * 5) / 100)) AS Final_Salary
FROM Employees;
