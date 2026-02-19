<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Enrollments - Enrollment Service</title>
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
        .loading {
            text-align: center;
            padding: 50px;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/header.jsp" %>

    <div class="container content-wrapper">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0"><i class="fas fa-list"></i> All Enrollments</h5>
                        <div>
                            <button class="btn btn-sm btn-light" onclick="loadEnrollments()">
                                <i class="fas fa-sync"></i> Refresh
                            </button>
                            <a href="${pageContext.request.contextPath}/enroll.jsp" class="btn btn-sm btn-light">
                                <i class="fas fa-plus"></i> New Enrollment
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <!-- Filter Section -->
                        <div class="row mb-3">
                            <div class="col-md-3">
                                <input type="number" class="form-control" id="filterStudentId" placeholder="Filter by Student ID">
                            </div>
                            <div class="col-md-3">
                                <input type="number" class="form-control" id="filterCourseId" placeholder="Filter by Course ID">
                            </div>
                            <div class="col-md-3">
                                <select class="form-control" id="filterStatus">
                                    <option value="">All Status</option>
                                    <option value="ACTIVE">Active</option>
                                    <option value="DROPPED">Dropped</option>
                                    <option value="COMPLETED">Completed</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-primary w-100" onclick="applyFilters()">
                                    <i class="fas fa-filter"></i> Apply Filters
                                </button>
                            </div>
                        </div>

                        <!-- Table -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Student</th>
                                        <th>Course</th>
                                        <th>Semester</th>
                                        <th>Academic Year</th>
                                        <th>Status</th>
                                        <th>Grade</th>
                                        <th>Enrollment Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="enrollmentsTableBody">
                                    <tr>
                                        <td colspan="9" class="loading">
                                            <div class="spinner-border text-primary" role="status">
                                                <span class="visually-hidden">Loading...</span>
                                            </div>
                                            <p class="mt-2">Loading enrollments...</p>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <nav aria-label="Enrollments pagination" id="paginationNav" style="display: none;">
                            <ul class="pagination justify-content-center">
                                <li class="page-item disabled">
                                    <a class="page-link" href="#" tabindex="-1">Previous</a>
                                </li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item">
                                    <a class="page-link" href="#">Next</a>
                                </li>
                            </ul>
                        </nav>
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
        
        // Cache for student and course names
        const studentsCache = {};
        const coursesCache = {};

        // Load enrollments on page load
        window.addEventListener('DOMContentLoaded', async function() {
            await loadLookupData();
            loadEnrollments();
        });

        async function loadLookupData() {
            try {
                // Load students
                const studentsResponse = await fetch(BASE_URL + '/api/students');
                const studentsResult = await studentsResponse.json();
                if (studentsResult.success && studentsResult.data) {
                    studentsResult.data.forEach(student => {
                        studentsCache[student.id] = student.name;
                    });
                }

                // Load courses
                const coursesResponse = await fetch(BASE_URL + '/api/courses');
                const coursesResult = await coursesResponse.json();
                if (coursesResult.success && coursesResult.data) {
                    coursesResult.data.forEach(course => {
                        coursesCache[course.id] = course.name + ' (' + course.code + ')';
                    });
                }
            } catch (error) {
                console.error('Error loading lookup data:', error);
            }
        }

        async function loadEnrollments(filters = {}) {
            const tbody = document.getElementById('enrollmentsTableBody');
            
            try {
                let url = BASE_URL + '/api/enrollments';
                const params = new URLSearchParams();
                
                if (filters.studentId) params.append('studentId', filters.studentId);
                if (filters.courseId) params.append('courseId', filters.courseId);
                if (filters.status) params.append('status', filters.status);
                
                if (params.toString()) url += '?' + params.toString();
                
                const response = await fetch(url);
                const result = await response.json();
                
                if (result.success && result.data.length > 0) {
                    tbody.innerHTML = result.data.map(e => 
                        '<tr>' +
                            '<td>' + e.id + '</td>' +
                            '<td><span class="badge bg-info">' + (studentsCache[e.studentId] || 'Student #' + e.studentId) + '</span></td>' +
                            '<td><span class="badge bg-secondary">' + (coursesCache[e.courseId] || 'Course #' + e.courseId) + '</span></td>' +
                            '<td>' + e.semester + '</td>' +
                            '<td>' + e.academicYear + '</td>' +
                            '<td><span class="badge badge-' + e.status.toLowerCase() + '">' + e.status + '</span></td>' +
                            '<td>' + (e.grade || 'N/A') + '</td>' +
                            '<td>' + (e.enrollmentDate ? new Date(e.enrollmentDate).toLocaleDateString() : 'N/A') + '</td>' +
                            '<td>' +
                                '<div class="btn-group-vertical btn-group-sm" role="group" style="min-width: 100px;">' +
                                    '<button class="btn btn-sm btn-primary" onclick="editEnrollment(' + e.id + ')">' +
                                        '<i class="fas fa-edit"></i> Edit' +
                                    '</button>' +
                                    (e.status === 'ACTIVE' ? 
                                        '<button class="btn btn-sm btn-warning" onclick="dropCourse(' + e.id + ')">' +
                                            '<i class="fas fa-ban"></i> Drop' +
                                        '</button>'
                                    : '') +
                                    '<button class="btn btn-sm btn-danger" onclick="deleteEnrollment(' + e.id + ')">' +
                                        '<i class="fas fa-trash"></i> Delete' +
                                    '</button>' +
                                '</div>' +
                            '</td>' +
                        '</tr>'
                    ).join('');
                } else {
                    tbody.innerHTML = `
                        <tr>
                            <td colspan="9" class="text-center">
                                <p class="text-muted my-3">No enrollments found</p>
                            </td>
                        </tr>
                    `;
                }
            } catch (error) {
                console.error('Error loading enrollments:', error);
                tbody.innerHTML = 
                    '<tr>' +
                        '<td colspan="9" class="text-center">' +
                            '<div class="alert alert-danger">Error loading enrollments: ' + error.message + '</div>' +
                        '</td>' +
                    '</tr>';
            }
        }

        function applyFilters() {
            const filters = {
                studentId: document.getElementById('filterStudentId').value,
                courseId: document.getElementById('filterCourseId').value,
                status: document.getElementById('filterStatus').value
            };
            loadEnrollments(filters);
        }

        function viewDetails(enrollmentId) {
            window.location.href = BASE_URL + '/enrollment-details.jsp?id=' + enrollmentId;
        }

        async function dropCourse(enrollmentId) {
            if (!confirm('Are you sure you want to drop this course?')) return;

            const btn = event.target.closest('button');
            const originalHtml = btn.innerHTML;
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Dropping...';

            try {
                const response = await fetch(BASE_URL + '/api/enrollments/drop/' + enrollmentId, {
                    method: 'POST'
                });
                const result = await response.json();
                
                if (result.success) {
                    showNotification('Course dropped successfully!', 'success');
                    setTimeout(() => loadEnrollments(), 500);
                } else {
                    showNotification('Error: ' + result.message, 'danger');
                    btn.disabled = false;
                    btn.innerHTML = originalHtml;
                }
            } catch (error) {
                showNotification('Error: ' + error.message, 'danger');
                btn.disabled = false;
                btn.innerHTML = originalHtml;
            }
        }

        function editEnrollment(enrollmentId) {
            window.location.href = BASE_URL + '/edit-enrollment.jsp?id=' + enrollmentId;
        }

        async function deleteEnrollment(enrollmentId) {
            if (!confirm('⚠️ Are you sure you want to permanently delete this enrollment?\n\nThis action cannot be undone!')) return;

            const btn = event.target.closest('button');
            const originalHtml = btn.innerHTML;
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Deleting...';

            try {
                const response = await fetch(BASE_URL + '/api/enrollments/' + enrollmentId, {
                    method: 'DELETE'
                });
                const result = await response.json();
                
                if (result.success) {
                    showNotification('Enrollment deleted successfully!', 'success');
                    setTimeout(() => loadEnrollments(), 500);
                } else {
                    showNotification('Error: ' + result.message, 'danger');
                    btn.disabled = false;
                    btn.innerHTML = originalHtml;
                }
            } catch (error) {
                showNotification('Error: ' + error.message, 'danger');
                btn.disabled = false;
                btn.innerHTML = originalHtml;
            }
        }

        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.className = 'alert alert-' + type + ' alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3';
            notification.style.zIndex = '9999';
            notification.style.minWidth = '300px';
            notification.innerHTML = 
                message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
            
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.remove();
            }, 3000);
        }
    </script>
</body>
</html>
