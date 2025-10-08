-- Complete SQL Project Execution Script
-- Run this file in MySQL Workbench or any SQL client

-- Step 1: Create Database and Basic Tables
SOURCE database_setup.sql;

-- Step 2: Add Sample Data
SOURCE sample_data.sql;

-- Step 3: Add Advanced Schema
SOURCE advanced_schema.sql;

-- Step 4: Add Advanced Sample Data
SOURCE advanced_sample_data.sql;

-- Step 5: Create Triggers and Views
SOURCE triggers_views.sql;

-- Step 6: Create Stored Procedures
SOURCE stored_procedures.sql;

-- Step 7: Create Advanced Procedures
SOURCE advanced_procedures.sql;

-- Step 8: Test Basic Queries
SELECT 'Database Setup Complete!' as Status;

-- Test Employee Dashboard
SELECT * FROM employee_dashboard LIMIT 5;

-- Test Department Analytics
SELECT * FROM department_analytics;

-- Test a Stored Procedure
CALL GetEmployeeDetails(1);

SELECT 'All Systems Ready! 🚀' as Message;