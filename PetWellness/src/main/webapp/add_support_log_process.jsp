<%@ page import="com.petwellness.service.SupportLogService" %>
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
    if (!"Admin".equals(_role) && !"Technician".equals(_role)) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }

    boolean success = false;
    String errorMsg = "";
    String visitIdStr    = request.getParameter("visit_id");
    String apptIdStr     = request.getParameter("appointment_id");
    if (apptIdStr == null) apptIdStr = "";

    try {
        String techIdStr    = request.getParameter("technician_id");
        String weightStr    = request.getParameter("weight");
        String tempStr      = request.getParameter("temperature");
        String notes        = request.getParameter("notes");

        if (visitIdStr == null || visitIdStr.trim().isEmpty() ||
            techIdStr  == null || techIdStr.trim().isEmpty()) {
            throw new Exception("Visit ID and technician are required.");
        }

        int visitId      = Integer.parseInt(visitIdStr.trim());
        int technicianId = Integer.parseInt(techIdStr.trim());
        Double weight      = (weightStr != null && !weightStr.trim().isEmpty()) ? Double.parseDouble(weightStr.trim()) : null;
        Double temperature = (tempStr   != null && !tempStr.trim().isEmpty())   ? Double.parseDouble(tempStr.trim())   : null;

        SupportLogService.addSupportLog(visitId, technicianId, weight, temperature, notes);

        // Advance appointment status: Scheduled → Recorded
        if (!apptIdStr.isEmpty()) {
            Connection _ac = DBConnection.getConnection();
            try {
                PreparedStatement _ap = _ac.prepareStatement(
                    "UPDATE appointment SET status='Recorded' WHERE appointment_id=? AND status='Scheduled'");
                _ap.setInt(1, Integer.parseInt(apptIdStr.trim()));
                _ap.executeUpdate();
                _ap.close();
            } finally { try { _ac.close(); } catch (Exception e) {} }
        }
        success = true;

    } catch (NumberFormatException e) {
        errorMsg = "Visit ID must be a valid number.";
    } catch (Exception e) {
        errorMsg = e.getMessage();
        if (errorMsg == null || errorMsg.trim().isEmpty()) {
            errorMsg = "An unexpected error occurred.";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Support Log Result — PetWellness</title>
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

<div class="page-shell" style="display:flex;align-items:center;justify-content:center;min-height:calc(100vh - var(--topbar-h));">
<div class="card-sm" style="width:100%;">
<div class="card" style="text-align:center;">

    <% if (success) { %>
        <div class="result-icon success">&#10003;</div>
        <h1 class="page-title">Log Saved</h1>
        <p class="page-subtitle">Technician support log has been recorded successfully.</p>
        <div class="btn-row" style="justify-content:center;">
            <a href="add_support_log.jsp?appointment_id=<%= apptIdStr %>" class="btn btn-primary">Add Another Log</a>
            <a href="hospital_view_visits.jsp" class="btn btn-secondary">Patient History</a>
            <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    <% } else { %>
        <div class="result-icon error">!</div>
        <h1 class="page-title">Something Went Wrong</h1>
        <div class="alert alert-error" style="text-align:left;"><%= errorMsg %></div>
        <div class="btn-row" style="justify-content:center;">
            <a href="add_support_log.jsp" class="btn btn-primary">Try Again</a>
            <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    <% } %>

</div>
</div>
</div>

</body>
</html>
