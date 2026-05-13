<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page import="com.petwellness.service.ServiceCatalogService" %>
<%@ page import="com.petwellness.service.ServiceCatalogService.ServiceRecord" %>
<%@ page import="com.petwellness.service.ClinicServiceService" %>
<%@ page import="com.petwellness.service.ClinicServiceService.ClinicServiceRecord" %>
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

    String clinicIdStr = request.getParameter("clinic_id");
    Integer filterClinicId = null;
    if (clinicIdStr != null && !clinicIdStr.trim().isEmpty()) {
        try { filterClinicId = Integer.parseInt(clinicIdStr); } catch (NumberFormatException e) {}
    }

    List<ClinicServiceRecord> rows = filterClinicId != null
        ? ClinicServiceService.getServicesForClinic(filterClinicId)
        : ClinicServiceService.getAllClinicServices();

    List<ServiceRecord> catalog = ServiceCatalogService.getAllServices();

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clinic Services — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <a href="manage_services.jsp">Service Catalog</a>
        <a href="manage_clinic_services.jsp" class="nav-active">Clinic Services</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-lg">
<div class="card">

    <h1 class="page-title">Clinic Services &amp; Pricing</h1>
    <p class="page-subtitle">Assign services from the catalog to specific clinics and set pricing.</p>
    <hr class="divider">

    <% if ("added".equals(msg)) { %>
        <div class="alert alert-success">Service added to clinic.</div>
    <% } else if ("removed".equals(msg)) { %>
        <div class="alert alert-success">Service removed from clinic.</div>
    <% } else if ("error".equals(msg)) { %>
        <div class="alert alert-error">An error occurred. Please try again.</div>
    <% } else if ("nocatalog".equals(msg)) { %>
        <div class="alert alert-error">No services in the catalog yet. <a href="manage_services.jsp">Add services first.</a></div>
    <% } %>

    <%-- ── Add service to clinic form ─────────────────────────────────────── --%>
    <p class="section-heading">Assign Service to Clinic</p>

    <% if (catalog.isEmpty()) { %>
        <p class="form-hint">No services in the catalog. <a href="manage_services.jsp">Add services to the catalog first.</a></p>
    <% } else { %>
    <form action="manage_clinic_services_process.jsp" method="post">
        <input type="hidden" name="action" value="add">
        <div class="form-row">
            <div class="form-group-inline">
                <label>Clinic *</label>
                <select name="clinic_id" class="form-control" required style="min-width:200px;">
                    <option value="">— Select clinic —</option>
                    <%
                        Connection _c = null; PreparedStatement _s = null; ResultSet _r = null;
                        try {
                            _c = DBConnection.getConnection();
                            _s = _c.prepareStatement(
                                "SELECT clinic_id, clinic_name, city FROM clinic ORDER BY clinic_name");
                            _r = _s.executeQuery();
                            while (_r.next()) {
                                String city = _r.getString("city");
                                String label = _r.getString("clinic_name")
                                             + (city != null ? " — " + city : "");
                                boolean sel = filterClinicId != null
                                           && filterClinicId == _r.getInt("clinic_id");
                    %>
                        <option value="<%= _r.getInt("clinic_id") %>"
                                <%= sel ? "selected" : "" %>><%= label %></option>
                    <%      }
                        } catch (Exception e) {
                            out.println("<option disabled>Error loading clinics</option>");
                        } finally {
                            try { if (_r != null) _r.close(); } catch (Exception e) {}
                            try { if (_s != null) _s.close(); } catch (Exception e) {}
                            try { if (_c != null) _c.close(); } catch (Exception e) {}
                        }
                    %>
                </select>
            </div>
            <div class="form-group-inline">
                <label>Service *</label>
                <select name="service_id" class="form-control" required style="min-width:200px;">
                    <option value="">— Select service —</option>
                    <% for (ServiceRecord svc : catalog) { %>
                        <option value="<%= svc.getServiceId() %>">
                            <%= svc.getServiceName() %>
                            <% if (!svc.getCategory().isEmpty()) { %>
                                (<%= svc.getCategory() %>)
                            <% } %>
                        </option>
                    <% } %>
                </select>
            </div>
            <div class="form-group-inline">
                <label>Min Price ($)</label>
                <input type="number" name="price_min" step="0.01" min="0"
                       class="form-control" placeholder="e.g. 50.00" style="width:120px;">
            </div>
            <div class="form-group-inline">
                <label>Max Price ($)</label>
                <input type="number" name="price_max" step="0.01" min="0"
                       class="form-control" placeholder="e.g. 80.00" style="width:120px;">
            </div>
            <div class="form-group-inline">
                <label>&nbsp;</label>
                <button type="submit" class="btn btn-primary">Add</button>
            </div>
        </div>
        <p class="form-hint">Leave both prices blank if the price is not yet set. If fixed price, enter the same value in both fields.</p>
    </form>
    <% } %>

    <hr class="divider">

    <%-- ── Filter by clinic ───────────────────────────────────────────────── --%>
    <form method="get" action="manage_clinic_services.jsp"
          style="display:flex;align-items:flex-end;gap:10px;margin-bottom:18px;flex-wrap:wrap;">
        <div class="form-group-inline">
            <label>Filter by Clinic</label>
            <select name="clinic_id" class="form-control" style="min-width:200px;">
                <option value="">— All Clinics —</option>
                <%
                    Connection _cf = null; PreparedStatement _sf = null; ResultSet _rf = null;
                    try {
                        _cf = DBConnection.getConnection();
                        _sf = _cf.prepareStatement(
                            "SELECT clinic_id, clinic_name FROM clinic ORDER BY clinic_name");
                        _rf = _sf.executeQuery();
                        while (_rf.next()) {
                            boolean sel = filterClinicId != null
                                       && filterClinicId == _rf.getInt("clinic_id");
                %>
                    <option value="<%= _rf.getInt("clinic_id") %>"
                            <%= sel ? "selected" : "" %>><%= _rf.getString("clinic_name") %></option>
                <%      }
                    } catch (Exception e) {
                        out.println("<option disabled>Error</option>");
                    } finally {
                        try { if (_rf != null) _rf.close(); } catch (Exception e) {}
                        try { if (_sf != null) _sf.close(); } catch (Exception e) {}
                        try { if (_cf != null) _cf.close(); } catch (Exception e) {}
                    }
                %>
            </select>
        </div>
        <button type="submit" class="btn btn-secondary">Filter</button>
        <a href="manage_clinic_services.jsp" class="btn btn-secondary">Show All</a>
    </form>

    <%-- ── Services table ─────────────────────────────────────────────────── --%>
    <table class="data-table">
        <thead>
            <tr>
                <th>Clinic</th>
                <th>Service</th>
                <th>Category</th>
                <th>Price</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <% if (rows.isEmpty()) { %>
            <tr class="no-data">
                <td colspan="5">
                    <div class="empty-state-icon">🩺</div>
                    No clinic-service assignments yet.
                </td>
            </tr>
        <% } else {
               for (ClinicServiceRecord r : rows) { %>
            <tr>
                <td><strong><%= r.getClinicName() %></strong></td>
                <td><%= r.getServiceName() %></td>
                <td><%= r.getCategory() %></td>
                <td><%= r.getPriceDisplay() %></td>
                <td>
                    <form action="manage_clinic_services_process.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="clinic_service_id" value="<%= r.getClinicServiceId() %>">
                        <% if (filterClinicId != null) { %>
                            <input type="hidden" name="redirect_clinic_id" value="<%= filterClinicId %>">
                        <% } %>
                        <button type="submit" class="btn btn-danger btn-sm"
                                onclick="return confirm('Remove this service from the clinic?')">Remove</button>
                    </form>
                </td>
            </tr>
        <% } } %>
        </tbody>
    </table>

    <div class="btn-row mt-24">
        <a href="manage_services.jsp" class="btn btn-secondary">Manage Service Catalog</a>
        <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
