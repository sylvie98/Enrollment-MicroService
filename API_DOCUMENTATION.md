# API Documentation - Enrollment Microservice

## Base URL
```
http://localhost:8080/Enrollment-MicroService/api
```

---

## Table of Contents
1. [Authentication](#authentication)
2. [Enrollment Endpoints](#enrollment-endpoints)
3. [Statistics Endpoints](#statistics-endpoints)
4. [Request/Response Formats](#request-response-formats)
5. [Error Handling](#error-handling)

---

## Authentication
Currently, this service does not require authentication for testing purposes. In production, integrate with the Authentication Service.

---

## Enrollment Endpoints

### 1. Create Enrollment
**Endpoint:** `POST /enrollments`  
**Description:** Enroll a student in a course

**Request Body:**
```json
{
  "studentId": 1,
  "courseId": 101,
  "semester": "FIRST",
  "academicYear": "2024-2025"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Enrollment created successfully",
  "data": {
    "id": 1,
    "studentId": 1,
    "courseId": 101,
    "semester": "FIRST",
    "academicYear": "2024-2025",
    "enrollmentDate": "2024-02-18 10:30:00",
    "status": "ACTIVE",
    "grade": null,
    "createdAt": "2024-02-18 10:30:00",
    "updatedAt": "2024-02-18 10:30:00"
  }
}
```

**Validation Rules:**
- Student ID must exist (validated via Student Service)
- Course ID must exist (validated via Course Service)
- Student cannot be enrolled in the same course for the same semester

**Error Response (400 Bad Request):**
```json
{
  "success": false,
  "message": "Student is already enrolled in this course for the given semester"
}
```

---

### 2. Get All Enrollments
**Endpoint:** `GET /enrollments`  
**Description:** Retrieve all enrollments

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Enrollments retrieved successfully",
  "data": [
    {
      "id": 1,
      "studentId": 1,
      "courseId": 101,
      "semester": "FIRST",
      "academicYear": "2024-2025",
      "status": "ACTIVE"
    },
    ...
  ]
}
```

---

### 3. Get Enrollment by ID
**Endpoint:** `GET /enrollments/{id}`  
**Description:** Retrieve a specific enrollment

**Parameters:**
- `id` (path) - Enrollment ID

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Enrollment retrieved successfully",
  "data": {
    "id": 1,
    "studentId": 1,
    "courseId": 101,
    "semester": "FIRST",
    "academicYear": "2024-2025",
    "status": "ACTIVE"
  }
}
```

**Error Response (404 Not Found):**
```json
{
  "success": false,
  "message": "Enrollment not found with ID: 1"
}
```

---

### 4. Get Student Enrollment History
**Endpoint:** `GET /enrollments?studentId={studentId}`  
**Description:** Get all enrollments for a specific student

**Query Parameters:**
- `studentId` (required) - Student ID

**Example:**
```
GET /enrollments?studentId=1
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Enrollments retrieved successfully",
  "data": [
    {
      "id": 1,
      "studentId": 1,
      "courseId": 101,
      "semester": "FIRST",
      "academicYear": "2024-2025",
      "status": "ACTIVE",
      "grade": null
    },
    {
      "id": 2,
      "studentId": 1,
      "courseId": 102,
      "semester": "FIRST",
      "academicYear": "2024-2025",
      "status": "DROPPED",
      "grade": null
    }
  ]
}
```

---

### 5. Get Course Enrollments
**Endpoint:** `GET /enrollments?courseId={courseId}`  
**Description:** Get all students enrolled in a specific course

**Query Parameters:**
- `courseId` (required) - Course ID

**Example:**
```
GET /enrollments?courseId=101
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Enrollments retrieved successfully",
  "data": [
    {
      "id": 1,
      "studentId": 1,
      "courseId": 101,
      "semester": "FIRST",
      "academicYear": "2024-2025",
      "status": "ACTIVE"
    },
    {
      "id": 3,
      "studentId": 2,
      "courseId": 101,
      "semester": "FIRST",
      "academicYear": "2024-2025",
      "status": "ACTIVE"
    }
  ]
}
```

---

### 6. Get Enrollments by Semester
**Endpoint:** `GET /enrollments?semester={semester}&academicYear={year}`  
**Description:** Get all enrollments for a specific semester and academic year

**Query Parameters:**
- `semester` (required) - Semester (FIRST, SECOND, SUMMER)
- `academicYear` (required) - Academic year (e.g., 2024-2025)

**Example:**
```
GET /enrollments?semester=FIRST&academicYear=2024-2025
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Enrollments retrieved successfully",
  "data": [...]
}
```

---

### 7. Update Enrollment
**Endpoint:** `PUT /enrollments/{id}`  
**Description:** Update an existing enrollment

**Request Body:**
```json
{
  "studentId": 1,
  "courseId": 101,
  "semester": "FIRST",
  "academicYear": "2024-2025",
  "status": "COMPLETED",
  "grade": "A"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Enrollment updated successfully",
  "data": {
    "id": 1,
    "studentId": 1,
    "courseId": 101,
    "semester": "FIRST",
    "academicYear": "2024-2025",
    "status": "COMPLETED",
    "grade": "A"
  }
}
```

---

### 8. Delete Enrollment
**Endpoint:** `DELETE /enrollments/{id}`  
**Description:** Delete an enrollment (hard delete)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Enrollment deleted successfully",
  "data": null
}
```

---

### 9. Drop Course
**Endpoint:** `POST /enrollments/drop/{id}`  
**Description:** Drop a course (soft delete - changes status to DROPPED)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Course dropped successfully",
  "data": null
}
```

**Error Response (400 Bad Request):**
```json
{
  "success": false,
  "message": "Course is already dropped"
}
```

---

## Statistics Endpoints

### 1. Get Student Enrollment Count
**Endpoint:** `GET /stats/student/{studentId}`  
**Description:** Get the number of active enrollments for a student (Dummy endpoint for other services)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Student enrollment count retrieved successfully",
  "data": 5
}
```

**Use Case:** Other services (e.g., Student Service, Reporting Service) can call this endpoint to get enrollment statistics.

---

### 2. Get Course Enrollment Count
**Endpoint:** `GET /stats/course/{courseId}`  
**Description:** Get the total number of students enrolled in a course (Dummy endpoint for other services)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Course enrollment count retrieved successfully",
  "data": 25
}
```

**Use Case:** Course Service or Reporting Service can use this to display enrollment capacity.

---

## Request/Response Formats

### Standard Success Response
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { /* result data */ }
}
```

### Standard Error Response
```json
{
  "success": false,
  "message": "Error description"
}
```

---

## Error Handling

### HTTP Status Codes
- `200 OK` - Request succeeded
- `201 Created` - Resource created successfully
- `400 Bad Request` - Invalid request data
- `404 Not Found` - Resource not found
- `500 Internal Server Error` - Server error

### Common Error Messages
- `"Invalid student ID: {id}"` - Student validation failed
- `"Invalid course ID: {id}"` - Course validation failed
- `"Student is already enrolled in this course for the given semester"` - Duplicate enrollment
- `"Enrollment not found with ID: {id}"` - Enrollment does not exist
- `"Course is already dropped"` - Attempting to drop an already dropped course
- `"Invalid ID format"` - Non-numeric ID provided

---

## Testing with cURL

### Create Enrollment
```bash
curl -X POST http://localhost:8080/Enrollment-MicroService/api/enrollments \
  -H "Content-Type: application/json" \
  -d '{
    "studentId": 1,
    "courseId": 101,
    "semester": "FIRST",
    "academicYear": "2024-2025"
  }'
```

### Get All Enrollments
```bash
curl http://localhost:8080/Enrollment-MicroService/api/enrollments
```

### Get Student History
```bash
curl http://localhost:8080/Enrollment-MicroService/api/enrollments?studentId=1
```

### Drop Course
```bash
curl -X POST http://localhost:8080/Enrollment-MicroService/api/enrollments/drop/1
```

### Get Statistics
```bash
# Student stats
curl http://localhost:8080/Enrollment-MicroService/api/stats/student/1

# Course stats
curl http://localhost:8080/Enrollment-MicroService/api/stats/course/101
```

---

## Inter-Service Communication Examples

### From Student Service
```java
// Check enrollment count before allowing student deletion
String url = "http://localhost:8083/Enrollment-MicroService/api/stats/student/" + studentId;
String response = HttpClient.get(url);
// Parse response and check enrollment count
```

### From Result Service
```java
// Get enrollments to validate result entry
String url = "http://localhost:8083/Enrollment-MicroService/api/enrollments?studentId=" + studentId + "&courseId=" + courseId;
String response = HttpClient.get(url);
// Verify student is enrolled before adding results
```

### From Reporting Service
```java
// Get semester enrollment statistics
String url = "http://localhost:8083/Enrollment-MicroService/api/enrollments?semester=FIRST&academicYear=2024-2025";
String response = HttpClient.get(url);
// Use for generating reports
```

---

## Notes

1. **No Authentication Currently:** Authentication should be added by integrating with the Authentication Service (Group 1)

2. **Validation:** Student and course validations are currently dummy implementations. Update these when Student and Course services are available.

3. **CORS Enabled:** Cross-Origin Resource Sharing is enabled to allow inter-service communication.

4. **JSON Only:** All endpoints accept and return JSON format.

5. **Timestamps:** All timestamps are in format: `yyyy-MM-dd HH:mm:ss`

---

**Last Updated:** February 18, 2026  
**Version:** 1.0  
**Maintained By:** Group E
