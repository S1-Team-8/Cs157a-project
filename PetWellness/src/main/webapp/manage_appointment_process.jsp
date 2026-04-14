<%@ page import="com.petwellness.service.AppointmentService" %>
<%
    String actionType = request.getParameter("action_type");

    try {
        if ("create".equals(actionType)) {
            int petId = Integer.parseInt(request.getParameter("pet_id"));
            int vetId = Integer.parseInt(request.getParameter("vet_id"));
            String appointmentDate = request.getParameter("appointment_date");

            String formattedDate = appointmentDate.replace("T", " ") + ":00";

            AppointmentService.addAppointment(petId, vetId, formattedDate);

        } else if ("update".equals(actionType)) {
            int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
            String status = request.getParameter("status");

            AppointmentService.updateAppointmentStatus(appointmentId, status);
        }

        response.sendRedirect("dashboard.jsp");

    } catch (Exception e) {
        out.println("<h3>Error managing appointment.</h3>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>