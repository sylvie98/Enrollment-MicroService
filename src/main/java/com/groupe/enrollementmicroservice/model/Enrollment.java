package com.groupe.enrollementmicroservice.model;

import java.sql.Timestamp;

/**
 * Enrollment Model Class
 * Represents a student enrollment in a course
 */
public class Enrollment {
    
    private int id;
    private int studentId;
    private int courseId;
    private String semester;
    private String academicYear;
    private Timestamp enrollmentDate;
    private String status; // ACTIVE, DROPPED, COMPLETED
    private String grade;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Constructors
    public Enrollment() {
    }
    
    public Enrollment(int studentId, int courseId, String semester, String academicYear) {
        this.studentId = studentId;
        this.courseId = courseId;
        this.semester = semester;
        this.academicYear = academicYear;
        this.status = "ACTIVE";
    }
    
    public Enrollment(int id, int studentId, int courseId, String semester, String academicYear, 
                     Timestamp enrollmentDate, String status, String grade, 
                     Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.studentId = studentId;
        this.courseId = courseId;
        this.semester = semester;
        this.academicYear = academicYear;
        this.enrollmentDate = enrollmentDate;
        this.status = status;
        this.grade = grade;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getStudentId() {
        return studentId;
    }
    
    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }
    
    public int getCourseId() {
        return courseId;
    }
    
    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }
    
    public String getSemester() {
        return semester;
    }
    
    public void setSemester(String semester) {
        this.semester = semester;
    }
    
    public String getAcademicYear() {
        return academicYear;
    }
    
    public void setAcademicYear(String academicYear) {
        this.academicYear = academicYear;
    }
    
    public Timestamp getEnrollmentDate() {
        return enrollmentDate;
    }
    
    public void setEnrollmentDate(Timestamp enrollmentDate) {
        this.enrollmentDate = enrollmentDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getGrade() {
        return grade;
    }
    
    public void setGrade(String grade) {
        this.grade = grade;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    @Override
    public String toString() {
        return "Enrollment{" +
                "id=" + id +
                ", studentId=" + studentId +
                ", courseId=" + courseId +
                ", semester='" + semester + '\'' +
                ", academicYear='" + academicYear + '\'' +
                ", enrollmentDate=" + enrollmentDate +
                ", status='" + status + '\'' +
                ", grade='" + grade + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
