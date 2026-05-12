<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }

    String visitIdStr      = request.getParameter("visit_id");
    String procedureName   = request.getParameter("procedure_name");
    String chargeAmountStr = request.getParameter("charge_amount");
    String notes           = request.getParameter("notes");

    boolean success = false;
    String errorMsg = "";

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        if (visitIdStr == null || visitIdStr.trim().isEmpty() ||
            procedureName == null || procedureName.trim().isEmpty() ||
            chargeAmountStr == null || chargeAmountStr.trim().isEmpty()) {
            throw new Exception("Please fill in all required fields.");
        }

        int visitId = Integer.parseInt(visitIdStr.trim());
        double chargeAmount = Double.parseDouble(chargeAmountStr.trim());

        if (chargeAmount < 0) {
            throw new Exception("Charge amount cannot be negative.");
        }

        conn = DBConnection.getConnection();
        String sql = "INSERT INTO procedure_record (visit_id, procedure_name, charge_amount, notes) VALUES (?, ?, ?, ?)";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, visitId);
        ps.setString(2, procedureName.trim());
        ps.setDouble(3, chargeAmount);
        ps.setString(4, (notes != null && !notes.trim().isEmpty()) ? notes.trim() : null);

        int rows = ps.executeUpdate();
        if (rows > 0) {
            success = true;
        } else {
            throw new Exception("Procedure could not be saved. Please try again.");
        }

    } catch (SQLIntegrityConstraintViolationException e) {
        errorMsg = "Invalid Visit ID — no matching visit record exists.";
    } catch (NumberFormatException e) {
        errorMsg = "Visit ID and Charge Amount must be valid numbers.";
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
    <title>Add Procedure Result</title>
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
            <h1 class="page-title">Procedure Saved</h1>
            <p class="message success-text">The procedure has been added to the visit record.</p>
            <div class="button-group">
                <a href="add_procedure.jsp?visit_id=<%= visitIdStr %>" class="btn btn-primary">Add Another Procedure</a>
                <a href="view_procedures.jsp?visit_id=<%= visitIdStr %>" class="btn btn-secondary">View Procedures</a>
                <a href="hospital_dashboard.jsp" class="btn btn-secondary">Dashboard</a>
            </div>
        <% } else { %>
            <div class="icon-circle icon-error">!</div>
            <h1 class="page-title">Something Went Wrong</h1>
            <p class="message error-text"><%= errorMsg %></p>
            <div class="button-group">
                <a href="add_procedure.jsp" class="btn btn-primary">Try Again</a>
                <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
