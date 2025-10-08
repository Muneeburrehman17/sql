-- Ultra Advanced Employee Management System
USE employee_management;

-- Add advanced columns to existing tables
ALTER TABLE employees 
ADD COLUMN status ENUM('Active', 'Inactive', 'Terminated', 'On Leave') DEFAULT 'Active',
ADD COLUMN performance_rating DECIMAL(3,2) DEFAULT 0.00,
ADD COLUMN last_promotion_date DATE,
ADD COLUMN emergency_contact VARCHAR(100),
ADD COLUMN address TEXT,
ADD COLUMN date_of_birth DATE,
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Create Attendance Table
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT NOT NULL,
    date DATE NOT NULL,
    check_in TIME,
    check_out TIME,
    break_duration INT DEFAULT 0,
    overtime_hours DECIMAL(4,2) DEFAULT 0.00,
    status ENUM('Present', 'Absent', 'Late', 'Half Day') DEFAULT 'Present',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    UNIQUE KEY unique_emp_date (emp_id, date)
);

-- Create Payroll Table
CREATE TABLE payroll (
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT NOT NULL,
    pay_period_start DATE NOT NULL,
    pay_period_end DATE NOT NULL,
    basic_salary DECIMAL(10,2) NOT NULL,
    overtime_pay DECIMAL(10,2) DEFAULT 0.00,
    bonus DECIMAL(10,2) DEFAULT 0.00,
    deductions DECIMAL(10,2) DEFAULT 0.00,
    tax_deduction DECIMAL(10,2) DEFAULT 0.00,
    net_salary DECIMAL(10,2) NOT NULL,
    payment_date DATE,
    status ENUM('Pending', 'Processed', 'Paid') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- Create Leave Management Table
CREATE TABLE leave_requests (
    leave_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT NOT NULL,
    leave_type ENUM('Annual', 'Sick', 'Maternity', 'Emergency', 'Unpaid') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    days_requested INT NOT NULL,
    reason TEXT,
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    approved_by INT,
    approved_date DATE,
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (approved_by) REFERENCES employees(emp_id)
);

-- Create Performance Reviews Table
CREATE TABLE performance_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT NOT NULL,
    reviewer_id INT NOT NULL,
    review_period_start DATE NOT NULL,
    review_period_end DATE NOT NULL,
    technical_skills DECIMAL(3,2) DEFAULT 0.00,
    communication DECIMAL(3,2) DEFAULT 0.00,
    teamwork DECIMAL(3,2) DEFAULT 0.00,
    leadership DECIMAL(3,2) DEFAULT 0.00,
    overall_rating DECIMAL(3,2) DEFAULT 0.00,
    goals_achieved TEXT,
    areas_improvement TEXT,
    comments TEXT,
    status ENUM('Draft', 'Submitted', 'Approved') DEFAULT 'Draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (reviewer_id) REFERENCES employees(emp_id)
);

-- Create Training Programs Table
CREATE TABLE training_programs (
    training_id INT PRIMARY KEY AUTO_INCREMENT,
    program_name VARCHAR(100) NOT NULL,
    description TEXT,
    duration_hours INT NOT NULL,
    cost DECIMAL(10,2) DEFAULT 0.00,
    trainer_name VARCHAR(100),
    max_participants INT DEFAULT 20,
    start_date DATE,
    end_date DATE,
    status ENUM('Planned', 'Active', 'Completed', 'Cancelled') DEFAULT 'Planned',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Employee Training Junction Table
CREATE TABLE employee_training (
    emp_id INT,
    training_id INT,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    completion_date DATE,
    score DECIMAL(5,2),
    status ENUM('Enrolled', 'In Progress', 'Completed', 'Failed') DEFAULT 'Enrolled',
    certificate_issued BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (emp_id, training_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (training_id) REFERENCES training_programs(training_id)
);

-- Create Audit Log Table
CREATE TABLE audit_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50) NOT NULL,
    operation ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    record_id INT NOT NULL,
    old_values JSON,
    new_values JSON,
    changed_by INT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (changed_by) REFERENCES employees(emp_id)
);

-- Create Indexes for Performance
CREATE INDEX idx_emp_dept ON employees(dept_id);
CREATE INDEX idx_emp_manager ON employees(manager_id);
CREATE INDEX idx_attendance_date ON attendance(date);
CREATE INDEX idx_payroll_period ON payroll(pay_period_start, pay_period_end);
CREATE INDEX idx_leave_dates ON leave_requests(start_date, end_date);
CREATE INDEX idx_performance_period ON performance_reviews(review_period_start, review_period_end);