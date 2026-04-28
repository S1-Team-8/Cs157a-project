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

    Connection conn = null;
    PreparedStatement checkStmt = null;
    PreparedStatement insertStmt = null;
    ResultSet rs = null;

    try {
        if (fullName == null || fullName.trim().isEmpty() ||
            role == null || role.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("staff_signup.jsp?error=1");
            return;
        }

        fullName = fullName.trim();
        role = role.trim();
        username = username.trim();

        if (password.length() < 6) {
            response.sendRedirect("staff_signup.jsp?error=3");
            return;
        }

        conn = DBConnection.getConnection();

        String checkSql = "SELECT employee_id FROM staff WHERE username = ?";
        checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setString(1, username);
        rs = checkStmt.executeQuery();

        if (rs.next()) {
            response.sendRedirect("staff_signup.jsp?error=2");
            return;
        }

        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (checkStmt != null) checkStmt.close(); } catch (Exception e) {}

        String hashedPassword = hashPassword(password);

        String insertSql = "INSERT INTO staff (full_name, role, username, password_hash, is_active) VALUES (?, ?, ?, ?, ?)";
        insertStmt = conn.prepareStatement(insertSql);
        insertStmt.setString(1, fullName);
        insertStmt.setString(2, role);
        insertStmt.setString(3, username);
        insertStmt.setString(4, hashedPassword);
        insertStmt.setBoolean(5, true);

        int rows = insertStmt.executeUpdate();

        if (rows > 0) {
            response.sendRedirect("staff_signup.jsp?success=1");
        } else {
            response.sendRedirect("staff_signup.jsp?error=4");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("staff_signup.jsp?error=4");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (checkStmt != null) checkStmt.close(); } catch (Exception e) {}
        try { if (insertStmt != null) insertStmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>