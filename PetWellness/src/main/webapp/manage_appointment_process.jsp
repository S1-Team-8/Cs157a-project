<%@ page import="com.petwellness.service.AppointmentService" %>
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

    String actionType = request.getParameter("action_type");
    boolean success = false;
    String errorMsg = "";

    try {
        if ("create".equals(actionType)) {
            String petIdStr = request.getParameter("pet_id");
            String vetIdStr = request.getParameter("vet_id");
            String appointmentDate = request.getParameter("appointment_date");

            if (petIdStr == null || petIdStr.trim().isEmpty() ||
                vetIdStr  == null || vetIdStr.trim().isEmpty() ||
                appointmentDate == null || appointmentDate.trim().isEmpty()) {
                throw new Exception("Please fill in all required fields.");
            }

            int petId = Integer.parseInt(petIdStr);
            int vetId = Integer.parseInt(vetIdStr);
            String formattedDate = appointmentDate.replace("T", " ") + ":00";

            String svcIdStr = request.getParameter("service_id");
            Integer serviceId = (svcIdStr != null && !svcIdStr.trim().isEmpty())
                                ? Integer.parseInt(svcIdStr) : null;

            AppointmentService.addAppointment(petId, vetId, formattedDate, serviceId);
            success = true;

        } else if ("update".equals(actionType)) {
            String apptIdStr = request.getParameter("appointment_id");
            String status = request.getParameter("status");

            if (apptIdStr == null || apptIdStr.trim().isEmpty() ||
                status == null || status.trim().isEmpty()) {
                throw new Exception("Please provide Appointment ID and Status.");
            }

            int appointmentId = Integer.parseInt(apptIdStr);
            AppointmentService.updateAppointmentStatus(appointmentId, status);
            success = true;

        } else {
            throw new Exception("Unknown action type.");
        }

    } catch (NumberFormatException e) {
        errorMsg = "IDs must be valid numbers.";
    } catch (Exception e) {
        errorMsg = e.getMessage();
        if (errorMsg == null || errorMsg.trim().isEmpty()) {
            errorMsg = "An unexpected error occurred.";
        }
    }

    if (success) {
        String redirectMsg = "Completed".equals(request.getParameter("status")) ? "completed" : "updated";
        if ("create".equals(actionType)) redirectMsg = "created";
        response.sendRedirect("view_appointments.jsp?msg=" + redirectMsg);
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Error — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <a href="view_appointments.jsp">Appointments</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell" style="display:flex;align-items:center;justify-content:center;min-height:calc(100vh - var(--topbar-h));">
<div class="card-sm" style="width:100%;">
<div class="card" style="text-align:center;">

    <div class="result-icon error">!</div>
    <h1 class="page-title">Something Went Wrong</h1>
    <div class="alert alert-error" style="text-align:left;"><%= errorMsg %></div>
    <div class="btn-row" style="justify-content:center;">
        <a href="manage_appointment.jsp" class="btn btn-primary">Try Again</a>
        <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
