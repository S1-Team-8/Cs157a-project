<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    String _role = (String) session.getAttribute("staff_role");
    if (_role == null) _role = "";
    if (!"Admin".equals(_role) && !"Veterinarian".equals(_role)) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }

    String petIdStr    = request.getParameter("pet_id");
    String vetIdStr    = request.getParameter("vet_id");
    String visitDate   = request.getParameter("visit_date");
    String notes       = request.getParameter("notes");

    boolean success = false;
    String errorMsg = "";

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        if (petIdStr == null || petIdStr.trim().isEmpty() ||
            vetIdStr  == null || vetIdStr.trim().isEmpty() ||
            visitDate == null || visitDate.trim().isEmpty()) {
            throw new Exception("Please fill in all required fields.");
        }

        int petId = Integer.parseInt(petIdStr);
        int vetId = Integer.parseInt(vetIdStr);
        String formattedDate = visitDate.replace("T", " ") + ":00";

        conn = DBConnection.getConnection();
        String sql = "INSERT INTO visit (pet_id, vet_id, visit_date, notes) VALUES (?, ?, ?, ?)";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, petId);
        ps.setInt(2, vetId);
        ps.setTimestamp(3, Timestamp.valueOf(formattedDate));
        ps.setString(4, (notes != null && !notes.trim().isEmpty()) ? notes.trim() : null);

        int rows = ps.executeUpdate();
        if (rows > 0) {
            success = true;
        } else {
            throw new Exception("Visit could not be saved. Please try again.");
        }

    } catch (Exception e) {
        errorMsg = e.getMessage();
        if (errorMsg == null || errorMsg.trim().isEmpty()) {
            errorMsg = "An unexpected error occurred.";
        }
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visit Record Result — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <a href="hospital_view_visits.jsp">Visits</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell" style="display:flex;align-items:center;justify-content:center;min-height:calc(100vh - var(--topbar-h));">
<div class="card-sm" style="width:100%;">
<div class="card" style="text-align:center;">

    <% if (success) { %>
        <div class="result-icon success">&#10003;</div>
        <h1 class="page-title">Visit Saved</h1>
        <p class="page-subtitle">Visit record has been created successfully.</p>
        <div class="btn-row" style="justify-content:center;">
            <a href="hospital_add_visit.jsp" class="btn btn-primary">Add Another Visit</a>
            <a href="hospital_view_visits.jsp" class="btn btn-secondary">View All Visits</a>
            <a href="hospital_dashboard.jsp" class="btn btn-secondary">Dashboard</a>
        </div>
    <% } else { %>
        <div class="result-icon error">!</div>
        <h1 class="page-title">Something Went Wrong</h1>
        <div class="alert alert-error" style="text-align:left;"><%= errorMsg %></div>
        <div class="btn-row" style="justify-content:center;">
            <a href="hospital_add_visit.jsp" class="btn btn-primary">Try Again</a>
            <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    <% } %>

</div>
</div>
</div>

</body>
</html>
