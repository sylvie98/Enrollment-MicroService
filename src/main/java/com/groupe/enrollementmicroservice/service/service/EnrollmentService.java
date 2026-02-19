package com.groupe.enrollementmicroservice.service;

import com.groupe.enrollementmicroservice.dao.EnrollmentDAO;
import com.groupe.enrollementmicroservice.model.Enrollment;
import com.groupe.enrollementmicroservice.util.HttpClient;

import java.sql.SQLException;
import java.util.List;

/**
 * Service Layer for Enrollment Business Logic
 * Handles validation and business rules
 */
public class EnrollmentService {
    
    private EnrollmentDAO enrollmentDAO;
    
    // Configuration for other microservices (Update these URLs based on your setup)
    private static final String STUDENT_SERVICE_URL = "http://localhost:8081/student-service/api/students";
    private static final String COURSE_SERVICE_URL = "http://localhost:8082/course-service/api/courses";
    
    public EnrollmentService() {
        this.enrollmentDAO = new EnrollmentDAO();
    }
    
    /**
     * Validate if student exists (dummy call to Student Service)
     * @param studentId Student ID
     * @return true if student exists
     */
    public boolean validateStudent(int studentId) {
        // In production, this would make an HTTP call to Student Service
        // For now, we'll implement a dummy validation
        try {
            // Uncomment when Student Service is available:
            // String response = HttpClient.get(STUDENT_SERVICE_URL + "/" + studentId);
            // return response != null && !response.isEmpty();
            
            // Dummy validation - accepts all student IDs > 0
            return studentId > 0;
        } catch (Exception e) {
            System.err.println("Error validating student: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Validate if course exists (dummy call to Course Service)
     * @param courseId Course ID
     * @return true if course exists
     */
    public boolean validateCourse(int courseId) {
        // In production, this would make an HTTP call to Course Service
        // For now, we'll implement a dummy validation
        try {
            // Uncomment when Course Service is available:
            // String response = HttpClient.get(COURSE_SERVICE_URL + "/" + courseId);
            // return response != null && !response.isEmpty();
            
            // Dummy validation - accepts all course IDs > 0
            return courseId > 0;
        } catch (Exception e) {
            System.err.println("Error validating course: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Enroll student in a course
     * @param enrollment Enrollment object
     * @return Created enrollment
     * @throws Exception if validation fails or enrollment fails
     */
    public Enrollment enrollStudent(Enrollment enrollment) throws Exception {
        // Validate student
        if (!validateStudent(enrollment.getStudentId())) {
            throw new Exception("Invalid student ID: " + enrollment.getStudentId());
        }
        
        // Validate course
        if (!validateCourse(enrollment.getCourseId())) {
            throw new Exception("Invalid course ID: " + enrollment.getCourseId());
        }
        
        // Check if already enrolled
        if (enrollmentDAO.isAlreadyEnrolled(
                enrollment.getStudentId(), 
                enrollment.getCourseId(), 
                enrollment.getSemester(), 
                enrollment.getAcademicYear())) {
            throw new Exception("Student is already enrolled in this course for the given semester");
        }
        
        // Create enrollment
        try {
            return enrollmentDAO.createEnrollment(enrollment);
        } catch (SQLException e) {
            throw new Exception("Failed to create enrollment: " + e.getMessage());
        }
    }
    
    /**
     * Get enrollment by ID
     * @param id Enrollment ID
     * @return Enrollment object
     * @throws Exception if not found
     */
    public Enrollment getEnrollmentById(int id) throws Exception {
        try {
            Enrollment enrollment = enrollmentDAO.getEnrollmentById(id);
            if (enrollment == null) {
                throw new Exception("Enrollment not found with ID: " + id);
            }
            return enrollment;
        } catch (SQLException e) {
            throw new Exception("Failed to retrieve enrollment: " + e.getMessage());
        }
    }
    
    /**
     * Get all enrollments
     * @return List of all enrollments
     * @throws Exception if operation fails
     */
    public List<Enrollment> getAllEnrollments() throws Exception {
        try {
            return enrollmentDAO.getAllEnrollments();
        } catch (SQLException e) {
            throw new Exception("Failed to retrieve enrollments: " + e.getMessage());
        }
    }
    
    /**
     * Get student enrollment history
     * @param studentId Student ID
     * @return List of enrollments
     * @throws Exception if operation fails
     */
    public List<Enrollment> getStudentEnrollmentHistory(int studentId) throws Exception {
        try {
            return enrollmentDAO.getEnrollmentsByStudentId(studentId);
        } catch (SQLException e) {
            throw new Exception("Failed to retrieve student enrollments: " + e.getMessage());
        }
    }
    
    /**
     * Get course enrollments
     * @param courseId Course ID
     * @return List of enrollments
     * @throws Exception if operation fails
     */
    public List<Enrollment> getCourseEnrollments(int courseId) throws Exception {
        try {
            return enrollmentDAO.getEnrollmentsByCourseId(courseId);
        } catch (SQLException e) {
            throw new Exception("Failed to retrieve course enrollments: " + e.getMessage());
        }
    }
    
    /**
     * Get enrollments by semester
     * @param semester Semester
     * @param academicYear Academic year
     * @return List of enrollments
     * @throws Exception if operation fails
     */
    public List<Enrollment> getEnrollmentsBySemester(String semester, String academicYear) throws Exception {
        try {
            return enrollmentDAO.getEnrollmentsBySemester(semester, academicYear);
        } catch (SQLException e) {
            throw new Exception("Failed to retrieve semester enrollments: " + e.getMessage());
        }
    }
    
    /**
     * Drop a course
     * @param enrollmentId Enrollment ID
     * @return true if successful
     * @throws Exception if operation fails
     */
    public boolean dropCourse(int enrollmentId) throws Exception {
        try {
            // Check if enrollment exists and is active
            Enrollment enrollment = enrollmentDAO.getEnrollmentById(enrollmentId);
            if (enrollment == null) {
                throw new Exception("Enrollment not found with ID: " + enrollmentId);
            }
            
            if ("DROPPED".equals(enrollment.getStatus())) {
                throw new Exception("Course is already dropped");
            }
            
            return enrollmentDAO.dropCourse(enrollmentId);
        } catch (SQLException e) {
            throw new Exception("Failed to drop course: " + e.getMessage());
        }
    }
    
    /**
     * Update enrollment
     * @param enrollment Enrollment object with updated data
     * @return true if successful
     * @throws Exception if operation fails
     */
    public boolean updateEnrollment(Enrollment enrollment) throws Exception {
        try {
            // Validate enrollment exists
            Enrollment existing = enrollmentDAO.getEnrollmentById(enrollment.getId());
            if (existing == null) {
                throw new Exception("Enrollment not found with ID: " + enrollment.getId());
            }
            
            return enrollmentDAO.updateEnrollment(enrollment);
        } catch (SQLException e) {
            throw new Exception("Failed to update enrollment: " + e.getMessage());
        }
    }
    
    /**
     * Delete enrollment
     * @param id Enrollment ID
     * @return true if successful
     * @throws Exception if operation fails
     */
    public boolean deleteEnrollment(int id) throws Exception {
        try {
            // Validate enrollment exists
            Enrollment existing = enrollmentDAO.getEnrollmentById(id);
            if (existing == null) {
                throw new Exception("Enrollment not found with ID: " + id);
            }
            
            return enrollmentDAO.deleteEnrollment(id);
        } catch (SQLException e) {
            throw new Exception("Failed to delete enrollment: " + e.getMessage());
        }
    }
    
    /**
     * Get enrollment count by student (dummy endpoint for other services)
     * @param studentId Student ID
     * @return Count of active enrollments
     * @throws Exception if operation fails
     */
    public int getEnrollmentCountByStudent(int studentId) throws Exception {
        try {
            return enrollmentDAO.getEnrollmentCountByStudent(studentId);
        } catch (SQLException e) {
            throw new Exception("Failed to get enrollment count: " + e.getMessage());
        }
    }
    
    /**
     * Get enrollment count by course (dummy endpoint for other services)
     * @param courseId Course ID
     * @return Count of active enrollments
     * @throws Exception if operation fails
     */
    public int getEnrollmentCountByCourse(int courseId) throws Exception {
        try {
            return enrollmentDAO.getEnrollmentCountByCourse(courseId);
        } catch (SQLException e) {
            throw new Exception("Failed to get enrollment count: " + e.getMessage());
        }
    }
}
