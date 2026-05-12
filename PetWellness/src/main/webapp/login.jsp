<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pet Owner Login — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar topbar-light">
    <div class="brand"><a href="index.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="signup.jsp">Sign Up</a>
    </div>
</nav>

<div class="page-shell" style="display:flex;align-items:center;justify-content:center;min-height:calc(100vh - var(--topbar-h));">
<div class="card-sm" style="width:100%;">
<div class="card">

    <h1 class="page-title">Pet Owner Login</h1>

    <%
        String error = request.getParameter("error");
        if ("1".equals(error)) {
    %>
        <div class="alert alert-error">Invalid email / name or password. Please try again.</div>
    <% } else if ("2".equals(error)) { %>
        <div class="alert alert-error">Please enter both your email/name and password.</div>
    <% } %>

    <form action="login_process.jsp" method="post">

        <div class="form-group">
            <label for="login_id">Email or Full Name</label>
            <input type="text" id="login_id" name="login_id" class="form-control" required autofocus autocomplete="username">
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <div>
                <input type="password" id="password" name="password" class="form-control" required autocomplete="current-password">
                <label class="password-toggle">
                    <input type="checkbox" onclick="document.getElementById('password').type = this.checked ? 'text' : 'password'">
                    Show password
                </label>
            </div>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Log In</button>
        </div>
    </form>

    <div style="margin-top:20px;display:flex;gap:20px;align-items:center;">
        <a href="signup.jsp" class="text-link">Don't have an account? Sign up →</a>
        <a href="index.jsp" class="text-link">← Back to Home</a>
    </div>

</div>
</div>
</div>

</body>
</html>
