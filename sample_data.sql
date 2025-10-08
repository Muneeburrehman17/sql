-- Sample Data for Employee Management System
USE employee_management;

-- Insert Departments
INSERT INTO departments (dept_name, location) VALUES
('Human Resources', 'Building A'),
('Information Technology', 'Building B'),
('Finance', 'Building A'),
('Marketing', 'Building C'),
('Operations', 'Building B');

-- Insert Employees
INSERT INTO employees (first_name, last_name, email, phone, hire_date, salary, dept_id, manager_id) VALUES
('Ahmed', 'Khan', 'ahmed.khan@company.com', '03001234567', '2020-01-15', 75000.00, 2, NULL),
('Fatima', 'Ali', 'fatima.ali@company.com', '03009876543', '2021-03-10', 65000.00, 1, 1),
('Hassan', 'Sheikh', 'hassan.sheikh@company.com', '03005555555', '2019-06-20', 80000.00, 2, 1),
('Ayesha', 'Malik', 'ayesha.malik@company.com', '03007777777', '2022-02-01', 55000.00, 3, NULL),
('Omar', 'Qureshi', 'omar.qureshi@company.com', '03008888888', '2021-09-15', 70000.00, 4, NULL),
('Zara', 'Hussain', 'zara.hussain@company.com', '03006666666', '2023-01-10', 45000.00, 1, 2),
('Bilal', 'Ahmed', 'bilal.ahmed@company.com', '03004444444', '2020-11-05', 72000.00, 2, 3),
('Sana', 'Tariq', 'sana.tariq@company.com', '03003333333', '2022-07-20', 60000.00, 5, NULL);

-- Insert Projects
INSERT INTO projects (project_name, start_date, end_date, budget, status) VALUES
('Website Redesign', '2024-01-01', '2024-06-30', 150000.00, 'Active'),
('Mobile App Development', '2024-02-15', '2024-12-31', 300000.00, 'Active'),
('HR System Upgrade', '2023-10-01', '2024-03-31', 100000.00, 'Completed'),
('Marketing Campaign 2024', '2024-03-01', '2024-08-31', 75000.00, 'Planning'),
('Data Migration Project', '2024-01-15', '2024-05-15', 200000.00, 'Active');

-- Assign Employees to Projects
INSERT INTO employee_projects (emp_id, project_id, role, assigned_date) VALUES
(1, 1, 'Project Manager', '2024-01-01'),
(3, 1, 'Lead Developer', '2024-01-01'),
(7, 1, 'Developer', '2024-01-05'),
(1, 2, 'Technical Lead', '2024-02-15'),
(3, 2, 'Senior Developer', '2024-02-15'),
(2, 3, 'HR Coordinator', '2023-10-01'),
(5, 4, 'Marketing Manager', '2024-03-01'),
(1, 5, 'Data Architect', '2024-01-15'),
(7, 5, 'Database Developer', '2024-01-15');