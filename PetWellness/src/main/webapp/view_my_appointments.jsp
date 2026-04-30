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
    <title>View My Appointments</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
    <h2>My Appointments</h2>

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

    <table border="1" cellpadding="10" cellspacing="0" style="margin: auto; background: white;">
        <tr>
            <th>Appointment ID</th>
            <th>Pet Name</th>
            <th>Clinic / Hospital</th>
            <th>Date and Time</th>
            <th>Notes</th>
        </tr>

    <%
            while (rs.next()) {
                hasAppointments = true;
    %>
        <tr>
            <td><%= rs.getInt("visit_id") %></td>
            <td><%= rs.getString("pet_name") %></td>
            <td><%= rs.getString("clinic_name") != null ? rs.getString("clinic_name") : "Not Assigned" %></td>
            <td><%= rs.getString("visit_date") %></td>
            <td><%= rs.getString("notes") != null ? rs.getString("notes") : "" %></td>
        </tr>
    <%
            }

            if (!hasAppointments) {
    %>
        <tr>
            <td colspan="5">No appointments found.</td>
        </tr>
    <%
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            out.println("<p>Error loading appointments.</p>");
        }
    %>

    </table>

    <br>
    <a class="btn" href="dashboard.jsp">Back to Dashboard</a>
</div>
</body>
</html>