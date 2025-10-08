# Employee Management System - SQL Project

## Project Overview
Yeh ek complete Employee Management System ka SQL project hai jo employees, departments, aur projects ko manage karta hai.

## Database Structure

### Tables:
1. **departments** - Company departments ki information
2. **employees** - Employee details aur salary information  
3. **projects** - Company projects ki details
4. **employee_projects** - Employees aur projects ka mapping

## Files Description

### 1. database_setup.sql
- Database aur tables create karta hai
- Foreign key relationships define karta hai
- Primary keys aur constraints set karta hai

### 2. sample_data.sql
- Sample data insert karta hai testing ke liye
- Pakistani names aur realistic data use karta hai
- Different departments aur projects include karta hai

### 3. queries.sql
- Common reporting queries
- Employee analysis queries
- Department-wise statistics
- Project assignments

### 4. stored_procedures.sql
- AddEmployee - Naya employee add karne ke liye
- UpdateSalary - Salary update karne ke liye
- GetEmployeeDetails - Employee ki complete details
- AssignToProject - Employee ko project assign karna

## How to Use

1. **Setup Database:**
   ```sql
   source database_setup.sql
   ```

2. **Insert Sample Data:**
   ```sql
   source sample_data.sql
   ```

3. **Run Queries:**
   ```sql
   source queries.sql
   ```

4. **Create Procedures:**
   ```sql
   source stored_procedures.sql
   ```

## Sample Queries

### Get all employees with departments:
```sql
SELECT e.first_name, e.last_name, d.dept_name 
FROM employees e 
JOIN departments d ON e.dept_id = d.dept_id;
```

### Find highest paid employees:
```sql
SELECT * FROM employees 
ORDER BY salary DESC 
LIMIT 5;
```

## Features
- ✅ Complete database schema
- ✅ Sample data with Pakistani context
- ✅ Advanced SQL queries
- ✅ Stored procedures
- ✅ Foreign key relationships
- ✅ Data integrity constraints

## Requirements
- MySQL 5.7+ ya MariaDB
- SQL client (MySQL Workbench, phpMyAdmin, etc.)

## Next Steps
- Views create kar sakte hain reporting ke liye
- Triggers add kar sakte hain audit trail ke liye
- Indexes optimize kar sakte hain performance ke liye