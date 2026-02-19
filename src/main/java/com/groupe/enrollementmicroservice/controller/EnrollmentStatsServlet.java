package com.groupe.enrollementmicroservice.controller;

import com.groupe.enrollementmicroservice.service.EnrollmentService;
import com.groupe.enrollementmicroservice.util.JsonUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Enrollment Statistics Servlet (Dummy Endpoint for Other Services)
 * Provides enrollment counts for students and courses
 * Endpoints:
 * - GET /api/stats/student/{studentId} - Get enrollment count for a student
 * - GET /api/stats/course/{courseId} - Get enrollment count for a course
 */
@WebServlet("/api/stats/*")
public class EnrollmentStatsServlet extends HttpServlet {
    
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
            if (pathInfo == null || pathInfo.equals("/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(JsonUtil.errorResponse("Invalid endpoint"));
                out.flush();
                return;
            }
            
            String[] pathParts = pathInfo.split("/");
            
            if (pathParts.length < 3) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(JsonUtil.errorResponse("Invalid endpoint format"));
                out.flush();
                return;
            }
            
            String type = pathParts[1]; // "student" or "course"
            int id = Integer.parseInt(pathParts[2]);
            
            int count;
            String message;
            
            if ("student".equals(type)) {
                count = enrollmentService.getEnrollmentCountByStudent(id);
                message = "Student enrollment count retrieved successfully";
            } else if ("course".equals(type)) {
                count = enrollmentService.getEnrollmentCountByCourse(id);
                message = "Course enrollment count retrieved successfully";
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(JsonUtil.errorResponse("Invalid stats type. Use 'student' or 'course'"));
                out.flush();
                return;
            }
            
            response.setStatus(HttpServletResponse.SC_OK);
            out.print(JsonUtil.successResponse(message, count));
            
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
