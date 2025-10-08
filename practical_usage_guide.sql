-- PRACTICAL USAGE GUIDE - How to Use This System in Real Work

USE employee_management;

-- ========================================
-- 1. DAILY HR OPERATIONS
-- ========================================

-- Add New Employee (Real Example)
CALL CompleteEmployeeOnboarding(
    'Sara', 'Ahmed', 'sara.ahmed@company.com',
    '03001234567', 60000.00, 2, 1,
    'House 123, Model Town, Lahore', '1995-06-15',
    'Ali Ahmed - 03009876543'
);

-- Update Employee Salary (Promotion)
CALL UpdateSalary(1, 85000.00);

-- Assign Employee to New Project
CALL AssignToProject(1, 2, 'Senior Developer');

-- ========================================
-- 2. ATTENDANCE MANAGEMENT
-- ========================================

-- Mark Daily Attendance
INSERT INTO attendance (emp_id, date, check_in, check_out, overtime_hours, status) 
VALUES 
(1, CURRENT_DATE, '09:00:00', '18:30:00', 1.5, 'Present'),
(2, CURRENT_DATE, '09:15:00', '17:00:00', 0.0, 'Late'),
(3, CURRENT_DATE, NULL, NULL, 0.0, 'Absent');

-- Check Monthly Attendance Report
SELECT * FROM monthly_attendance 
WHERE year = YEAR(CURRENT_DATE) 
AND month = MONTH(CURRENT_DATE);

-- ========================================
-- 3. LEAVE MANAGEMENT
-- ========================================

-- Employee Applies for Leave
INSERT INTO leave_requests (emp_id, leave_type, start_date, end_date, days_requested, reason, status)
VALUES (2, 'Annual', '2024-03-15', '2024-03-20', 6, 'Family wedding', 'Pending');

-- Manager Approves/Rejects Leave
CALL ProcessLeaveRequest(1, 1, 'Approved', 'Approved for family event');

-- Check Pending Leave Requests
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) as Employee,
    lr.leave_type,
    lr.start_date,
    lr.end_date,
    lr.days_requested,
    lr.reason
FROM leave_requests lr
JOIN employees e ON lr.emp_id = e.emp_id
WHERE lr.status = 'Pending';

-- ========================================
-- 4. PAYROLL PROCESSING
-- ========================================

-- Process Monthly Payroll for All Employees
CALL ProcessMonthlyPayroll(MONTH(CURRENT_DATE), YEAR(CURRENT_DATE));

-- Check Payroll Summary
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) as Employee,
    p.basic_salary,
    p.overtime_pay,
    p.bonus,
    p.deductions,
    p.net_salary,
    p.status
FROM payroll p
JOIN employees e ON p.emp_id = e.emp_id
WHERE MONTH(p.pay_period_start) = MONTH(CURRENT_DATE);

-- ========================================
-- 5. PERFORMANCE MANAGEMENT
-- ========================================

-- Add Performance Review
INSERT INTO performance_reviews 
(emp_id, reviewer_id, review_period_start, review_period_end, 
 technical_skills, communication, teamwork, leadership, overall_rating, 
 goals_achieved, areas_improvement, status)
VALUES 
(2, 1, '2024-01-01', '2024-06-30', 
 4.2, 4.5, 4.3, 3.8, 4.2,
 'Completed HR automation project', 'Leadership development needed', 'Approved');

-- Get Performance Analytics
CALL GetPerformanceAnalytics(NULL, '2024-01-01', '2024-12-31');

-- ========================================
-- 6. TRAINING MANAGEMENT
-- ========================================

-- Enroll Employee in Training
INSERT INTO employee_training (emp_id, training_id, status)
VALUES (3, 2, 'Enrolled');

-- Mark Training Complete with Score
UPDATE employee_training 
SET completion_date = CURRENT_DATE, score = 88.5, status = 'Completed', certificate_issued = TRUE
WHERE emp_id = 3 AND training_id = 2;

-- Check Training ROI
CALL CalculateTrainingROI(1);

-- ========================================
-- 7. MANAGEMENT DASHBOARDS
-- ========================================

-- Executive Dashboard - Key Metrics
SELECT 
    COUNT(CASE WHEN status = 'Active' THEN 1 END) as Active_Employees,
    ROUND(AVG(salary), 0) as Average_Salary,
    ROUND(AVG(performance_rating), 2) as Average_Performance,
    COUNT(DISTINCT dept_id) as Total_Departments
FROM employees;

-- Department Performance Comparison
SELECT * FROM department_analytics
ORDER BY avg_performance DESC;

-- Employee Performance Dashboard
SELECT * FROM employee_dashboard
WHERE performance_rating >= 4.0
ORDER BY performance_rating DESC;

-- Project Status Overview
SELECT * FROM project_performance
ORDER BY team_avg_performance DESC;

-- ========================================
-- 8. HR ANALYTICS & REPORTS
-- ========================================

-- High Performers (Promotion Candidates)
SELECT 
    full_name,
    dept_name,
    salary,
    performance_rating,
    active_projects,
    trainings_completed
FROM employee_dashboard
WHERE performance_rating >= 4.5 
AND trainings_completed >= 2
ORDER BY performance_rating DESC;

-- Employees Needing Training
SELECT 
    full_name,
    dept_name,
    performance_rating,
    trainings_completed
FROM employee_dashboard
WHERE performance_rating < 3.5 
OR trainings_completed = 0;

-- Salary Analysis by Department
SELECT 
    dept_name,
    COUNT(*) as employees,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    AVG(salary) as avg_salary
FROM employee_dashboard
GROUP BY dept_name;

-- ========================================
-- 9. AUDIT & COMPLIANCE
-- ========================================

-- Check Recent Changes (Audit Trail)
SELECT 
    table_name,
    operation,
    record_id,
    new_values,
    changed_at
FROM audit_log
WHERE changed_at >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
ORDER BY changed_at DESC;

-- Compliance Check - Missing Performance Reviews
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) as Employee,
    e.hire_date,
    DATEDIFF(CURRENT_DATE, e.hire_date) as Days_Since_Hire
FROM employees e
LEFT JOIN performance_reviews pr ON e.emp_id = pr.emp_id
WHERE pr.emp_id IS NULL 
AND DATEDIFF(CURRENT_DATE, e.hire_date) > 180;

-- ========================================
-- 10. BUSINESS INTELLIGENCE QUERIES
-- ========================================

-- Attrition Risk Analysis
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) as Employee,
    e.performance_rating,
    COUNT(lr.leave_id) as Leave_Requests,
    AVG(a.overtime_hours) as Avg_Overtime,
    CASE 
        WHEN e.performance_rating < 3.0 AND COUNT(lr.leave_id) > 3 THEN 'High Risk'
        WHEN AVG(a.overtime_hours) > 10 THEN 'Burnout Risk'
        ELSE 'Low Risk'
    END as Attrition_Risk
FROM employees e
LEFT JOIN leave_requests lr ON e.emp_id = lr.emp_id
LEFT JOIN attendance a ON e.emp_id = a.emp_id
WHERE e.status = 'Active'
GROUP BY e.emp_id
ORDER BY Attrition_Risk DESC;

SELECT '✅ SYSTEM READY FOR REAL WORK! Use these queries for daily operations.' as Status;