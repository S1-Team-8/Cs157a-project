<%@ page import="java.util.List" %>
<%@ page import="com.petwellness.service.ServiceCatalogService" %>
<%@ page import="com.petwellness.service.ServiceCatalogService.ServiceRecord" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    String _role = (String) session.getAttribute("staff_role");
    if (_role == null) _role = "";
    boolean _canEdit = "Admin".equals(_role) || "Manager".equals(_role);

    List<ServiceRecord> services = ServiceCatalogService.getAllServices();

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service Catalog — PetWellness</title>

    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <a href="manage_services.jsp" class="nav-active">Service Catalog</a>
        <a href="manage_clinic_services.jsp">Clinic Services</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-lg">
<div class="card">

    <h1 class="page-title">Service Catalog</h1>
    <p class="page-subtitle">Services available for owners to select when scheduling appointments.</p>
    <hr class="divider">

    <% if ("added".equals(msg)) { %>
        <div class="alert alert-success">Service added successfully.</div>
    <% } else if ("deleted".equals(msg)) { %>
        <div class="alert alert-success">Service deleted.</div>
    <% } else if ("error".equals(msg)) { %>
        <div class="alert alert-error">An error occurred. Please try again.</div>
    <% } %>

    <% if (_canEdit) { %>
    <p class="section-heading">Add New Service</p>
    <form action="manage_services_process.jsp" method="post">
        <input type="hidden" name="action" value="add">
        <div class="form-row">
            <div class="form-group-inline">
                <label>Service Name *</label>
                <input type="text" name="service_name" class="form-control"
                       placeholder="e.g., Annual Wellness Exam" required style="width:220px;">
            </div>
            <div class="form-group-inline">
                <label>Category</label>
                <input type="text" name="category" class="form-control"
                       placeholder="e.g., Wellness" style="width:160px;">
            </div>
            <div class="form-group-inline">
                <label>Description</label>
                <input type="text" name="description" class="form-control"
                       placeholder="Brief description" style="width:240px;">
            </div>
            <div class="form-group-inline">
                <label>&nbsp;</label>
                <button type="submit" class="btn btn-primary">Add Service</button>
            </div>
        </div>
    </form>
    <hr class="divider">
    <% } %>

    <p class="section-heading" style="border:none;margin-bottom:14px;">All Services</p>

    <table class="data-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Service Name</th>
                <th>Category</th>
                <th>Description</th>
                <% if (_canEdit) { %><th>Actions</th><% } %>
            </tr>
        </thead>
        <tbody>
        <% if (services == null || services.isEmpty()) { %>
            <tr class="no-data"><td colspan="<%= _canEdit ? 5 : 4 %>">No services defined yet.</td></tr>
        <% } else {
               for (ServiceRecord svc : services) { %>
            <tr>
                <td style="color:var(--text-muted);font-size:12px;"><%= svc.getServiceId() %></td>
                <td><strong><%= svc.getServiceName() %></strong></td>
                <td><%= svc.getCategory() %></td>
                <td><%= svc.getDescription() %></td>
                <% if (_canEdit) { %>
                <td>
                    <form action="manage_services_process.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="service_id" value="<%= svc.getServiceId() %>">
                        <button type="submit" class="btn btn-danger btn-sm"
                                onclick="return confirm('Delete this service?')">Delete</button>
                    </form>
                </td>
                <% } %>
            </tr>
        <% } } %>
        </tbody>
    </table>

    <div class="btn-row mt-24">
        <% if (_canEdit) { %>
            <a href="manage_clinic_services.jsp" class="btn btn-primary">Manage Clinic Pricing →</a>
        <% } %>
        <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
