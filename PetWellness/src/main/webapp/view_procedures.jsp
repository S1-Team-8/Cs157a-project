<%@ page import="java.util.List" %>
<%@ page import="com.petwellness.service.ViewProcedureService" %>
<%@ page import="com.petwellness.service.ViewProcedureService.ProcedureRecord" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    String visitIdStr = request.getParameter("visit_id");
    List<ProcedureRecord> procedures = null;
    Integer visitId = null;
    if (visitIdStr != null && !visitIdStr.trim().isEmpty()) {
        try {
            visitId = Integer.parseInt(visitIdStr.trim());
            procedures = ViewProcedureService.getProceduresByVisitId(visitId);
        } catch (NumberFormatException e) { visitId = null; }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Procedures — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp" class="nav-active">Dashboard</a>
        <a href="view_appointments.jsp">Appointments</a>
        <a href="manage_inventory.jsp">Inventory</a>
        <a href="reports.jsp">Reports</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-lg">
<div class="card">

    <h1 class="page-title">Procedures for a Visit</h1>

    <!-- Search bar -->
    <form method="get" action="view_procedures.jsp" style="margin:20px 0 28px;">
        <div class="form-row" style="align-items:flex-end;">
            <div class="form-group-inline">
                <label>Visit ID</label>
                <input type="number" name="visit_id" class="form-control" min="1"
                       value="<%= visitIdStr != null ? visitIdStr : "" %>"
                       placeholder="Enter visit ID" style="width:160px;" required>
            </div>
            <button type="submit" class="btn btn-primary">Search</button>
        </div>
    </form>

    <%
        if (visitIdStr != null && !visitIdStr.trim().isEmpty()) {
            if (visitId == null) { %>
                <p class="error">Invalid Visit ID. Please enter a valid number.</p>
    <%      } else if (procedures == null || procedures.isEmpty()) { %>
                <p class="text-muted" style="text-align:center;padding:28px;font-style:italic;">
                    No procedures found for Visit ID <%= visitId %>.
                </p>
    <%      } else { %>
                <h3 style="color:var(--primary);font-size:16px;margin-bottom:14px;">
                    Procedures for Visit ID <%= visitId %>
                </h3>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Procedure ID</th>
                            <th>Procedure Name</th>
                            <th>Charge</th>
                            <th>Notes</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% for (ProcedureRecord proc : procedures) {
                           String notes = proc.getNotes(); if (notes == null) notes = ""; %>
                        <tr>
                            <td><%= proc.getProcedureId() %></td>
                            <td><strong><%= proc.getProcedureName() %></strong></td>
                            <td style="color:var(--success);font-weight:600;">$<%= String.format("%.2f", proc.getChargeAmount()) %></td>
                            <td><%= notes %></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
    <%      }
        }
    %>

    <div class="btn-row mt-24">
        <a href="add_procedure.jsp<%= visitIdStr != null && !visitIdStr.isEmpty() ? "?visit_id=" + visitIdStr : "" %>"
           class="btn btn-primary">Add Procedure</a>
        <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
