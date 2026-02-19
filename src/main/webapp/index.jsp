<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enrollment Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 0;
        }
        .main-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            padding: 30px;
            margin-bottom: 30px;
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
            color: #667eea;
        }
        .nav-tabs .nav-link.active {
            background-color: #667eea;
            color: white;
        }
        .btn-primary {
            background-color: #667eea;
            border-color: #667eea;
        }
        .btn-primary:hover {
            background-color: #764ba2;
            border-color: #764ba2;
        }
        .card {
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .card-header {
            background-color: #667eea;
            color: white;
            font-weight: bold;
        }
        .table thead {
            background-color: #667eea;
            color: white;
        }
        .badge-active {
            background-color: #28a745;
        }
        .badge-dropped {
            background-color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="main-container">
            <div class="header">
                <h1><i class="fas fa-graduation-cap"></i> Enrollment Management System</h1>
                <p class="text-muted">SmartCampus Microservice - Group E</p>
            </div>

            <!-- Navigation Tabs -->
            <ul class="nav nav-tabs" id="mainTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="enroll-tab" data-bs-toggle="tab" data-bs-target="#enroll" type="button">
                        Enroll Student
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="view-tab" data-bs-toggle="tab" data-bs-target="#view" type="button">
                        View Enrollments
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="history-tab" data-bs-toggle="tab" data-bs-target="#history" type="button">
                        Student History
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="stats-tab" data-bs-toggle="tab" data-bs-target="#stats" type="button">
                        Statistics
                    </button>
                </li>
            </ul>

            <!-- Tab Content -->
            <div class="tab-content mt-4" id="mainTabContent">
                <!-- Enroll Student Tab -->
                <div class="tab-pane fade show active" id="enroll" role="tabpanel">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Enroll New Student</h5>
                        </div>
                        <div class="card-body">
                            <form id="enrollForm">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Student ID</label>
                                        <input type="number" class="form-control" id="studentId" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Course ID</label>
                                        <input type="number" class="form-control" id="courseId" required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Semester</label>
                                        <select class="form-control" id="semester" required>
                                            <option value="">Select Semester</option>
                                            <option value="FIRST">First Semester</option>
                                            <option value="SECOND">Second Semester</option>
                                            <option value="SUMMER">Summer Semester</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Academic Year</label>
                                        <input type="text" class="form-control" id="academicYear" placeholder="2024-2025" required>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-plus"></i> Enroll Student
                                </button>
                            </form>
                            <div id="enrollResult" class="mt-3"></div>
                        </div>
                    </div>
                </div>

                <!-- View Enrollments Tab -->
                <div class="tab-pane fade" id="view" role="tabpanel">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">All Enrollments</h5>
                            <button class="btn btn-sm btn-light" onclick="loadAllEnrollments()">
                                <i class="fas fa-refresh"></i> Refresh
                            </button>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Student ID</th>
                                            <th>Course ID</th>
                                            <th>Semester</th>
                                            <th>Academic Year</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="enrollmentsTable">
                                        <tr>
                                            <td colspan="7" class="text-center">Loading...</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Student History Tab -->
                <div class="tab-pane fade" id="history" role="tabpanel">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Student Enrollment History</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label">Enter Student ID</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" id="searchStudentId" placeholder="Student ID">
                                    <button class="btn btn-primary" onclick="searchStudentEnrollments()">
                                        <i class="fas fa-search"></i> Search
                                    </button>
                                </div>
                            </div>
                            <div id="studentHistoryResult"></div>
                        </div>
                    </div>
                </div>

                <!-- Statistics Tab -->
                <div class="tab-pane fade" id="stats" role="tabpanel">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">Student Statistics</h5>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <label class="form-label">Student ID</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" id="statsStudentId">
                                            <button class="btn btn-primary" onclick="getStudentStats()">Get Stats</button>
                                        </div>
                                    </div>
                                    <div id="studentStatsResult"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">Course Statistics</h5>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <label class="form-label">Course ID</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" id="statsCourseId">
                                            <button class="btn btn-primary" onclick="getCourseStats()">Get Stats</button>
                                        </div>
                                    </div>
                                    <div id="courseStatsResult"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js"></script>
    <script>
        const BASE_URL = window.location.origin + '/Enrollment-MicroService';

        // Enroll student
        document.getElementById('enrollForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const data = {
                studentId: parseInt(document.getElementById('studentId').value),
                courseId: parseInt(document.getElementById('courseId').value),
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
                const resultDiv = document.getElementById('enrollResult');
                
                if (result.success) {
                    resultDiv.innerHTML = '<div class="alert alert-success">' + result.message + '</div>';
                    document.getElementById('enrollForm').reset();
                } else {
                    resultDiv.innerHTML = '<div class="alert alert-danger">' + result.message + '</div>';
                }
            } catch (error) {
                document.getElementById('enrollResult').innerHTML = 
                    '<div class="alert alert-danger">Error: ' + error.message + '</div>';
            }
        });

        // Load all enrollments
        async function loadAllEnrollments() {
            try {
                const response = await fetch(BASE_URL + '/api/enrollments');
                const result = await response.json();
                
                const tbody = document.getElementById('enrollmentsTable');
                
                if (result.success && result.data.length > 0) {
                    tbody.innerHTML = result.data.map(e => `
                        <tr>
                            <td>${e.id}</td>
                            <td>${e.studentId}</td>
                            <td>${e.courseId}</td>
                            <td>${e.semester}</td>
                            <td>${e.academicYear}</td>
                            <td><span class="badge badge-${e.status.toLowerCase()}">${e.status}</span></td>
                            <td>
                                <button class="btn btn-sm btn-danger" onclick="dropCourse(${e.id})">Drop</button>
                            </td>
                        </tr>
                    `).join('');
                } else {
                    tbody.innerHTML = '<tr><td colspan="7" class="text-center">No enrollments found</td></tr>';
                }
            } catch (error) {
                console.error('Error loading enrollments:', error);
            }
        }

        // Search student enrollments
        async function searchStudentEnrollments() {
            const studentId = document.getElementById('searchStudentId').value;
            
            if (!studentId) {
                alert('Please enter a student ID');
                return;
            }

            try {
                const response = await fetch(BASE_URL + '/api/enrollments?studentId=' + studentId);
                const result = await response.json();
                
                const resultDiv = document.getElementById('studentHistoryResult');
                
                if (result.success && result.data.length > 0) {
                    resultDiv.innerHTML = `
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Course ID</th>
                                    <th>Semester</th>
                                    <th>Academic Year</th>
                                    <th>Status</th>
                                    <th>Grade</th>
                                </tr>
                            </thead>
                            <tbody>
                                ${result.data.map(e => `
                                    <tr>
                                        <td>${e.courseId}</td>
                                        <td>${e.semester}</td>
                                        <td>${e.academicYear}</td>
                                        <td><span class="badge badge-${e.status.toLowerCase()}">${e.status}</span></td>
                                        <td>${e.grade || 'N/A'}</td>
                                    </tr>
                                `).join('')}
                            </tbody>
                        </table>
                    `;
                } else {
                    resultDiv.innerHTML = '<div class="alert alert-info">No enrollments found for this student</div>';
                }
            } catch (error) {
                console.error('Error:', error);
            }
        }

        // Drop course
        async function dropCourse(enrollmentId) {
            if (!confirm('Are you sure you want to drop this course?')) return;

            try {
                const response = await fetch(BASE_URL + '/api/enrollments/drop/' + enrollmentId, {
                    method: 'POST'
                });
                const result = await response.json();
                
                if (result.success) {
                    alert(result.message);
                    loadAllEnrollments();
                } else {
                    alert('Error: ' + result.message);
                }
            } catch (error) {
                alert('Error: ' + error.message);
            }
        }

        // Get student statistics
        async function getStudentStats() {
            const studentId = document.getElementById('statsStudentId').value;
            
            if (!studentId) {
                alert('Please enter a student ID');
                return;
            }

            try {
                const response = await fetch(BASE_URL + '/api/stats/student/' + studentId);
                const result = await response.json();
                
                if (result.success) {
                    document.getElementById('studentStatsResult').innerHTML = `
                        <div class="alert alert-info">
                            <h5>Active Enrollments: ${result.data}</h5>
                        </div>
                    `;
                }
            } catch (error) {
                console.error('Error:', error);
            }
        }

        // Get course statistics
        async function getCourseStats() {
            const courseId = document.getElementById('statsCourseId').value;
            
            if (!courseId) {
                alert('Please enter a course ID');
                return;
            }

            try {
                const response = await fetch(BASE_URL + '/api/stats/course/' + courseId);
                const result = await response.json();
                
                if (result.success) {
                    document.getElementById('courseStatsResult').innerHTML = `
                        <div class="alert alert-info">
                            <h5>Total Students Enrolled: ${result.data}</h5>
                        </div>
                    `;
                }
            } catch (error) {
                console.error('Error:', error);
            }
        }

        // Load enrollments when view tab is shown
        document.getElementById('view-tab').addEventListener('click', loadAllEnrollments);
    </script>
</body>
</html>