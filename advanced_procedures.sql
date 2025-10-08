-- Ultra Advanced Stored Procedures
USE employee_management;

DELIMITER //

-- Advanced Employee Onboarding
CREATE PROCEDURE CompleteEmployeeOnboarding(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15),
    IN p_salary DECIMAL(10,2),
    IN p_dept_id INT,
    IN p_manager_id INT,
    IN p_address TEXT,
    IN p_dob DATE,
    IN p_emergency_contact VARCHAR(100)
)
BEGIN
    DECLARE new_emp_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO employees (first_name, last_name, email, phone, hire_date, salary, 
                          dept_id, manager_id, address, date_of_birth, emergency_contact, status)
    VALUES (p_first_name, p_last_name, p_email, p_phone, CURRENT_DATE, p_salary, 
            p_dept_id, p_manager_id, p_address, p_dob, p_emergency_contact, 'Active');
    
    SET new_emp_id = LAST_INSERT_ID();
    
    -- Auto-assign to orientation training
    INSERT INTO employee_training (emp_id, training_id, status)
    SELECT new_emp_id, training_id, 'Enrolled'
    FROM training_programs 
    WHERE program_name LIKE '%Orientation%' 
    LIMIT 1;
    
    COMMIT;
    SELECT new_emp_id AS employee_id, 'Employee onboarded successfully' AS message;
END //

-- Advanced Payroll Processing
CREATE PROCEDURE ProcessMonthlyPayroll(
    IN p_month INT,
    IN p_year INT
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_emp_id INT;
    DECLARE v_basic_salary DECIMAL(10,2);
    DECLARE v_overtime_hours DECIMAL(4,2);
    DECLARE v_overtime_pay DECIMAL(10,2);
    DECLARE v_tax_rate DECIMAL(4,4) DEFAULT 0.15;
    
    DECLARE emp_cursor CURSOR FOR
        SELECT emp_id, salary FROM employees WHERE status = 'Active';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    START TRANSACTION;
    
    OPEN emp_cursor;
    
    payroll_loop: LOOP
        FETCH emp_cursor INTO v_emp_id, v_basic_salary;
        IF done THEN
            LEAVE payroll_loop;
        END IF;
        
        -- Calculate overtime
        SELECT COALESCE(SUM(overtime_hours), 0) INTO v_overtime_hours
        FROM attendance 
        WHERE emp_id = v_emp_id 
        AND MONTH(date) = p_month 
        AND YEAR(date) = p_year;
        
        SET v_overtime_pay = v_overtime_hours * (v_basic_salary / 160) * 1.5;
        
        INSERT INTO payroll (emp_id, pay_period_start, pay_period_end, basic_salary, 
                           overtime_pay, tax_deduction, status)
        VALUES (v_emp_id, 
                DATE(CONCAT(p_year, '-', p_month, '-01')),
                LAST_DAY(DATE(CONCAT(p_year, '-', p_month, '-01'))),
                v_basic_salary, v_overtime_pay, 
                (v_basic_salary + v_overtime_pay) * v_tax_rate,
                'Processed');
    END LOOP;
    
    CLOSE emp_cursor;
    COMMIT;
    
    SELECT CONCAT('Payroll processed for ', ROW_COUNT(), ' employees') AS message;
END //

-- Performance Analytics
CREATE PROCEDURE GetPerformanceAnalytics(
    IN p_dept_id INT,
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT 
        CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
        AVG(pr.overall_rating) AS avg_rating,
        COUNT(pr.review_id) AS total_reviews,
        MAX(pr.overall_rating) AS best_rating,
        MIN(pr.overall_rating) AS lowest_rating,
        CASE 
            WHEN AVG(pr.overall_rating) >= 4.5 THEN 'Excellent'
            WHEN AVG(pr.overall_rating) >= 3.5 THEN 'Good'
            WHEN AVG(pr.overall_rating) >= 2.5 THEN 'Average'
            ELSE 'Needs Improvement'
        END AS performance_category
    FROM employees e
    LEFT JOIN performance_reviews pr ON e.emp_id = pr.emp_id
    WHERE (p_dept_id IS NULL OR e.dept_id = p_dept_id)
    AND pr.review_period_start >= p_start_date
    AND pr.review_period_end <= p_end_date
    GROUP BY e.emp_id, e.first_name, e.last_name
    ORDER BY avg_rating DESC;
END //

-- Automated Leave Approval
CREATE PROCEDURE ProcessLeaveRequest(
    IN p_leave_id INT,
    IN p_approver_id INT,
    IN p_decision ENUM('Approved', 'Rejected'),
    IN p_comments TEXT
)
BEGIN
    DECLARE v_emp_id INT;
    DECLARE v_leave_days INT;
    DECLARE v_leave_type VARCHAR(20);
    
    SELECT emp_id, days_requested, leave_type 
    INTO v_emp_id, v_leave_days, v_leave_type
    FROM leave_requests 
    WHERE leave_id = p_leave_id;
    
    UPDATE leave_requests 
    SET status = p_decision,
        approved_by = p_approver_id,
        approved_date = CURRENT_DATE,
        comments = p_comments
    WHERE leave_id = p_leave_id;
    
    IF p_decision = 'Approved' THEN
        -- Auto-create attendance records for leave period
        INSERT INTO attendance (emp_id, date, status)
        SELECT v_emp_id, 
               lr.start_date + INTERVAL (a.a + (10 * b.a) + (100 * c.a)) DAY,
               'Absent'
        FROM leave_requests lr
        CROSS JOIN (SELECT 0 AS a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) AS a
        CROSS JOIN (SELECT 0 AS a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) AS b
        CROSS JOIN (SELECT 0 AS a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) AS c
        WHERE lr.leave_id = p_leave_id
        AND lr.start_date + INTERVAL (a.a + (10 * b.a) + (100 * c.a)) DAY <= lr.end_date;
    END IF;
    
    SELECT CONCAT('Leave request ', p_decision, ' successfully') AS message;
END //

-- Training ROI Calculator
CREATE PROCEDURE CalculateTrainingROI(IN p_training_id INT)
BEGIN
    SELECT 
        tp.program_name,
        tp.cost AS total_cost,
        COUNT(et.emp_id) AS participants,
        AVG(et.score) AS avg_score,
        tp.cost / COUNT(et.emp_id) AS cost_per_participant,
        CASE 
            WHEN AVG(et.score) >= 85 THEN 'High ROI'
            WHEN AVG(et.score) >= 70 THEN 'Medium ROI'
            ELSE 'Low ROI'
        END AS roi_category,
        COUNT(CASE WHEN et.status = 'Completed' THEN 1 END) / COUNT(et.emp_id) * 100 AS completion_rate
    FROM training_programs tp
    LEFT JOIN employee_training et ON tp.training_id = et.training_id
    WHERE tp.training_id = p_training_id
    GROUP BY tp.training_id;
END //

DELIMITER ;