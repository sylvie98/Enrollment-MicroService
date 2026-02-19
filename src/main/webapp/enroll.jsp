<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Enrollment - Enrollment Service</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .content-wrapper {
            padding: 40px 0;
        }
        .card {
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: bold;
        }
        .btn-primary {
            background-color: #667eea;
            border-color: #667eea;
        }
        .btn-primary:hover {
            background-color: #764ba2;
            border-color: #764ba2;
        }
        .form-label {
            font-weight: 500;
        }
        .required::after {
            content: " *";
            color: red;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/header.jsp" %>

    <div class="container content-wrapper">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-user-plus"></i> Create New Enrollment</h5>
                    </div>
                    <div class="card-body">
                        <form id="enrollmentForm">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label required">Student</label>
                                    <select class="form-control" id="studentSelect" name="studentId" required>
                                        <option value="">Select a student...</option>
                                    </select>
                                    <input type="hidden" id="studentId" name="studentId">
                                    <div class="form-text">Search and select a student by name</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label required">Course</label>
                                    <select class="form-control" id="courseSelect" name="courseId" required>
                                        <option value="">Select a course...</option>
                                    </select>
                                    <input type="hidden" id="courseId" name="courseId">
                                    <div class="form-text">Search and select a course by name</div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label required">Semester</label>
                                    <select class="form-control" id="semester" name="semester" required>
                                        <option value="">Select Semester</option>
                                        <option value="FIRST">First Semester</option>
                                        <option value="SECOND">Second Semester</option>
                                        <option value="SUMMER">Summer Semester</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label required">Academic Year</label>
                                    <input type="text" class="form-control" id="academicYear" name="academicYear" 
                                           placeholder="2024-2025" required pattern="\d{4}-\d{4}">
                                    <div class="form-text">Format: YYYY-YYYY (e.g., 2024-2025)</div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Additional Notes</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3" 
                                          placeholder="Enter any additional information (optional)"></textarea>
                            </div>

                            <hr>

                            <div class="alert alert-info">
                                <i class="fas fa-info-circle"></i>
                                <strong>Note:</strong> The system will validate that:
                                <ul class="mb-0 mt-2">
                                    <li>Student ID exists in the Student Service</li>
                                    <li>Course ID exists in the Course Service</li>
                                    <li>Student is not already enrolled in this course for the selected semester</li>
                                </ul>
                            </div>

                            <div id="formMessage"></div>

                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/enrollments.jsp" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Create Enrollment
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Quick Access Card -->
                <div class="card mt-4">
                    <div class="card-header">
                        <h6 class="mb-0"><i class="fas fa-link"></i> Quick Links</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-2">
                                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary w-100">
                                    <i class="fas fa-home"></i> Home
                                </a>
                            </div>
                            <div class="col-md-6 mb-2">
                                <a href="${pageContext.request.contextPath}/enrollments.jsp" class="btn btn-outline-primary w-100">
                                    <i class="fas fa-list"></i> All Enrollments
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js"></script>
    <script>
        const BASE_URL = window.location.origin + '${pageContext.request.contextPath}';

        // Load students and courses on page load
        window.addEventListener('DOMContentLoaded', async function() {
            await loadStudents();
            await loadCourses();
            
            // Auto-fill academic year with current year
            const year = new Date().getFullYear();
            document.getElementById('academicYear').value = year + '-' + (year + 1);
        });

        async function loadStudents() {
            try {
                const response = await fetch(BASE_URL + '/api/students');
                const result = await response.json();
                
                if (result.success && result.data) {
                    const select = document.getElementById('studentSelect');
                    result.data.forEach(student => {
                        const option = document.createElement('option');
                        option.value = student.id;
                        option.textContent = student.name + ' (' + student.email + ')';
                        select.appendChild(option);
                    });
                }
            } catch (error) {
                console.error('Error loading students:', error);
            }
        }

        async function loadCourses() {
            try {
                const response = await fetch(BASE_URL + '/api/courses');
                const result = await response.json();
                
                if (result.success && result.data) {
                    const select = document.getElementById('courseSelect');
                    result.data.forEach(course => {
                        const option = document.createElement('option');
                        option.value = course.id;
                        option.textContent = course.name + ' (' + course.code + ')';
                        select.appendChild(option);
                    });
                }
            } catch (error) {
                console.error('Error loading courses:', error);
            }
        }

        document.getElementById('enrollmentForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Creating...';
            
            const data = {
                studentId: parseInt(document.getElementById('studentSelect').value),
                courseId: parseInt(document.getElementById('courseSelect').value),
                semester: document.getElementById('semester').value,
                academicYear: document.getElementById('academicYear').value
            };

            try {
                const response = await fetch(BASE_URL + '/api/enrollments', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify(data)
                });

                const result = await response.json();
                const messageDiv = document.getElementById('formMessage');
                
                if (result.success) {
                    messageDiv.innerHTML = 
                        '<div class="alert alert-success alert-dismissible fade show">' +
                            '<i class="fas fa-check-circle"></i> Student enrolled successfully' +
                            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                        '</div>';
                    
                    // Reset form
                    this.reset();
                    
                    // Redirect after 2 seconds
                    setTimeout(() => {
                        window.location.href = BASE_URL + '/enrollments.jsp';
                    }, 2000);
                } else {
                    messageDiv.innerHTML = 
                        '<div class="alert alert-danger alert-dismissible fade show">' +
                            '<i class="fas fa-exclamation-circle"></i> ' + result.message +
                            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                        '</div>';
                }
            } catch (error) {
                document.getElementById('formMessage').innerHTML = 
                    '<div class="alert alert-danger alert-dismissible fade show">' +
                        '<i class="fas fa-exclamation-triangle"></i> Error: ' + error.message +
                        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                    '</div>';
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            }
        });
    </script>
</body>
</html>
