<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-container {
            background: white;
            border-radius: 15px;
            padding: 50px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            max-width: 600px;
        }
        .error-code {
            font-size: 120px;
            font-weight: bold;
            color: #667eea;
            margin: 0;
        }
        .error-message {
            font-size: 24px;
            color: #333;
            margin: 20px 0;
        }
        .error-description {
            color: #666;
            margin-bottom: 30px;
        }
        .btn-home {
            background-color: #667eea;
            border-color: #667eea;
            color: white;
            padding: 12px 30px;
            font-size: 16px;
        }
        .btn-home:hover {
            background-color: #764ba2;
            border-color: #764ba2;
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <p class="error-code">404</p>
        <h1 class="error-message">Page Not Found</h1>
        <p class="error-description">
            The page you are looking for might have been removed, had its name changed, 
            or is temporarily unavailable.
        </p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-home">
            <i class="fas fa-home"></i> Return to Home
        </a>
        <div style="margin-top: 30px;">
            <small class="text-muted">
                Request URL: <%= request.getRequestURL() %>
            </small>
        </div>
    </div>
    <script src="https://kit.fontawesome.com/a076d05399.js"></script>
</body>
</html>
