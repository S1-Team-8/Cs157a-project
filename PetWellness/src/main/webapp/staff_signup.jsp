<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Sign Up - PetWellness</title>
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

        .form-card {
            width: 100%;
            max-width: 820px;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.08);
            padding: 40px 45px;
        }

        .page-title {
            margin: 0 0 10px 0;
            font-size: 42px;
            font-weight: 700;
            color: #2f5597;
        }

        .page-subtitle {
            margin: 0 0 28px 0;
            font-size: 18px;
            color: #5f6b7a;
        }

        .message {
            font-size: 17px;
            font-weight: 600;
            margin-bottom: 20px;
        }

        .error { color: #c0392b; }
        .success { color: #1f8f4d; }

        .form-group {
            margin-bottom: 22px;
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
    </style>
</head>
<body>
    <div class="page-wrapper">
        <div class="form-card">
            <h1 class="page-title">Staff Sign Up</h1>
            <p class="page-subtitle">Create a staff account for the clinic system.</p>

            <%
                String error = request.getParameter("error");
                String success = request.getParameter("success");

                if ("1".equals(error)) {
            %>
                <div class="message error">All fields are required.</div>
            <%
                } else if ("2".equals(error)) {
            %>
                <div class="message error">That username already exists.</div>
            <%
                } else if ("3".equals(error)) {
            %>
                <div class="message error">Password must be at least 6 characters long.</div>
            <%
                } else if ("4".equals(error)) {
            %>
                <div class="message error">Something went wrong. Please try again.</div>
            <%
                } else if ("1".equals(success)) {
            %>
                <div class="message success">Staff account created successfully. Please log in.</div>
            <%
                }
            %>

            <form action="staff_signup_process.jsp" method="post">
                <div class="form-group">
                    <label for="full_name">Full Name</label>
                    <input type="text" id="full_name" name="full_name" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="role">Role</label>
                    <select id="role" name="role" class="form-control" required>
                        <option value="">Select role</option>
                        <option value="Admin">Admin</option>
                        <option value="Manager">Manager</option>
                        <option value="Veterinarian">Veterinarian</option>
                        <option value="Technician">Technician</option>
                        <option value="Inventory Staff">Inventory Staff</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>

                <div class="button-row">
                    <button type="submit" class="btn btn-primary">Create Staff Account</button>
                    <a href="staff_login.jsp" class="btn btn-secondary">Staff Login</a>
                    <a href="index.jsp" class="btn btn-secondary">Back to Home</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>