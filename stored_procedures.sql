-- Stored Procedures for Employee Management System
USE employee_management;

DELIMITER //

-- 1. Add new employee
CREATE PROCEDURE AddEmployee(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15),
    IN p_salary DECIMAL(10,2),
    IN p_dept_id INT,
    IN p_manager_id INT
)
BEGIN
    INSERT INTO employees (first_name, last_name, email, phone, hire_date, salary, dept_id, manager_id)
    VALUES (p_first_name, p_last_name, p_email, p_phone, CURRENT_DATE, p_salary, p_dept_id, p_manager_id);
    
    SELECT LAST_INSERT_ID() AS new_employee_id;
END //

-- 2. Update employee salary
CREATE PROCEDURE UpdateSalary(
    IN p_emp_id INT,
    IN p_new_salary DECIMAL(10,2)
)
BEGIN
    UPDATE employees 
    SET salary = p_new_salary 
    WHERE emp_id = p_emp_id;
    
    SELECT CONCAT('Salary updated for employee ID: ', p_emp_id) AS message;
END //

-- 3. Get employee details
CREATE PROCEDURE GetEmployeeDetails(IN p_emp_id INT)
BEGIN
    SELECT 
        e.emp_id,
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        e.email,
        e.phone,
        e.hire_date,
        e.salary,
        d.dept_name,
        CONCAT(m.first_name, ' ', m.last_name) AS manager_name
    FROM employees e
    JOIN departments d ON e.dept_id = d.dept_id
    LEFT JOIN employees m ON e.manager_id = m.emp_id
    WHERE e.emp_id = p_emp_id;
END //

-- 4. Assign employee to project
CREATE PROCEDURE AssignToProject(
    IN p_emp_id INT,
    IN p_project_id INT,
    IN p_role VARCHAR(50)
)
BEGIN
    INSERT INTO employee_projects (emp_id, project_id, role, assigned_date)
    VALUES (p_emp_id, p_project_id, p_role, CURRENT_DATE);
    
    SELECT 'Employee assigned to project successfully' AS message;
END //

DELIMITER ;