<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Login — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar topbar-light">
    <div class="brand"><a href="index.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="staff_signup.jsp">Staff Sign Up</a>
    </div>
</nav>

<div class="page-shell" style="display:flex;align-items:center;justify-content:center;min-height:calc(100vh - var(--topbar-h));">
<div class="card-sm" style="width:100%;">
<div class="card">

    <h1 class="page-title">Staff Login</h1>

    <% if ("1".equals(request.getParameter("error"))) { %>
        <div class="alert alert-error">Invalid username or password. Please try again.</div>
    <% } else if ("2".equals(request.getParameter("error"))) { %>
        <div class="alert alert-error">Please enter both your username and password.</div>
    <% } %>

    <form action="staff_login_process.jsp" method="post">

        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" class="form-control" required autofocus autocomplete="username">
        </div>

        <div class="form-group">
            <label for="staff_password">Password</label>
            <div>
                <input type="password" id="staff_password" name="password" class="form-control" required autocomplete="current-password">
                <label class="password-toggle">
                    <input type="checkbox" onclick="document.getElementById('staff_password').type = this.checked ? 'text' : 'password'">
                    Show password
                </label>
            </div>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Log In</button>
        </div>
    </form>

    <div style="margin-top:20px;display:flex;gap:20px;align-items:center;">
        <a href="staff_signup.jsp" class="text-link">Need an account? Sign up →</a>
        <a href="index.jsp" class="text-link">← Back to Home</a>
    </div>

</div>
</div>
</div>

</body>
</html>
