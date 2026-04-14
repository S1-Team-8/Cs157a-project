<%@ page import="com.petwellness.service.PetService" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String petName = request.getParameter("pet_name");
    String species = request.getParameter("species");

    if (petName == null || species == null || petName.trim().isEmpty() || species.trim().isEmpty()) {
        response.sendRedirect("add_pet.jsp?error=1");
        return;
    }

    try {
        int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
        PetService.addPet(ownerId, petName.trim(), species.trim());
        response.sendRedirect("add_pet.jsp?success=1");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("add_pet.jsp?error=2");
    }
%>