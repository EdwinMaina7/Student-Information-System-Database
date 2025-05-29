# Student Information System Database

## Project Title
Student Information System - Comprehensive Database for Educational Institutions

## Description
The Student Information System Database is a robust MySQL database designed to manage all aspects of an educational institution's data. This comprehensive system handles:

- **Student Management**: Complete student profiles, academic records, and enrollment tracking
- **Faculty Management**: Faculty profiles, teaching assignments, and departmental affiliations
- **Course Management**: Course catalog, semester-based offerings, and prerequisites
- **Academic Records**: Grading, transcripts, GPA calculation, and academic standing
- **Financial Management**: Tuition payments and financial aid tracking
- **Attendance System**: Daily attendance recording and monitoring
- **Assignment Management**: Assignment creation, submission tracking, and grading
- **Campus Infrastructure**: Buildings and room management for scheduling

This database follows best practices in relational database design with proper constraints, relationships, and normalization to ensure data integrity and performance.

## How to Setup/Run the Project

### Requirements
- MySQL Server 5.7+ or MariaDB 10.2+
- MySQL client or administration tool (MySQL Workbench, phpMyAdmin, etc.)

### Installation Steps

1. **Clone the repository or download the SQL file**
   ```
   git clone https://github.com/yourusername/student-information-system.git
   ```

2. **Connect to your MySQL server** using your preferred client
   ```
   mysql -u username -p
   ```

3. **Import the SQL file**
   ```
   mysql -u username -p < student_information_system.sql
   ```
   
   Alternatively, in the MySQL command line:
   ```
   source /path/to/student_information_system.sql
   ```

4. **Verify installation**
   ```sql
   USE student_information_system;
   SHOW TABLES;
   ```

5. **Access the database views**
   ```sql
   SELECT * FROM current_offerings;
   SELECT * FROM student_transcripts;
   ```

### Quick Start Guide

After importing the database, you can start using it by:

1. **Adding departments**
   ```sql
   INSERT INTO departments (department_name, department_code, creation_date) 
   VALUES ('Computer Science', 'CS', CURDATE());
   ```

2. **Adding faculty members**
   ```sql
   INSERT INTO faculty (first_name, last_name, email, phone, hire_date, department_id, position) 
   VALUES ('John', 'Smith', 'jsmith@university.edu', '555-123-4567', '2020-08-15', 1, 'Professor');
   ```

3. **Adding students**
   ```sql
   INSERT INTO students (first_name, last_name, email, date_of_birth, enrollment_date) 
   VALUES ('Jane', 'Doe', 'jdoe@university.edu', '2003-05-10', CURDATE());
   ```

4. **Creating courses**
   ```sql
   INSERT INTO courses (course_code, course_name, credit_hours, department_id) 
   VALUES ('CS101', 'Introduction to Programming', 3, 1);
   ```


*Note: Replace the URL above with the actual link to your ERD image when available.*

### Core Relationships

- **Student-Course**: Many-to-many relationship through the enrollments table
- **Faculty-Department**: Many-to-one relationship (faculty members belong to departments)
- **Faculty-Student**: Many-to-many relationship through the advisors table
- **Course-Department**: Many-to-one relationship (courses belong to departments)
- **Building-Room**: One-to-many relationship (buildings contain many rooms)

## Database Features

### Constraints and Data Integrity
- Primary and Foreign Keys for all relationships
- Check constraints for valid grades, credit hours, etc.
- Unique constraints for emails, course codes, etc.
- Default values for common fields
- Data validation through ENUM types

### Performance Optimization
- Indexes on frequently queried columns
- Views for common complex queries
- Proper normalization to minimize redundancy

### Sample Queries

**Get a student's transcript:**
```sql
SELECT * FROM student_transcripts WHERE student_id = 1;
```

**Find available courses for the current semester:**
```sql
SELECT * FROM current_offerings WHERE status = 'Open';
```

**Calculate class attendance rates:**
```sql
SELECT e.offering_id, c.course_name, 
       COUNT(CASE WHEN a.status = 'Present' THEN 1 END) / COUNT(*) * 100 AS attendance_rate
FROM attendance a
JOIN enrollments e ON a.enrollment_id = e.enrollment_id
JOIN course_offerings co ON e.offering_id = co.offering_id
JOIN courses c ON co.course_id = c.course_id
GROUP BY e.offering_id;
```

## Future Enhancements
- Stored procedures for common operations
- Triggers for maintaining derived data
- User authentication and authorization system
- Integration with reporting tools


## Contact
For questions or support, please contact: mainaedwin716@gmail.com or +254799399139
