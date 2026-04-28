<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Login - PetWellness</title>
    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #eef2f7;
            color: #1f2d3d;
        }

        .page-wrapper {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        .login-card {
            width: 100%;
            max-width: 760px;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.08);
            padding: 40px 42px;
        }

        .page-title {
            margin: 0 0 28px 0;
            font-size: 42px;
            font-weight: 700;
            color: #2f5597;
        }

        .form-group {
            margin-bottom: 26px;
        }

        .form-group label {
            display: block;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 10px;
            color: #2f5597;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px;
            font-size: 18px;
            border: 1px solid #ccd6e0;
            border-radius: 12px;
            outline: none;
        }

        .form-control:focus {
            border-color: #2f5597;
            box-shadow: 0 0 0 4px rgba(47, 85, 151, 0.12);
        }

        .button-row {
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
            margin-top: 10px;
        }

        .btn {
            display: inline-block;
            text-decoration: none;
            border: none;
            border-radius: 12px;
            padding: 14px 26px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
        }

        .btn-primary {
            background: #2f5597;
            color: #ffffff;
        }

        .btn-secondary {
            background: #dfe7f2;
            color: #2f5597;
        }

        .error-message {
            color: #c0392b;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="page-wrapper">
        <div class="login-card">
            <h1 class="page-title">Staff Login</h1>

            <% if ("1".equals(request.getParameter("error"))) { %>
                <div class="error-message">Invalid staff username or password.</div>
            <% } else if ("2".equals(request.getParameter("error"))) { %>
                <div class="error-message">Please enter both username and password.</div>
            <% } %>

            <form action="staff_login_process.jsp" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="staff_password">Password</label>
                    <input type="password" id="staff_password" name="password" class="form-control" required>
                </div>

                <div class="button-row">
                    <button type="submit" class="btn btn-primary">Login</button>
                    <a href="index.jsp" class="btn btn-secondary">Back to Home</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>