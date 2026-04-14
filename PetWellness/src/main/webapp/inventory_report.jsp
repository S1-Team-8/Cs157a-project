<%@ page import="java.util.List" %>
<%@ page import="com.petwellness.service.InventoryReportService" %>
<%@ page import="com.petwellness.service.InventoryReportService.LowStockRecord" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<LowStockRecord> lowStockItems = InventoryReportService.getLowStockItems();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inventory Report</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h2>Inventory KPI Report</h2>
        <h3>Low Stock Items</h3>

        <%
            if (lowStockItems == null || lowStockItems.isEmpty()) {
        %>
            <p>No low-stock items found.</p>
        <%
            } else {
        %>
            <table border="1" cellpadding="10" cellspacing="0" style="margin: 0 auto; background: white;">
                <tr>
                    <th>Item ID</th>
                    <th>Item Name</th>
                    <th>Category</th>
                    <th>Quantity on Hand</th>
                    <th>Reorder Threshold</th>
                    <th>Unit Cost</th>
                </tr>

                <%
                    for (LowStockRecord item : lowStockItems) {
                %>
                <tr>
                    <td><%= item.getItemId() %></td>
                    <td><%= item.getItemName() %></td>
                    <td><%= item.getCategory() %></td>
                    <td><%= item.getQtyOnHand() %></td>
                    <td><%= item.getReorderThreshold() %></td>
                    <td><%= item.getUnitCost() %></td>
                </tr>
                <%
                    }
                %>
            </table>
        <%
            }
        %>

        <br>
        <p><a class="btn" href="manage_inventory.jsp">Back to Manage Inventory</a></p>
        <p><a class="btn" href="hospital_dashboard.jsp">Back to Hospital Dashboard</a></p>
    </div>
</body>
</html>