<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Sign Up — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar topbar-light">
    <div class="brand"><a href="index.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="staff_login.jsp">Staff Login</a>
    </div>
</nav>

<div class="page-shell" style="display:flex;align-items:flex-start;justify-content:center;padding-top:40px;">
<div class="card-sm" style="width:100%;">
<div class="card">

    <h1 class="page-title">Staff Sign Up</h1>
    <p class="page-subtitle">Create a staff account for the clinic system.</p>
    <hr class="divider">

    <%
        String error   = request.getParameter("error");
        String success = request.getParameter("success");
        if ("1".equals(error)) {
    %>
        <div class="alert alert-error">All fields are required.</div>
    <% } else if ("2".equals(error)) { %>
        <div class="alert alert-error">That username is already taken. Please choose another.</div>
    <% } else if ("3".equals(error)) { %>
        <div class="alert alert-error">Password must be at least 6 characters long.</div>
    <% } else if ("4".equals(error)) { %>
        <div class="alert alert-error">Something went wrong. Please try again.</div>
    <% } else if ("1".equals(success)) { %>
        <div class="alert alert-success">Staff account created successfully. You can now log in.</div>
    <% } %>

    <form action="staff_signup_process.jsp" method="post">

        <div class="form-group">
            <label for="full_name">Full Name</label>
            <input type="text" id="full_name" name="full_name" class="form-control" required autofocus>
        </div>

        <div class="form-group">
            <label for="role">Role</label>
            <div>
                <select id="role" name="role" class="form-control" required>
                    <option value="">Select a role</option>
                    <option value="Admin">Admin — full system access</option>
                    <option value="Manager">Manager — reports, appointments, inventory</option>
                    <option value="Veterinarian">Veterinarian — visits, procedures, appointments</option>
                    <option value="Technician">Technician — vitals, visit support logs</option>
                </select>
                <p class="form-hint">Your role determines which sections you can access.</p>
            </div>
        </div>

        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" class="form-control" required autocomplete="username">
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <div>
                <input type="password" id="password" name="password" class="form-control" required autocomplete="new-password">
                <label class="password-toggle">
                    <input type="checkbox" onclick="document.getElementById('password').type = this.checked ? 'text' : 'password'">
                    Show password
                </label>
                <p class="form-hint">Minimum 6 characters.</p>
            </div>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Create Staff Account</button>
        </div>
    </form>

    <div style="margin-top:20px;display:flex;gap:20px;align-items:center;">
        <a href="staff_login.jsp" class="text-link">Already have an account? Log in →</a>
        <a href="index.jsp" class="text-link">← Back to Home</a>
    </div>

</div>
</div>
</div>

</body>
</html>
