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
    boolean isAdmin = "Admin".equals(staffRole);
    boolean isTech  = "Technician".equals(staffRole);
    if (!isAdmin && !isTech) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }
    int    loggedInTechId   = Integer.parseInt(session.getAttribute("employee_id").toString());
    String loggedInTechName = (String) session.getAttribute("staff_name");

    String apptIdStr = request.getParameter("appointment_id");
    if (apptIdStr == null) apptIdStr = "";

    // Resolve visit context when appointment is selected
    String contextPetName  = null;
    String contextService  = null;
    String contextDate     = null;
    int    resolvedVisitId = -1;

    if (!apptIdStr.isEmpty()) {
        Connection _cc = null; PreparedStatement _cp = null; ResultSet _cr = null;
        try {
            int apptId = Integer.parseInt(apptIdStr.trim());
            _cc = DBConnection.getConnection();
            _cp = _cc.prepareStatement(
                "SELECT p.pet_name, sc.service_name, a.appointment_date, v.visit_id " +
                "FROM appointment a " +
                "JOIN pet p ON a.pet_id = p.pet_id " +
                "LEFT JOIN service_catalog sc ON a.service_id = sc.service_id " +
                "LEFT JOIN visit v ON v.pet_id = a.pet_id " +
                "    AND v.vet_id = a.vet_id " +
                "    AND DATE(v.visit_date) = DATE(a.appointment_date) " +
                "WHERE a.appointment_id = ? AND a.status IN ('Scheduled','Recorded') LIMIT 1");
            _cp.setInt(1, apptId);
            _cr = _cp.executeQuery();
            if (_cr.next()) {
                contextPetName  = _cr.getString("pet_name");
                contextService  = _cr.getString("service_name");
                contextDate     = _cr.getString("appointment_date");
                resolvedVisitId = _cr.getInt("visit_id");
            }
            _cr.close(); _cp.close();
        } catch (Exception e) { /* context load failure */ }
        finally {
            try { if (_cc != null) _cc.close(); } catch (Exception e) {}
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Record Technician Notes — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <a href="view_appointments.jsp">Appointments</a>
        <% if (isAdmin) { %>
            <a href="manage_inventory.jsp">Inventory</a>
            <a href="reports.jsp">Reports</a>
        <% } %>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-md">
<div class="card">

    <h1 class="page-title">Record Technician Notes / Vitals</h1>
    <p class="page-subtitle">Select a scheduled appointment then record weight, temperature, and notes.</p>
    <hr class="divider">

    <!-- Step 1: Appointment selector -->
    <p class="section-heading" style="margin-top:0;">Step 1 — Select Appointment</p>
    <div class="form-group">
        <label for="appt_select">Appointment</label>
        <select id="appt_select" class="form-control"
                onchange="if(this.value) window.location='add_support_log.jsp?appointment_id='+this.value;">
            <option value="">— Select a scheduled appointment —</option>
            <%
                Connection _sc = null; PreparedStatement _sp = null; ResultSet _sr = null;
                try {
                    _sc = DBConnection.getConnection();
                    _sp = _sc.prepareStatement(
                        "SELECT a.appointment_id, p.pet_name, o.full_name AS owner_name, " +
                        "a.appointment_date, sc.service_name " +
                        "FROM appointment a " +
                        "JOIN pet p ON a.pet_id = p.pet_id " +
                        "JOIN pet_owner o ON p.owner_id = o.owner_id " +
                        "LEFT JOIN service_catalog sc ON a.service_id = sc.service_id " +
                        "WHERE a.status IN ('Scheduled','Recorded') " +
                        "ORDER BY a.appointment_date DESC LIMIT 100");
                    _sr = _sp.executeQuery();
                    while (_sr.next()) {
                        int    aid = _sr.getInt("appointment_id");
                        String sel = apptIdStr.equals(String.valueOf(aid)) ? "selected" : "";
                        String svc = _sr.getString("service_name");
                        String lbl = "#" + aid + " — " + _sr.getString("pet_name") +
                                     " (" + _sr.getString("owner_name") + ") — " +
                                     _sr.getString("appointment_date") +
                                     (svc != null ? " [" + svc + "]" : "");
                %>
                    <option value="<%= aid %>" <%= sel %>><%= lbl %></option>
                <%
                    }
                } catch (Exception e) {
                    out.println("<option disabled>Error loading appointments</option>");
                } finally {
                    try { if (_sr != null) _sr.close(); } catch (Exception e) {}
                    try { if (_sp != null) _sp.close(); } catch (Exception e) {}
                    try { if (_sc != null) _sc.close(); } catch (Exception e) {}
                }
            %>
        </select>
    </div>

    <!-- Context card -->
    <% if (contextPetName != null) { %>
    <div style="background:#f3f6fb;border-radius:var(--radius-lg);padding:16px 22px;margin-bottom:24px;border-left:4px solid var(--primary);">
        <p style="font-weight:700;color:var(--primary);margin-bottom:8px;">Visit Context</p>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:4px 24px;font-size:14px;">
            <div><span class="text-muted">Patient:</span> <strong><%= contextPetName %></strong></div>
            <div><span class="text-muted">Date:</span> <%= contextDate %></div>
            <div><span class="text-muted">Service:</span> <%= contextService != null ? contextService : "—" %></div>
        </div>
    </div>
    <% } else if (!apptIdStr.isEmpty()) { %>
        <div class="alert alert-error">
            No active visit found for appointment #<%= apptIdStr %>.
            Ensure the appointment has been approved (Scheduled) with a vet assigned.
        </div>
    <% } %>

    <!-- Step 2: Vitals form — shown only when appointment is resolved -->
    <% if (resolvedVisitId > 0) { %>
    <p class="section-heading">Step 2 — Record Vitals &amp; Notes</p>
    <form action="add_support_log_process.jsp" method="post">
        <input type="hidden" name="visit_id" value="<%= resolvedVisitId %>">
        <input type="hidden" name="appointment_id" value="<%= apptIdStr %>">
        <input type="hidden" name="technician_id" value="<%= loggedInTechId %>">

        <div class="form-group">
            <label>Technician</label>
            <input type="text" class="form-control" value="<%= loggedInTechName %>" readonly>
        </div>

        <div class="form-group">
            <label for="weight">Weight (lbs)</label>
            <input type="number" step="0.01" min="0" name="weight" id="weight"
                   class="form-control" placeholder="e.g., 12.50">
        </div>

        <div class="form-group">
            <label for="temperature">Temperature (&deg;F)</label>
            <input type="number" step="0.01" min="0" name="temperature" id="temperature"
                   class="form-control" placeholder="e.g., 101.5">
        </div>

        <div class="form-group">
            <label for="notes">Support Notes</label>
            <textarea name="notes" id="notes" class="form-control"
                      placeholder="Technician observations and notes..."></textarea>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Save Support Log</button>
            <a href="hospital_view_visits.jsp" class="btn btn-secondary">Patient History</a>
            <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </form>
    <% } else if (apptIdStr.isEmpty()) { %>
        <div class="btn-row mt-24">
            <a href="hospital_view_visits.jsp" class="btn btn-secondary">Patient History</a>
            <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    <% } %>

</div>
</div>
</div>

</body>
</html>
