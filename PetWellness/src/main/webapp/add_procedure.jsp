<%@ page import="java.util.List" %>
<%@ page import="com.petwellness.service.InventoryService" %>
<%@ page import="com.petwellness.service.InventoryService.InventoryRecord" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    String _role = (String) session.getAttribute("staff_role");
    if (_role == null) _role = "";
    if (!"Admin".equals(_role) && !"Veterinarian".equals(_role)) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }
    String preVisitId = request.getParameter("visit_id");
    if (preVisitId == null) preVisitId = "";

    List<InventoryRecord> inventoryItems = InventoryService.getAllInventoryItems();
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
        <a href="manage_inventory.jsp">Inventory</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-md">
<div class="card">

    <h1 class="page-title">Add Procedure / Treatment</h1>
    <p class="page-subtitle">Record a procedure and optionally log inventory items consumed.</p>
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

        <hr class="divider">

        <p class="section-heading" style="margin-top:0;">Inventory Used <span style="font-weight:400;font-size:13px;color:var(--text-muted);">(optional)</span></p>
        <p class="form-hint" style="margin-bottom:16px;">
            If this procedure consumed a supply or medication, select it here.
            The quantity on hand will decrease automatically.
        </p>

        <div class="form-row">
            <div class="form-group-inline">
                <label>Item</label>
                <select name="item_id" id="item_id" class="form-control" style="min-width:220px;">
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
                <input type="number" name="qty_used" id="qty_used"
                       class="form-control" min="1" placeholder="e.g., 1" style="width:110px;">
            </div>
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
