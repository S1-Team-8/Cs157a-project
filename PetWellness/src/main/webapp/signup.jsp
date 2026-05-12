<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar topbar-light">
    <div class="brand"><a href="index.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="login.jsp">Pet Owner Login</a>
    </div>
</nav>

<div class="page-shell" style="display:flex;align-items:flex-start;justify-content:center;padding-top:40px;">
<div class="card-sm" style="width:100%;">
<div class="card">

    <h1 class="page-title">Create Account</h1>
    <p class="page-subtitle">Sign up to manage your pets and appointments.</p>
    <hr class="divider">

    <%
        String error   = request.getParameter("error");
        String success = request.getParameter("success");
        if ("1".equals(error)) {
    %>
        <div class="alert alert-error">All fields are required.</div>
    <% } else if ("2".equals(error)) { %>
        <div class="alert alert-error">An account with that email already exists.</div>
    <% } else if ("3".equals(error)) { %>
        <div class="alert alert-error">Something went wrong. Please try again.</div>
    <% } else if ("1".equals(success)) { %>
        <div class="alert alert-success">Account created successfully. You can now log in.</div>
    <% } %>

    <form action="signup_process.jsp" method="post">

        <div class="form-group">
            <label for="full_name">Full Name</label>
            <input type="text" name="full_name" id="full_name" class="form-control" required autofocus>
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" name="email" id="email" class="form-control" required autocomplete="email">
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <div>
                <input type="password" name="password" id="password" class="form-control" required autocomplete="new-password">
                <label class="password-toggle">
                    <input type="checkbox" onclick="document.getElementById('password').type = this.checked ? 'text' : 'password'">
                    Show password
                </label>
            </div>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Sign Up</button>
        </div>
    </form>

    <div style="margin-top:20px;display:flex;gap:20px;align-items:center;">
        <a href="login.jsp" class="text-link">Already have an account? Log in →</a>
        <a href="index.jsp" class="text-link">← Back to Home</a>
    </div>

</div>
</div>
</div>

</body>
</html>
