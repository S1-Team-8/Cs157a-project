<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%!
    public String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
%>

<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    if (!"Admin".equals(session.getAttribute("staff_role"))) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }

    String fullName = request.getParameter("full_name");
    String role     = request.getParameter("role");
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    boolean success = false;
    String message  = "";
    String safeError = "";

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        if (fullName == null || fullName.trim().isEmpty() ||
            role     == null || role.trim().isEmpty()     ||
            username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            throw new Exception("Please fill in all required fields.");
        }

        fullName = fullName.trim();
        role     = role.trim();
        username = username.trim();

        if (fullName.length() > 100) throw new Exception("Full name is too long.");
        if (role.length()     > 50)  throw new Exception("Role is too long.");
        if (username.length() > 50)  throw new Exception("Username is too long.");
        if (password.length() < 6)   throw new Exception("Password must be at least 6 characters long.");

        String hashedPassword = hashPassword(password);

        conn = DBConnection.getConnection();
        String sql = "INSERT INTO staff (full_name, role, username, password_hash, is_active) VALUES (?, ?, ?, ?, ?)";
        ps = conn.prepareStatement(sql);
        ps.setString(1, fullName);
        ps.setString(2, role);
        ps.setString(3, username);
        ps.setString(4, hashedPassword);
        ps.setBoolean(5, true);

        int rows = ps.executeUpdate();
        if (rows > 0) {
            success = true;
            message = "Staff account created successfully.";
        } else {
            throw new Exception("Staff account could not be created.");
        }

    } catch (SQLIntegrityConstraintViolationException e) {
        safeError = "That username already exists. Please choose another.";
    } catch (Exception e) {
        safeError = e.getMessage();
        if (safeError == null || safeError.trim().isEmpty()) {
            safeError = "An unexpected error occurred.";
        }
    } finally {
        try { if (ps   != null) ps.close();   } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Staff Result — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <a href="manage_staff.jsp">Staff</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell" style="display:flex;align-items:center;justify-content:center;min-height:calc(100vh - var(--topbar-h));">
<div class="card-sm" style="width:100%;">
<div class="card" style="text-align:center;">

    <% if (success) { %>
        <div class="result-icon success">&#10003;</div>
        <h1 class="page-title">Staff Added</h1>
        <p class="page-subtitle"><%= message %></p>
        <div class="btn-row" style="justify-content:center;">
            <a href="add_staff.jsp" class="btn btn-primary">Add Another Staff</a>
            <a href="manage_staff.jsp" class="btn btn-secondary">Back to Staff List</a>
        </div>
    <% } else { %>
        <div class="result-icon error">!</div>
        <h1 class="page-title">Something Went Wrong</h1>
        <div class="alert alert-error" style="text-align:left;"><%= safeError %></div>
        <div class="btn-row" style="justify-content:center;">
            <a href="add_staff.jsp" class="btn btn-primary">Try Again</a>
            <a href="manage_staff.jsp" class="btn btn-secondary">Back to Staff List</a>
        </div>
    <% } %>

</div>
</div>
</div>

</body>
</html>
