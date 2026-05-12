<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
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
    <title>Visit Record Result</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: Arial, sans-serif; background: #eef2f7; color: #1f2d3d; }
        .page-wrapper { min-height: 100vh; display: flex; justify-content: center; align-items: center; padding: 40px 20px; }
        .result-card { width: 100%; max-width: 700px; background: #fff; border-radius: 20px; box-shadow: 0 12px 35px rgba(0,0,0,0.08); padding: 40px 45px; text-align: center; }
        .icon-circle { width: 90px; height: 90px; margin: 0 auto 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 42px; font-weight: bold; }
        .icon-success { background: #e7f7ee; color: #1f8f4d; }
        .icon-error   { background: #fdecec; color: #c0392b; }
        .page-title { margin: 0 0 12px 0; font-size: 40px; font-weight: 700; color: #2f5597; }
        .message { font-size: 20px; line-height: 1.6; margin-bottom: 30px; }
        .success-text { color: #1f8f4d; }
        .error-text   { color: #c0392b; }
        .button-group { display: flex; justify-content: center; gap: 16px; flex-wrap: wrap; }
        .btn { display: inline-block; text-decoration: none; border: none; border-radius: 12px; padding: 14px 28px; font-size: 18px; font-weight: 600; cursor: pointer; }
        .btn-primary   { background: #2f5597; color: #fff; }
        .btn-secondary { background: #dfe7f2; color: #2f5597; }
    </style>
</head>
<body>
<div class="page-wrapper">
    <div class="result-card">
        <% if (success) { %>
            <div class="icon-circle icon-success">&#10003;</div>
            <h1 class="page-title">Visit Saved</h1>
            <p class="message success-text">Visit record has been created successfully.</p>
            <div class="button-group">
                <a href="hospital_add_visit.jsp" class="btn btn-primary">Add Another Visit</a>
                <a href="hospital_view_visits.jsp" class="btn btn-secondary">View All Visits</a>
                <a href="hospital_dashboard.jsp" class="btn btn-secondary">Dashboard</a>
            </div>
        <% } else { %>
            <div class="icon-circle icon-error">!</div>
            <h1 class="page-title">Something Went Wrong</h1>
            <p class="message error-text"><%= errorMsg %></p>
            <div class="button-group">
                <a href="hospital_add_visit.jsp" class="btn btn-primary">Try Again</a>
                <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
