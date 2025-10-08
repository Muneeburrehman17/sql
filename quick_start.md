# 🚀 Quick Start Guide - 5 Minutes Setup

## Option 1: XAMPP (Easiest)

### Step 1: Download & Install
```
1. Download XAMPP: https://www.apachefriends.org/download.html
2. Install XAMPP
3. Start XAMPP Control Panel
4. Click "Start" for Apache and MySQL
```

### Step 2: Open phpMyAdmin
```
1. Open browser
2. Go to: http://localhost/phpmyadmin
3. Click "New" database
4. Name: employee_management
5. Click "Create"
```

### Step 3: Import SQL
```
1. Click "Import" tab
2. Choose file: run_all.sql
3. Click "Go"
4. Wait for success message
```

## Option 2: MySQL Workbench

### Step 1: Download & Install
```
1. Download: https://dev.mysql.com/downloads/workbench/
2. Install MySQL Workbench
3. Install MySQL Server if not installed
```

### Step 2: Connect & Execute
```
1. Open MySQL Workbench
2. Create connection (localhost:3306)
3. Open run_all.sql file
4. Click Execute (⚡) button
```

## Option 3: Online MySQL (No Installation)

### Use db4free.net
```
1. Go to: https://www.db4free.net/
2. Create free account
3. Use online phpMyAdmin
4. Import run_all.sql
```

## ✅ Verification

After setup, run these queries:
```sql
USE employee_management;
SELECT COUNT(*) FROM employees;
SELECT * FROM employee_dashboard LIMIT 3;
```

## 🎯 Ready to Use!

Your system is now ready with:
- 8 employees
- 5 departments  
- 5 projects
- Complete HR system
- Analytics dashboard

## 📞 Need Help?

If any issues:
1. Check MySQL service is running
2. Verify database name: employee_management
3. Run test_queries.sql to verify setup