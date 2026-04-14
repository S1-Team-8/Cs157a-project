<%@ page import="java.util.List" %>
<%@ page import="com.petwellness.service.ViewAppointmentService" %>
<%@ page import="com.petwellness.service.ViewAppointmentService.AppointmentRecord" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<AppointmentRecord> appointments = ViewAppointmentService.getAllAppointments();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View All Appointments</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h2>All Appointments</h2>

        <%
            if (appointments == null || appointments.isEmpty()) {
        %>
            <p>No appointments found.</p>
        <%
            } else {
        %>
            <table border="1" cellpadding="10" cellspacing="0" style="margin: 0 auto; background: white;">
                <tr>
                    <th>Appointment ID</th>
                    <th>Pet ID</th>
                    <th>Vet ID</th>
                    <th>Appointment Date</th>
                    <th>Status</th>
                </tr>

                <%
                    for (AppointmentRecord appointment : appointments) {
                %>
                <tr>
                    <td><%= appointment.getAppointmentId() %></td>
                    <td><%= appointment.getPetId() %></td>
                    <td><%= appointment.getVetId() %></td>
                    <td><%= appointment.getAppointmentDate() %></td>
                    <td><%= appointment.getStatus() %></td>
                </tr>
                <%
                    }
                %>
            </table>
        <%
            }
        %>

        <br>
        <p><a class="btn" href="hospital_dashboard.jsp">Back to Hospital Dashboard</a></p>
    </div>
</body>
</html>