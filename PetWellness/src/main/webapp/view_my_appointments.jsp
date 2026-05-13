<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="view_pets.jsp">My Pets</a>
        <a href="view_my_appointments.jsp" class="nav-active">Appointments</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-lg">
<div class="card">

    <h1 class="page-title">My Appointments</h1>
    <p class="page-subtitle">All scheduled appointments for your pets.</p>
    <hr class="divider">

    <%
        try {
            Connection conn = DBConnection.getConnection();

            String sql =
                "SELECT v.visit_id, p.pet_name, c.clinic_name, v.visit_date, v.notes " +
                "FROM visit v " +
                "JOIN pet p ON v.pet_id = p.pet_id " +
                "LEFT JOIN clinic c ON v.vet_id = c.clinic_id " +
                "WHERE p.owner_id = ? " +
                "ORDER BY v.visit_date DESC";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, ownerId);
            ResultSet rs = stmt.executeQuery();

            boolean hasAppointments = false;
    %>

    <table class="data-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Pet</th>
                <th>Clinic</th>
                <th>Date &amp; Time</th>
                <th>Notes</th>
            </tr>
        </thead>
        <tbody>
    <%
            while (rs.next()) {
                hasAppointments = true;
                String clinicName = rs.getString("clinic_name");
                String notes = rs.getString("notes");
    %>
            <tr>
                <td><%= rs.getInt("visit_id") %></td>
                <td><strong><%= rs.getString("pet_name") %></strong></td>
                <td><%= clinicName != null ? clinicName : "Not Assigned" %></td>
                <td><%= rs.getString("visit_date") %></td>
                <td><%= notes != null ? notes : "" %></td>
            </tr>
    <%
            }

            if (!hasAppointments) {
    %>
            <tr class="no-data">
                <td colspan="5">
                    <div class="empty-state-icon">📅</div>
                    No appointments found.
                </td>
            </tr>
    <%
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<tr><td colspan=\"5\"><div class=\"alert alert-error\">Error loading appointments.</div></td></tr>");
        }
    %>
        </tbody>
    </table>

    <div class="btn-row mt-24">
        <a href="schedule_appointment.jsp" class="btn btn-primary">+ Schedule Appointment</a>
        <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
