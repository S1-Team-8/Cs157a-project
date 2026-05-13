<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    String _role = (String) session.getAttribute("staff_role");
    if (_role == null) _role = "";
    if (!"Admin".equals(_role) && !"Manager".equals(_role)) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }

    String apptIdStr    = request.getParameter("appointment_id");
    String vetIdStr     = request.getParameter("vet_id");
    String confirmedDate = request.getParameter("appointment_date");

    if (apptIdStr == null || vetIdStr == null || confirmedDate == null
            || apptIdStr.trim().isEmpty() || vetIdStr.trim().isEmpty()
            || confirmedDate.trim().isEmpty()) {
        response.sendRedirect("view_appointments.jsp?msg=error");
        return;
    }

    Connection conn = null; PreparedStatement stmt = null;
    try {
        int apptId = Integer.parseInt(apptIdStr);
        int vetId  = Integer.parseInt(vetIdStr);
        String formattedDate = confirmedDate.replace("T", " ");
        if (formattedDate.length() == 16) formattedDate += ":00";

        conn = DBConnection.getConnection();
        stmt = conn.prepareStatement(
            "UPDATE appointment SET vet_id = ?, appointment_date = ?, status = 'Scheduled' " +
            "WHERE appointment_id = ? AND status = 'Pending'");
        stmt.setInt(1, vetId);
        stmt.setString(2, formattedDate);
        stmt.setInt(3, apptId);
        int rows = stmt.executeUpdate();

        if (rows == 0) {
            response.sendRedirect("view_appointments.jsp?msg=error");
        } else {
            response.sendRedirect("view_appointments.jsp?msg=approved");
        }
    } catch (Exception e) {
        response.sendRedirect("view_appointments.jsp?msg=error");
    } finally {
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
