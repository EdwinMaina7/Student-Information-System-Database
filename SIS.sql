-- Student Information System Database
-- Created: May 09, 2025

-- Drop database if it exists to start fresh
DROP DATABASE IF EXISTS student_information_system;

-- Create new database
CREATE DATABASE student_information_system;

-- Use the newly created database
USE student_information_system;

-- DEPARTMENTS TABLE
-- Stores academic departments information
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    department_code VARCHAR(10) NOT NULL UNIQUE,
    department_head INT,
    office_location VARCHAR(100),
    phone_number VARCHAR(20),
    creation_date DATE NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- FACULTY TABLE
-- Stores faculty members information
CREATE TABLE faculty (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    department_id INT,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2),
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL
);

-- Add foreign key constraint for department_head after faculty table exists
ALTER TABLE departments 
ADD CONSTRAINT fk_department_head 
FOREIGN KEY (department_head) REFERENCES faculty(faculty_id) ON DELETE SET NULL;

-- STUDENTS TABLE
-- Stores student information
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Non-binary', 'Other', 'Prefer not to say'),
    address TEXT,
    phone VARCHAR(20),
    enrollment_date DATE NOT NULL,
    graduation_date DATE,
    major_department_id INT,
    gpa DECIMAL(3,2) CHECK (gpa >= 0.0 AND gpa <= 4.0),
    academic_status ENUM('Active', 'Probation', 'Suspended', 'Graduated', 'Withdrawn') DEFAULT 'Active',
    FOREIGN KEY (major_department_id) REFERENCES departments(department_id) ON DELETE SET NULL
);

-- COURSES TABLE
-- Stores course information
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    credit_hours INT NOT NULL CHECK (credit_hours > 0),
    department_id INT NOT NULL,
    prerequisites TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
);

-- SEMESTERS TABLE
-- Stores academic term information
CREATE TABLE semesters (
    semester_id INT AUTO_INCREMENT PRIMARY KEY,
    semester_name VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    registration_start DATE NOT NULL,
    registration_end DATE NOT NULL,
    is_current BOOLEAN DEFAULT FALSE,
    CHECK (end_date > start_date),
    CHECK (registration_end > registration_start),
    CHECK (registration_end <= start_date)
);

-- COURSE_OFFERINGS TABLE
-- Stores specific course offerings for each semester
CREATE TABLE course_offerings (
    offering_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    semester_id INT NOT NULL,
    faculty_id INT,
    max_enrollment INT NOT NULL CHECK (max_enrollment > 0),
    current_enrollment INT DEFAULT 0 CHECK (current_enrollment >= 0),
    room_location VARCHAR(50),
    schedule VARCHAR(100),
    status ENUM('Open', 'Closed', 'Cancelled') DEFAULT 'Open',
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES semesters(semester_id) ON DELETE CASCADE,
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id) ON DELETE SET NULL,
    UNIQUE (course_id, semester_id, faculty_id, schedule)
);

-- ENROLLMENTS TABLE
-- Stores student enrollment in specific course offerings
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    offering_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    grade CHAR(2),
    grade_points DECIMAL(3,2),
    status ENUM('Enrolled', 'Withdrawn', 'Completed', 'Failed') DEFAULT 'Enrolled',
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (offering_id) REFERENCES course_offerings(offering_id) ON DELETE CASCADE,
    UNIQUE (student_id, offering_id)
);

-- ATTENDANCE TABLE
-- Tracks student attendance for each class session
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    date DATE NOT NULL,
    status ENUM('Present', 'Absent', 'Late', 'Excused') NOT NULL,
    notes TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE,
    UNIQUE (enrollment_id, date)
);

-- ASSIGNMENTS TABLE
-- Stores assignment information for course offerings
CREATE TABLE assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    offering_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    due_date DATETIME NOT NULL,
    total_points INT NOT NULL CHECK (total_points > 0),
    weight DECIMAL(5,2) CHECK (weight > 0),
    assignment_type ENUM('Homework', 'Quiz', 'Exam', 'Project', 'Paper', 'Presentation', 'Other'),
    FOREIGN KEY (offering_id) REFERENCES course_offerings(offering_id) ON DELETE CASCADE
);

-- ASSIGNMENT_SUBMISSIONS TABLE
-- Tracks student submissions for assignments
CREATE TABLE assignment_submissions (
    submission_id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT NOT NULL,
    student_id INT NOT NULL,
    submission_date DATETIME,
    score DECIMAL(5,2),
    feedback TEXT,
    status ENUM('Pending', 'Submitted', 'Late', 'Graded', 'Resubmitted') DEFAULT 'Pending',
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    UNIQUE (assignment_id, student_id)
);

-- PAYMENTS TABLE
-- Stores payment information for student fees
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    semester_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_date DATETIME NOT NULL,
    payment_method ENUM('Credit Card', 'Bank Transfer', 'Cash', 'Check', 'Scholarship', 'Other'),
    status ENUM('Pending', 'Completed', 'Failed', 'Refunded') DEFAULT 'Pending',
    reference_number VARCHAR(50),
    notes TEXT,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES semesters(semester_id) ON DELETE CASCADE
);

-- FINANCIAL_AID TABLE
-- Stores financial aid information for students
CREATE TABLE financial_aid (
    aid_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    semester_id INT NOT NULL,
    aid_type ENUM('Scholarship', 'Grant', 'Loan', 'Work Study', 'Other'),
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    status ENUM('Applied', 'Approved', 'Disbursed', 'Denied', 'Cancelled') DEFAULT 'Applied',
    application_date DATE NOT NULL,
    approval_date DATE,
    disbursement_date DATE,
    notes TEXT,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES semesters(semester_id) ON DELETE CASCADE
);

-- ADVISORS TABLE
-- Assigns faculty members as advisors to students
CREATE TABLE advisors (
    advisor_id INT AUTO_INCREMENT PRIMARY KEY,
    faculty_id INT NOT NULL,
    student_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    notes TEXT,
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    UNIQUE (faculty_id, student_id)
);

-- ACADEMIC_RECORDS TABLE
-- Stores cumulative academic information for students by semester
CREATE TABLE academic_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    semester_id INT NOT NULL,
    credits_attempted INT NOT NULL DEFAULT 0 CHECK (credits_attempted >= 0),
    credits_earned INT NOT NULL DEFAULT 0 CHECK (credits_earned >= 0),
    semester_gpa DECIMAL(3,2) CHECK (semester_gpa >= 0.0 AND semester_gpa <= 4.0),
    cumulative_gpa DECIMAL(3,2) CHECK (cumulative_gpa >= 0.0 AND cumulative_gpa <= 4.0),
    academic_standing ENUM('Good Standing', 'Warning', 'Probation', 'Suspension', 'Dismissal') DEFAULT 'Good Standing',
    notes TEXT,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES semesters(semester_id) ON DELETE CASCADE,
    UNIQUE (student_id, semester_id)
);

-- BUILDINGS TABLE
-- Stores information about campus buildings
CREATE TABLE buildings (
    building_id INT AUTO_INCREMENT PRIMARY KEY,
    building_name VARCHAR(100) NOT NULL UNIQUE,
    building_code VARCHAR(10) NOT NULL UNIQUE,
    address TEXT,
    total_floors INT NOT NULL CHECK (total_floors > 0),
    year_built INT,
    last_renovation_year INT
);

-- ROOMS TABLE
-- Stores information about rooms in campus buildings
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    building_id INT NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    room_type ENUM('Classroom', 'Laboratory', 'Office', 'Conference', 'Other'),
    capacity INT CHECK (capacity > 0),
    has_projector BOOLEAN DEFAULT FALSE,
    has_computers BOOLEAN DEFAULT FALSE,
    special_equipment TEXT,
    FOREIGN KEY (building_id) REFERENCES buildings(building_id) ON DELETE CASCADE,
    UNIQUE (building_id, room_number)
);

-- Create an index on commonly queried columns
CREATE INDEX idx_student_name ON students(last_name, first_name);
CREATE INDEX idx_course_name ON courses(course_name);
CREATE INDEX idx_enrollment_status ON enrollments(status);
CREATE INDEX idx_offering_semester ON course_offerings(semester_id);
CREATE INDEX idx_faculty_department ON faculty(department_id);

-- Create a view for current course offerings
CREATE VIEW current_offerings AS
SELECT co.offering_id, c.course_code, c.course_name, co.schedule, co.room_location,
       CONCAT(f.first_name, ' ', f.last_name) AS instructor,
       co.max_enrollment, co.current_enrollment, co.status,
       s.semester_name, s.start_date, s.end_date
FROM course_offerings co
JOIN courses c ON co.course_id = c.course_id
JOIN semesters s ON co.semester_id = s.semester_id
LEFT JOIN faculty f ON co.faculty_id = f.faculty_id
WHERE s.is_current = TRUE;

-- Create a view for student transcripts
CREATE VIEW student_transcripts AS
SELECT s.student_id, CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       c.course_code, c.course_name, c.credit_hours, e.grade, e.grade_points,
       sm.semester_name, sm.start_date, sm.end_date
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN course_offerings co ON e.offering_id = co.offering_id
JOIN courses c ON co.course_id = c.course_id
JOIN semesters sm ON co.semester_id = sm.semester_id
WHERE e.status = 'Completed';