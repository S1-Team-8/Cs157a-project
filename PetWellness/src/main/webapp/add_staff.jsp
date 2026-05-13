<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    String staffRole = (String) session.getAttribute("staff_role");
    if (staffRole == null) staffRole = "";
    boolean isAdmin    = "Admin".equals(staffRole);
    boolean isManager  = "Manager".equals(staffRole);
    boolean isInvStaff = "Inventory Staff".equals(staffRole);
    if (!isAdmin) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Staff Account — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <% if (isAdmin || isManager || isInvStaff) { %>
            <a href="manage_inventory.jsp">Inventory</a>
        <% } %>
        <% if (isAdmin || isManager) { %>
            <a href="reports.jsp">Reports</a>
        <% } %>
        <a href="manage_staff.jsp" class="nav-active">Staff</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-sm" style="margin-top:0;">
<div class="card">

    <h1 class="page-title">Add Staff Account</h1>
    <p class="page-subtitle">Create a new staff login for the clinic system.</p>
    <hr class="divider">

    <form action="add_staff_process.jsp" method="post">

        <div class="form-group">
            <label for="full_name">Full Name</label>
            <input type="text" name="full_name" id="full_name" class="form-control" required autofocus>
        </div>

        <div class="form-group">
            <label for="role">Role</label>
            <div>
                <select name="role" id="role" class="form-control" required>
                    <option value="">Select a role</option>
                    <option value="Admin">Admin — full system access</option>
                    <option value="Manager">Manager — reports, appointments, inventory</option>
                    <option value="Veterinarian">Veterinarian — visits, procedures, appointments</option>
                    <option value="Technician">Technician — vitals, visit support logs</option>
                    <option value="Inventory Staff">Inventory Staff — inventory management</option>
                </select>
                <p class="form-hint">Role determines which sections the staff member can access after login.</p>
            </div>
        </div>

        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" name="username" id="username" class="form-control" required autocomplete="off">
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
            <button type="submit" class="btn btn-primary">Create Staff Account</button>
            <a href="manage_staff.jsp" class="btn btn-secondary">Cancel</a>
        </div>
    </form>

</div>
</div>
</div>

</body>
</html>
