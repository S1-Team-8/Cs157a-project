<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    int loggedInTechId     = Integer.parseInt(session.getAttribute("employee_id").toString());
    String loggedInTechName = (String) session.getAttribute("staff_name");
    String preVisitId       = request.getParameter("visit_id");
    if (preVisitId == null) preVisitId = "";
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

    <h1 class="page-title">Record Technician Notes / Vitals</h1>
    <p class="page-subtitle">Record weight, temperature, and support notes for a visit.</p>
    <hr class="divider">

    <form action="add_support_log_process.jsp" method="post">

        <div class="form-group">
            <label for="visit_id">Visit ID</label>
            <div>
                <input type="number" name="visit_id" id="visit_id" class="form-control"
                       min="1" required value="<%= preVisitId %>">
                <p class="form-hint">Enter the Visit ID from the patient's visit record.</p>
            </div>
        </div>

        <div class="form-group">
            <label>Technician</label>
            <div>
                <input type="text" class="form-control" value="<%= loggedInTechName %>" readonly>
                <input type="hidden" name="technician_id" value="<%= loggedInTechId %>">
                <p class="form-hint">Auto-filled from your login session.</p>
            </div>
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
                      placeholder="Technician observations and support notes..."></textarea>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Save Support Log</button>
            <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </form>

</div>
</div>
</div>

</body>
</html>
