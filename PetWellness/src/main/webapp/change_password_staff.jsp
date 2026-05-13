<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    String staffName = (String) session.getAttribute("staff_name");
    if (staffName == null) staffName = "Staff";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell" style="display:flex;align-items:flex-start;justify-content:center;padding-top:40px;">
<div class="card-sm" style="width:100%;">
<div class="card">

    <h1 class="page-title">Change Password</h1>
    <p class="page-subtitle">Logged in as <strong><%= staffName %></strong></p>
    <hr class="divider">

    <%
        String error   = request.getParameter("error");
        String success = request.getParameter("success");
        if ("1".equals(error)) {
    %>
        <div class="alert alert-error">All fields are required.</div>
    <% } else if ("2".equals(error)) { %>
        <div class="alert alert-error">Current password is incorrect.</div>
    <% } else if ("3".equals(error)) { %>
        <div class="alert alert-error">New password must be at least 6 characters.</div>
    <% } else if ("4".equals(error)) { %>
        <div class="alert alert-error">Something went wrong. Please try again.</div>
    <% } else if ("1".equals(success)) { %>
        <div class="alert alert-success">Password updated successfully.</div>
    <% } %>

    <form action="change_password_staff_process.jsp" method="post">

        <div class="form-group">
            <label for="current_password">Current Password</label>
            <input type="password" id="current_password" name="current_password" class="form-control" required autocomplete="current-password">
        </div>

        <div class="form-group">
            <label for="new_password">New Password</label>
            <div>
                <input type="password" id="new_password" name="new_password" class="form-control" required autocomplete="new-password">
                <label class="password-toggle">
                    <input type="checkbox" onclick="document.getElementById('new_password').type = this.checked ? 'text' : 'password'">
                    Show password
                </label>
                <p class="form-hint">Minimum 6 characters.</p>
            </div>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Update Password</button>
            <a href="hospital_dashboard.jsp" class="btn btn-secondary">Cancel</a>
        </div>
    </form>

</div>
</div>
</div>

</body>
</html>
