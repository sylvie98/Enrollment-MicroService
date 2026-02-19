package com.groupe.enrollementmicroservice.util;

import com.groupe.enrollementmicroservice.model.Enrollment;

import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Simple JSON Utility for Enrollment Service
 * Handles JSON serialization without external libraries
 */
public class JsonUtil {
    
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    
    /**
     * Convert Enrollment object to JSON string
     * @param enrollment Enrollment object
     * @return JSON string
     */
    public static String toJson(Enrollment enrollment) {
        if (enrollment == null) {
            return "{}";
        }
        
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"id\":").append(enrollment.getId()).append(",");
        json.append("\"studentId\":").append(enrollment.getStudentId()).append(",");
        json.append("\"courseId\":").append(enrollment.getCourseId()).append(",");
        json.append("\"semester\":").append(quote(enrollment.getSemester())).append(",");
        json.append("\"academicYear\":").append(quote(enrollment.getAcademicYear())).append(",");
        
        if (enrollment.getEnrollmentDate() != null) {
            json.append("\"enrollmentDate\":").append(quote(dateFormat.format(enrollment.getEnrollmentDate()))).append(",");
        }
        
        json.append("\"status\":").append(quote(enrollment.getStatus())).append(",");
        
        if (enrollment.getGrade() != null) {
            json.append("\"grade\":").append(quote(enrollment.getGrade()));
        } else {
            json.append("\"grade\":null");
        }
        
        if (enrollment.getCreatedAt() != null) {
            json.append(",\"createdAt\":").append(quote(dateFormat.format(enrollment.getCreatedAt())));
        }
        
        if (enrollment.getUpdatedAt() != null) {
            json.append(",\"updatedAt\":").append(quote(dateFormat.format(enrollment.getUpdatedAt())));
        }
        
        json.append("}");
        
        return json.toString();
    }
    
    /**
     * Convert list of Enrollments to JSON array string
     * @param enrollments List of enrollments
     * @return JSON array string
     */
    public static String toJsonArray(List<Enrollment> enrollments) {
        if (enrollments == null || enrollments.isEmpty()) {
            return "[]";
        }
        
        StringBuilder json = new StringBuilder();
        json.append("[");
        
        for (int i = 0; i < enrollments.size(); i++) {
            json.append(toJson(enrollments.get(i)));
            if (i < enrollments.size() - 1) {
                json.append(",");
            }
        }
        
        json.append("]");
        
        return json.toString();
    }
    
    /**
     * Create success response JSON
     * @param message Success message
     * @param data Data object (will be converted to JSON)
     * @return JSON response string
     */
    public static String successResponse(String message, Object data) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\":true,");
        json.append("\"message\":").append(quote(message)).append(",");
        json.append("\"data\":");
        
        if (data instanceof Enrollment) {
            json.append(toJson((Enrollment) data));
        } else if (data instanceof List) {
            json.append(toJsonArray((List<Enrollment>) data));
        } else if (data instanceof Integer) {
            json.append(data);
        } else if (data instanceof String) {
            json.append(quote((String) data));
        } else {
            json.append("null");
        }
        
        json.append("}");
        
        return json.toString();
    }
    
    /**
     * Create error response JSON
     * @param message Error message
     * @return JSON error response string
     */
    public static String errorResponse(String message) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\":false,");
        json.append("\"message\":").append(quote(message));
        json.append("}");
        
        return json.toString();
    }
    
    /**
     * Create simple JSON object with key-value pairs
     * @param key Key
     * @param value Value
     * @return JSON string
     */
    public static String simpleJson(String key, Object value) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append(quote(key)).append(":");
        
        if (value instanceof Integer) {
            json.append(value);
        } else if (value instanceof String) {
            json.append(quote((String) value));
        } else if (value instanceof Boolean) {
            json.append(value);
        } else {
            json.append(quote(value.toString()));
        }
        
        json.append("}");
        
        return json.toString();
    }
    
    /**
     * Quote a string for JSON
     * @param str String to quote
     * @return Quoted string
     */
    private static String quote(String str) {
        if (str == null) {
            return "null";
        }
        
        // Escape special characters
        String escaped = str.replace("\\", "\\\\")
                           .replace("\"", "\\\"")
                           .replace("\n", "\\n")
                           .replace("\r", "\\r")
                           .replace("\t", "\\t");
        
        return "\"" + escaped + "\"";
    }
    
    /**
     * Parse simple JSON value (basic implementation)
     * @param json JSON string
     * @param key Key to extract
     * @return Value as string
     */
    public static String parseValue(String json, String key) {
        if (json == null || key == null) {
            return null;
        }
        
        String searchKey = "\"" + key + "\":";
        int startIndex = json.indexOf(searchKey);
        
        if (startIndex == -1) {
            return null;
        }
        
        startIndex += searchKey.length();
        
        // Skip whitespace
        while (startIndex < json.length() && Character.isWhitespace(json.charAt(startIndex))) {
            startIndex++;
        }
        
        // Handle quoted strings
        if (json.charAt(startIndex) == '"') {
            startIndex++;
            int endIndex = json.indexOf('"', startIndex);
            if (endIndex != -1) {
                return json.substring(startIndex, endIndex);
            }
        } else {
            // Handle numbers or booleans
            int endIndex = startIndex;
            while (endIndex < json.length() && 
                   json.charAt(endIndex) != ',' && 
                   json.charAt(endIndex) != '}' && 
                   json.charAt(endIndex) != ']') {
                endIndex++;
            }
            return json.substring(startIndex, endIndex).trim();
        }
        
        return null;
    }
}
