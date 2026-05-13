<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());

    String petIdStr  = request.getParameter("pet_id");
    String petName   = request.getParameter("pet_name");
    String species   = request.getParameter("species");

    if (petIdStr == null || petName == null || species == null
            || petName.trim().isEmpty() || species.trim().isEmpty()) {
        String pid = (petIdStr != null) ? petIdStr : "";
        response.sendRedirect("edit_pet.jsp?pet_id=" + pid + "&error=1");
        return;
    }

    try {
        int petId = Integer.parseInt(petIdStr.trim());
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(
            "UPDATE pet SET pet_name = ?, species = ? WHERE pet_id = ? AND owner_id = ?");
        ps.setString(1, petName.trim());
        ps.setString(2, species.trim());
        ps.setInt(3, petId);
        ps.setInt(4, ownerId);
        int rows = ps.executeUpdate();
        ps.close(); conn.close();

        if (rows == 0) {
            response.sendRedirect("view_pets.jsp?error=auth");
        } else {
            response.sendRedirect("view_pets.jsp?msg=updated");
        }
    } catch (Exception e) {
        response.sendRedirect("edit_pet.jsp?pet_id=" + petIdStr + "&error=2");
    }
%>
