-- Advanced Triggers and Views
USE employee_management;

DELIMITER //

-- Trigger: Auto-calculate net salary in payroll
CREATE TRIGGER calculate_net_salary 
BEFORE INSERT ON payroll
FOR EACH ROW
BEGIN
    SET NEW.net_salary = NEW.basic_salary + NEW.overtime_pay + NEW.bonus - NEW.deductions - NEW.tax_deduction;
END //

-- Trigger: Update employee performance rating
CREATE TRIGGER update_performance_rating
AFTER INSERT ON performance_reviews
FOR EACH ROW
BEGIN
    UPDATE employees 
    SET performance_rating = NEW.overall_rating 
    WHERE emp_id = NEW.emp_id;
END //

-- Trigger: Audit log for employee changes
CREATE TRIGGER employee_audit_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, operation, record_id, new_values, changed_at)
    VALUES ('employees', 'INSERT', NEW.emp_id, JSON_OBJECT(
        'first_name', NEW.first_name,
        'last_name', NEW.last_name,
        'salary', NEW.salary,
        'dept_id', NEW.dept_id
    ), NOW());
END //

CREATE TRIGGER employee_audit_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, operation, record_id, old_values, new_values, changed_at)
    VALUES ('employees', 'UPDATE', NEW.emp_id, 
        JSON_OBJECT('salary', OLD.salary, 'dept_id', OLD.dept_id),
        JSON_OBJECT('salary', NEW.salary, 'dept_id', NEW.dept_id),
        NOW());
END //

DELIMITER ;

-- Advanced Views

-- Employee Dashboard View
CREATE VIEW employee_dashboard AS
SELECT 
    e.emp_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.email,
    e.salary,
    e.performance_rating,
    d.dept_name,
    COUNT(DISTINCT ep.project_id) AS active_projects,
    COUNT(DISTINCT et.training_id) AS trainings_completed,
    COALESCE(AVG(pr.overall_rating), 0) AS avg_performance
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
LEFT JOIN employee_projects ep ON e.emp_id = ep.emp_id
LEFT JOIN employee_training et ON e.emp_id = et.emp_id AND et.status = 'Completed'
LEFT JOIN performance_reviews pr ON e.emp_id = pr.emp_id
WHERE e.status = 'Active'
GROUP BY e.emp_id;

-- Department Analytics View
CREATE VIEW department_analytics AS
SELECT 
    d.dept_name,
    COUNT(e.emp_id) AS total_employees,
    AVG(e.salary) AS avg_salary,
    SUM(e.salary) AS total_salary_cost,
    AVG(e.performance_rating) AS avg_performance,
    COUNT(CASE WHEN e.status = 'Active' THEN 1 END) AS active_employees
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

-- Monthly Attendance Summary
CREATE VIEW monthly_attendance AS
SELECT 
    YEAR(a.date) AS year,
    MONTH(a.date) AS month,
    e.dept_id,
    d.dept_name,
    COUNT(CASE WHEN a.status = 'Present' THEN 1 END) AS present_days,
    COUNT(CASE WHEN a.status = 'Absent' THEN 1 END) AS absent_days,
    COUNT(CASE WHEN a.status = 'Late' THEN 1 END) AS late_days,
    ROUND(AVG(CASE WHEN a.status = 'Present' THEN 
        TIMESTAMPDIFF(MINUTE, a.check_in, a.check_out) / 60.0 END), 2) AS avg_hours_worked
FROM attendance a
JOIN employees e ON a.emp_id = e.emp_id
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY YEAR(a.date), MONTH(a.date), e.dept_id, d.dept_name;

-- Project Performance View
CREATE VIEW project_performance AS
SELECT 
    p.project_name,
    p.status,
    p.budget,
    COUNT(ep.emp_id) AS team_size,
    AVG(e.performance_rating) AS team_avg_performance,
    DATEDIFF(COALESCE(p.end_date, CURRENT_DATE), p.start_date) AS project_duration_days
FROM projects p
LEFT JOIN employee_projects ep ON p.project_id = ep.project_id
LEFT JOIN employees e ON ep.emp_id = e.emp_id
GROUP BY p.project_id;

-- Training Effectiveness View
CREATE VIEW training_effectiveness AS
SELECT 
    tp.program_name,
    COUNT(et.emp_id) AS total_participants,
    COUNT(CASE WHEN et.status = 'Completed' THEN 1 END) AS completed,
    AVG(et.score) AS avg_score,
    tp.cost,
    ROUND(tp.cost / COUNT(et.emp_id), 2) AS cost_per_participant
FROM training_programs tp
LEFT JOIN employee_training et ON tp.training_id = et.training_id
GROUP BY tp.training_id;