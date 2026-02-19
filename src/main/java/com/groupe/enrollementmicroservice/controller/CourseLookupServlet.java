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
 * Course Lookup Servlet
 * Provides course data for enrollment forms
 * TODO: Replace with actual calls to Course Service microservice
 */
@WebServlet("/api/courses/*")
public class CourseLookupServlet extends HttpServlet {
    
    // Mock course data - Replace with actual Course Service API calls
    private static final Map<Integer, Map<String, String>> COURSES = new HashMap<>();
    
    static {
        // Sample courses for testing
        COURSES.put(101, createCourse(101, "Introduction to Computer Science", "CS101", "3"));
        COURSES.put(102, createCourse(102, "Data Structures and Algorithms", "CS102", "4"));
        COURSES.put(103, createCourse(103, "Database Management Systems", "CS201", "3"));
        COURSES.put(104, createCourse(104, "Web Development", "CS202", "3"));
        COURSES.put(105, createCourse(105, "Software Engineering", "CS301", "4"));
        COURSES.put(106, createCourse(106, "Operating Systems", "CS302", "3"));
        COURSES.put(107, createCourse(107, "Computer Networks", "CS303", "3"));
        COURSES.put(108, createCourse(108, "Artificial Intelligence", "CS401", "4"));
        COURSES.put(109, createCourse(109, "Machine Learning", "CS402", "3"));
        COURSES.put(110, createCourse(110, "Mobile Application Development", "CS403", "3"));
    }
    
    private static Map<String, String> createCourse(int id, String name, String code, String credits) {
        Map<String, String> course = new HashMap<>();
        course.put("id", String.valueOf(id));
        course.put("name", name);
        course.put("code", code);
        course.put("credits", credits);
        return course;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String pathInfo = request.getPathInfo();
        
        try {
            // Get course by ID
            if (pathInfo != null && !pathInfo.equals("/")) {
                String[] pathParts = pathInfo.split("/");
                if (pathParts.length > 1) {
                    int id = Integer.parseInt(pathParts[1]);
                    Map<String, String> course = COURSES.get(id);
                    
                    if (course != null) {
                        response.setStatus(HttpServletResponse.SC_OK);
                        out.print("{\"success\":true,\"message\":\"Course retrieved successfully\",\"data\":" + mapToJson(course) + "}");
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        out.print(JsonUtil.errorResponse("Course not found"));
                    }
                }
            } 
            // Get all courses or search
            else {
                String searchQuery = request.getParameter("search");
                List<Map<String, String>> courses = new ArrayList<>();
                
                for (Map<String, String> course : COURSES.values()) {
                    if (searchQuery == null || searchQuery.isEmpty() || 
                        course.get("name").toLowerCase().contains(searchQuery.toLowerCase()) ||
                        course.get("code").toLowerCase().contains(searchQuery.toLowerCase())) {
                        courses.add(course);
                    }
                }
                
                response.setStatus(HttpServletResponse.SC_OK);
                out.print("{\"success\":true,\"message\":\"Courses retrieved successfully\",\"data\":" + listToJson(courses) + "}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(JsonUtil.errorResponse("Invalid course ID format"));
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
