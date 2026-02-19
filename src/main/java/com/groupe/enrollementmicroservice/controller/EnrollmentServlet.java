package com.groupe.enrollementmicroservice.controller;

import com.groupe.enrollementmicroservice.model.Enrollment;
import com.groupe.enrollementmicroservice.service.EnrollmentService;
import com.groupe.enrollementmicroservice.util.JsonUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Main Enrollment Controller Servlet
 * Handles all enrollment-related HTTP requests
 * Endpoints:
 * - GET /api/enrollments - Get all enrollments
 * - POST /api/enrollments - Create new enrollment
 * - GET /api/enrollments/{id} - Get enrollment by ID
 * - PUT /api/enrollments/{id} - Update enrollment
 * - DELETE /api/enrollments/{id} - Delete enrollment
 */
@WebServlet("/api/enrollments/*")
public class EnrollmentServlet extends HttpServlet {
    
    private EnrollmentService enrollmentService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        enrollmentService = new EnrollmentService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String pathInfo = request.getPathInfo();
        
        try {
            // Get enrollment by ID
            if (pathInfo != null && !pathInfo.equals("/")) {
                String[] pathParts = pathInfo.split("/");
                if (pathParts.length > 1) {
                    int id = Integer.parseInt(pathParts[1]);
                    Enrollment enrollment = enrollmentService.getEnrollmentById(id);
                    
                    response.setStatus(HttpServletResponse.SC_OK);
                    out.print(JsonUtil.successResponse("Enrollment retrieved successfully", enrollment));
                }
            } 
            // Get all enrollments or filter by parameters
            else {
                String studentIdParam = request.getParameter("studentId");
                String courseIdParam = request.getParameter("courseId");
                String semester = request.getParameter("semester");
                String academicYear = request.getParameter("academicYear");
                
                List<Enrollment> enrollments;
                
                if (studentIdParam != null) {
                    int studentId = Integer.parseInt(studentIdParam);
                    enrollments = enrollmentService.getStudentEnrollmentHistory(studentId);
                } else if (courseIdParam != null) {
                    int courseId = Integer.parseInt(courseIdParam);
                    enrollments = enrollmentService.getCourseEnrollments(courseId);
                } else if (semester != null && academicYear != null) {
                    enrollments = enrollmentService.getEnrollmentsBySemester(semester, academicYear);
                } else {
                    enrollments = enrollmentService.getAllEnrollments();
                }
                
                response.setStatus(HttpServletResponse.SC_OK);
                out.print(JsonUtil.successResponse("Enrollments retrieved successfully", enrollments));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(JsonUtil.errorResponse("Invalid ID format"));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(JsonUtil.errorResponse(e.getMessage()));
        }
        
        out.flush();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Read JSON from request body
            StringBuilder jsonBuilder = new StringBuilder();
            String line;
            BufferedReader reader = request.getReader();
            while ((line = reader.readLine()) != null) {
                jsonBuilder.append(line);
            }
            String json = jsonBuilder.toString();
            
            // Parse JSON manually
            int studentId = Integer.parseInt(JsonUtil.parseValue(json, "studentId"));
            int courseId = Integer.parseInt(JsonUtil.parseValue(json, "courseId"));
            String semester = JsonUtil.parseValue(json, "semester");
            String academicYear = JsonUtil.parseValue(json, "academicYear");
            
            // Create enrollment object
            Enrollment enrollment = new Enrollment(studentId, courseId, semester, academicYear);
            
            // Save enrollment
            Enrollment createdEnrollment = enrollmentService.enrollStudent(enrollment);
            
            response.setStatus(HttpServletResponse.SC_CREATED);
            out.print(JsonUtil.successResponse("Enrollment created successfully", createdEnrollment));
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(JsonUtil.errorResponse("Invalid input data format"));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(JsonUtil.errorResponse(e.getMessage()));
        }
        
        out.flush();
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(JsonUtil.errorResponse("Enrollment ID is required"));
                out.flush();
                return;
            }
            
            String[] pathParts = pathInfo.split("/");
            int id = Integer.parseInt(pathParts[1]);
            
            // Read JSON from request body
            StringBuilder jsonBuilder = new StringBuilder();
            String line;
            BufferedReader reader = request.getReader();
            while ((line = reader.readLine()) != null) {
                jsonBuilder.append(line);
            }
            String json = jsonBuilder.toString();
            
            // Parse JSON
            int studentId = Integer.parseInt(JsonUtil.parseValue(json, "studentId"));
            int courseId = Integer.parseInt(JsonUtil.parseValue(json, "courseId"));
            String semester = JsonUtil.parseValue(json, "semester");
            String academicYear = JsonUtil.parseValue(json, "academicYear");
            String status = JsonUtil.parseValue(json, "status");
            String grade = JsonUtil.parseValue(json, "grade");
            
            // Create enrollment object
            Enrollment enrollment = new Enrollment(studentId, courseId, semester, academicYear);
            enrollment.setId(id);
            enrollment.setStatus(status);
            enrollment.setGrade(grade);
            
            // Update enrollment
            boolean updated = enrollmentService.updateEnrollment(enrollment);
            
            if (updated) {
                Enrollment updatedEnrollment = enrollmentService.getEnrollmentById(id);
                response.setStatus(HttpServletResponse.SC_OK);
                out.print(JsonUtil.successResponse("Enrollment updated successfully", updatedEnrollment));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(JsonUtil.errorResponse("Failed to update enrollment"));
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(JsonUtil.errorResponse("Invalid ID or data format"));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(JsonUtil.errorResponse(e.getMessage()));
        }
        
        out.flush();
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(JsonUtil.errorResponse("Enrollment ID is required"));
                out.flush();
                return;
            }
            
            String[] pathParts = pathInfo.split("/");
            int id = Integer.parseInt(pathParts[1]);
            
            boolean deleted = enrollmentService.deleteEnrollment(id);
            
            if (deleted) {
                response.setStatus(HttpServletResponse.SC_OK);
                out.print(JsonUtil.successResponse("Enrollment deleted successfully", null));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(JsonUtil.errorResponse("Failed to delete enrollment"));
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(JsonUtil.errorResponse("Invalid ID format"));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(JsonUtil.errorResponse(e.getMessage()));
        }
        
        out.flush();
    }
}
