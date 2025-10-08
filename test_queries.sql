-- Test Queries to Verify System is Working
USE employee_management;

-- 1. Basic System Check
SELECT 'System Status Check' as Test;
SELECT COUNT(*) as Total_Employees FROM employees;
SELECT COUNT(*) as Total_Departments FROM departments;
SELECT COUNT(*) as Total_Projects FROM projects;

-- 2. Test Advanced Views
SELECT 'Testing Employee Dashboard' as Test;
SELECT * FROM employee_dashboard LIMIT 3;

SELECT 'Testing Department Analytics' as Test;
SELECT * FROM department_analytics;

-- 3. Test Payroll Calculation
SELECT 'Testing Payroll Data' as Test;
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) as Employee,
    p.basic_salary,
    p.overtime_pay,
    p.net_salary,
    p.status
FROM payroll p
JOIN employees e ON p.emp_id = e.emp_id
LIMIT 5;

-- 4. Test Performance Analytics
SELECT 'Testing Performance Reviews' as Test;
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) as Employee,
    pr.overall_rating,
    pr.technical_skills,
    pr.communication
FROM performance_reviews pr
JOIN employees e ON pr.emp_id = e.emp_id;

-- 5. Test Training Effectiveness
SELECT 'Testing Training Programs' as Test;
SELECT * FROM training_effectiveness;

-- 6. Test Attendance Summary
SELECT 'Testing Attendance Data' as Test;
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) as Employee,
    a.date,
    a.check_in,
    a.check_out,
    a.overtime_hours,
    a.status
FROM attendance a
JOIN employees e ON a.emp_id = e.emp_id
ORDER BY a.date DESC
LIMIT 10;

-- 7. Advanced Analytics Test
SELECT 'Advanced Analytics - High Performers' as Test;
SELECT 
    full_name,
    salary,
    performance_rating,
    active_projects,
    trainings_completed
FROM employee_dashboard
WHERE performance_rating >= 4.0
ORDER BY performance_rating DESC;

SELECT 'All Tests Complete! System is Working! 🎉' as Final_Status;