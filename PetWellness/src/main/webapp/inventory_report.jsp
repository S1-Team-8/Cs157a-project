<%@ page import="java.util.List" %>
<%@ page import="com.petwellness.service.InventoryReportService" %>
<%@ page import="com.petwellness.service.InventoryReportService.LowStockRecord" %>
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
    List<LowStockRecord> lowStockItems = InventoryReportService.getLowStockItems();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Low-Stock Report — PetWellness</title>
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

    <div style="display:flex;align-items:center;gap:16px;margin-bottom:6px;flex-wrap:wrap;">
        <h1 class="page-title" style="margin-bottom:0;">Low-Stock Inventory Report</h1>
        <% if (lowStockItems != null && !lowStockItems.isEmpty()) { %>
            <span class="badge badge-canceled" style="font-size:14px;padding:6px 14px;">
                <%= lowStockItems.size() %> item<%= lowStockItems.size() == 1 ? "" : "s" %> need attention
            </span>
        <% } %>
    </div>
    <p class="page-subtitle">Items at or below their reorder threshold.</p>

    <table class="data-table">
        <thead>
            <tr>
                <th>Item ID</th>
                <th>Item Name</th>
                <th>Category</th>
                <th>Qty on Hand</th>
                <th>Reorder Threshold</th>
                <th>Unit Cost</th>
            </tr>
        </thead>
        <tbody>
        <%
            if (lowStockItems == null || lowStockItems.isEmpty()) { %>
            <tr><td colspan="6" style="text-align:center;padding:32px;color:var(--success);font-weight:600;">
                All items are sufficiently stocked.
            </td></tr>
        <%  } else {
                for (LowStockRecord item : lowStockItems) {
        %>
            <tr class="low-stock">
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

    <hr class="divider">

    <h2 class="section-heading">Most Used Items (Last 30 Days)</h2>
    <table class="data-table">
        <thead>
            <tr>
                <th>Item Name</th>
                <th>Category</th>
                <th>Times Used</th>
                <th>Total Units Consumed</th>
                <th>Current Stock</th>
            </tr>
        </thead>
        <tbody>
        <%
            java.sql.Connection _uc = null; java.sql.PreparedStatement _us = null; java.sql.ResultSet _ur = null;
            boolean hasUsage = false;
            try {
                _uc = com.petwellness.util.DBConnection.getConnection();
                _us = _uc.prepareStatement(
                    "SELECT i.item_id, i.item_name, i.category, i.qty_on_hand, " +
                    "COUNT(ul.usage_id) AS times_used, SUM(ul.qty_used) AS total_used " +
                    "FROM inventory_usage_log ul " +
                    "JOIN inventory_item i ON ul.item_id = i.item_id " +
                    "WHERE ul.used_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                    "GROUP BY i.item_id, i.item_name, i.category, i.qty_on_hand " +
                    "ORDER BY total_used DESC LIMIT 10");
                _ur = _us.executeQuery();
                while (_ur.next()) {
                    hasUsage = true;
        %>
            <tr>
                <td><strong><%= _ur.getString("item_name") %></strong></td>
                <td><%= _ur.getString("category") != null ? _ur.getString("category") : "" %></td>
                <td><%= _ur.getInt("times_used") %></td>
                <td><%= _ur.getInt("total_used") %></td>
                <td><%= _ur.getInt("qty_on_hand") %></td>
            </tr>
        <%      }
            } catch (Exception _e) {
                out.println("<tr><td colspan=\"5\"><div class=\"alert alert-error\">Error loading usage data.</div></td></tr>");
            } finally {
                try { if (_ur != null) _ur.close(); } catch (Exception e) {}
                try { if (_us != null) _us.close(); } catch (Exception e) {}
                try { if (_uc != null) _uc.close(); } catch (Exception e) {}
            }
            if (!hasUsage) {
        %>
            <tr class="no-data">
                <td colspan="5">No inventory usage recorded in the last 30 days.</td>
            </tr>
        <% } %>
        </tbody>
    </table>

    <div class="btn-row mt-24">
        <a href="manage_inventory.jsp" class="btn btn-primary">Manage Inventory</a>
        <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
