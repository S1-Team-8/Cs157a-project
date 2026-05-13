<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
    String fullName = request.getParameter("full_name");

    if (fullName == null || fullName.trim().isEmpty()) {
        response.sendRedirect("owner_profile.jsp?error=1");
        return;
    }

    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(
            "UPDATE pet_owner SET full_name = ? WHERE owner_id = ?");
        ps.setString(1, fullName.trim());
        ps.setInt(2, ownerId);
        ps.executeUpdate();
        ps.close(); conn.close();

        session.setAttribute("owner_name", fullName.trim());
        response.sendRedirect("owner_profile.jsp?msg=updated");
    } catch (Exception e) {
        response.sendRedirect("owner_profile.jsp?error=2");
    }
%>
