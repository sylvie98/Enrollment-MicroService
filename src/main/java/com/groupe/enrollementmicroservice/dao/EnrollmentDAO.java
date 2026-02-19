package com.groupe.enrollementmicroservice.dao;

import com.groupe.enrollementmicroservice.model.Enrollment;
import com.groupe.enrollementmicroservice.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Enrollment operations
 * Handles all database interactions for enrollments
 */
public class EnrollmentDAO {
    
    /**
     * Create a new enrollment
     * @param enrollment Enrollment object to create
     * @return Created enrollment with generated ID
     * @throws SQLException if database operation fails
     */
    public Enrollment createEnrollment(Enrollment enrollment) throws SQLException {
        String sql = "INSERT INTO enrollments (student_id, course_id, semester, academic_year, status) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, enrollment.getStudentId());
            pstmt.setInt(2, enrollment.getCourseId());
            pstmt.setString(3, enrollment.getSemester());
            pstmt.setString(4, enrollment.getAcademicYear());
            pstmt.setString(5, enrollment.getStatus());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating enrollment failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    enrollment.setId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating enrollment failed, no ID obtained.");
                }
            }
            
            return enrollment;
        }
    }
    
    /**
     * Get enrollment by ID
     * @param id Enrollment ID
     * @return Enrollment object or null if not found
     * @throws SQLException if database operation fails
     */
    public Enrollment getEnrollmentById(int id) throws SQLException {
        String sql = "SELECT * FROM enrollments WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractEnrollmentFromResultSet(rs);
                }
            }
        }
        
        return null;
    }
    
    /**
     * Get all enrollments
     * @return List of all enrollments
     * @throws SQLException if database operation fails
     */
    public List<Enrollment> getAllEnrollments() throws SQLException {
        String sql = "SELECT * FROM enrollments ORDER BY created_at DESC";
        List<Enrollment> enrollments = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                enrollments.add(extractEnrollmentFromResultSet(rs));
            }
        }
        
        return enrollments;
    }
    
    /**
     * Get enrollments by student ID
     * @param studentId Student ID
     * @return List of enrollments for the student
     * @throws SQLException if database operation fails
     */
    public List<Enrollment> getEnrollmentsByStudentId(int studentId) throws SQLException {
        String sql = "SELECT * FROM enrollments WHERE student_id = ? ORDER BY created_at DESC";
        List<Enrollment> enrollments = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    enrollments.add(extractEnrollmentFromResultSet(rs));
                }
            }
        }
        
        return enrollments;
    }
    
    /**
     * Get enrollments by course ID
     * @param courseId Course ID
     * @return List of enrollments for the course
     * @throws SQLException if database operation fails
     */
    public List<Enrollment> getEnrollmentsByCourseId(int courseId) throws SQLException {
        String sql = "SELECT * FROM enrollments WHERE course_id = ? ORDER BY created_at DESC";
        List<Enrollment> enrollments = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, courseId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    enrollments.add(extractEnrollmentFromResultSet(rs));
                }
            }
        }
        
        return enrollments;
    }
    
    /**
     * Get enrollments by semester and academic year
     * @param semester Semester
     * @param academicYear Academic year
     * @return List of enrollments
     * @throws SQLException if database operation fails
     */
    public List<Enrollment> getEnrollmentsBySemester(String semester, String academicYear) throws SQLException {
        String sql = "SELECT * FROM enrollments WHERE semester = ? AND academic_year = ? ORDER BY created_at DESC";
        List<Enrollment> enrollments = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, semester);
            pstmt.setString(2, academicYear);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    enrollments.add(extractEnrollmentFromResultSet(rs));
                }
            }
        }
        
        return enrollments;
    }
    
    /**
     * Check if student is already enrolled in a course
     * @param studentId Student ID
     * @param courseId Course ID
     * @param semester Semester
     * @param academicYear Academic year
     * @return true if already enrolled
     * @throws SQLException if database operation fails
     */
    public boolean isAlreadyEnrolled(int studentId, int courseId, String semester, String academicYear) throws SQLException {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE student_id = ? AND course_id = ? AND semester = ? AND academic_year = ? AND status = 'ACTIVE'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, courseId);
            pstmt.setString(3, semester);
            pstmt.setString(4, academicYear);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        
        return false;
    }
    
    /**
     * Update enrollment
     * @param enrollment Enrollment object with updated data
     * @return true if update successful
     * @throws SQLException if database operation fails
     */
    public boolean updateEnrollment(Enrollment enrollment) throws SQLException {
        String sql = "UPDATE enrollments SET student_id = ?, course_id = ?, semester = ?, academic_year = ?, status = ?, grade = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, enrollment.getStudentId());
            pstmt.setInt(2, enrollment.getCourseId());
            pstmt.setString(3, enrollment.getSemester());
            pstmt.setString(4, enrollment.getAcademicYear());
            pstmt.setString(5, enrollment.getStatus());
            pstmt.setString(6, enrollment.getGrade());
            pstmt.setInt(7, enrollment.getId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    /**
     * Drop a course (update status to DROPPED)
     * @param enrollmentId Enrollment ID
     * @return true if drop successful
     * @throws SQLException if database operation fails
     */
    public boolean dropCourse(int enrollmentId) throws SQLException {
        String sql = "UPDATE enrollments SET status = 'DROPPED' WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, enrollmentId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    /**
     * Delete enrollment
     * @param id Enrollment ID
     * @return true if delete successful
     * @throws SQLException if database operation fails
     */
    public boolean deleteEnrollment(int id) throws SQLException {
        String sql = "DELETE FROM enrollments WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    /**
     * Get enrollment count by student
     * @param studentId Student ID
     * @return Count of active enrollments
     * @throws SQLException if database operation fails
     */
    public int getEnrollmentCountByStudent(int studentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE student_id = ? AND status = 'ACTIVE'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        
        return 0;
    }
    
    /**
     * Get enrollment count by course
     * @param courseId Course ID
     * @return Count of active enrollments
     * @throws SQLException if database operation fails
     */
    public int getEnrollmentCountByCourse(int courseId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE course_id = ? AND status = 'ACTIVE'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, courseId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        
        return 0;
    }
    
    /**
     * Extract Enrollment object from ResultSet
     * @param rs ResultSet
     * @return Enrollment object
     * @throws SQLException if database operation fails
     */
    private Enrollment extractEnrollmentFromResultSet(ResultSet rs) throws SQLException {
        Enrollment enrollment = new Enrollment();
        enrollment.setId(rs.getInt("id"));
        enrollment.setStudentId(rs.getInt("student_id"));
        enrollment.setCourseId(rs.getInt("course_id"));
        enrollment.setSemester(rs.getString("semester"));
        enrollment.setAcademicYear(rs.getString("academic_year"));
        enrollment.setEnrollmentDate(rs.getTimestamp("enrollment_date"));
        enrollment.setStatus(rs.getString("status"));
        enrollment.setGrade(rs.getString("grade"));
        enrollment.setCreatedAt(rs.getTimestamp("created_at"));
        enrollment.setUpdatedAt(rs.getTimestamp("updated_at"));
        return enrollment;
    }
}
