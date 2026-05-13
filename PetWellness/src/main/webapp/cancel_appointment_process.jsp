<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
    String apptIdStr = request.getParameter("appointment_id");

    if (apptIdStr == null || apptIdStr.trim().isEmpty()) {
        response.sendRedirect("view_my_appointments.jsp");
        return;
    }

    try {
        int apptId = Integer.parseInt(apptIdStr.trim());
        Connection conn = DBConnection.getConnection();

        // Only cancel Pending appointments that belong to this owner
        PreparedStatement ps = conn.prepareStatement(
            "UPDATE appointment a " +
            "JOIN pet p ON a.pet_id = p.pet_id " +
            "SET a.status = 'Canceled' " +
            "WHERE a.appointment_id = ? AND p.owner_id = ? AND a.status = 'Pending'");
        ps.setInt(1, apptId);
        ps.setInt(2, ownerId);
        int rows = ps.executeUpdate();
        ps.close(); conn.close();

        if (rows > 0) {
            response.sendRedirect("view_my_appointments.jsp?msg=canceled");
        } else {
            response.sendRedirect("view_my_appointments.jsp?error=cancel");
        }
    } catch (Exception e) {
        response.sendRedirect("view_my_appointments.jsp?error=cancel");
    }
%>
