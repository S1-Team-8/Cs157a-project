<%@ page import="com.petwellness.service.ReportService" %>
<%@ page import="com.petwellness.service.ReportService.DashboardStats" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    DashboardStats stats = ReportService.getDashboardStats();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hospital Reports / KPI Dashboard</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h1>Hospital Reports / KPI Dashboard</h1>

        <table border="1" cellpadding="10" cellspacing="0" style="margin: 0 auto; background: white;">
            <tr>
                <th>Metric</th>
                <th>Value</th>
            </tr>
            <tr>
                <td>Total Revenue</td>
                <td>$<%= String.format("%.2f", stats.getTotalRevenue()) %></td>
            </tr>
            <tr>
                <td>Total Visits</td>
                <td><%= stats.getTotalVisits() %></td>
            </tr>
            <tr>
                <td>Total Appointments</td>
                <td><%= stats.getTotalAppointments() %></td>
            </tr>
            <tr>
                <td>Completed Appointments</td>
                <td><%= stats.getCompletedAppointments() %></td>
            </tr>
            <tr>
                <td>Canceled Appointments</td>
                <td><%= stats.getCanceledAppointments() %></td>
            </tr>
            <tr>
                <td>No-show Appointments</td>
                <td><%= stats.getNoShowAppointments() %></td>
            </tr>
            <tr>
                <td>Most Common Procedure</td>
                <td><%= stats.getMostCommonProcedure() %></td>
            </tr>
        </table>

        <br>
        <p><a class="btn" href="hospital_dashboard.jsp">Back to Hospital Dashboard</a></p>
    </div>
</body>
</html>