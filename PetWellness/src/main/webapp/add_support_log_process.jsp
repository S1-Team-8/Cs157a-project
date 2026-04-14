<%@ page import="com.petwellness.service.SupportLogService" %>
<%
    try {
        int visitId = Integer.parseInt(request.getParameter("visit_id"));
        int technicianId = Integer.parseInt(request.getParameter("technician_id"));
        double weight = Double.parseDouble(request.getParameter("weight"));
        double temperature = Double.parseDouble(request.getParameter("temperature"));
        String notes = request.getParameter("notes");

        SupportLogService.addSupportLog(visitId, technicianId, weight, temperature, notes);

        response.sendRedirect("hospital_dashboard.jsp");
    } catch (Exception e) {
        out.println("<h3>Error saving technician support log.</h3>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>