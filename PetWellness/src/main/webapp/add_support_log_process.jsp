<%@ page import="com.petwellness.service.SupportLogService" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }

    boolean success = false;
    String errorMsg = "";
    String visitIdStr = request.getParameter("visit_id");

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
        double weight      = (weightStr != null && !weightStr.trim().isEmpty()) ? Double.parseDouble(weightStr.trim()) : 0.0;
        double temperature = (tempStr   != null && !tempStr.trim().isEmpty())   ? Double.parseDouble(tempStr.trim())   : 0.0;

        SupportLogService.addSupportLog(visitId, technicianId, weight, temperature, notes);
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
    <title>Support Log Result</title>
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
            <h1 class="page-title">Log Saved</h1>
            <p class="message success-text">Technician support log has been recorded successfully.</p>
            <div class="button-group">
                <a href="add_support_log.jsp?visit_id=<%= visitIdStr %>" class="btn btn-primary">Add Another Log</a>
                <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
            </div>
        <% } else { %>
            <div class="icon-circle icon-error">!</div>
            <h1 class="page-title">Something Went Wrong</h1>
            <p class="message error-text"><%= errorMsg %></p>
            <div class="button-group">
                <a href="add_support_log.jsp" class="btn btn-primary">Try Again</a>
                <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
