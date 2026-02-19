<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistics Dashboard - Enrollment Service</title>
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
            margin-bottom: 20px;
        }
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: bold;
        }
        .stat-card {
            text-align: center;
            padding: 30px;
            border-radius: 10px;
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-value {
            font-size: 48px;
            font-weight: bold;
            margin: 10px 0;
        }
        .stat-label {
            color: #666;
            font-size: 16px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .stat-icon {
            font-size: 48px;
            opacity: 0.7;
        }
        .btn-primary {
            background-color: #667eea;
            border-color: #667eea;
        }
        .btn-primary:hover {
            background-color: #764ba2;
            border-color: #764ba2;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/header.jsp" %>

    <div class="container content-wrapper">
        <h2 class="mb-4"><i class="fas fa-chart-bar"></i> Statistics Dashboard</h2>

        <!-- Quick Stats -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="stat-card">
                    <i class="fas fa-users stat-icon text-primary"></i>
                    <div class="stat-value text-primary" id="totalStudents">-</div>
                    <div class="stat-label">Total Students</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <i class="fas fa-book stat-icon text-success"></i>
                    <div class="stat-value text-success" id="totalCourses">-</div>
                    <div class="stat-label">Total Courses</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <i class="fas fa-graduation-cap stat-icon text-info"></i>
                    <div class="stat-value text-info" id="totalEnrollments">-</div>
                    <div class="stat-label">Total Enrollments</div>
                </div>
            </div>
        </div>

        <!-- Student Statistics -->
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-user"></i> Student Enrollment Statistics</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">Student ID</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="statsStudentId" 
                                       placeholder="Enter student ID" min="1">
                                <button class="btn btn-primary" onclick="getStudentStats()">
                                    <i class="fas fa-search"></i> Get Stats
                                </button>
                            </div>
                        </div>
                        <div id="studentStatsResult"></div>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-book"></i> Course Enrollment Statistics</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">Course ID</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="statsCourseId" 
                                       placeholder="Enter course ID" min="1">
                                <button class="btn btn-primary" onclick="getCourseStats()">
                                    <i class="fas fa-search"></i> Get Stats
                                </button>
                            </div>
                        </div>
                        <div id="courseStatsResult"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Semester Statistics -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-calendar"></i> Semester Statistics</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Semester</label>
                                <select class="form-control" id="statsSemester">
                                    <option value="">Select Semester</option>
                                    <option value="FIRST">First Semester</option>
                                    <option value="SECOND">Second Semester</option>
                                    <option value="SUMMER">Summer Semester</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Academic Year</label>
                                <input type="text" class="form-control" id="statsYear" 
                                       placeholder="2024-2025">
                            </div>
                        </div>
                        <button class="btn btn-primary" onclick="getSemesterStats()">
                            <i class="fas fa-chart-line"></i> Get Semester Statistics
                        </button>
                        <div id="semesterStatsResult" class="mt-3"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Status Breakdown -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-pie-chart"></i> Enrollment Status Breakdown</h5>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-md-4">
                                <div class="stat-card bg-success text-white">
                                    <h3 id="activeCount">0</h3>
                                    <p class="mb-0">Active Enrollments</p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="stat-card bg-primary text-white">
                                    <h3 id="completedCount">0</h3>
                                    <p class="mb-0">Completed Enrollments</p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="stat-card bg-danger text-white">
                                    <h3 id="droppedCount">0</h3>
                                    <p class="mb-0">Dropped Enrollments</p>
                                </div>
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

        // Load overview stats on page load
        window.addEventListener('DOMContentLoaded', function() {
            loadOverviewStats();
            loadStatusBreakdown();
            
            // Set current academic year
            const year = new Date().getFullYear();
            document.getElementById('statsYear').value = year + '-' + (year + 1);
        });

        async function loadOverviewStats() {
            try {
                const response = await fetch(BASE_URL + '/api/enrollments');
                const result = await response.json();
                
                if (result.success) {
                    const enrollments = result.data;
                    const uniqueStudents = new Set(enrollments.map(e => e.studentId)).size;
                    const uniqueCourses = new Set(enrollments.map(e => e.courseId)).size;
                    
                    document.getElementById('totalStudents').textContent = uniqueStudents;
                    document.getElementById('totalCourses').textContent = uniqueCourses;
                    document.getElementById('totalEnrollments').textContent = enrollments.length;
                }
            } catch (error) {
                console.error('Error loading overview stats:', error);
            }
        }

        async function loadStatusBreakdown() {
            try {
                const response = await fetch(BASE_URL + '/api/enrollments');
                const result = await response.json();
                
                if (result.success) {
                    const enrollments = result.data;
                    const active = enrollments.filter(e => e.status === 'ACTIVE').length;
                    const completed = enrollments.filter(e => e.status === 'COMPLETED').length;
                    const dropped = enrollments.filter(e => e.status === 'DROPPED').length;
                    
                    document.getElementById('activeCount').textContent = active;
                    document.getElementById('completedCount').textContent = completed;
                    document.getElementById('droppedCount').textContent = dropped;
                }
            } catch (error) {
                console.error('Error loading status breakdown:', error);
            }
        }

        async function getStudentStats() {
            const studentId = document.getElementById('statsStudentId').value;
            
            if (!studentId) {
                alert('Please enter a student ID');
                return;
            }

            try {
                const response = await fetch(BASE_URL + '/api/stats/student/' + studentId);
                const result = await response.json();
                
                const resultDiv = document.getElementById('studentStatsResult');
                if (result.success) {
                    resultDiv.innerHTML = 
                        '<div class="alert alert-success">' +
                            '<h4><i class="fas fa-check-circle"></i> Active Enrollments: ' + result.data + '</h4>' +
                            '<a href="' + BASE_URL + '/student-history.jsp?studentId=' + studentId + '" ' +
                               'class="btn btn-sm btn-primary mt-2">' +
                                '<i class="fas fa-history"></i> View Full History' +
                            '</a>' +
                        '</div>';
                } else {
                    resultDiv.innerHTML = 
                        '<div class="alert alert-danger">' +
                            '<i class="fas fa-exclamation-circle"></i> ' + result.message +
                        '</div>';
                }
            } catch (error) {
                console.error('Error:', error);
            }
        }

        async function getCourseStats() {
            const courseId = document.getElementById('statsCourseId').value;
            
            if (!courseId) {
                alert('Please enter a course ID');
                return;
            }

            try {
                const response = await fetch(BASE_URL + '/api/stats/course/' + courseId);
                const result = await response.json();
                
                const resultDiv = document.getElementById('courseStatsResult');
                if (result.success) {
                    resultDiv.innerHTML = 
                        '<div class="alert alert-success">' +
                            '<h4><i class="fas fa-check-circle"></i> Total Students Enrolled: ' + result.data + '</h4>' +
                            '<a href="' + BASE_URL + '/enrollments.jsp" class="btn btn-sm btn-primary mt-2">' +
                                '<i class="fas fa-list"></i> View All Enrollments' +
                            '</a>' +
                        '</div>';
                } else {
                    resultDiv.innerHTML = 
                        '<div class="alert alert-danger">' +
                            '<i class="fas fa-exclamation-circle"></i> ' + result.message +
                        '</div>';
                }
            } catch (error) {
                console.error('Error:', error);
            }
        }

        async function getSemesterStats() {
            const semester = document.getElementById('statsSemester').value;
            const year = document.getElementById('statsYear').value;
            
            if (!semester || !year) {
                alert('Please select both semester and academic year');
                return;
            }

            try {
                const response = await fetch(BASE_URL + '/api/enrollments?semester=' + semester + '&academicYear=' + year);
                const result = await response.json();
                
                const resultDiv = document.getElementById('semesterStatsResult');
                if (result.success && result.data.length > 0) {
                    const enrollments = result.data;
                    const active = enrollments.filter(e => e.status === 'ACTIVE').length;
                    
                    resultDiv.innerHTML = 
                        '<div class="alert alert-info">' +
                            '<h5><i class="fas fa-calendar-check"></i> ' + semester + ' Semester ' + year + '</h5>' +
                            '<ul class="mb-0">' +
                                '<li>Total Enrollments: <strong>' + enrollments.length + '</strong></li>' +
                                '<li>Active: <strong class="text-success">' + active + '</strong></li>' +
                                '<li>Unique Students: <strong>' + new Set(enrollments.map(e => e.studentId)).size + '</strong></li>' +
                                '<li>Unique Courses: <strong>' + new Set(enrollments.map(e => e.courseId)).size + '</strong></li>' +
                            '</ul>' +
                        '</div>';
                } else {
                    resultDiv.innerHTML = 
                        '<div class="alert alert-warning">' +
                            '<i class="fas fa-info-circle"></i> No enrollments found for this semester' +
                        '</div>';
                }
            } catch (error) {
                console.error('Error:', error);
            }
        }
    </script>
</body>
</html>
