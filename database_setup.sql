-- Employee Management System Database Setup
-- Created: 2024

-- Create Database
CREATE DATABASE IF NOT EXISTS employee_management;
USE employee_management;

-- Create Departments Table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    created_date DATE DEFAULT CURRENT_DATE
);

-- Create Employees Table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    dept_id INT,
    manager_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

-- Create Projects Table
CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12,2),
    status ENUM('Planning', 'Active', 'Completed', 'On Hold') DEFAULT 'Planning'
);

-- Create Employee_Projects Junction Table
CREATE TABLE employee_projects (
    emp_id INT,
    project_id INT,
    role VARCHAR(50),
    assigned_date DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);