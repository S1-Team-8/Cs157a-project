<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
    String msg = request.getParameter("msg");
    String err = request.getParameter("error");

    String fullName = null, email = null;
    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(
            "SELECT full_name, email FROM pet_owner WHERE owner_id = ?");
        ps.setInt(1, ownerId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            fullName = rs.getString("full_name");
            email    = rs.getString("email");
        }
        rs.close(); ps.close(); conn.close();
    } catch (Exception e) {
        fullName = "";
        email    = "";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile — PetWellness</title>
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

    <h1 class="page-title">My Profile</h1>
    <p class="page-subtitle">View and update your account information.</p>
    <hr class="divider">

    <% if ("updated".equals(msg)) { %>
        <div class="alert alert-success">Profile updated successfully.</div>
    <% } else if ("1".equals(err)) { %>
        <div class="alert alert-error">Full name cannot be empty.</div>
    <% } else if ("2".equals(err)) { %>
        <div class="alert alert-error">Unable to save changes. Please try again.</div>
    <% } %>

    <form action="owner_profile_process.jsp" method="post">

        <div class="form-group">
            <label for="full_name">Full Name *</label>
            <input type="text" name="full_name" id="full_name" class="form-control"
                   value="<%= fullName != null ? fullName : "" %>" required autofocus>
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="text" class="form-control" value="<%= email != null ? email : "" %>" readonly>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Save Changes</button>
            <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </form>

    <hr class="divider">

    <p class="section-heading" style="margin-top:0;">Security</p>
    <div class="btn-row">
        <a href="change_password_owner.jsp" class="btn btn-secondary">Change Password</a>
    </div>

</div>
</div>
</div>

</body>
</html>
