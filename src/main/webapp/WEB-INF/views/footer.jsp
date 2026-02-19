<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Footer Component -->
<footer class="mt-5 py-4 text-white" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
    <div class="container">
        <div class="row">
            <div class="col-md-4">
                <h5><i class="fas fa-graduation-cap"></i> Enrollment Service</h5>
                <p class="small">SmartCampus Microservice Architecture</p>
                <p class="small">Group E - 2024-2025</p>
            </div>
            <div class="col-md-4">
                <h6>Quick Links</h6>
                <ul class="list-unstyled small">
                    <li><a href="${pageContext.request.contextPath}/" class="text-white text-decoration-none">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/api/enrollments" class="text-white text-decoration-none">API Endpoints</a></li>
                    <li><a href="#" class="text-white text-decoration-none">Documentation</a></li>
                    <li><a href="#" class="text-white text-decoration-none">Support</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h6>Contact</h6>
                <p class="small">
                    <i class="fas fa-envelope"></i> support@smartcampus.edu<br>
                    <i class="fas fa-phone"></i> +250 xxx xxx xxx<br>
                    <i class="fas fa-map-marker-alt"></i> Kigali, Rwanda
                </p>
            </div>
        </div>
        <hr class="bg-white">
        <div class="row">
            <div class="col-12 text-center small">
                <p class="mb-0">
                    &copy; <%= java.time.Year.now().getValue() %> SmartCampus Enrollment Service. 
                    Developed by Group E | All Rights Reserved
                </p>
            </div>
        </div>
    </div>
</footer>
