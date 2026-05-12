<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    String staffRole = (String) session.getAttribute("staff_role");
    if (staffRole == null) staffRole = "";
    boolean isAdmin   = "Admin".equals(staffRole);
    boolean isManager = "Manager".equals(staffRole);
    boolean isInvStaff = "Inventory Staff".equals(staffRole);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Appointments — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <a href="view_appointments.jsp" class="nav-active">Appointments</a>
        <% if (isAdmin || isManager || isInvStaff) { %>
            <a href="manage_inventory.jsp">Inventory</a>
        <% } %>
        <% if (isAdmin || isManager) { %>
            <a href="reports.jsp">Reports</a>
        <% } %>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-lg">
<div class="card">

    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;flex-wrap:wrap;gap:12px;">
        <h1 class="page-title" style="margin-bottom:0;">All Appointments</h1>
        <% if (isAdmin || isManager) { %>
            <a href="manage_appointment.jsp" class="btn btn-primary">Schedule / Update Appointment</a>
        <% } %>
    </div>

    <table class="data-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Patient</th>
                <th>Owner</th>
                <th>Veterinarian</th>
                <th>Date &amp; Time</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
            boolean hasRows = false;
            try {
                conn = DBConnection.getConnection();
                ps = conn.prepareStatement(
                    "SELECT a.appointment_id, p.pet_name, p.species, " +
                    "o.full_name AS owner_name, s.full_name AS vet_name, " +
                    "a.appointment_date, a.status " +
                    "FROM appointment a " +
                    "JOIN pet p ON a.pet_id = p.pet_id " +
                    "JOIN pet_owner o ON p.owner_id = o.owner_id " +
                    "LEFT JOIN staff s ON a.vet_id = s.employee_id " +
                    "ORDER BY a.appointment_date DESC");
                rs = ps.executeQuery();
                while (rs.next()) {
                    hasRows = true;
                    String status = rs.getString("status");
                    String badgeClass = "badge-scheduled";
                    if ("Completed".equals(status))  badgeClass = "badge-completed";
                    else if ("Canceled".equals(status))  badgeClass = "badge-canceled";
                    else if ("No-show".equals(status))   badgeClass = "badge-noshow";
                    String vetName = rs.getString("vet_name");
                    if (vetName == null) vetName = "Unassigned";
        %>
            <tr>
                <td style="color:var(--text-muted);font-size:12px;">#<%= rs.getInt("appointment_id") %></td>
                <td>
                    <strong><%= rs.getString("pet_name") %></strong>
                    <span style="color:var(--text-muted);font-size:12px;"> (<%= rs.getString("species") %>)</span>
                </td>
                <td><%= rs.getString("owner_name") %></td>
                <td><%= vetName %></td>
                <td><%= rs.getString("appointment_date") %></td>
                <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
            </tr>
        <%
                }
                if (!hasRows) {
        %>
            <tr>
                <td colspan="6">
                    <div class="empty-state">
                        <div class="empty-state-icon">📅</div>
                        No appointments found.
                    </div>
                </td>
            </tr>
        <%
                }
            } catch (Exception e) {
        %>
            <tr><td colspan="6"><div class="alert alert-error">Error loading appointments: <%= e.getMessage() %></div></td></tr>
        <%
            } finally {
                try { if (rs   != null) rs.close();   } catch (Exception e) {}
                try { if (ps   != null) ps.close();   } catch (Exception e) {}
                try { if (conn != null) conn.close();  } catch (Exception e) {}
            }
        %>
        </tbody>
    </table>

    <div class="btn-row mt-24">
        <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
