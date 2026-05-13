<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    private String sha256(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(input.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) { return null; }
    }
%>
<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());

    String currentPw  = request.getParameter("current_password");
    String newPw      = request.getParameter("new_password");
    String confirmPw  = request.getParameter("confirm_password");

    if (currentPw == null || currentPw.isEmpty() ||
        newPw     == null || newPw.isEmpty() ||
        confirmPw == null || confirmPw.isEmpty()) {
        response.sendRedirect("change_password_owner.jsp?error=1");
        return;
    }

    if (!newPw.equals(confirmPw)) {
        response.sendRedirect("change_password_owner.jsp?error=3");
        return;
    }

    if (newPw.length() < 6) {
        response.sendRedirect("change_password_owner.jsp?error=4");
        return;
    }

    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(
            "SELECT password_hash FROM pet_owner WHERE owner_id = ?");
        ps.setInt(1, ownerId);
        ResultSet rs = ps.executeQuery();
        if (!rs.next()) {
            rs.close(); ps.close(); conn.close();
            response.sendRedirect("login.jsp");
            return;
        }
        String storedHash = rs.getString("password_hash");
        rs.close(); ps.close();

        if (!sha256(currentPw).equals(storedHash)) {
            conn.close();
            response.sendRedirect("change_password_owner.jsp?error=2");
            return;
        }

        PreparedStatement upPs = conn.prepareStatement(
            "UPDATE pet_owner SET password_hash = ? WHERE owner_id = ?");
        upPs.setString(1, sha256(newPw));
        upPs.setInt(2, ownerId);
        upPs.executeUpdate();
        upPs.close(); conn.close();

        response.sendRedirect("change_password_owner.jsp?msg=updated");
    } catch (Exception e) {
        response.sendRedirect("change_password_owner.jsp?error=5");
    }
%>
