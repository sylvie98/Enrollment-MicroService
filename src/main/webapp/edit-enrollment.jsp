<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Enrollment - Enrollment Service</title>
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
        .loading {
            text-align: center;
            padding: 50px;
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
                        <h5 class="mb-0"><i class="fas fa-edit"></i> Edit Enrollment</h5>
                    </div>
                    <div class="card-body" id="formContainer">
                        <div class="loading">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <p class="mt-2">Loading enrollment details...</p>
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
        let enrollmentId = null;
        let studentsData = [];
        let coursesData = [];

        window.addEventListener('DOMContentLoaded', async function() {
            const urlParams = new URLSearchParams(window.location.search);
            enrollmentId = urlParams.get('id');
            
            if (!enrollmentId) {
                alert('No enrollment ID provided');
                window.location.href = BASE_URL + '/enrollments.jsp';
                return;
            }
            
            await loadLookupData();
            loadEnrollment();
        });

        async function loadLookupData() {
            try {
                // Load students
                const studentsResponse = await fetch(BASE_URL + '/api/students');
                const studentsResult = await studentsResponse.json();
                if (studentsResult.success && studentsResult.data) {
                    studentsData = studentsResult.data;
                }

                // Load courses
                const coursesResponse = await fetch(BASE_URL + '/api/courses');
                const coursesResult = await coursesResponse.json();
                if (coursesResult.success && coursesResult.data) {
                    coursesData = coursesResult.data;
                }
            } catch (error) {
                console.error('Error loading lookup data:', error);
            }
        }

        async function loadEnrollment() {
            try {
                const response = await fetch(BASE_URL + '/api/enrollments/' + enrollmentId);
                const result = await response.json();
                
                if (result.success && result.data) {
                    displayEditForm(result.data);
                } else {
                    document.getElementById('formContainer').innerHTML = 
                        '<div class="alert alert-danger">Enrollment not found</div>';
                }
            } catch (error) {
                document.getElementById('formContainer').innerHTML = 
                    '<div class="alert alert-danger">Error loading enrollment: ' + error.message + '</div>';
            }
        }

        function displayEditForm(enrollment) {
            let studentOptions = '<option value="">Select a student...</option>';
            studentsData.forEach(student => {
                const selected = student.id == enrollment.studentId ? ' selected' : '';
                studentOptions += '<option value="' + student.id + '"' + selected + '>' + student.name + ' (' + student.email + ')</option>';
            });

            let courseOptions = '<option value="">Select a course...</option>';
            coursesData.forEach(course => {
                const selected = course.id == enrollment.courseId ? ' selected' : '';
                courseOptions += '<option value="' + course.id + '"' + selected + '>' + course.name + ' (' + course.code + ')</option>';
            });

            const formHtml = 
                '<form id="editEnrollmentForm">' +
                    '<input type="hidden" id="enrollmentId" value="' + enrollment.id + '">' +
                    '<div class="row">' +
                        '<div class="col-md-6 mb-3">' +
                            '<label class="form-label required">Student</label>' +
                            '<select class="form-control" id="studentSelect" required>' +
                                studentOptions +
                            '</select>' +
                        '</div>' +
                        '<div class="col-md-6 mb-3">' +
                            '<label class="form-label required">Course</label>' +
                            '<select class="form-control" id="courseSelect" required>' +
                                courseOptions +
                            '</select>' +
                        '</div>' +
                    '</div>' +
                    '<div class="row">' +
                        '<div class="col-md-6 mb-3">' +
                            '<label class="form-label required">Semester</label>' +
                            '<select class="form-control" id="semester" required>' +
                                '<option value="">Select Semester</option>' +
                                '<option value="FIRST"' + (enrollment.semester === 'FIRST' ? ' selected' : '') + '>First Semester</option>' +
                                '<option value="SECOND"' + (enrollment.semester === 'SECOND' ? ' selected' : '') + '>Second Semester</option>' +
                                '<option value="SUMMER"' + (enrollment.semester === 'SUMMER' ? ' selected' : '') + '>Summer Semester</option>' +
                            '</select>' +
                        '</div>' +
                        '<div class="col-md-6 mb-3">' +
                            '<label class="form-label required">Academic Year</label>' +
                            '<input type="text" class="form-control" id="academicYear" value="' + enrollment.academicYear + '" required pattern="\\d{4}-\\d{4}">' +
                            '<div class="form-text">Format: YYYY-YYYY (e.g., 2024-2025)</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="row">' +
                        '<div class="col-md-6 mb-3">' +
                            '<label class="form-label required">Status</label>' +
                            '<select class="form-control" id="status" required>' +
                                '<option value="ACTIVE"' + (enrollment.status === 'ACTIVE' ? ' selected' : '') + '>Active</option>' +
                                '<option value="COMPLETED"' + (enrollment.status === 'COMPLETED' ? ' selected' : '') + '>Completed</option>' +
                                '<option value="DROPPED"' + (enrollment.status === 'DROPPED' ? ' selected' : '') + '>Dropped</option>' +
                            '</select>' +
                        '</div>' +
                        '<div class="col-md-6 mb-3">' +
                            '<label class="form-label">Grade</label>' +
                            '<input type="text" class="form-control" id="grade" value="' + (enrollment.grade || '') + '" placeholder="A, B, C, etc.">' +
                            '<div class="form-text">Optional: Enter final grade if completed</div>' +
                        '</div>' +
                    '</div>' +
                    '<hr>' +
                    '<div class="d-flex justify-content-between">' +
                        '<a href="' + BASE_URL + '/enrollments.jsp" class="btn btn-secondary">' +
                            '<i class="fas fa-arrow-left"></i> Cancel' +
                        '</a>' +
                        '<button type="submit" class="btn btn-primary">' +
                            '<i class="fas fa-save"></i> Update Enrollment' +
                        '</button>' +
                    '</div>' +
                '</form>';
            
            document.getElementById('formContainer').innerHTML = formHtml;
            document.getElementById('editEnrollmentForm').addEventListener('submit', updateEnrollment);
        }

        async function updateEnrollment(e) {
            e.preventDefault();
            
            const submitBtn = document.querySelector('button[type="submit"]');
            const originalHtml = submitBtn.innerHTML;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
            
            const enrollmentData = {
                studentId: parseInt(document.getElementById('studentSelect').value),
                courseId: parseInt(document.getElementById('courseSelect').value),
                semester: document.getElementById('semester').value,
                academicYear: document.getElementById('academicYear').value,
                status: document.getElementById('status').value,
                grade: document.getElementById('grade').value || null
            };
            
            try {
                const response = await fetch(BASE_URL + '/api/enrollments/' + enrollmentId, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(enrollmentData)
                });
                
                const result = await response.json();
                
                if (result.success) {
                    showSuccessMessage('Enrollment updated successfully!');
                    setTimeout(() => {
                        window.location.href = BASE_URL + '/enrollments.jsp';
                    }, 1500);
                } else {
                    showErrorMessage('Error: ' + result.message);
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = originalHtml;
                }
            } catch (error) {
                showErrorMessage('Error updating enrollment: ' + error.message);
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalHtml;
            }
        }

        function showSuccessMessage(message) {
            const alert = document.createElement('div');
            alert.className = 'alert alert-success alert-dismissible fade show';
            alert.innerHTML = 
                '<i class="fas fa-check-circle"></i> ' + message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
            
            const formContainer = document.getElementById('formContainer');
            formContainer.insertBefore(alert, formContainer.firstChild);
        }

        function showErrorMessage(message) {
            const alert = document.createElement('div');
            alert.className = 'alert alert-danger alert-dismissible fade show';
            alert.innerHTML = 
                '<i class="fas fa-exclamation-circle"></i> ' + message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
            
            const formContainer = document.getElementById('formContainer');
            formContainer.insertBefore(alert, formContainer.firstChild);
            
            setTimeout(() => alert.remove(), 5000);
        }
    </script>
</body>
</html>
