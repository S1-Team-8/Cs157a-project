<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
    String visitIdStr = request.getParameter("visit_id");
    if (visitIdStr == null || visitIdStr.trim().isEmpty()) {
        response.sendRedirect("view_visits.jsp");
        return;
    }

    int visitId = 0;
    String petName = null, visitDate = null, vetName = null, serviceName = null, visitNotes = null;
    java.util.List<Object[]> procedures = new java.util.ArrayList<>();
    java.util.List<Object[]> vitals     = new java.util.ArrayList<>();
    double totalCharge = 0.0;
    String loadError = null;

    try {
        visitId = Integer.parseInt(visitIdStr.trim());
        Connection conn = DBConnection.getConnection();

        // Load visit info — verify the pet belongs to this owner
        PreparedStatement vPs = conn.prepareStatement(
            "SELECT v.visit_date, v.notes, p.pet_name, " +
            "s.full_name AS vet_name, sc.service_name " +
            "FROM visit v " +
            "JOIN pet p ON v.pet_id = p.pet_id " +
            "LEFT JOIN staff s ON v.vet_id = s.employee_id " +
            "LEFT JOIN service_catalog sc ON v.service_id = sc.service_id " +
            "WHERE v.visit_id = ? AND p.owner_id = ?");
        vPs.setInt(1, visitId);
        vPs.setInt(2, ownerId);
        ResultSet vRs = vPs.executeQuery();
        if (vRs.next()) {
            visitDate   = vRs.getString("visit_date");
            visitNotes  = vRs.getString("notes");
            petName     = vRs.getString("pet_name");
            vetName     = vRs.getString("vet_name");
            serviceName = vRs.getString("service_name");
        }
        vRs.close(); vPs.close();

        if (petName == null) {
            conn.close();
            response.sendRedirect("view_visits.jsp");
            return;
        }

        // Load procedures
        PreparedStatement pPs = conn.prepareStatement(
            "SELECT procedure_name, charge_amount, notes " +
            "FROM procedure_record WHERE visit_id = ? ORDER BY procedure_id");
        pPs.setInt(1, visitId);
        ResultSet pRs = pPs.executeQuery();
        while (pRs.next()) {
            double charge = pRs.getDouble("charge_amount");
            totalCharge += charge;
            procedures.add(new Object[]{
                pRs.getString("procedure_name"),
                charge,
                pRs.getString("notes")
            });
        }
        pRs.close(); pPs.close();

        // Load vitals from support log
        PreparedStatement sPs = conn.prepareStatement(
            "SELECT vsl.weight, vsl.temperature, vsl.notes, vsl.log_time, " +
            "st.full_name AS tech_name " +
            "FROM visit_support_log vsl " +
            "LEFT JOIN staff st ON vsl.technician_id = st.employee_id " +
            "WHERE vsl.visit_id = ? ORDER BY vsl.log_time");
        sPs.setInt(1, visitId);
        ResultSet sRs = sPs.executeQuery();
        while (sRs.next()) {
            vitals.add(new Object[]{
                sRs.getObject("weight"),
                sRs.getObject("temperature"),
                sRs.getString("notes"),
                sRs.getString("log_time"),
                sRs.getString("tech_name")
            });
        }
        sRs.close(); sPs.close();
        conn.close();

    } catch (Exception e) {
        loadError = "Unable to load visit details.";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visit Detail — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="view_pets.jsp">My Pets</a>
        <a href="view_my_appointments.jsp">Appointments</a>
        <a href="search_clinic.jsp">Clinics</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-md">
<div class="card">

    <h1 class="page-title">Visit Detail</h1>

    <% if (loadError != null) { %>
        <div class="alert alert-error"><%= loadError %></div>
    <% } else { %>

    <p class="page-subtitle">Complete record for <%= petName %>'s visit.</p>
    <hr class="divider">

    <!-- Visit summary -->
    <div class="kpi-grid">
        <div class="kpi-card">
            <div class="kpi-label">Pet</div>
            <div style="font-size:20px;font-weight:700;color:var(--primary);margin-top:4px;"><%= petName %></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-label">Date</div>
            <div style="font-size:16px;font-weight:700;color:var(--primary);margin-top:4px;"><%= visitDate %></div>
        </div>
        <div class="kpi-card">
            <div class="kpi-label">Veterinarian</div>
            <div style="font-size:16px;font-weight:700;color:var(--primary);margin-top:4px;">
                <%= vetName != null ? vetName : "—" %>
            </div>
        </div>
        <div class="kpi-card kpi-revenue">
            <div class="kpi-label">Total Charges</div>
            <div class="kpi-value">$<%= String.format("%.2f", totalCharge) %></div>
        </div>
    </div>

    <% if (serviceName != null) { %>
        <p class="text-muted" style="margin-bottom:8px;">
            <strong>Service:</strong> <%= serviceName %>
        </p>
    <% } %>
    <% if (visitNotes != null && !visitNotes.isEmpty()) { %>
        <p class="text-muted" style="margin-bottom:16px;">
            <strong>Notes:</strong> <%= visitNotes %>
        </p>
    <% } %>

    <!-- Procedures -->
    <h2 class="section-heading">Procedures &amp; Charges</h2>
    <table class="data-table">
        <thead>
            <tr>
                <th>Procedure</th>
                <th>Notes</th>
                <th>Charge</th>
            </tr>
        </thead>
        <tbody>
        <% if (procedures.isEmpty()) { %>
            <tr class="no-data"><td colspan="3">No procedures recorded for this visit.</td></tr>
        <% } else {
               for (Object[] p : procedures) {
        %>
            <tr>
                <td><strong><%= p[0] %></strong></td>
                <td><%= p[2] != null && !((String)p[2]).isEmpty() ? p[2] : "—" %></td>
                <td>$<%= String.format("%.2f", (double)p[1]) %></td>
            </tr>
        <%     }
           }
        %>
        </tbody>
        <% if (!procedures.isEmpty()) { %>
        <tfoot>
            <tr>
                <td colspan="2" style="text-align:right;font-weight:700;padding:12px 14px;">Total</td>
                <td style="font-weight:700;padding:12px 14px;color:var(--success);">
                    $<%= String.format("%.2f", totalCharge) %>
                </td>
            </tr>
        </tfoot>
        <% } %>
    </table>

    <!-- Vitals -->
    <% if (!vitals.isEmpty()) { %>
    <h2 class="section-heading">Recorded Vitals</h2>
    <table class="data-table">
        <thead>
            <tr>
                <th>Time</th>
                <th>Weight (kg)</th>
                <th>Temp (°F)</th>
                <th>Technician</th>
                <th>Notes</th>
            </tr>
        </thead>
        <tbody>
        <% for (Object[] sv : vitals) { %>
            <tr>
                <td><%= sv[3] %></td>
                <td><%= sv[0] != null ? sv[0] : "—" %></td>
                <td><%= sv[1] != null ? sv[1] : "—" %></td>
                <td><%= sv[4] != null ? sv[4] : "—" %></td>
                <td><%= sv[2] != null && !((String)sv[2]).isEmpty() ? sv[2] : "—" %></td>
            </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>

    <% } %>

    <div class="btn-row mt-24">
        <a href="javascript:history.back()" class="btn btn-secondary">Back</a>
        <a href="view_pets.jsp" class="btn btn-secondary">My Pets</a>
        <a href="dashboard.jsp" class="btn btn-secondary">Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
