# Enrollment Microservice - SmartCampus System

## Project Overview
This is the **Enrollment Service** microservice developed for the SmartCampus University Management System. This service is part of a distributed microservice architecture where each service operates independently with its own database.

**Group:** E  
**Service:** Enrollment Management  
**Technology Stack:** Java Servlet, JSP, JDBC, MySQL, Apache Tomcat

---

## Features

### Core Functionality
✅ **Enroll Student in Course** - Register students for courses with semester and academic year tracking  
✅ **Drop Course** - Allow students to drop enrolled courses  
✅ **View Enrollment History** - Display complete enrollment history for students  
✅ **Manage Semester Enrollments** - Track enrollments by semester and academic year  
✅ **Enrollment Statistics** - Provide enrollment counts for students and courses  

### API Endpoints

#### 1. Enrollment Management
- `POST /api/enrollments` - Create new enrollment
- `GET /api/enrollments` - Get all enrollments
- `GET /api/enrollments/{id}` - Get enrollment by ID
- `GET /api/enrollments?studentId={id}` - Get student enrollment history
- `GET /api/enrollments?courseId={id}` - Get course enrollments
- `GET /api/enrollments?semester={sem}&academicYear={year}` - Get enrollments by semester
- `PUT /api/enrollments/{id}` - Update enrollment
- `DELETE /api/enrollments/{id}` - Delete enrollment

#### 2. Course Operations
- `POST /api/enrollments/drop/{id}` - Drop a course

#### 3. Statistics (Dummy Endpoints for Other Services)
- `GET /api/stats/student/{studentId}` - Get active enrollment count for student
- `GET /api/stats/course/{courseId}` - Get total enrollment count for course

---

## Project Structure

```
src/
├── main/
│   ├── java/
│   │   └── com/groupe/enrollementmicroservice/
│   │       ├── controller/          # Servlet Controllers
│   │       │   ├── EnrollmentServlet.java
│   │       │   ├── DropCourseServlet.java
│   │       │   └── EnrollmentStatsServlet.java
│   │       ├── service/             # Business Logic Layer
│   │       │   └── EnrollmentService.java
│   │       ├── dao/                 # Data Access Layer
│   │       │   └── EnrollmentDAO.java
│   │       ├── model/               # Domain Models
│   │       │   └── Enrollment.java
│   │       └── util/                # Utility Classes
│   │           ├── DBConnection.java
│   │           ├── JsonUtil.java
│   │           └── HttpClient.java
│   ├── webapp/
│   │   ├── index.jsp               # Main UI
│   │   └── WEB-INF/
│   │       └── web.xml             # Servlet Configuration
│   └── resources/
└── database.sql                     # Database Schema
```

---

## Database Schema

### Table: enrollments
```sql
CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester VARCHAR(20) NOT NULL,
    academic_year VARCHAR(10) NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    grade VARCHAR(5) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_enrollment (student_id, course_id, semester, academic_year)
);
```

**Status Values:** `ACTIVE`, `DROPPED`, `COMPLETED`

---

## Setup Instructions

### Prerequisites
- **Java JDK** 17 or higher
- **MySQL** 8.0 or higher
- **Maven** 3.6 or higher (Maven wrapper included: `mvnw`)

### Step 1: Setup MySQL Database

1. **Install MySQL** (if not already installed)
   - Download from: https://dev.mysql.com/downloads/mysql/
   - Or use your package manager

2. **Create Database**
   ```sql
   CREATE DATABASE enrollment_service_db;
   ```

3. **Import Database Schema**
   ```bash
   mysql -u root -p enrollment_service_db < database.sql
   ```

### Step 2: Configure Database Connection

Update the password in `src/main/java/com/groupe/enrollementmicroservice/util/DBConnection.java`:

```java
private static final String DB_PASSWORD = ""; // Set your MySQL root password
```

### Step 3: Build the Application

```bash
./mvnw clean package
```

### Step 4: Run the Application

**Option A: Using Maven (Recommended)**
```bash
./mvnw cargo:run
```
Application runs at: http://localhost:8080/

**Option B: Deploy to Tomcat**
1. Copy WAR file to Tomcat:
   ```bash
   cp target/enrollment-service.war $TOMCAT_HOME/webapps/
   ```
2. Start Tomcat and access: http://localhost:8080/enrollment-service/

### Step 5: Access the Application

- **Homepage:** http://localhost:8080/
- **Enrollment Form:** http://localhost:8080/enroll.jsp
- **View All Enrollments:** http://localhost:8080/enrollments.jsp
- **Student History:** http://localhost:8080/student-history.jsp
- **Statistics:** http://localhost:8080/statistics.jsp
- **API Base:** http://localhost:8080/api/enrollments

---

## API Usage Examples

### 1. Create Enrollment
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

**Response:**
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
    "status": "ACTIVE"
  }
}
```

### 2. Get Student Enrollment History
```bash
curl http://localhost:8080/Enrollment-MicroService/api/enrollments?studentId=1
```

### 3. Drop Course
```bash
curl -X POST http://localhost:8080/Enrollment-MicroService/api/enrollments/drop/1
```

### 4. Get Enrollment Statistics
```bash
# Student enrollment count
curl http://localhost:8080/Enrollment-MicroService/api/stats/student/1

# Course enrollment count
curl http://localhost:8080/Enrollment-MicroService/api/stats/course/101
```

---

## Inter-Service Communication

This service is designed to communicate with other microservices:

### Dependencies (Consumes from):
- **Student Service** - Validates student existence before enrollment
- **Course Service** - Validates course existence before enrollment

### Provides Data To:
- **Result Service** - Enrollment information for grade management
- **Attendance Service** - Enrollment status for attendance tracking
- **Reporting Service** - Enrollment statistics and counts

### Configuration
Update service URLs in `EnrollmentService.java`:
```java
private static final String STUDENT_SERVICE_URL = "http://localhost:8081/student-service/api/students";
private static final String COURSE_SERVICE_URL = "http://localhost:8082/course-service/api/courses";
```

---

## Running on Different Port

To run on a different port (e.g., 8083):

1. Edit `$TOMCAT_HOME/conf/server.xml`:
```xml
<Connector port="8083" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443" />
```

2. Restart Tomcat

---

## Testing

### Manual Testing via UI
1. Open http://localhost:8080/Enrollment-MicroService/
2. Use the web interface to:
   - Enroll students
   - View all enrollments
   - Search student history
   - View statistics

### API Testing with Postman
Import the following endpoints into Postman:
- All endpoints listed in the API Endpoints section above

### Database Testing
```sql
-- Check all enrollments
SELECT * FROM enrollments;

-- Check active enrollments for a student
SELECT * FROM enrollments WHERE student_id = 1 AND status = 'ACTIVE';

-- Check enrollment count for a course
SELECT COUNT(*) FROM enrollments WHERE course_id = 101 AND status = 'ACTIVE';
```

---

## Troubleshooting

### Common Issues

**1. Database Connection Failed**
- Verify MySQL is running: `sudo systemctl status mysql`
- Check credentials in `DBConnection.java`
- Ensure database exists: `SHOW DATABASES;`

**2. 404 Error on API Calls**
- Verify WAR is deployed: Check `$TOMCAT_HOME/webapps/`
- Check Tomcat logs: `$TOMCAT_HOME/logs/catalina.out`
- Verify servlet URL patterns in code

**3. CORS Issues**
- Add CORS filter in `web.xml` if calling from different origin

**4. JSON Parsing Errors**
- Ensure request Content-Type is `application/json`
- Validate JSON structure matches expected format

---

## Architecture Principles

✅ **Independent Database** - Uses `enrollment_service_db` exclusively  
✅ **No Direct Database Access** - Other services must use HTTP APIs  
✅ **RESTful Design** - Follows REST principles for all endpoints  
✅ **MVC Architecture** - Clear separation: Model, View, Controller  
✅ **No External Frameworks** - Pure Servlet/JSP/JDBC as per requirements  

---

## Contributors

**Group E Members:**
- [Your Name]
- [Team Member 2]
- [Team Member 3]

---

## License

This project is developed as part of an academic assignment for the Distributed University Management System course.

---

## Contact

For questions or collaboration:
- **Email:** [your-email@example.com]
- **GitHub:** [your-github-username]

---

## Submission Checklist

✅ Clean project structure  
✅ Complete MVC implementation  
✅ All CRUD operations working  
✅ Database script included  
✅ README with setup instructions  
✅ Deployable WAR file  
✅ API documentation  
✅ Inter-service communication endpoints  
✅ UI with Bootstrap  
✅ JSON request/response handling

---

**Last Updated:** February 18, 2026