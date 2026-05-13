<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
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
    boolean isVet     = "Veterinarian".equals(staffRole);
    boolean isTech    = "Technician".equals(staffRole);
    if (!isAdmin && !isManager && !isVet && !isTech) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }

    String apptIdStr = request.getParameter("appointment_id");
    if (apptIdStr == null) apptIdStr = "";
    // Fallback: visit_id passed directly
    String directVisitId = request.getParameter("visit_id");
    if (apptIdStr.isEmpty() && directVisitId != null && !directVisitId.isEmpty()) {
        Connection _fbc = null; PreparedStatement _fbp = null; ResultSet _fbr = null;
        try {
            _fbc = DBConnection.getConnection();
            _fbp = _fbc.prepareStatement(
                "SELECT a.appointment_id FROM appointment a " +
                "JOIN visit v ON v.pet_id = a.pet_id AND v.vet_id = a.vet_id " +
                "    AND DATE(v.visit_date) = DATE(a.appointment_date) " +
                "WHERE v.visit_id = ? AND a.status IN ('Scheduled','Completed') LIMIT 1");
            _fbp.setInt(1, Integer.parseInt(directVisitId.trim()));
            _fbr = _fbp.executeQuery();
            if (_fbr.next()) apptIdStr = String.valueOf(_fbr.getInt("appointment_id"));
            _fbr.close(); _fbp.close();
        } catch (Exception e) {}
        finally { try { if (_fbc != null) _fbc.close(); } catch (Exception e) {} }
    }

    String contextPetName  = null;
    String contextService  = null;
    String contextDate     = null;
    String contextVetName  = null;
    int    resolvedVisitId = -1;
    List<Object[]> vitalsLogs = new ArrayList<>();

    if (!apptIdStr.isEmpty()) {
        Connection _cc = null; PreparedStatement _cp = null; ResultSet _cr = null;
        try {
            int apptId = Integer.parseInt(apptIdStr.trim());
            _cc = DBConnection.getConnection();
            _cp = _cc.prepareStatement(
                "SELECT p.pet_name, sc.service_name, s.full_name AS vet_name, " +
                "a.appointment_date, v.visit_id " +
                "FROM appointment a " +
                "JOIN pet p ON a.pet_id = p.pet_id " +
                "LEFT JOIN service_catalog sc ON a.service_id = sc.service_id " +
                "LEFT JOIN staff s ON a.vet_id = s.employee_id " +
                "LEFT JOIN visit v ON v.pet_id = a.pet_id " +
                "    AND v.vet_id = a.vet_id " +
                "    AND DATE(v.visit_date) = DATE(a.appointment_date) " +
                "WHERE a.appointment_id = ? AND a.status IN ('Scheduled','Completed') LIMIT 1");
            _cp.setInt(1, apptId);
            _cr = _cp.executeQuery();
            if (_cr.next()) {
                contextPetName  = _cr.getString("pet_name");
                contextService  = _cr.getString("service_name");
                contextVetName  = _cr.getString("vet_name");
                contextDate     = _cr.getString("appointment_date");
                resolvedVisitId = _cr.getInt("visit_id");
            }
            _cr.close(); _cp.close();

            if (resolvedVisitId > 0) {
                _cp = _cc.prepareStatement(
                    "SELECT vsl.weight, vsl.temperature, vsl.notes, vsl.log_time, " +
                    "st.full_name AS tech_name " +
                    "FROM visit_support_log vsl " +
                    "LEFT JOIN staff st ON vsl.technician_id = st.employee_id " +
                    "WHERE vsl.visit_id = ? ORDER BY vsl.log_time");
                _cp.setInt(1, resolvedVisitId);
                _cr = _cp.executeQuery();
                while (_cr.next()) {
                    vitalsLogs.add(new Object[]{
                        _cr.getObject("weight"),
                        _cr.getObject("temperature"),
                        _cr.getString("notes"),
                        _cr.getString("log_time"),
                        _cr.getString("tech_name")
                    });
                }
                _cr.close(); _cp.close();
            }
        } catch (Exception e) {}
        finally { try { if (_cc != null) _cc.close(); } catch (Exception e) {} }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Vitals — PetWellness</title>
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

    <h1 class="page-title">Technician Vitals for a Visit</h1>
    <p class="page-subtitle">Select a scheduled or completed appointment to view all recorded vitals and notes.</p>
    <hr class="divider">

    <!-- Appointment selector -->
    <div class="form-group">
        <label for="appt_select">Appointment</label>
        <select id="appt_select" class="form-control"
                onchange="if(this.value) window.location='view_vitals.jsp?appointment_id='+this.value;">
            <option value="">— Select an appointment —</option>
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
                        "WHERE a.status IN ('Scheduled','Completed') " +
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

    <% if (!apptIdStr.isEmpty()) {
           if (contextPetName == null) { %>
        <div class="alert alert-error">No visit found for appointment #<%= apptIdStr %>.</div>
    <%     } else { %>
        <!-- Context summary -->
        <div style="background:#f3f6fb;border-radius:var(--radius-lg);padding:14px 22px;margin-bottom:24px;border-left:4px solid var(--primary);font-size:14px;">
            <strong style="color:var(--primary);"><%= contextPetName %></strong>
            &nbsp;·&nbsp; <%= contextDate %>
            &nbsp;·&nbsp; Service: <%= contextService != null ? contextService : "—" %>
            &nbsp;·&nbsp; Dr. <%= contextVetName != null ? contextVetName : "—" %>
        </div>

        <% if (vitalsLogs.isEmpty()) { %>
            <p class="text-muted" style="padding:16px 0;font-style:italic;">No vitals recorded for this visit yet.</p>
        <% } else { %>
        <table class="data-table">
            <thead>
                <tr>
                    <th>Time</th>
                    <th>Technician</th>
                    <th>Weight (lbs)</th>
                    <th>Temp (&deg;F)</th>
                    <th>Notes</th>
                </tr>
            </thead>
            <tbody>
            <% for (Object[] log : vitalsLogs) {
                   String logNotes = (String) log[2]; if (logNotes == null || logNotes.isEmpty()) logNotes = "—"; %>
                <tr>
                    <td style="font-size:13px;"><%= log[3] %></td>
                    <td><%= log[4] != null ? log[4] : "—" %></td>
                    <td><%= log[0] != null ? log[0] : "—" %></td>
                    <td><%= log[1] != null ? log[1] : "—" %></td>
                    <td><%= logNotes %></td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    <%  }
       }
    %>

    <div class="btn-row mt-24">
        <a href="hospital_view_visits.jsp" class="btn btn-secondary">Patient History</a>
        <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
