<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }

    String staffName = (String) session.getAttribute("staff_name");
    String staffRole = (String) session.getAttribute("staff_role");
    if (staffName == null) staffName = "Staff";
    if (staffRole == null) staffRole = "";

    boolean isAdmin    = "Admin".equals(staffRole);
    boolean isManager  = "Manager".equals(staffRole);
    boolean isVet      = "Veterinarian".equals(staffRole);
    boolean isTech     = "Technician".equals(staffRole);
    boolean isInvStaff = "Inventory Staff".equals(staffRole);

    // KPI counts — fail silently if DB is unavailable
    int todayAppointments = 0, totalPets = 0, lowStockCount = 0, pendingRequests = 0;
    try {
        Connection _c = DBConnection.getConnection();
        PreparedStatement _s; ResultSet _r;

        _s = _c.prepareStatement("SELECT COUNT(*) FROM appointment WHERE DATE(appointment_date) = CURDATE() AND status = 'Scheduled'");
        _r = _s.executeQuery(); if (_r.next()) todayAppointments = _r.getInt(1); _r.close(); _s.close();

        _s = _c.prepareStatement("SELECT COUNT(*) FROM appointment WHERE status = 'Pending'");
        _r = _s.executeQuery(); if (_r.next()) pendingRequests = _r.getInt(1); _r.close(); _s.close();

        _s = _c.prepareStatement("SELECT COUNT(*) FROM pet");
        _r = _s.executeQuery(); if (_r.next()) totalPets = _r.getInt(1); _r.close(); _s.close();

        _s = _c.prepareStatement("SELECT COUNT(*) FROM inventory_item WHERE qty_on_hand <= reorder_threshold");
        _r = _s.executeQuery(); if (_r.next()) lowStockCount = _r.getInt(1); _r.close(); _s.close();

        _c.close();
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hospital Dashboard — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp" class="nav-active">Dashboard</a>
        <% if (isAdmin || isManager || isVet) { %>
            <a href="view_appointments.jsp">Appointments</a>
        <% } %>
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

    <!-- Welcome banner -->
    <div class="welcome-banner">
        <h1>Hospital Dashboard</h1>
        <p>Logged in as <strong><%= staffName %></strong> &mdash; <%= staffRole %></p>
    </div>

    <!-- KPI strip -->
    <div class="kpi-grid" style="margin-bottom:28px;">
        <% if (isAdmin || isManager || isVet) { %>
        <a href="view_appointments.jsp?status=Pending" style="text-decoration:none;">
        <div class="kpi-card <%= pendingRequests > 0 ? "kpi-warning" : "" %>" style="cursor:pointer;">
            <div class="kpi-label">Pending Requests</div>
            <div class="kpi-value"><%= pendingRequests %></div>
        </div>
        </a>
        <a href="view_appointments.jsp?status=Scheduled" style="text-decoration:none;">
        <div class="kpi-card" style="cursor:pointer;">
            <div class="kpi-label">Scheduled Today</div>
            <div class="kpi-value"><%= todayAppointments %></div>
        </div>
        </a>
        <% } %>
        <% if (isAdmin || isManager || isVet || isTech) { %>
        <a href="hospital_view_visits.jsp" style="text-decoration:none;">
        <div class="kpi-card kpi-info" style="cursor:pointer;">
            <div class="kpi-label">Patients on File</div>
            <div class="kpi-value" style="font-size:34px;"><%= totalPets %></div>
        </div>
        </a>
        <% } %>
        <% if (isAdmin || isManager || isInvStaff) { %>
        <a href="inventory_report.jsp" style="text-decoration:none;">
        <div class="kpi-card <%= lowStockCount > 0 ? "kpi-danger" : "kpi-success" %>" style="cursor:pointer;">
            <div class="kpi-label">Low-Stock Items</div>
            <div class="kpi-value"><%= lowStockCount %></div>
        </div>
        </a>
        <% } %>
    </div>

    <%-- ── Upcoming Appointments preview ─────────────────────────────────── --%>
    <% if (isAdmin || isManager || isVet) { %>
    <div class="dashboard-preview">
        <div class="dashboard-preview-header">
            <span class="dashboard-preview-title">📅 Upcoming Appointments</span>
            <a href="view_appointments.jsp" class="dashboard-preview-link">View all →</a>
        </div>
        <%
            Connection connA = null; PreparedStatement psA = null; ResultSet rsA = null;
            boolean hasAppts = false;
            try {
                connA = DBConnection.getConnection();
                psA = connA.prepareStatement(
                    "SELECT a.appointment_id, p.pet_name, p.species, " +
                    "o.full_name AS owner_name, s.full_name AS vet_name, " +
                    "a.appointment_date, a.status " +
                    "FROM appointment a " +
                    "JOIN pet p ON a.pet_id = p.pet_id " +
                    "JOIN pet_owner o ON p.owner_id = o.owner_id " +
                    "LEFT JOIN staff s ON a.vet_id = s.employee_id " +
                    "WHERE a.appointment_date >= NOW() AND a.status = 'Scheduled' " +
                    "ORDER BY a.appointment_date ASC LIMIT 3");
                rsA = psA.executeQuery();
                if (rsA.next()) {
                    hasAppts = true;
        %>
        <table class="preview-table">
            <thead>
                <tr>
                    <th>Patient</th>
                    <th>Owner</th>
                    <th>Veterinarian</th>
                    <th>Date &amp; Time</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
            <%
                do {
                    String vetN = rsA.getString("vet_name"); if (vetN == null) vetN = "Unassigned";
            %>
                <tr>
                    <td><strong><%= rsA.getString("pet_name") %></strong> <span style="color:var(--text-muted);font-size:12px;">(<%= rsA.getString("species") %>)</span></td>
                    <td><%= rsA.getString("owner_name") %></td>
                    <td><%= vetN %></td>
                    <td><%= rsA.getString("appointment_date") %></td>
                    <td><span class="badge badge-scheduled">Scheduled</span></td>
                </tr>
            <% } while (rsA.next()); %>
            </tbody>
        </table>
        <%
            } // closes if (rsA.next())
        } catch (Exception ignored) {}
        finally {
            try { if (rsA  != null) rsA.close();  } catch (Exception e) {}
            try { if (psA  != null) psA.close();  } catch (Exception e) {}
            try { if (connA!= null) connA.close(); } catch (Exception e) {}
        }
        if (!hasAppts) {
        %>
        <div class="empty-state">
            <div class="empty-state-icon">📅</div>
            No upcoming appointments scheduled.
        </div>
        <% } %>
    </div>
    <% } %>

    <%-- ── Recent Visits preview ───────────────────────────────────────────── --%>
    <% if (isAdmin || isManager || isVet || isTech) { %>
    <div class="dashboard-preview">
        <div class="dashboard-preview-header">
            <span class="dashboard-preview-title">📋 Recent Visits</span>
            <a href="hospital_view_visits.jsp" class="dashboard-preview-link">View all →</a>
        </div>
        <%
            Connection connV = null; PreparedStatement psV = null; ResultSet rsV = null;
            boolean hasVisits = false;
            try {
                connV = DBConnection.getConnection();
                psV = connV.prepareStatement(
                    "SELECT v.visit_id, p.pet_name, p.species, " +
                    "o.full_name AS owner_name, s.full_name AS vet_name, " +
                    "v.visit_date, v.notes " +
                    "FROM visit v " +
                    "JOIN pet p ON v.pet_id = p.pet_id " +
                    "JOIN pet_owner o ON p.owner_id = o.owner_id " +
                    "LEFT JOIN staff s ON v.vet_id = s.employee_id " +
                    "ORDER BY v.visit_date DESC LIMIT 3");
                rsV = psV.executeQuery();
                if (rsV.next()) {
                    hasVisits = true;
        %>
        <table class="preview-table">
            <thead>
                <tr>
                    <th>Visit ID</th>
                    <th>Patient</th>
                    <th>Owner</th>
                    <th>Veterinarian</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
            <%
                do {
                    String vetN2 = rsV.getString("vet_name"); if (vetN2 == null) vetN2 = "Unassigned";
            %>
                <tr>
                    <td style="color:var(--text-muted);font-size:12px;">#<%= rsV.getInt("visit_id") %></td>
                    <td><strong><%= rsV.getString("pet_name") %></strong> <span style="color:var(--text-muted);font-size:12px;">(<%= rsV.getString("species") %>)</span></td>
                    <td><%= rsV.getString("owner_name") %></td>
                    <td><%= vetN2 %></td>
                    <td><%= rsV.getString("visit_date") %></td>
                </tr>
            <% } while (rsV.next()); %>
            </tbody>
        </table>
        <%
            } // closes if (rsV.next())
        } catch (Exception ignored) {}
        finally {
            try { if (rsV  != null) rsV.close();  } catch (Exception e) {}
            try { if (psV  != null) psV.close();  } catch (Exception e) {}
            try { if (connV!= null) connV.close(); } catch (Exception e) {}
        }
        if (!hasVisits) {
        %>
        <div class="empty-state">
            <div class="empty-state-icon">📋</div>
            No visit records yet.
        </div>
        <% } %>
    </div>
    <% } %>

    <!-- Action grid -->
    <div class="dashboard-grid">

        <%-- ── Visits & Patient Records ─────────────────────────────────── --%>
        <% if (isAdmin || isManager || isVet || isTech) { %>
        <div class="dashboard-section">
            <div class="dashboard-section-title">
                <span class="dashboard-section-icon">📋</span> Visits &amp; Patient Records
            </div>
            <p class="section-desc">Record clinical visits and review full patient histories.</p>
            <% if (isAdmin || isVet) { %>
                <a class="btn btn-primary btn-block" href="hospital_add_visit.jsp">Create Visit Record</a>
            <% } %>
            <a class="section-btn" href="hospital_view_visits.jsp">View Patient History</a>
        </div>
        <% } %>

        <%-- ── Appointments ──────────────────────────────────────────────── --%>
        <% if (isAdmin || isManager || isVet) { %>
        <div class="dashboard-section">
            <div class="dashboard-section-title">
                <span class="dashboard-section-icon">📅</span> Appointments
            </div>
            <p class="section-desc">Schedule, update, and track upcoming appointments.</p>
            <% if (isAdmin || isManager) { %>
                <a class="btn btn-primary btn-block" href="manage_appointment.jsp">Manage Appointments</a>
            <% } %>
            <a class="section-btn" href="view_appointments.jsp">View All Appointments</a>
        </div>
        <% } %>

        <%-- ── Procedures & Clinical Support ──────────────────────────────── --%>
        <% if (isAdmin || isVet || isTech) { %>
        <div class="dashboard-section">
            <div class="dashboard-section-title">
                <span class="dashboard-section-icon">💉</span> Procedures &amp; Clinical Support
            </div>
            <p class="section-desc">Log treatments, charges, and technician vitals for each visit.</p>
            <% if (isAdmin || isVet) { %>
                <a class="btn btn-primary btn-block" href="add_procedure.jsp">Add Procedure / Treatment</a>
                <a class="section-btn" href="view_procedures.jsp">View Procedures for a Visit</a>
            <% } %>
            <% if (isAdmin || isTech) { %>
                <a class="section-btn" href="add_support_log.jsp">Record Technician Notes / Vitals</a>
            <% } %>
        </div>
        <% } %>

        <%-- ── Inventory ─────────────────────────────────────────────────── --%>
        <% if (isAdmin || isManager || isInvStaff) { %>
        <div class="dashboard-section">
            <div class="dashboard-section-title">
                <span class="dashboard-section-icon">📦</span> Inventory
            </div>
            <p class="section-desc">Monitor stock levels and flag items below the reorder threshold.</p>
            <% if (isAdmin || isInvStaff) { %>
                <a class="btn btn-primary btn-block" href="manage_inventory.jsp">Manage Inventory</a>
            <% } %>
            <a class="section-btn" href="inventory_report.jsp">Low-Stock Report</a>
        </div>
        <% } %>

        <%-- ── Service Catalog ─────────────────────────────────────────────── --%>
        <div class="dashboard-section">
            <div class="dashboard-section-title">
                <span class="dashboard-section-icon">🩺</span> Services &amp; Pricing
            </div>
            <p class="section-desc">Define service types and assign them to clinics with pricing.</p>
            <% if (isAdmin || isManager) { %>
                <a class="btn btn-primary btn-block" href="manage_services.jsp">Manage Service Catalog</a>
                <a class="section-btn" href="manage_clinic_services.jsp">Manage Clinic Pricing</a>
            <% } else { %>
                <a class="section-btn" href="manage_services.jsp">View Service Catalog</a>
            <% } %>
        </div>

        <%-- ── Staff & Administration ──────────────────────────────────────── --%>
        <% if (isAdmin || isManager) { %>
        <div class="dashboard-section">
            <div class="dashboard-section-title">
                <span class="dashboard-section-icon">👥</span> Staff &amp; Administration
            </div>
            <p class="section-desc">Manage staff accounts, roles, and clinic-wide KPI reports.</p>
            <% if (isAdmin) { %>
                <a class="btn btn-primary btn-block" href="manage_staff.jsp">Manage Staff Accounts</a>
            <% } %>
            <a class="section-btn" href="reports.jsp">View Reports / KPIs</a>
        </div>
        <% } %>

        <%-- ── My Account ──────────────────────────────────────────────── --%>
        <div class="dashboard-section">
            <div class="dashboard-section-title">
                <span class="dashboard-section-icon">⚙️</span> My Account
            </div>
            <p class="section-desc">Manage your login credentials.</p>
            <a class="section-btn" href="change_password_staff.jsp">Change Password</a>
        </div>

    </div><!-- /.dashboard-grid -->

</div><!-- /.card-lg -->
</div><!-- /.page-shell -->

</body>
</html>
