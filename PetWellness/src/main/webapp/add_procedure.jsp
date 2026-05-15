<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page import="com.petwellness.service.InventoryService" %>
<%@ page import="com.petwellness.service.InventoryService.InventoryRecord" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    String staffRole = (String) session.getAttribute("staff_role");
    if (staffRole == null) staffRole = "";
    boolean isAdmin = "Admin".equals(staffRole);
    boolean isVet   = "Veterinarian".equals(staffRole) || "Vet".equals(staffRole);
    if (!isAdmin && !isVet) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }

    String apptIdStr = request.getParameter("appointment_id");
    if (apptIdStr == null) apptIdStr = "";
    // Fallback: if visit_id is passed directly (walk-in), use it to resolve appointment_id
    String directVisitId = request.getParameter("visit_id");
    if (apptIdStr.isEmpty() && directVisitId != null && !directVisitId.isEmpty()) {
        // Try to find matching appointment for this walk-in visit
        Connection _fbc = null; PreparedStatement _fbp = null; ResultSet _fbr = null;
        try {
            _fbc = DBConnection.getConnection();
            _fbp = _fbc.prepareStatement(
                "SELECT a.appointment_id FROM appointment a " +
                "JOIN visit v ON v.pet_id = a.pet_id AND v.vet_id = a.vet_id " +
                "    AND DATE(v.visit_date) = DATE(a.appointment_date) " +
                "WHERE v.visit_id = ? AND a.status = 'Completed' LIMIT 1");
            _fbp.setInt(1, Integer.parseInt(directVisitId.trim()));
            _fbr = _fbp.executeQuery();
            if (_fbr.next()) apptIdStr = String.valueOf(_fbr.getInt("appointment_id"));
            _fbr.close(); _fbp.close();
        } catch (Exception e) { /* no match — appointment_id stays empty */ }
        finally { try { if (_fbc != null) _fbc.close(); } catch (Exception e) {} }
    }

    List<InventoryRecord> inventoryItems = InventoryService.getAllInventoryItems();

    // Pre-load context when an appointment is selected
    String contextPetName    = null;
    String contextService    = null;
    String contextVetName    = null;
    String contextDate       = null;
    int    resolvedVisitId   = -1;
    List<Object[]> supportLogs = new ArrayList<>();

    if (!apptIdStr.isEmpty()) {
        Connection _cc = null; PreparedStatement _cp = null; ResultSet _cr = null;
        try {
            int apptId = Integer.parseInt(apptIdStr.trim());
            _cc = DBConnection.getConnection();

            // Resolve context + visit_id
            _cp = _cc.prepareStatement(
                "SELECT p.pet_name, sc.service_name, s.full_name AS vet_name, " +
                "a.appointment_date, " +
                "v.visit_id " +
                "FROM appointment a " +
                "JOIN pet p ON a.pet_id = p.pet_id " +
                "LEFT JOIN service_catalog sc ON a.service_id = sc.service_id " +
                "LEFT JOIN staff s ON a.vet_id = s.employee_id " +
                "LEFT JOIN visit v ON v.pet_id = a.pet_id " +
                "    AND v.vet_id = a.vet_id " +
                "    AND DATE(v.visit_date) = DATE(a.appointment_date) " +
                "WHERE a.appointment_id = ? AND a.status = 'Recorded' " +
                "LIMIT 1");
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

            // Load existing technician notes for this visit
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
                    supportLogs.add(new Object[]{
                        _cr.getObject("weight"),
                        _cr.getObject("temperature"),
                        _cr.getString("notes"),
                        _cr.getString("log_time"),
                        _cr.getString("tech_name")
                    });
                }
                _cr.close(); _cp.close();
            }
        } catch (Exception e) {
            // context load failure — form still usable
        } finally {
            try { if (_cc != null) _cc.close(); } catch (Exception e) {}
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Procedure — PetWellness</title>
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
        <% } %>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-md">
<div class="card">

    <h1 class="page-title">Add Procedure / Treatment</h1>
    <p class="page-subtitle">Select a recorded appointment (vitals on file), review technician vitals, then record the procedure.</p>
    <hr class="divider">

    <!-- Step 1: Appointment selector -->
    <p class="section-heading" style="margin-top:0;">Step 1 — Select Appointment</p>
    <div class="form-group">
        <label for="appt_select">Appointment</label>
        <select id="appt_select" class="form-control"
                onchange="if(this.value) window.location='add_procedure.jsp?appointment_id='+this.value;">
            <option value="">— Select a scheduled appointment —</option>
            <%
                Connection _sc = null; PreparedStatement _sp = null; ResultSet _sr = null;
                try {
                    _sc = DBConnection.getConnection();
                    _sp = _sc.prepareStatement(
                        "SELECT a.appointment_id, p.pet_name, o.full_name AS owner_name, " +
                        "a.appointment_date, sc.service_name, s.full_name AS vet_name " +
                        "FROM appointment a " +
                        "JOIN pet p ON a.pet_id = p.pet_id " +
                        "JOIN pet_owner o ON p.owner_id = o.owner_id " +
                        "LEFT JOIN service_catalog sc ON a.service_id = sc.service_id " +
                        "LEFT JOIN staff s ON a.vet_id = s.employee_id " +
                        "WHERE a.status = 'Recorded' " +
                        "ORDER BY a.appointment_date DESC LIMIT 100");
                    _sr = _sp.executeQuery();
                    while (_sr.next()) {
                        int    aid  = _sr.getInt("appointment_id");
                        String sel  = apptIdStr.equals(String.valueOf(aid)) ? "selected" : "";
                        String svc  = _sr.getString("service_name");
                        String lbl  = "#" + aid + " — " + _sr.getString("pet_name") +
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

    <!-- Context card: shown only when appointment is selected and resolved -->
    <% if (contextPetName != null) { %>
    <div style="background:#f3f6fb;border-radius:var(--radius-lg);padding:18px 22px;margin-bottom:24px;border-left:4px solid var(--primary);">
        <p style="font-weight:700;color:var(--primary);margin-bottom:10px;">
            Visit Context — <%= contextPetName %>
        </p>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:6px 24px;font-size:14px;">
            <div><span class="text-muted">Service:</span> <strong><%= contextService != null ? contextService : "—" %></strong></div>
            <div><span class="text-muted">Date:</span> <%= contextDate %></div>
            <div><span class="text-muted">Veterinarian:</span> <%= contextVetName != null ? contextVetName : "—" %></div>
            <% if (resolvedVisitId > 0) { %>
            <div><span class="text-muted">Visit ID:</span> #<%= resolvedVisitId %></div>
            <% } %>
        </div>

        <!-- Technician notes -->
        <% if (!supportLogs.isEmpty()) { %>
        <p style="font-weight:700;color:var(--primary);margin:14px 0 8px;">Technician Notes &amp; Vitals</p>
        <table class="data-table" style="background:#fff;">
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
            <% for (Object[] log : supportLogs) { %>
                <tr>
                    <td style="font-size:13px;"><%= log[3] %></td>
                    <td><%= log[4] != null ? log[4] : "—" %></td>
                    <td><%= log[0] != null ? log[0] : "—" %></td>
                    <td><%= log[1] != null ? log[1] : "—" %></td>
                    <td><%= log[2] != null && !((String)log[2]).isEmpty() ? log[2] : "—" %></td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <% } else { %>
            <p class="text-muted" style="font-size:13px;margin-top:10px;font-style:italic;">
                No technician notes recorded for this visit yet.
            </p>
        <% } %>
    </div>
    <% } else if (!apptIdStr.isEmpty()) { %>
        <div class="alert alert-error">
            No recorded visit found for appointment #<%= apptIdStr %>.
            Ensure the appointment is in Recorded status — a technician must log vitals before treatment.
        </div>
    <% } %>

    <!-- Step 2: Procedure form — only shown once appointment is resolved AND vitals recorded -->
    <% if (resolvedVisitId > 0) { %>
    <% if (supportLogs.isEmpty()) { %>
        <div class="alert alert-error">
            <strong>Vitals required before treatment.</strong>
            A technician must record vitals for this visit before a procedure can be added.
            <a href="add_support_log.jsp?appointment_id=<%= apptIdStr %>" style="margin-left:8px;">Record Vitals Now</a>
        </div>
    <% } else { %>
    <p class="section-heading">Step 2 — Record Procedure</p>
    <form action="add_procedure_process.jsp" method="post">
        <input type="hidden" name="appointment_id" value="<%= apptIdStr %>">
        <input type="hidden" name="visit_id" value="<%= resolvedVisitId %>">

        <div class="form-group">
            <label for="procedure_name">Procedure Name *</label>
            <input type="text" name="procedure_name" id="procedure_name" class="form-control"
                   placeholder="e.g., Blood Test, Vaccination, X-Ray" required autofocus>
        </div>

        <div class="form-group">
            <label for="charge_amount">Charge ($) *</label>
            <input type="number" step="0.01" min="0" name="charge_amount" id="charge_amount"
                   class="form-control" placeholder="e.g., 75.00" required>
        </div>

        <div class="form-group">
            <label for="proc_notes">Notes</label>
            <textarea name="notes" id="proc_notes" class="form-control"
                      placeholder="Any additional clinical notes..."></textarea>
        </div>

        <hr class="divider">
        <p class="section-heading" style="margin-top:0;">Inventory Used <span style="font-weight:400;font-size:13px;color:var(--text-muted);">(optional)</span></p>
        <p class="form-hint" style="margin-bottom:16px;">
            Select a supply or medication consumed. Stock will decrease automatically.
        </p>

        <div class="form-row">
            <div class="form-group-inline">
                <label>Item</label>
                <select name="item_id" class="form-control" style="min-width:220px;">
                    <option value="">— None —</option>
                    <% for (InventoryRecord item : inventoryItems) { %>
                        <option value="<%= item.getItemId() %>">
                            <%= item.getItemName() %>
                            <% if (item.getCategory() != null && !item.getCategory().isEmpty()) { %>
                                (<%= item.getCategory() %>)
                            <% } %>
                            — <%= item.getQtyOnHand() %> in stock
                        </option>
                    <% } %>
                </select>
            </div>
            <div class="form-group-inline">
                <label>Qty Used</label>
                <input type="number" name="qty_used" class="form-control"
                       min="1" placeholder="e.g., 1" style="width:110px;">
            </div>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Save Procedure</button>
            <a href="view_procedures.jsp?appointment_id=<%= apptIdStr %>" class="btn btn-secondary">View Procedures</a>
            <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </form>
    <% } %>
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
