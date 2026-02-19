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
 * Drop Course Servlet
 * Handles course drop functionality
 * Endpoint: POST /api/enrollments/drop/{id}
 */
@WebServlet("/api/enrollments/drop/*")
public class DropCourseServlet extends HttpServlet {
    
    private EnrollmentService enrollmentService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        enrollmentService = new EnrollmentService();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
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
            int enrollmentId = Integer.parseInt(pathParts[1]);
            
            boolean dropped = enrollmentService.dropCourse(enrollmentId);
            
            if (dropped) {
                response.setStatus(HttpServletResponse.SC_OK);
                out.print(JsonUtil.successResponse("Course dropped successfully", null));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(JsonUtil.errorResponse("Failed to drop course"));
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(JsonUtil.errorResponse("Invalid enrollment ID format"));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(JsonUtil.errorResponse(e.getMessage()));
        }
        
        out.flush();
    }
}
