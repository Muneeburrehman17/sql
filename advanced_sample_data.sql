-- Advanced Sample Data
USE employee_management;

-- Insert Training Programs
INSERT INTO training_programs (program_name, description, duration_hours, cost, trainer_name, start_date, end_date, status) VALUES
('New Employee Orientation', 'Complete onboarding program for new hires', 16, 5000.00, 'Sarah Ahmed', '2024-01-15', '2024-01-16', 'Completed'),
('Advanced SQL Training', 'Database management and optimization', 40, 15000.00, 'Hassan Ali', '2024-02-01', '2024-02-05', 'Active'),
('Leadership Development', 'Management and leadership skills', 32, 20000.00, 'Fatima Khan', '2024-03-01', '2024-03-04', 'Planned'),
('Cybersecurity Awareness', 'Information security best practices', 8, 8000.00, 'Omar Sheikh', '2024-01-20', '2024-01-20', 'Completed'),
('Project Management Certification', 'PMP certification preparation', 60, 35000.00, 'Ayesha Malik', '2024-04-01', '2024-04-10', 'Planned');

-- Insert Employee Training Records
INSERT INTO employee_training (emp_id, training_id, completion_date, score, status, certificate_issued) VALUES
(1, 1, '2024-01-16', 92.5, 'Completed', TRUE),
(2, 1, '2024-01-16', 88.0, 'Completed', TRUE),
(3, 1, '2024-01-16', 95.0, 'Completed', TRUE),
(1, 2, '2024-02-05', 89.5, 'Completed', TRUE),
(3, 2, '2024-02-05', 94.0, 'Completed', TRUE),
(7, 2, NULL, NULL, 'In Progress', FALSE),
(4, 4, '2024-01-20', 87.0, 'Completed', TRUE),
(5, 4, '2024-01-20', 91.5, 'Completed', TRUE);

-- Insert Attendance Records (Last 30 days)
INSERT INTO attendance (emp_id, date, check_in, check_out, overtime_hours, status) VALUES
(1, '2024-01-01', '09:00:00', '18:30:00', 1.5, 'Present'),
(1, '2024-01-02', '09:15:00', '17:00:00', 0.0, 'Late'),
(1, '2024-01-03', '09:00:00', '17:00:00', 0.0, 'Present'),
(2, '2024-01-01', '09:00:00', '17:00:00', 0.0, 'Present'),
(2, '2024-01-02', NULL, NULL, 0.0, 'Absent'),
(2, '2024-01-03', '09:00:00', '17:00:00', 0.0, 'Present'),
(3, '2024-01-01', '08:45:00', '19:00:00', 2.0, 'Present'),
(3, '2024-01-02', '09:00:00', '18:00:00', 1.0, 'Present'),
(3, '2024-01-03', '09:00:00', '17:00:00', 0.0, 'Present');

-- Insert Leave Requests
INSERT INTO leave_requests (emp_id, leave_type, start_date, end_date, days_requested, reason, status, approved_by, approved_date) VALUES
(2, 'Annual', '2024-02-15', '2024-02-19', 5, 'Family vacation', 'Approved', 1, '2024-02-10'),
(4, 'Sick', '2024-01-25', '2024-01-26', 2, 'Flu symptoms', 'Approved', 1, '2024-01-24'),
(6, 'Annual', '2024-03-01', '2024-03-05', 5, 'Wedding ceremony', 'Pending', NULL, NULL),
(7, 'Emergency', '2024-01-30', '2024-01-30', 1, 'Family emergency', 'Approved', 3, '2024-01-29');

-- Insert Performance Reviews
INSERT INTO performance_reviews (emp_id, reviewer_id, review_period_start, review_period_end, technical_skills, communication, teamwork, leadership, overall_rating, goals_achieved, areas_improvement, status) VALUES
(2, 1, '2023-07-01', '2023-12-31', 4.2, 4.5, 4.3, 3.8, 4.2, 'Completed HR system implementation, Improved employee satisfaction by 15%', 'Leadership skills, Technical certifications', 'Approved'),
(3, 1, '2023-07-01', '2023-12-31', 4.8, 4.2, 4.5, 4.6, 4.5, 'Led 3 major projects, Mentored 2 junior developers', 'Time management, Documentation', 'Approved'),
(7, 3, '2023-07-01', '2023-12-31', 4.0, 3.8, 4.2, 3.5, 3.9, 'Delivered projects on time, Good code quality', 'Communication skills, Initiative taking', 'Approved'),
(4, 1, '2023-07-01', '2023-12-31', 4.3, 4.4, 4.1, 4.0, 4.2, 'Streamlined financial processes, Cost reduction of 10%', 'Advanced Excel skills, Process automation', 'Approved');

-- Insert Payroll Records
INSERT INTO payroll (emp_id, pay_period_start, pay_period_end, basic_salary, overtime_pay, bonus, deductions, tax_deduction, payment_date, status) VALUES
(1, '2024-01-01', '2024-01-31', 75000.00, 3500.00, 5000.00, 2000.00, 12075.00, '2024-02-01', 'Paid'),
(2, '2024-01-01', '2024-01-31', 65000.00, 0.00, 3000.00, 1500.00, 9975.00, '2024-02-01', 'Paid'),
(3, '2024-01-01', '2024-01-31', 80000.00, 4200.00, 6000.00, 2500.00, 13155.00, '2024-02-01', 'Paid'),
(4, '2024-01-01', '2024-01-31', 55000.00, 0.00, 2000.00, 1000.00, 8400.00, '2024-02-01', 'Paid'),
(5, '2024-01-01', '2024-01-31', 70000.00, 1500.00, 4000.00, 1800.00, 11055.00, '2024-02-01', 'Paid');

-- Update employee additional information
UPDATE employees SET 
    address = 'House 123, Block A, Gulberg, Lahore',
    date_of_birth = '1990-05-15',
    emergency_contact = 'Ali Khan - 03001111111',
    performance_rating = 4.2
WHERE emp_id = 1;

UPDATE employees SET 
    address = 'Flat 45, DHA Phase 2, Karachi',
    date_of_birth = '1992-08-22',
    emergency_contact = 'Fatima Ali - 03002222222',
    performance_rating = 4.2
WHERE emp_id = 2;

UPDATE employees SET 
    address = 'Villa 67, Bahria Town, Islamabad',
    date_of_birth = '1988-12-10',
    emergency_contact = 'Amna Sheikh - 03003333333',
    performance_rating = 4.5
WHERE emp_id = 3;