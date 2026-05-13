<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
    String msg = request.getParameter("msg");
    String err = request.getParameter("error");
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
        <a href="search_clinic.jsp">Clinics</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-lg">
<div class="card">

    <h1 class="page-title">My Appointments</h1>
    <p class="page-subtitle">Pending requests and confirmed appointments for your pets.</p>
    <hr class="divider">

    <% if ("canceled".equals(msg)) { %>
        <div class="alert alert-success">Appointment request canceled.</div>
    <% } else if ("cancel".equals(err)) { %>
        <div class="alert alert-error">Unable to cancel — only pending requests can be canceled.</div>
    <% } %>

    <%
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        boolean hasRows = false;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(
                "SELECT a.appointment_id, p.pet_name, p.species, " +
                "sc.service_name, a.appointment_date, a.status, s.full_name AS vet_name " +
                "FROM appointment a " +
                "JOIN pet p ON a.pet_id = p.pet_id " +
                "LEFT JOIN service_catalog sc ON a.service_id = sc.service_id " +
                "LEFT JOIN staff s ON a.vet_id = s.employee_id " +
                "WHERE p.owner_id = ? " +
                "ORDER BY a.appointment_date DESC");
            stmt.setInt(1, ownerId);
            rs = stmt.executeQuery();
    %>
    <table class="data-table">
        <thead>
            <tr>
                <th>Pet</th>
                <th>Service</th>
                <th>Date &amp; Time</th>
                <th>Veterinarian</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
    <%
            while (rs.next()) {
                hasRows = true;
                int apptId     = rs.getInt("appointment_id");
                String status  = rs.getString("status");
                String svcName = rs.getString("service_name");
                String vetName = rs.getString("vet_name");
                String species = rs.getString("species");

                String badgeClass = "badge-scheduled";
                if ("Pending".equals(status))        badgeClass = "badge-noshow";
                else if ("Recorded".equals(status))  badgeClass = "badge-recorded";
                else if ("Treated".equals(status))   badgeClass = "badge-treated";
                else if ("Completed".equals(status)) badgeClass = "badge-completed";
                else if ("Canceled".equals(status))  badgeClass = "badge-canceled";
                else if ("No-show".equals(status))   badgeClass = "badge-canceled";
    %>
            <tr>
                <td>
                    <strong><%= rs.getString("pet_name") %></strong>
                    <% if (species != null) { %>
                        <span class="text-muted" style="font-size:12px;"> (<%= species %>)</span>
                    <% } %>
                </td>
                <td><%= svcName != null ? svcName : "—" %></td>
                <td><%= rs.getString("appointment_date") %></td>
                <td>
                    <% if ("Pending".equals(status)) { %>
                        <span class="text-muted" style="font-style:italic;">Awaiting assignment</span>
                    <% } else { %>
                        <%= vetName != null ? vetName : "—" %>
                    <% } %>
                </td>
                <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                <td>
                    <% if ("Pending".equals(status)) { %>
                        <form method="post" action="cancel_appointment_process.jsp" style="display:inline;"
                              onsubmit="return confirm('Cancel this appointment request?');">
                            <input type="hidden" name="appointment_id" value="<%= apptId %>">
                            <button type="submit" class="btn btn-danger btn-sm">Cancel</button>
                        </form>
                    <% } else { %>
                        <span class="text-muted" style="font-size:13px;">—</span>
                    <% } %>
                </td>
            </tr>
    <%
            }
            if (!hasRows) {
    %>
            <tr class="no-data">
                <td colspan="6">
                    <div class="empty-state-icon">📅</div>
                    No appointments yet.
                </td>
            </tr>
    <%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan=\"6\"><div class=\"alert alert-error\">Error loading appointments: "
                + e.getMessage() + "</div></td></tr>");
        } finally {
            try { if (rs   != null) rs.close();   } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    %>
        </tbody>
    </table>

    <div class="btn-row mt-24">
        <a href="schedule_appointment.jsp" class="btn btn-primary">+ Request Appointment</a>
        <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
