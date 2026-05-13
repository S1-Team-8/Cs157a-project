<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String err = request.getParameter("error");
    String msg = request.getParameter("msg");
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
    <div class="brand"><a href="dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="view_pets.jsp">My Pets</a>
        <a href="view_my_appointments.jsp">Appointments</a>
        <a href="search_clinic.jsp">Clinics</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-sm" style="width:100%;">
<div class="card">

    <h1 class="page-title">Change Password</h1>
    <p class="page-subtitle">Enter your current password to set a new one.</p>
    <hr class="divider">

    <% if ("updated".equals(msg)) { %>
        <div class="alert alert-success">Password changed successfully.</div>
    <% } else if ("1".equals(err)) { %>
        <div class="alert alert-error">All fields are required.</div>
    <% } else if ("2".equals(err)) { %>
        <div class="alert alert-error">Current password is incorrect.</div>
    <% } else if ("3".equals(err)) { %>
        <div class="alert alert-error">New passwords do not match.</div>
    <% } else if ("4".equals(err)) { %>
        <div class="alert alert-error">New password must be at least 6 characters.</div>
    <% } else if ("5".equals(err)) { %>
        <div class="alert alert-error">Unable to update password. Please try again.</div>
    <% } %>

    <form action="change_password_owner_process.jsp" method="post">

        <div class="form-group">
            <label for="current_password">Current Password</label>
            <input type="password" name="current_password" id="current_password"
                   class="form-control" required autofocus>
        </div>

        <div class="form-group">
            <label for="new_password">New Password</label>
            <input type="password" name="new_password" id="new_password"
                   class="form-control" required>
        </div>

        <div class="form-group">
            <label for="confirm_password">Confirm Password</label>
            <input type="password" name="confirm_password" id="confirm_password"
                   class="form-control" required>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Update Password</button>
            <a href="owner_profile.jsp" class="btn btn-secondary">Back to Profile</a>
        </div>
    </form>

</div>
</div>
</div>

</body>
</html>
