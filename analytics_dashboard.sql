-- Ultra Advanced Analytics & Dashboard Queries
USE employee_management;

-- 1. Executive Dashboard - Key Metrics
SELECT 
    'Total Employees' as metric,
    COUNT(*) as value,
    'Active workforce' as description
FROM employees WHERE status = 'Active'

UNION ALL

SELECT 
    'Average Salary' as metric,
    ROUND(AVG(salary), 2) as value,
    'Company average' as description
FROM employees WHERE status = 'Active'

UNION ALL

SELECT 
    'Total Payroll Cost' as metric,
    SUM(net_salary) as value,
    'Monthly expense' as description
FROM payroll WHERE MONTH(pay_period_start) = MONTH(CURRENT_DATE)

UNION ALL

SELECT 
    'Average Performance' as metric,
    ROUND(AVG(performance_rating), 2) as value,
    'Company performance' as description
FROM employees WHERE status = 'Active' AND performance_rating > 0;

-- 2. Advanced Employee Analytics with Predictive Insights
SELECT 
    e.emp_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.dept_name,
    e.salary,
    e.performance_rating,
    DATEDIFF(CURRENT_DATE, e.hire_date) AS tenure_days,
    COUNT(DISTINCT ep.project_id) AS projects_count,
    COUNT(DISTINCT et.training_id) AS trainings_completed,
    AVG(a.overtime_hours) AS avg_monthly_overtime,
    CASE 
        WHEN e.performance_rating >= 4.5 AND DATEDIFF(CURRENT_DATE, e.hire_date) > 365 THEN 'Promotion Ready'
        WHEN e.performance_rating < 3.0 THEN 'Performance Improvement Needed'
        WHEN DATEDIFF(CURRENT_DATE, e.hire_date) > 1095 AND e.performance_rating >= 4.0 THEN 'Senior Level'
        ELSE 'Standard Performance'
    END AS career_status,
    CASE 
        WHEN AVG(a.overtime_hours) > 10 THEN 'High Workload'
        WHEN AVG(a.overtime_hours) BETWEEN 5 AND 10 THEN 'Moderate Workload'
        ELSE 'Normal Workload'
    END AS workload_status
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN employee_projects ep ON e.emp_id = ep.emp_id
LEFT JOIN employee_training et ON e.emp_id = et.emp_id AND et.status = 'Completed'
LEFT JOIN attendance a ON e.emp_id = a.emp_id AND a.date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
WHERE e.status = 'Active'
GROUP BY e.emp_id
ORDER BY e.performance_rating DESC, tenure_days DESC;

-- 3. Department Performance Matrix
SELECT 
    d.dept_name,
    COUNT(e.emp_id) AS headcount,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    ROUND(AVG(e.performance_rating), 2) AS avg_performance,
    SUM(p.net_salary) AS monthly_cost,
    COUNT(DISTINCT ep.project_id) AS active_projects,
    ROUND(AVG(DATEDIFF(CURRENT_DATE, e.hire_date) / 365), 1) AS avg_tenure_years,
    COUNT(CASE WHEN lr.status = 'Pending' THEN 1 END) AS pending_leaves,
    ROUND(
        COUNT(CASE WHEN a.status = 'Present' THEN 1 END) * 100.0 / 
        COUNT(a.attendance_id), 2
    ) AS attendance_rate,
    CASE 
        WHEN AVG(e.performance_rating) >= 4.0 AND 
             COUNT(CASE WHEN a.status = 'Present' THEN 1 END) * 100.0 / COUNT(a.attendance_id) >= 95 
        THEN 'Excellent'
        WHEN AVG(e.performance_rating) >= 3.5 THEN 'Good'
        WHEN AVG(e.performance_rating) >= 3.0 THEN 'Average'
        ELSE 'Needs Attention'
    END AS department_grade
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id AND e.status = 'Active'
LEFT JOIN payroll p ON e.emp_id = p.emp_id AND MONTH(p.pay_period_start) = MONTH(CURRENT_DATE)
LEFT JOIN employee_projects ep ON e.emp_id = ep.emp_id
LEFT JOIN leave_requests lr ON e.emp_id = lr.emp_id
LEFT JOIN attendance a ON e.emp_id = a.emp_id AND a.date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY d.dept_id, d.dept_name
ORDER BY avg_performance DESC, attendance_rate DESC;

-- 4. Project ROI and Resource Allocation Analysis
SELECT 
    p.project_name,
    p.status,
    p.budget,
    COUNT(ep.emp_id) AS team_size,
    ROUND(AVG(e.salary * COUNT(ep.emp_id) / 12), 2) AS estimated_monthly_cost,
    ROUND(p.budget / NULLIF(COUNT(ep.emp_id), 0), 2) AS budget_per_person,
    ROUND(AVG(e.performance_rating), 2) AS team_avg_performance,
    DATEDIFF(COALESCE(p.end_date, CURRENT_DATE), p.start_date) AS duration_days,
    CASE 
        WHEN p.status = 'Completed' AND AVG(e.performance_rating) >= 4.0 THEN 'High Success'
        WHEN p.status = 'Active' AND AVG(e.performance_rating) >= 4.0 THEN 'On Track'
        WHEN p.status = 'Active' AND AVG(e.performance_rating) < 3.5 THEN 'At Risk'
        ELSE 'Monitor'
    END AS project_health,
    GROUP_CONCAT(DISTINCT d.dept_name) AS departments_involved
FROM projects p
LEFT JOIN employee_projects ep ON p.project_id = ep.project_id
LEFT JOIN employees e ON ep.emp_id = e.emp_id
LEFT JOIN departments d ON e.dept_id = d.dept_id
GROUP BY p.project_id
ORDER BY team_avg_performance DESC, budget DESC;

-- 5. Training Effectiveness & Skills Gap Analysis
SELECT 
    tp.program_name,
    tp.cost,
    COUNT(et.emp_id) AS total_enrolled,
    COUNT(CASE WHEN et.status = 'Completed' THEN 1 END) AS completed,
    ROUND(COUNT(CASE WHEN et.status = 'Completed' THEN 1 END) * 100.0 / COUNT(et.emp_id), 2) AS completion_rate,
    ROUND(AVG(et.score), 2) AS avg_score,
    ROUND(tp.cost / NULLIF(COUNT(CASE WHEN et.status = 'Completed' THEN 1 END), 0), 2) AS cost_per_completion,
    COUNT(CASE WHEN et.certificate_issued = TRUE THEN 1 END) AS certificates_issued,
    CASE 
        WHEN AVG(et.score) >= 90 AND COUNT(CASE WHEN et.status = 'Completed' THEN 1 END) * 100.0 / COUNT(et.emp_id) >= 80 THEN 'Excellent ROI'
        WHEN AVG(et.score) >= 75 AND COUNT(CASE WHEN et.status = 'Completed' THEN 1 END) * 100.0 / COUNT(et.emp_id) >= 60 THEN 'Good ROI'
        WHEN AVG(et.score) >= 60 THEN 'Average ROI'
        ELSE 'Poor ROI'
    END AS training_effectiveness
FROM training_programs tp
LEFT JOIN employee_training et ON tp.training_id = et.training_id
GROUP BY tp.training_id
ORDER BY completion_rate DESC, avg_score DESC;

-- 6. Predictive Attrition Risk Analysis
SELECT 
    e.emp_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    d.dept_name,
    DATEDIFF(CURRENT_DATE, e.hire_date) AS tenure_days,
    e.performance_rating,
    COUNT(lr.leave_id) AS leave_requests_count,
    AVG(a.overtime_hours) AS avg_overtime,
    DATEDIFF(CURRENT_DATE, COALESCE(e.last_promotion_date, e.hire_date)) AS days_since_promotion,
    CASE 
        WHEN e.performance_rating < 3.0 AND COUNT(lr.leave_id) > 3 THEN 'High Risk'
        WHEN DATEDIFF(CURRENT_DATE, COALESCE(e.last_promotion_date, e.hire_date)) > 730 
             AND e.performance_rating >= 4.0 THEN 'Medium Risk - Promotion Due'
        WHEN AVG(a.overtime_hours) > 15 AND e.performance_rating < 3.5 THEN 'Medium Risk - Burnout'
        WHEN DATEDIFF(CURRENT_DATE, e.hire_date) BETWEEN 365 AND 730 
             AND e.performance_rating < 3.5 THEN 'Medium Risk - Early Career'
        ELSE 'Low Risk'
    END AS attrition_risk,
    CASE 
        WHEN e.performance_rating < 3.0 THEN 'Performance coaching, Skills development'
        WHEN DATEDIFF(CURRENT_DATE, COALESCE(e.last_promotion_date, e.hire_date)) > 730 
        THEN 'Consider promotion, Career development discussion'
        WHEN AVG(a.overtime_hours) > 15 THEN 'Workload redistribution, Work-life balance'
        ELSE 'Continue current engagement'
    END AS recommended_action
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN leave_requests lr ON e.emp_id = lr.emp_id AND lr.created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH)
LEFT JOIN attendance a ON e.emp_id = a.emp_id AND a.date >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH)
WHERE e.status = 'Active'
GROUP BY e.emp_id
ORDER BY 
    CASE 
        WHEN attrition_risk = 'High Risk' THEN 1
        WHEN attrition_risk LIKE 'Medium Risk%' THEN 2
        ELSE 3
    END,
    e.performance_rating DESC;