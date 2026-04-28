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
    String fullName = request.getParameter("full_name");
    String role = request.getParameter("role");
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    boolean success = false;
    String message = "";
    String safeError = "";

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        if (fullName == null || fullName.trim().isEmpty() ||
            role == null || role.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            throw new Exception("Please fill in all required fields.");
        }

        fullName = fullName.trim();
        role = role.trim();
        username = username.trim();

        if (fullName.length() > 100) {
            throw new Exception("Full name is too long.");
        }

        if (role.length() > 50) {
            throw new Exception("Role is too long.");
        }

        if (username.length() > 50) {
            throw new Exception("Username is too long.");
        }

        if (password.length() < 6) {
            throw new Exception("Password must be at least 6 characters long.");
        }

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
        safeError = "That username already exists. Please choose another username.";
    } catch (Exception e) {
        safeError = e.getMessage();
        if (safeError == null || safeError.trim().isEmpty()) {
            safeError = "An unexpected error occurred while creating the staff account.";
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
    <title>Add Staff Result</title>
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
            max-width: 720px;
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
                <h1 class="page-title">Staff Added</h1>
                <p class="message success-text"><%= message %></p>
                <div class="button-group">
                    <a href="add_staff.jsp" class="btn btn-primary">Add Another Staff</a>
                    <a href="manage_staff.jsp" class="btn btn-secondary">Back to Staff List</a>
                </div>
            <% } else { %>
                <div class="icon-circle icon-error">!</div>
                <h1 class="page-title">Something Went Wrong</h1>
                <p class="message error-text"><%= safeError %></p>
                <div class="button-group">
                    <a href="add_staff.jsp" class="btn btn-primary">Try Again</a>
                    <a href="manage_staff.jsp" class="btn btn-secondary">Back to Staff List</a>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>