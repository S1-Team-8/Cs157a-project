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
    if (!"Admin".equals(_role) && !"Manager".equals(_role) && !"Inventory Staff".equals(_role)) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }
    List<InventoryRecord> items = InventoryService.getAllInventoryItems();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Inventory — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <a href="view_appointments.jsp">Appointments</a>
        <a href="manage_inventory.jsp" class="nav-active">Inventory</a>
        <a href="reports.jsp">Reports</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-lg">
<div class="card">

    <h1 class="page-title">Manage Inventory</h1>

    <!-- ADD ITEM -->
    <p class="section-heading">Add Inventory Item</p>
    <form action="manage_inventory_process.jsp" method="post">
        <input type="hidden" name="action_type" value="add">
        <div class="form-row">
            <div class="form-group-inline">
                <label>Item Name *</label>
                <input type="text" name="item_name" class="form-control" placeholder="e.g., Amoxicillin" required style="width:190px;">
            </div>
            <div class="form-group-inline">
                <label>Category</label>
                <input type="text" name="category" class="form-control" placeholder="e.g., Medication" style="width:150px;">
            </div>
            <div class="form-group-inline">
                <label>Qty on Hand *</label>
                <input type="number" name="qty_on_hand" class="form-control" min="0" required style="width:110px;">
            </div>
            <div class="form-group-inline">
                <label>Reorder Threshold *</label>
                <input type="number" name="reorder_threshold" class="form-control" min="0" required style="width:130px;">
            </div>
            <div class="form-group-inline">
                <label>Unit Cost ($) *</label>
                <input type="number" step="0.01" min="0" name="unit_cost" class="form-control" placeholder="0.00" required style="width:120px;">
            </div>
            <div class="form-group-inline">
                <label>&nbsp;</label>
                <button type="submit" class="btn btn-primary">Add Item</button>
            </div>
        </div>
    </form>

    <hr class="divider">

    <!-- UPDATE QTY -->
    <p class="section-heading">Update Inventory Quantity</p>
    <form action="manage_inventory_process.jsp" method="post">
        <input type="hidden" name="action_type" value="update">
        <div class="form-row">
            <div class="form-group-inline">
                <label>Item ID *</label>
                <input type="number" name="item_id" class="form-control" min="1" required style="width:120px;">
            </div>
            <div class="form-group-inline">
                <label>New Quantity *</label>
                <input type="number" name="new_qty_on_hand" class="form-control" min="0" required style="width:130px;">
            </div>
            <div class="form-group-inline">
                <label>&nbsp;</label>
                <button type="submit" class="btn btn-primary">Update</button>
            </div>
        </div>
    </form>

    <hr class="divider">

    <!-- INVENTORY TABLE -->
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:14px;flex-wrap:wrap;gap:10px;">
        <p class="section-heading" style="margin:0;border:none;">Current Inventory</p>
        <a href="inventory_report.jsp" class="btn btn-secondary btn-sm">View Low-Stock Report</a>
    </div>
    <p class="form-hint" style="margin-bottom:12px;">Rows highlighted in amber are at or below their reorder threshold.</p>

    <table class="data-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Item Name</th>
                <th>Category</th>
                <th>Qty on Hand</th>
                <th>Reorder Threshold</th>
                <th>Unit Cost</th>
            </tr>
        </thead>
        <tbody>
        <%
            if (items == null || items.isEmpty()) { %>
            <tr class="no-data"><td colspan="6">No inventory items found.</td></tr>
        <%  } else {
                for (InventoryRecord item : items) {
                    boolean low = item.getQtyOnHand() <= item.getReorderThreshold();
        %>
            <tr class="<%= low ? "low-stock" : "" %>">
                <td><%= item.getItemId() %></td>
                <td><strong><%= item.getItemName() %></strong></td>
                <td><%= item.getCategory() != null ? item.getCategory() : "" %></td>
                <td><%= item.getQtyOnHand() %></td>
                <td><%= item.getReorderThreshold() %></td>
                <td>$<%= String.format("%.2f", item.getUnitCost()) %></td>
            </tr>
        <%      }
            }
        %>
        </tbody>
    </table>

    <div class="btn-row mt-24">
        <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
