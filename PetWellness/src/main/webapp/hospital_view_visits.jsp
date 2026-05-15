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
    boolean isVet     = "Veterinarian".equals(staffRole) || "Vet".equals(staffRole);
    boolean isTech    = "Technician".equals(staffRole);
    if (!isAdmin && !isManager && !isVet && !isTech) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }
    String petIdStr = request.getParameter("pet_id");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Visit History — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <% if (isAdmin || isManager || isVet || isTech) { %>
            <a href="view_appointments.jsp">Appointments</a>
        <% } %>
        <% if (isAdmin || isManager) { %>
            <a href="manage_inventory.jsp">Inventory</a>
            <a href="reports.jsp">Reports</a>
        <% } %>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-lg">
<div class="card">

    <h1 class="page-title">Patient Visit History</h1>
    <p class="page-subtitle">View visit records and access procedures or vitals for each visit.</p>
    <hr class="divider">

    <!-- Filter bar -->
    <form method="get" action="hospital_view_visits.jsp">
        <div class="form-row" style="align-items:flex-end;">
            <div class="form-group-inline">
                <label>Filter by Patient</label>
                <select name="pet_id" class="form-control" style="min-width:280px;">
                    <option value="">— All Patients —</option>
                    <%
                        Connection conn0 = null; PreparedStatement ps0 = null; ResultSet rs0 = null;
                        try {
                            conn0 = DBConnection.getConnection();
                            ps0 = conn0.prepareStatement(
                                "SELECT p.pet_id, p.pet_name, p.species, o.full_name " +
                                "FROM pet p JOIN pet_owner o ON p.owner_id = o.owner_id " +
                                "ORDER BY o.full_name, p.pet_name");
                            rs0 = ps0.executeQuery();
                            while (rs0.next()) {
                                String sel = (petIdStr != null && petIdStr.equals(String.valueOf(rs0.getInt("pet_id")))) ? "selected" : "";
                    %>
                        <option value="<%= rs0.getInt("pet_id") %>" <%= sel %>>
                            <%= rs0.getString("pet_name") %> (<%= rs0.getString("species") %>) — <%= rs0.getString("full_name") %>
                        </option>
                    <%      }
                        } catch (Exception e) { out.println("<option disabled>Error</option>"); }
                        finally {
                            try { if (rs0  != null) rs0.close();  } catch (Exception e) {}
                            try { if (ps0  != null) ps0.close();  } catch (Exception e) {}
                            try { if (conn0!= null) conn0.close();} catch (Exception e) {}
                        }
                    %>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Search</button>
            <a href="hospital_view_visits.jsp" class="btn btn-secondary">Show All</a>
        </div>
    </form>

    <table class="data-table">
        <thead>
            <tr>
                <th>Visit ID</th>
                <th>Patient</th>
                <th>Owner</th>
                <th>Veterinarian</th>
                <th>Visit Date</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
            boolean hasRows = false;
            try {
                conn = DBConnection.getConnection();
                String sql;
                String baseSelect =
                    "SELECT v.visit_id, p.pet_name, p.species, o.full_name AS owner_name, " +
                    "s.full_name AS vet_name, v.visit_date, " +
                    "(SELECT a.appointment_id FROM appointment a " +
                    "  WHERE a.pet_id = v.pet_id AND a.vet_id = v.vet_id " +
                    "    AND DATE(a.appointment_date) = DATE(v.visit_date) " +
                    "    AND a.status IN ('Scheduled','Recorded','Treated','Completed') LIMIT 1) AS appointment_id " +
                    "FROM visit v JOIN pet p ON v.pet_id = p.pet_id " +
                    "JOIN pet_owner o ON p.owner_id = o.owner_id " +
                    "LEFT JOIN staff s ON v.vet_id = s.employee_id ";
                if (petIdStr != null && !petIdStr.trim().isEmpty()) {
                    sql = baseSelect + "WHERE v.pet_id = ? ORDER BY v.visit_date DESC";
                    ps = conn.prepareStatement(sql);
                    ps.setInt(1, Integer.parseInt(petIdStr));
                } else {
                    sql = baseSelect + "ORDER BY v.visit_date DESC LIMIT 200";
                    ps = conn.prepareStatement(sql);
                }
                rs = ps.executeQuery();
                while (rs.next()) {
                    hasRows = true;
                    int    vId     = rs.getInt("visit_id");
                    Object apptObj = rs.getObject("appointment_id");
                    String apptParam = apptObj != null ? "appointment_id=" + apptObj : "";
                    String vetName = rs.getString("vet_name");
                    if (vetName == null) vetName = "Unassigned";
        %>
            <tr>
                <td style="color:var(--text-muted);font-size:13px;">#<%= vId %></td>
                <td>
                    <strong><%= rs.getString("pet_name") %></strong>
                    <span class="text-muted" style="font-size:12px;"> (<%= rs.getString("species") %>)</span>
                </td>
                <td><%= rs.getString("owner_name") %></td>
                <td><%= vetName %></td>
                <td><%= rs.getString("visit_date") %></td>
                <td style="white-space:nowrap;">
                    <a href="view_procedures.jsp?<%= apptParam.isEmpty() ? "visit_id=" + vId : apptParam %>"
                       class="btn btn-secondary btn-sm">View Procedures</a>
                    <a href="view_vitals.jsp?<%= apptParam.isEmpty() ? "visit_id=" + vId : apptParam %>"
                       class="btn btn-secondary btn-sm">View Vitals</a>
                </td>
            </tr>
        <%      }
                if (!hasRows) { %>
            <tr><td colspan="6">
                <div class="empty-state">
                    <div class="empty-state-icon">📋</div>
                    No visit records found.
                </div>
            </td></tr>
        <%      }
            } catch (Exception e) { %>
            <tr><td colspan="6"><div class="alert alert-error" style="margin:16px 0;">Error loading visits: <%= e.getMessage() %></div></td></tr>
        <%  } finally {
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
