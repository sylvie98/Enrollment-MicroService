-- =====================================================
-- Enrollment Service Database Schema
-- SmartCampus Microservice Architecture
-- =====================================================

-- Create Database
CREATE DATABASE IF NOT EXISTS enrollment_service_db;
USE enrollment_service_db;

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS enrollments;

-- =====================================================
-- Table: enrollments
-- =====================================================
CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester VARCHAR(20) NOT NULL,
    academic_year VARCHAR(10) NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    grade VARCHAR(5) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_enrollment (student_id, course_id, semester, academic_year),
    INDEX idx_student_id (student_id),
    INDEX idx_course_id (course_id),
    INDEX idx_semester (semester),
    INDEX idx_academic_year (academic_year),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- Sample Data for Testing
-- =====================================================
INSERT INTO enrollments (student_id, course_id, semester, academic_year, status) VALUES
(1, 101, 'FIRST', '2024-2025', 'ACTIVE'),
(1, 102, 'FIRST', '2024-2025', 'ACTIVE'),
(2, 101, 'FIRST', '2024-2025', 'ACTIVE'),
(2, 103, 'FIRST', '2024-2025', 'ACTIVE'),
(3, 102, 'FIRST', '2024-2025', 'DROPPED'),
(3, 104, 'FIRST', '2024-2025', 'ACTIVE');

-- =====================================================
-- Useful Queries for Testing
-- =====================================================

-- Get all enrollments for a student
-- SELECT * FROM enrollments WHERE student_id = 1 AND status = 'ACTIVE';

-- Get all students enrolled in a course
-- SELECT * FROM enrollments WHERE course_id = 101 AND status = 'ACTIVE';

-- Get enrollment by semester
-- SELECT * FROM enrollments WHERE semester = 'FIRST' AND academic_year = '2024-2025';

-- Check if student is already enrolled in a course
-- SELECT COUNT(*) FROM enrollments WHERE student_id = 1 AND course_id = 101 AND semester = 'FIRST' AND academic_year = '2024-2025' AND status = 'ACTIVE';
