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
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("staff_login.jsp?error=2");
            return;
        }

        String hashedPassword = hashPassword(password);
        conn = DBConnection.getConnection();

        String sql = "SELECT employee_id, full_name, role, username " +
                     "FROM staff " +
                     "WHERE username = ? AND password_hash = ? AND is_active = TRUE";

        ps = conn.prepareStatement(sql);
        ps.setString(1, username.trim());
        ps.setString(2, hashedPassword);

        rs = ps.executeQuery();

        if (rs.next()) {
            session.setAttribute("employee_id", rs.getInt("employee_id"));
            session.setAttribute("staff_name", rs.getString("full_name"));
            session.setAttribute("staff_role", rs.getString("role"));
            session.setAttribute("staff_username", rs.getString("username"));
            response.sendRedirect("hospital_dashboard.jsp");
            return;
        } else {
            response.sendRedirect("staff_login.jsp?error=1");
            return;
        }

    } catch (Exception e) {
        out.println("Login error: " + e.getMessage());
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>