<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    String preVisitId = request.getParameter("visit_id");
    if (preVisitId == null) preVisitId = "";
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
        <a href="hospital_dashboard.jsp" class="nav-active">Dashboard</a>
        <a href="view_appointments.jsp">Appointments</a>
        <a href="manage_inventory.jsp">Inventory</a>
        <a href="reports.jsp">Reports</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-md">
<div class="card">

    <h1 class="page-title">Add Procedure / Treatment</h1>
    <p class="page-subtitle">Record a procedure or treatment for a visit.</p>
    <hr class="divider">

    <form action="add_procedure_process.jsp" method="post">

        <div class="form-group">
            <label for="visit_id">Visit ID</label>
            <div>
                <input type="number" name="visit_id" id="visit_id" class="form-control"
                       min="1" required value="<%= preVisitId %>">
                <p class="form-hint">Enter the Visit ID from the patient's visit record.</p>
            </div>
        </div>

        <div class="form-group">
            <label for="procedure_name">Procedure Name</label>
            <input type="text" name="procedure_name" id="procedure_name" class="form-control"
                   placeholder="e.g., Blood Test, Vaccination, X-Ray" required>
        </div>

        <div class="form-group">
            <label for="charge_amount">Charge ($)</label>
            <input type="number" step="0.01" min="0" name="charge_amount" id="charge_amount"
                   class="form-control" placeholder="e.g., 75.00" required>
        </div>

        <div class="form-group">
            <label for="notes">Notes</label>
            <textarea name="notes" id="notes" class="form-control"
                      placeholder="Any additional notes..."></textarea>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Save Procedure</button>
            <a href="view_procedures.jsp" class="btn btn-secondary">View Procedures</a>
            <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </form>

</div>
</div>
</div>

</body>
</html>
