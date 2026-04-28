<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hospital Dashboard</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h1>Hospital Dashboard</h1>

        <h3>Visits & Patient Records</h3>
        <p><a class="btn" href="add_visit.jsp">Create Visit Record</a></p>
        <p><a class="btn" href="view_visits.jsp">View Patient History</a></p>

        <h3>Appointments</h3>
        <p><a class="btn" href="manage_appointment.jsp">Manage Appointments</a></p>
        <p><a class="btn" href="view_appointments.jsp">View All Appointments</a></p>

        <h3>Procedures & Clinical Support</h3>
        <p><a class="btn" href="add_procedure.jsp">Add Procedure / Treatment</a></p>
        <p><a class="btn" href="view_procedures.jsp">View Procedures for a Visit</a></p>
        <p><a class="btn" href="add_support_log.jsp">Record Technician Notes / Vitals</a></p>

        <h3>Inventory</h3>
        <p><a class="btn" href="manage_inventory.jsp">Manage Inventory</a></p>
        <p><a class="btn" href="inventory_report.jsp">View Inventory Report</a></p>

        <h3>Staff & Administration</h3>
        <p><a class="btn" href="manage_staff.jsp">Manage Staff Accounts</a></p>
        <p><a class="btn" href="reports.jsp">View Reports / KPIs</a></p>

        <hr>

        <p><a class="btn" href="logout.jsp">Logout</a></p>
    </div>
</body>
</html>