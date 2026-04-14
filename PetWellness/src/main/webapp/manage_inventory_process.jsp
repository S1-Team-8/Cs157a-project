<%@ page import="com.petwellness.service.InventoryService" %>
<%
    String actionType = request.getParameter("action_type");

    try {
        if ("add".equals(actionType)) {
            String itemName = request.getParameter("item_name");
            String category = request.getParameter("category");
            int qtyOnHand = Integer.parseInt(request.getParameter("qty_on_hand"));
            int reorderThreshold = Integer.parseInt(request.getParameter("reorder_threshold"));
            double unitCost = Double.parseDouble(request.getParameter("unit_cost"));

            InventoryService.addInventoryItem(itemName, category, qtyOnHand, reorderThreshold, unitCost);

        } else if ("update".equals(actionType)) {
            int itemId = Integer.parseInt(request.getParameter("item_id"));
            int newQtyOnHand = Integer.parseInt(request.getParameter("new_qty_on_hand"));

            InventoryService.updateInventoryQuantity(itemId, newQtyOnHand);
        }

        response.sendRedirect("manage_inventory.jsp");

    } catch (Exception e) {
        out.println("<h3>Error managing inventory.</h3>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>