<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    String _role = (String) session.getAttribute("staff_role");
    if (_role == null) _role = "";
    if (!"Admin".equals(_role) && !"Manager".equals(_role)) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if (idStr == null || idStr.trim().isEmpty()) {
        response.sendRedirect("view_appointments.jsp");
        return;
    }
    int apptId = Integer.parseInt(idStr);

    // Load appointment details
    String petName = "", ownerName = "", serviceName = "", requestedDate = "";
    Connection _c = null; PreparedStatement _s = null; ResultSet _r = null;
    try {
        _c = DBConnection.getConnection();
        _s = _c.prepareStatement(
            "SELECT p.pet_name, p.species, o.full_name AS owner_name, " +
            "sc.service_name, a.appointment_date, a.status " +
            "FROM appointment a " +
            "JOIN pet p ON a.pet_id = p.pet_id " +
            "JOIN pet_owner o ON p.owner_id = o.owner_id " +
            "LEFT JOIN service_catalog sc ON a.service_id = sc.service_id " +
            "WHERE a.appointment_id = ?");
        _s.setInt(1, apptId);
        _r = _s.executeQuery();
        if (_r.next()) {
            String status = _r.getString("status");
            if (!"Pending".equals(status)) {
                response.sendRedirect("view_appointments.jsp");
                return;
            }
            petName       = _r.getString("pet_name") + " (" + _r.getString("species") + ")";
            ownerName     = _r.getString("owner_name");
            serviceName   = _r.getString("service_name");
            if (serviceName == null) serviceName = "—";
            requestedDate = _r.getString("appointment_date");
        } else {
            response.sendRedirect("view_appointments.jsp");
            return;
        }
    } finally {
        try { if (_r != null) _r.close(); } catch (Exception e) {}
        try { if (_s != null) _s.close(); } catch (Exception e) {}
        try { if (_c != null) _c.close(); } catch (Exception e) {}
    }

    // Format requestedDate for datetime-local input (replace space with T)
    String inputDate = requestedDate != null ? requestedDate.replace(" ", "T") : "";
    // Trim seconds if present (datetime-local needs HH:MM not HH:MM:SS)
    if (inputDate.length() > 16) inputDate = inputDate.substring(0, 16);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approve Appointment — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <a href="view_appointments.jsp" class="nav-active">Appointments</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-sm" style="width:100%;">
<div class="card">

    <h1 class="page-title">Assign &amp; Approve Request</h1>
    <p class="page-subtitle">Appointment #<%= apptId %></p>
    <hr class="divider">

    <!-- Read-only request details -->
    <p class="section-heading">Request Details</p>
    <table class="data-table" style="margin-bottom:24px;">
        <tbody>
            <tr><td style="width:140px;font-weight:600;">Patient</td><td><%= petName %></td></tr>
            <tr><td style="font-weight:600;">Owner</td><td><%= ownerName %></td></tr>
            <tr><td style="font-weight:600;">Service</td><td><%= serviceName %></td></tr>
            <tr><td style="font-weight:600;">Requested Date</td><td><%= requestedDate %></td></tr>
        </tbody>
    </table>

    <!-- Approval form -->
    <p class="section-heading">Assign Veterinarian &amp; Confirm Time</p>
    <form action="approve_appointment_process.jsp" method="post">
        <input type="hidden" name="appointment_id" value="<%= apptId %>">

        <div class="form-group">
            <label for="vet_id">Veterinarian *</label>
            <select name="vet_id" id="vet_id" class="form-control" required>
                <option value="">— Select veterinarian —</option>
                <%
                    Connection _vc = null; PreparedStatement _vp = null; ResultSet _vr = null;
                    try {
                        _vc = DBConnection.getConnection();
                        _vp = _vc.prepareStatement(
                            "SELECT employee_id, full_name FROM staff " +
                            "WHERE is_active = TRUE AND role = 'Veterinarian' ORDER BY full_name");
                        _vr = _vp.executeQuery();
                        while (_vr.next()) { %>
                    <option value="<%= _vr.getInt("employee_id") %>"><%= _vr.getString("full_name") %></option>
                <%      }
                    } catch (Exception e) { out.println("<option disabled>Error loading vets</option>"); }
                    finally {
                        try { if (_vr != null) _vr.close(); } catch (Exception e) {}
                        try { if (_vp != null) _vp.close(); } catch (Exception e) {}
                        try { if (_vc != null) _vc.close(); } catch (Exception e) {}
                    }
                %>
            </select>
        </div>

        <div class="form-group">
            <label for="appointment_date">Confirmed Date &amp; Time *</label>
            <input type="datetime-local" name="appointment_date" id="appointment_date"
                   class="form-control" value="<%= inputDate %>" required>
            <p class="form-hint">Pre-filled with the owner's requested time. Adjust if needed.</p>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Approve &amp; Schedule</button>
            <a href="view_appointments.jsp" class="btn btn-secondary">Cancel</a>
        </div>
    </form>

</div>
</div>
</div>

</body>
</html>
