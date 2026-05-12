<%@ page import="com.petwellness.service.ReportService" %>
<%@ page import="com.petwellness.service.ReportService.DashboardStats" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    DashboardStats stats = ReportService.getDashboardStats();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports / KPIs — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <a href="view_appointments.jsp">Appointments</a>
        <a href="manage_inventory.jsp">Inventory</a>
        <a href="reports.jsp" class="nav-active">Reports</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-md">
<div class="card">

    <h1 class="page-title">Hospital Reports / KPIs</h1>
    <p class="page-subtitle">Live statistics from the PetWellness clinic database.</p>
    <hr class="divider">

    <!-- Financial -->
    <p class="section-heading">Financial</p>
    <div class="kpi-grid">
        <div class="kpi-card kpi-revenue">
            <div class="kpi-label">Total Revenue</div>
            <div class="kpi-value">$<%= String.format("%.2f", stats.getTotalRevenue()) %></div>
        </div>
    </div>

    <!-- Visits -->
    <p class="section-heading">Visits</p>
    <div class="kpi-grid">
        <div class="kpi-card">
            <div class="kpi-label">Total Visits</div>
            <div class="kpi-value"><%= stats.getTotalVisits() %></div>
        </div>
    </div>

    <!-- Appointments -->
    <p class="section-heading">Appointments</p>
    <div class="kpi-grid">
        <div class="kpi-card">
            <div class="kpi-label">Total Appointments</div>
            <div class="kpi-value"><%= stats.getTotalAppointments() %></div>
        </div>
        <div class="kpi-card kpi-success">
            <div class="kpi-label">Completed</div>
            <div class="kpi-value"><%= stats.getCompletedAppointments() %></div>
        </div>
        <div class="kpi-card kpi-danger">
            <div class="kpi-label">Canceled</div>
            <div class="kpi-value"><%= stats.getCanceledAppointments() %></div>
        </div>
        <div class="kpi-card kpi-warning">
            <div class="kpi-label">No-show</div>
            <div class="kpi-value"><%= stats.getNoShowAppointments() %></div>
        </div>
    </div>

    <!-- Procedures -->
    <p class="section-heading">Procedures</p>
    <div class="kpi-grid">
        <div class="kpi-card kpi-info">
            <div class="kpi-label">Most Common Procedure</div>
            <div class="kpi-value"><%= stats.getMostCommonProcedure() %></div>
        </div>
    </div>

    <div class="btn-row mt-24">
        <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
