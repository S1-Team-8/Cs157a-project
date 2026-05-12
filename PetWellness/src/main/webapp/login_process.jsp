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
    String loginInput = request.getParameter("login_id");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        if (loginInput == null || loginInput.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=2");
            return;
        }

        String hashedPassword = hashPassword(password);
        conn = DBConnection.getConnection();

        String sql = "SELECT owner_id, full_name, email " +
                     "FROM pet_owner " +
                     "WHERE (email = ? OR full_name = ?) AND password_hash = ?";

        ps = conn.prepareStatement(sql);
        ps.setString(1, loginInput.trim());
        ps.setString(2, loginInput.trim());
        ps.setString(3, hashedPassword);

        rs = ps.executeQuery();

        if (rs.next()) {
            session.setAttribute("owner_id", rs.getInt("owner_id"));
            session.setAttribute("owner_name", rs.getString("full_name"));
            session.setAttribute("owner_email", rs.getString("email"));
            response.sendRedirect("dashboard.jsp");
            return;
        } else {
            response.sendRedirect("login.jsp?error=1");
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