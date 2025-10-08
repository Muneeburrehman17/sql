-- Common Queries for Employee Management System
USE employee_management;

-- 1. Get all employees with their department information
SELECT 
    e.emp_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.email,
    e.salary,
    d.dept_name,
    d.location
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
ORDER BY e.last_name;

-- 2. Find employees earning more than average salary
SELECT 
    CONCAT(first_name, ' ', last_name) AS employee_name,
    salary,
    (SELECT AVG(salary) FROM employees) AS avg_salary
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

-- 3. Get department-wise employee count and total salary
SELECT 
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    SUM(e.salary) AS total_salary,
    AVG(e.salary) AS avg_salary
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY total_salary DESC;

-- 4. Find employees and their managers
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    d.dept_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
JOIN departments d ON e.dept_id = d.dept_id
ORDER BY d.dept_name, e.last_name;

-- 5. Get active projects with assigned employees
SELECT 
    p.project_name,
    p.status,
    p.budget,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    ep.role
FROM projects p
JOIN employee_projects ep ON p.project_id = ep.project_id
JOIN employees e ON ep.emp_id = e.emp_id
WHERE p.status = 'Active'
ORDER BY p.project_name, ep.role;

-- 6. Find employees not assigned to any project
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.email,
    d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN employee_projects ep ON e.emp_id = ep.emp_id
WHERE ep.emp_id IS NULL;

-- 7. Get project workload by employee
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    COUNT(ep.project_id) AS project_count,
    GROUP_CONCAT(p.project_name SEPARATOR ', ') AS projects
FROM employees e
JOIN employee_projects ep ON e.emp_id = ep.emp_id
JOIN projects p ON ep.project_id = p.project_id
GROUP BY e.emp_id, e.first_name, e.last_name
ORDER BY project_count DESC;

-- 8. Monthly hiring report
SELECT 
    YEAR(hire_date) AS hire_year,
    MONTH(hire_date) AS hire_month,
    COUNT(*) AS employees_hired
FROM employees
GROUP BY YEAR(hire_date), MONTH(hire_date)
ORDER BY hire_year DESC, hire_month DESC;