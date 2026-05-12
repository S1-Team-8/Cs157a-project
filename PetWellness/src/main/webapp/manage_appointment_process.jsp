<%@ page import="com.petwellness.service.AppointmentService" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
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

            AppointmentService.addAppointment(petId, vetId, formattedDate);
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
        response.sendRedirect("view_appointments.jsp");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Appointment Error</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: Arial, sans-serif; background: #eef2f7; color: #1f2d3d; }
        .page-wrapper { min-height: 100vh; display: flex; justify-content: center; align-items: center; padding: 40px 20px; }
        .result-card { width: 100%; max-width: 700px; background: #fff; border-radius: 20px; box-shadow: 0 12px 35px rgba(0,0,0,0.08); padding: 40px 45px; text-align: center; }
        .icon-circle { width: 90px; height: 90px; margin: 0 auto 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 42px; font-weight: bold; background: #fdecec; color: #c0392b; }
        .page-title { margin: 0 0 12px 0; font-size: 40px; font-weight: 700; color: #2f5597; }
        .message { font-size: 20px; line-height: 1.6; margin-bottom: 30px; color: #c0392b; }
        .button-group { display: flex; justify-content: center; gap: 16px; flex-wrap: wrap; }
        .btn { display: inline-block; text-decoration: none; border: none; border-radius: 12px; padding: 14px 28px; font-size: 18px; font-weight: 600; cursor: pointer; }
        .btn-primary   { background: #2f5597; color: #fff; }
        .btn-secondary { background: #dfe7f2; color: #2f5597; }
    </style>
</head>
<body>
<div class="page-wrapper">
    <div class="result-card">
        <div class="icon-circle">!</div>
        <h1 class="page-title">Something Went Wrong</h1>
        <p class="message"><%= errorMsg %></p>
        <div class="button-group">
            <a href="manage_appointment.jsp" class="btn btn-primary">Try Again</a>
            <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </div>
</div>
</body>
</html>
