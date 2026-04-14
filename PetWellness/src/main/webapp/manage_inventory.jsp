<%@ page import="java.util.List" %>
<%@ page import="com.petwellness.service.InventoryService" %>
<%@ page import="com.petwellness.service.InventoryService.InventoryRecord" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<InventoryRecord> items = InventoryService.getAllInventoryItems();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Inventory</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h2>Manage Inventory</h2>

        <h3>Add Inventory Item</h3>
        <form action="manage_inventory_process.jsp" method="post">
            <input type="hidden" name="action_type" value="add">

            <label for="item_name">Item Name</label>
            <input type="text" name="item_name" id="item_name" required>

            <label for="category">Category</label>
            <input type="text" name="category" id="category">

            <label for="qty_on_hand">Quantity on Hand</label>
            <input type="number" name="qty_on_hand" id="qty_on_hand" required>

            <label for="reorder_threshold">Reorder Threshold</label>
            <input type="number" name="reorder_threshold" id="reorder_threshold" required>

            <label for="unit_cost">Unit Cost</label>
            <input type="number" step="0.01" name="unit_cost" id="unit_cost" required>

            <button type="submit" class="btn">Add Item</button>
        </form>

        <hr>

        <h3>Update Inventory Quantity</h3>
        <form action="manage_inventory_process.jsp" method="post">
            <input type="hidden" name="action_type" value="update">

            <label for="item_id">Item ID</label>
            <input type="number" name="item_id" id="item_id" required>

            <label for="new_qty_on_hand">New Quantity on Hand</label>
            <input type="number" name="new_qty_on_hand" id="new_qty_on_hand" required>

            <button type="submit" class="btn">Update Quantity</button>
        </form>

        <hr>

        <h3>Inventory List</h3>

        <%
            if (items == null || items.isEmpty()) {
        %>
            <p>No inventory items found.</p>
        <%
            } else {
        %>
            <table border="1" cellpadding="10" cellspacing="0" style="margin: 0 auto; background: white;">
                <tr>
                    <th>Item ID</th>
                    <th>Item Name</th>
                    <th>Category</th>
                    <th>Quantity</th>
                    <th>Reorder Threshold</th>
                    <th>Unit Cost</th>
                </tr>

                <%
                    for (InventoryRecord item : items) {
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
        <p><a class="btn" href="hospital_dashboard.jsp">Back to Hospital Dashboard</a></p>
    </div>
</body>
</html>