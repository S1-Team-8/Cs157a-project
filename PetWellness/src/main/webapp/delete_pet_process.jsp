<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
    String petIdStr = request.getParameter("pet_id");

    if (petIdStr == null || petIdStr.trim().isEmpty()) {
        response.sendRedirect("view_pets.jsp");
        return;
    }

    try {
        int petId = Integer.parseInt(petIdStr.trim());
        Connection conn = DBConnection.getConnection();

        // Verify ownership before deleting
        PreparedStatement checkPs = conn.prepareStatement(
            "SELECT pet_id FROM pet WHERE pet_id = ? AND owner_id = ?");
        checkPs.setInt(1, petId);
        checkPs.setInt(2, ownerId);
        ResultSet checkRs = checkPs.executeQuery();
        boolean owned = checkRs.next();
        checkRs.close(); checkPs.close();

        if (!owned) {
            conn.close();
            response.sendRedirect("view_pets.jsp?error=auth");
            return;
        }

        PreparedStatement delPs = conn.prepareStatement(
            "DELETE FROM pet WHERE pet_id = ? AND owner_id = ?");
        delPs.setInt(1, petId);
        delPs.setInt(2, ownerId);
        delPs.executeUpdate();
        delPs.close(); conn.close();

        response.sendRedirect("view_pets.jsp?msg=deleted");

    } catch (SQLIntegrityConstraintViolationException e) {
        response.sendRedirect("view_pets.jsp?error=fk");
    } catch (Exception e) {
        response.sendRedirect("view_pets.jsp?error=auth");
    }
%>
