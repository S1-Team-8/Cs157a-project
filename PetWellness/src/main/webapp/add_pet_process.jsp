<<<<<<< Updated upstream
<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
=======
 <%@ page import="javax.servlet.*,javax.servlet.http.*" %>
<%@ page import="com.petwellness.service.PetService" %>
>>>>>>> Stashed changes
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Object ownerObj = session.getAttribute("id");
    String petName = request.getParameter("pet_name");
    String species = request.getParameter("species");

    out.println("DEBUG owner_id = " + ownerObj + "<br>");
    out.println("DEBUG pet_name = " + petName + "<br>");
    out.println("DEBUG species = " + species + "<br>");

    if (ownerObj == null) {
        out.println("Error: session owner_id is missing.");
        return;
    }

    if (petName == null || petName.trim().isEmpty() ||
        species == null || species.trim().isEmpty()) {
        out.println("Error: pet_name or species is missing.");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        int ownerId = Integer.parseInt(ownerObj.toString());

        conn = DBConnection.getConnection();

        String sql = "INSERT INTO Pet (owner_id, pet_name, species) VALUES (?, ?, ?)";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, ownerId);
        ps.setString(2, petName.trim());
        ps.setString(3, species.trim());

        int rows = ps.executeUpdate();

        if (rows > 0) {
            response.sendRedirect("add_pet.jsp?success=1");
        } else {
            out.println("Error: insert failed.");
        }

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        try {
            if (ps != null) ps.close();
        } catch (Exception e) {}

        try {
            if (conn != null) conn.close();
        } catch (Exception e) {}
    }
%>