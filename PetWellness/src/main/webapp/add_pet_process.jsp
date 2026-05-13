<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
    String petName = request.getParameter("pet_name");
    String species = request.getParameter("species");

    if (petName == null || petName.trim().isEmpty() ||
        species == null || species.trim().isEmpty()) {
        response.sendRedirect("add_pet.jsp?error=1");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        conn = DBConnection.getConnection();

        String sql = "INSERT INTO pet (owner_id, pet_name, species) VALUES (?, ?, ?)";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, ownerId);
        ps.setString(2, petName.trim());
        ps.setString(3, species.trim());

        ps.executeUpdate();
        response.sendRedirect("add_pet.jsp?success=1");

    } catch (Exception e) {
        response.sendRedirect("add_pet.jsp?error=2");
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
