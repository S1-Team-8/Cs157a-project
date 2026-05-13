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

    int employeeId = Integer.parseInt(session.getAttribute("employee_id").toString());
    String currentPassword = request.getParameter("current_password");
    String newPassword     = request.getParameter("new_password");

    if (currentPassword == null || currentPassword.trim().isEmpty() ||
        newPassword     == null || newPassword.trim().isEmpty()) {
        response.sendRedirect("change_password_staff.jsp?error=1");
        return;
    }

    if (newPassword.length() < 6) {
        response.sendRedirect("change_password_staff.jsp?error=3");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        String currentHash = hashPassword(currentPassword);
        String newHash     = hashPassword(newPassword);

        conn = DBConnection.getConnection();

        ps = conn.prepareStatement(
            "SELECT employee_id FROM staff WHERE employee_id = ? AND password_hash = ?");
        ps.setInt(1, employeeId);
        ps.setString(2, currentHash);
        rs = ps.executeQuery();

        if (!rs.next()) {
            response.sendRedirect("change_password_staff.jsp?error=2");
            return;
        }

        rs.close(); ps.close();

        ps = conn.prepareStatement(
            "UPDATE staff SET password_hash = ? WHERE employee_id = ?");
        ps.setString(1, newHash);
        ps.setInt(2, employeeId);
        ps.executeUpdate();

        response.sendRedirect("change_password_staff.jsp?success=1");

    } catch (Exception e) {
        response.sendRedirect("change_password_staff.jsp?error=4");
    } finally {
        try { if (rs   != null) rs.close();   } catch (Exception e) {}
        try { if (ps   != null) ps.close();   } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
