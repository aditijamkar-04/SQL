-- Employee Directory - SQL practice dataset
-- Departments, employees, projects, and assignments for a small company, with a reporting line that points back at the employees table.
--
-- Free to use for any purpose, including commercially. No attribution required.
-- Browse, query, and re-download at https://sqlshed.com/practice-datasets/
--
-- 4 tables, 57 rows. Standard SQL: runs on
-- PostgreSQL, MySQL, SQLite, DuckDB, and SQL Server without edits.

DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- departments: One row per department.
CREATE TABLE departments (
  department_id INTEGER,
  department_name VARCHAR(255),
  location VARCHAR(255),
  annual_budget INTEGER
);

INSERT INTO departments (department_id, department_name, location, annual_budget) VALUES
  (1, 'Engineering', 'Austin', 2400000),
  (2, 'Sales', 'Chicago', 1350000),
  (3, 'Marketing', 'Austin', 780000),
  (4, 'Support', 'Remote', 540000),
  (5, 'Finance', 'Chicago', 610000);

-- employees: One row per employee. manager_id points back at employee_id in this same table, and the CEO has neither a manager nor a department.
CREATE TABLE employees (
  employee_id INTEGER,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  job_title VARCHAR(255),
  department_id INTEGER,
  manager_id INTEGER,
  hire_date DATE,
  salary INTEGER
);

INSERT INTO employees (employee_id, first_name, last_name, job_title, department_id, manager_id, hire_date, salary) VALUES
  (1, 'Dana', 'Whitfield', 'Chief Executive Officer', NULL, NULL, '2015-03-02', 265000),
  (2, 'Marcus', 'Bell', 'VP Engineering', 1, 1, '2016-07-11', 198000),
  (3, 'Priya', 'Raman', 'VP Sales', 2, 1, '2017-01-23', 186000),
  (4, 'Elena', 'Sokolov', 'Engineering Manager', 1, 2, '2018-05-14', 162000),
  (5, 'Tomas', 'Ferreira', 'Senior Engineer', 1, 4, '2019-02-04', 148000),
  (6, 'Wren', 'Okafor', 'Senior Engineer', 1, 4, '2019-09-16', 145000),
  (7, 'Ivan', 'Petrov', 'Engineer', 1, 4, '2021-03-08', 118000),
  (8, 'Nora', 'Lindqvist', 'Engineer', 1, 4, '2022-06-13', 112000),
  (9, 'Hugo', 'Marchetti', 'Junior Engineer', 1, 5, '2023-08-21', 92000),
  (10, 'Aisha', 'Bakr', 'Account Executive', 2, 3, '2018-11-05', 134000),
  (11, 'Colin', 'Doyle', 'Account Executive', 2, 3, '2020-04-27', 127000),
  (12, 'Sana', 'Qureshi', 'Sales Development Rep', 2, 10, '2022-09-12', 86000),
  (13, 'Felix', 'Braun', 'Marketing Manager', 3, 1, '2019-06-03', 141000),
  (14, 'Rosa', 'Delgado', 'Content Strategist', 3, 13, '2021-10-18', 98000),
  (15, 'Yuki', 'Tanaka', 'Support Lead', 4, 1, '2020-02-10', 109000),
  (16, 'Omar', 'Haddad', 'Support Specialist', 4, 15, '2022-01-24', 78000),
  (17, 'Greta', 'Nyman', 'Support Specialist', 4, 15, '2023-05-08', 74000),
  (18, 'Leo', 'Castellano', 'Financial Analyst', 5, 1, '2021-07-19', 105000);

-- projects: One row per project. Projects still running have a null end_date.
CREATE TABLE projects (
  project_id INTEGER,
  project_name VARCHAR(255),
  department_id INTEGER,
  start_date DATE,
  end_date DATE,
  status VARCHAR(255)
);

INSERT INTO projects (project_id, project_name, department_id, start_date, end_date, status) VALUES
  (1, 'Billing Rewrite', 1, '2023-01-09', '2023-11-30', 'completed'),
  (2, 'Mobile App v2', 1, '2023-06-01', NULL, 'active'),
  (3, 'Search Relevance', 1, '2024-01-15', NULL, 'active'),
  (4, 'Enterprise Pipeline', 2, '2023-03-20', '2024-02-29', 'completed'),
  (5, 'Partner Program', 2, '2024-02-05', NULL, 'active'),
  (6, 'Brand Refresh', 3, '2023-09-11', '2024-01-19', 'completed'),
  (7, 'Helpdesk Migration', 4, '2024-03-04', NULL, 'active'),
  (8, 'Cost Audit', 5, '2024-01-08', '2024-04-30', 'completed');

-- assignments: One row per employee on a project, so employees and projects join many-to-many through this table.
CREATE TABLE assignments (
  assignment_id INTEGER,
  employee_id INTEGER,
  project_id INTEGER,
  role VARCHAR(255),
  hours_logged INTEGER
);

INSERT INTO assignments (assignment_id, employee_id, project_id, role, hours_logged) VALUES
  (1, 2, 1, 'sponsor', 90),
  (2, 4, 1, 'lead', 320),
  (3, 5, 1, 'contributor', 480),
  (4, 7, 1, 'contributor', 410),
  (5, 8, 1, 'contributor', 150),
  (6, 4, 2, 'lead', 260),
  (7, 6, 2, 'contributor', 505),
  (8, 8, 2, 'contributor', 470),
  (9, 9, 2, 'contributor', 180),
  (10, 5, 3, 'lead', 240),
  (11, 6, 3, 'contributor', 215),
  (12, 7, 3, 'contributor', 190),
  (13, 9, 3, 'contributor', 95),
  (14, 3, 4, 'sponsor', 120),
  (15, 10, 4, 'lead', 390),
  (16, 11, 4, 'contributor', 355),
  (17, 10, 5, 'lead', 150),
  (18, 11, 5, 'contributor', 140),
  (19, 12, 5, 'contributor', 220),
  (20, 13, 6, 'lead', 280),
  (21, 14, 6, 'contributor', 410),
  (22, 15, 7, 'lead', 175),
  (23, 16, 7, 'contributor', 300),
  (24, 17, 7, 'contributor', 260),
  (25, 18, 8, 'lead', 210),
  (26, 13, 8, 'contributor', 60);
