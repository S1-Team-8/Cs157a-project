<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String petIdStr = request.getParameter("pet_id");
    String vetIdStr = request.getParameter("vet_id");
    String visitDate = request.getParameter("visit_date");
    String notes = request.getParameter("notes");

    String message = "";
    String messageType = "error";
    boolean success = false;

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        if (petIdStr == null || petIdStr.trim().isEmpty() ||
            vetIdStr == null || vetIdStr.trim().isEmpty() ||
            visitDate == null || visitDate.trim().isEmpty()) {
            throw new Exception("Please fill in all required fields.");
        }

        int petId = Integer.parseInt(petIdStr);
        int vetId = Integer.parseInt(vetIdStr);

        conn = DBConnection.getConnection();

        String sql = "INSERT INTO visit (pet_id, vet_id, visit_date, notes) VALUES (?, ?, ?, ?)";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, petId);
        ps.setInt(2, vetId);
        ps.setTimestamp(3, Timestamp.valueOf(visitDate.replace("T", " ") + ":00"));
        ps.setString(4, notes);

        int rows = ps.executeUpdate();

        if (rows > 0) {
            success = true;
            messageType = "success";
            message = "Visit added successfully.";
        } else {
            throw new Exception("Visit could not be added.");
        }

    } catch (Exception e) {
        message = e.getMessage();
        if (message == null || message.trim().isEmpty()) {
            message = "An unexpected error occurred while adding the visit.";
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
    <title>Add Visit Result</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #eef2f7;
            color: #1f2d3d;
        }

        .page-wrapper {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        .result-card {
            width: 100%;
            max-width: 700px;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.08);
            padding: 40px 45px;
            text-align: center;
        }

        .icon-circle {
            width: 90px;
            height: 90px;
            margin: 0 auto 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 42px;
            font-weight: bold;
        }

        .icon-success {
            background: #e7f7ee;
            color: #1f8f4d;
        }

        .icon-error {
            background: #fdecec;
            color: #c0392b;
        }

        .page-title {
            margin: 0 0 12px 0;
            font-size: 40px;
            font-weight: 700;
            color: #2f5597;
        }

        .message {
            font-size: 20px;
            line-height: 1.6;
            margin-bottom: 30px;
            color: #5f6b7a;
        }

        .message.success-text {
            color: #1f8f4d;
        }

        .message.error-text {
            color: #c0392b;
        }

        .button-group {
            display: flex;
            justify-content: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-block;
            text-decoration: none;
            border: none;
            border-radius: 12px;
            padding: 14px 28px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s ease, transform 0.2s ease;
        }

        .btn-primary {
            background: #2f5597;
            color: #ffffff;
        }

        .btn-primary:hover {
            background: #24457a;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: #dfe7f2;
            color: #2f5597;
        }

        .btn-secondary:hover {
            background: #cfd9e8;
            transform: translateY(-1px);
        }

        @media (max-width: 768px) {
            .result-card {
                padding: 28px 22px;
            }

            .page-title {
                font-size: 32px;
            }

            .message {
                font-size: 18px;
            }

            .button-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="page-wrapper">
        <div class="result-card">
            <% if (success) { %>
                <div class="icon-circle icon-success">✓</div>
                <h1 class="page-title">Visit Added</h1>
                <p class="message success-text"><%= message %></p>
                <div class="button-group">
                    <a href="add_visit.jsp" class="btn btn-primary">Add Another Visit</a>
                    <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                </div>
            <% } else { %>
                <div class="icon-circle icon-error">!</div>
                <h1 class="page-title">Something Went Wrong</h1>
                <p class="message error-text"><%= message %></p>
                <div class="button-group">
                    <a href="add_visit.jsp" class="btn btn-primary">Try Again</a>
                    <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>