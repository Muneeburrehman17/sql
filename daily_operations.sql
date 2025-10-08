-- DAILY OPERATIONS - Ready-to-Use Queries for HR Team

-- ========================================
-- MORNING ROUTINE (9 AM)
-- ========================================

-- 1. Check who's present today
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) as Employee,
    a.check_in,
    a.status,
    CASE 
        WHEN a.status = 'Present' AND a.check_in <= '09:00:00' THEN '✅ On Time'
        WHEN a.status = 'Present' AND a.check_in > '09:00:00' THEN '⚠️ Late'
        WHEN a.status = 'Absent' THEN '❌ Absent'
        ELSE '❓ Not Marked'
    END as Status_Icon
FROM employees e
LEFT JOIN attendance a ON e.emp_id = a.emp_id AND a.date = CURRENT_DATE
WHERE e.status = 'Active'
ORDER BY a.check_in;

-- 2. Check pending leave requests
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) as Employee,
    lr.leave_type,
    lr.start_date,
    lr.days_requested,
    lr.reason
FROM leave_requests lr
JOIN employees e ON lr.emp_id = e.emp_id
WHERE lr.status = 'Pending'
ORDER BY lr.start_date;

-- ========================================
-- WEEKLY REPORTS (Monday)
-- ========================================

-- 3. Weekly attendance summary
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) as Employee,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) as Present_Days,
    COUNT(CASE WHEN a.status = 'Late' THEN 1 END) as Late_Days,
    COUNT(CASE WHEN a.status = 'Absent' THEN 1 END) as Absent_Days,
    SUM(a.overtime_hours) as Total_Overtime
FROM employees e
LEFT JOIN attendance a ON e.emp_id = a.emp_id 
    AND a.date >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
WHERE e.status = 'Active'
GROUP BY e.emp_id
ORDER BY Present_Days DESC;

-- ========================================
-- MONTHLY TASKS (1st of Month)
-- ========================================

-- 4. Process payroll for previous month
-- CALL ProcessMonthlyPayroll(MONTH(DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)), YEAR(DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)));

-- 5. Monthly performance summary
SELECT 
    d.dept_name,
    COUNT(e.emp_id) as Total_Employees,
    ROUND(AVG(e.performance_rating), 2) as Avg_Performance,
    COUNT(CASE WHEN e.performance_rating >= 4.0 THEN 1 END) as High_Performers,
    COUNT(CASE WHEN e.performance_rating < 3.0 THEN 1 END) as Need_Improvement
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
WHERE e.status = 'Active'
GROUP BY d.dept_id, d.dept_name;

-- ========================================
-- QUICK ACTIONS
-- ========================================

-- 6. Add new employee (Template)
/*
CALL CompleteEmployeeOnboarding(
    'First_Name', 'Last_Name', 'email@company.com',
    '03001234567', 50000.00, 1, 1,
    'Complete Address', '1990-01-01',
    'Emergency Contact - 03009876543'
);
*/

-- 7. Update salary (Template)
/*
CALL UpdateSalary(employee_id, new_salary_amount);
*/

-- 8. Assign to project (Template)
/*
CALL AssignToProject(employee_id, project_id, 'Role_Name');
*/

-- ========================================
-- EMERGENCY QUERIES
-- ========================================

-- 9. Find employee by name/email
SELECT 
    emp_id,
    CONCAT(first_name, ' ', last_name) as Full_Name,
    email,
    phone,
    dept_id
FROM employees 
WHERE first_name LIKE '%search_name%' 
   OR last_name LIKE '%search_name%'
   OR email LIKE '%search_email%';

-- 10. Check employee details quickly
/*
CALL GetEmployeeDetails(employee_id);
*/

-- ========================================
-- END OF DAY ROUTINE (6 PM)
-- ========================================

-- 11. Mark attendance for employees who forgot to check out
UPDATE attendance 
SET check_out = '17:00:00', 
    status = 'Present'
WHERE date = CURRENT_DATE 
  AND check_in IS NOT NULL 
  AND check_out IS NULL;

-- 12. Daily summary report
SELECT 
    'Today Summary' as Report_Type,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) as Present_Count,
    COUNT(CASE WHEN a.status = 'Late' THEN 1 END) as Late_Count,
    COUNT(CASE WHEN a.status = 'Absent' THEN 1 END) as Absent_Count,
    ROUND(AVG(CASE WHEN a.status = 'Present' THEN 
        TIMESTAMPDIFF(MINUTE, a.check_in, COALESCE(a.check_out, '17:00:00')) / 60.0 END), 1) as Avg_Hours_Worked
FROM attendance a
WHERE a.date = CURRENT_DATE;