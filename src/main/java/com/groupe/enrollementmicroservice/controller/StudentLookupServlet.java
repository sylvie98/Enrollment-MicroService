package com.groupe.enrollementmicroservice.controller;

import com.groupe.enrollementmicroservice.util.JsonUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Student Lookup Servlet
 * Provides student data for enrollment forms
 * TODO: Replace with actual calls to Student Service microservice
 */
@WebServlet("/api/students/*")
public class StudentLookupServlet extends HttpServlet {
    
    // Mock student data - Replace with actual Student Service API calls
    private static final Map<Integer, Map<String, String>> STUDENTS = new HashMap<>();
    
    static {
        // Sample students for testing
        STUDENTS.put(1, createStudent(1, "John Doe", "john.doe@university.edu"));
        STUDENTS.put(2, createStudent(2, "Jane Smith", "jane.smith@university.edu"));
        STUDENTS.put(3, createStudent(3, "Robert Johnson", "robert.johnson@university.edu"));
        STUDENTS.put(4, createStudent(4, "Emily Davis", "emily.davis@university.edu"));
        STUDENTS.put(5, createStudent(5, "Michael Wilson", "michael.wilson@university.edu"));
        STUDENTS.put(6, createStudent(6, "Sarah Brown", "sarah.brown@university.edu"));
        STUDENTS.put(7, createStudent(7, "David Martinez", "david.martinez@university.edu"));
        STUDENTS.put(8, createStudent(8, "Lisa Garcia", "lisa.garcia@university.edu"));
        STUDENTS.put(9, createStudent(9, "James Anderson", "james.anderson@university.edu"));
        STUDENTS.put(10, createStudent(10, "Maria Rodriguez", "maria.rodriguez@university.edu"));
    }
    
    private static Map<String, String> createStudent(int id, String name, String email) {
        Map<String, String> student = new HashMap<>();
        student.put("id", String.valueOf(id));
        student.put("name", name);
        student.put("email", email);
        return student;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String pathInfo = request.getPathInfo();
        
        try {
            // Get student by ID
            if (pathInfo != null && !pathInfo.equals("/")) {
                String[] pathParts = pathInfo.split("/");
                if (pathParts.length > 1) {
                    int id = Integer.parseInt(pathParts[1]);
                    Map<String, String> student = STUDENTS.get(id);
                    
                    if (student != null) {
                        response.setStatus(HttpServletResponse.SC_OK);
                        out.print("{\"success\":true,\"message\":\"Student retrieved successfully\",\"data\":" + mapToJson(student) + "}");
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        out.print(JsonUtil.errorResponse("Student not found"));
                    }
                }
            } 
            // Get all students or search
            else {
                String searchQuery = request.getParameter("search");
                List<Map<String, String>> students = new ArrayList<>();
                
                for (Map<String, String> student : STUDENTS.values()) {
                    if (searchQuery == null || searchQuery.isEmpty() || 
                        student.get("name").toLowerCase().contains(searchQuery.toLowerCase()) ||
                        student.get("email").toLowerCase().contains(searchQuery.toLowerCase())) {
                        students.add(student);
                    }
                }
                
                response.setStatus(HttpServletResponse.SC_OK);
                out.print("{\"success\":true,\"message\":\"Students retrieved successfully\",\"data\":" + listToJson(students) + "}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(JsonUtil.errorResponse("Invalid student ID format"));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(JsonUtil.errorResponse(e.getMessage()));
        }
        
        out.flush();
    }
    
    private String mapToJson(Map<String, String> map) {
        StringBuilder json = new StringBuilder("{");
        int i = 0;
        for (Map.Entry<String, String> entry : map.entrySet()) {
            if (i > 0) json.append(",");
            json.append("\"").append(entry.getKey()).append("\":\"").append(entry.getValue()).append("\"");
            i++;
        }
        json.append("}");
        return json.toString();
    }
    
    private String listToJson(List<Map<String, String>> list) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) json.append(",");
            json.append(mapToJson(list.get(i)));
        }
        json.append("]");
        return json.toString();
    }
}
