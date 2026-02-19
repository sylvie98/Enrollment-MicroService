<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student History - Enrollment Service</title>
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
        .badge-completed {
            background-color: #007bff;
        }
        .btn-primary {
            background-color: #667eea;
            border-color: #667eea;
        }
        .btn-primary:hover {
            background-color: #764ba2;
            border-color: #764ba2;
        }
        .student-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .stat-card {
            text-align: center;
            padding: 20px;
            border-radius: 8px;
            background: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .stat-value {
            font-size: 36px;
            font-weight: bold;
            color: #667eea;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/header.jsp" %>

    <div class="container content-wrapper">
        <!-- Search Section -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-search"></i> Search Student Enrollment History</h5>
                    </div>
                    <div class="card-body">
                        <div class="row align-items-end">
                            <div class="col-md-8">
                                <label class="form-label">Student ID</label>
                                <input type="number" class="form-control" id="studentId" 
                                       placeholder="Enter student ID" min="1">
                            </div>
                            <div class="col-md-4">
                                <button class="btn btn-primary w-100" onclick="searchStudent()">
                                    <i class="fas fa-search"></i> Search
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Student Info Section -->
        <div id="studentInfoSection" style="display: none;">
            <div class="row mt-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-value" id="totalEnrollments">0</div>
                        <div class="stat-label">Total Enrollments</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-value text-success" id="activeEnrollments">0</div>
                        <div class="stat-label">Active Courses</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-value text-primary" id="completedEnrollments">0</div>
                        <div class="stat-label">Completed Courses</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-value text-danger" id="droppedEnrollments">0</div>
                        <div class="stat-label">Dropped Courses</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- History Table -->
        <div id="historySection" style="display: none;">
            <div class="row mt-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="fas fa-history"></i> Enrollment History</h5>
                            <button class="btn btn-sm btn-light" onclick="exportToCSV()">
                                <i class="fas fa-download"></i> Export CSV
                            </button>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover" id="historyTable">
                                    <thead>
                                        <tr>
                                            <th>Enrollment ID</th>
                                            <th>Course ID</th>
                                            <th>Semester</th>
                                            <th>Academic Year</th>
                                            <th>Status</th>
                                            <th>Grade</th>
                                            <th>Enrollment Date</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="historyTableBody">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- No Results Message -->
        <div id="noResultsSection" style="display: none;">
            <div class="row mt-4">
                <div class="col-12">
                    <div class="alert alert-info text-center">
                        <i class="fas fa-info-circle fa-3x mb-3"></i>
                        <h5>No Enrollment History Found</h5>
                        <p>No enrollment records found for this student ID.</p>
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
        let currentData = [];

        // Check if student ID is in URL params
        window.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const studentId = urlParams.get('studentId');
            if (studentId) {
                document.getElementById('studentId').value = studentId;
                searchStudent();
            }
        });

        async function searchStudent() {
            const studentId = document.getElementById('studentId').value;
            
            if (!studentId) {
                alert('Please enter a student ID');
                return;
            }

            try {
                const response = await fetch(BASE_URL + '/api/enrollments?studentId=' + studentId);
                const result = await response.json();
                
                if (result.success && result.data.length > 0) {
                    currentData = result.data;
                    displayHistory(result.data);
                    calculateStats(result.data);
                    document.getElementById('studentInfoSection').style.display = 'block';
                    document.getElementById('historySection').style.display = 'block';
                    document.getElementById('noResultsSection').style.display = 'none';
                } else {
                    document.getElementById('studentInfoSection').style.display = 'none';
                    document.getElementById('historySection').style.display = 'none';
                    document.getElementById('noResultsSection').style.display = 'block';
                }
            } catch (error) {
                console.error('Error:', error);
                alert('Error fetching student history: ' + error.message);
            }
        }

        function displayHistory(enrollments) {
            const tbody = document.getElementById('historyTableBody');
            tbody.innerHTML = enrollments.map(e => 
                '<tr>' +
                    '<td><strong>#' + e.id + '</strong></td>' +
                    '<td><span class="badge bg-secondary">' + e.courseId + '</span></td>' +
                    '<td>' + e.semester + '</td>' +
                    '<td>' + e.academicYear + '</td>' +
                    '<td><span class="badge badge-' + e.status.toLowerCase() + '">' + e.status + '</span></td>' +
                    '<td>' + (e.grade || '-') + '</td>' +
                    '<td>' + (e.enrollmentDate ? new Date(e.enrollmentDate).toLocaleDateString() : 'N/A') + '</td>' +
                    '<td>' +
                        (e.status === 'ACTIVE' ? 
                            '<button class="btn btn-sm btn-danger" onclick="dropCourse(' + e.id + ')">' +
                                '<i class="fas fa-times"></i>' +
                            '</button>'
                        : '-') +
                    '</td>' +
                '</tr>'
            ).join('');
        }

        function calculateStats(enrollments) {
            const total = enrollments.length;
            const active = enrollments.filter(e => e.status === 'ACTIVE').length;
            const completed = enrollments.filter(e => e.status === 'COMPLETED').length;
            const dropped = enrollments.filter(e => e.status === 'DROPPED').length;

            document.getElementById('totalEnrollments').textContent = total;
            document.getElementById('activeEnrollments').textContent = active;
            document.getElementById('completedEnrollments').textContent = completed;
            document.getElementById('droppedEnrollments').textContent = dropped;
        }

        async function dropCourse(enrollmentId) {
            if (!confirm('Are you sure you want to drop this course?')) return;

            try {
                const response = await fetch(BASE_URL + '/api/enrollments/drop/' + enrollmentId, {
                    method: 'POST'
                });
                const result = await response.json();
                
                if (result.success) {
                    alert('Course dropped successfully');
                    searchStudent();
                } else {
                    alert('Error: ' + result.message);
                }
            } catch (error) {
                alert('Error: ' + error.message);
            }
        }

        function exportToCSV() {
            if (currentData.length === 0) return;

            const csv = [
                ['Enrollment ID', 'Course ID', 'Semester', 'Academic Year', 'Status', 'Grade', 'Enrollment Date'],
                ...currentData.map(e => [
                    e.id,
                    e.courseId,
                    e.semester,
                    e.academicYear,
                    e.status,
                    e.grade || '',
                    e.enrollmentDate || ''
                ])
            ].map(row => row.join(',')).join('\n');

            const blob = new Blob([csv], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'student_' + document.getElementById('studentId').value + '_history.csv';
            a.click();
        }
    </script>
</body>
</html>
