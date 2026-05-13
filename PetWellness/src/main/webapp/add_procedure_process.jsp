<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
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

    int staffId = Integer.parseInt(session.getAttribute("employee_id").toString());

    String apptIdStr       = request.getParameter("appointment_id");
    if (apptIdStr == null) apptIdStr = "";
    String visitIdStr      = request.getParameter("visit_id");
    String procedureName   = request.getParameter("procedure_name");
    String chargeAmountStr = request.getParameter("charge_amount");
    String notes           = request.getParameter("notes");
    String itemIdStr       = request.getParameter("item_id");
    String qtyUsedStr      = request.getParameter("qty_used");

    boolean success   = false;
    String  errorMsg  = "";
    int     savedVisitId = 0;
    String  inventoryMsg = null;

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        if (visitIdStr == null || visitIdStr.trim().isEmpty() ||
            procedureName == null || procedureName.trim().isEmpty() ||
            chargeAmountStr == null || chargeAmountStr.trim().isEmpty()) {
            throw new Exception("Please fill in all required fields.");
        }

        int visitId = Integer.parseInt(visitIdStr.trim());
        double chargeAmount = Double.parseDouble(chargeAmountStr.trim());
        if (chargeAmount < 0) throw new Exception("Charge amount cannot be negative.");

        savedVisitId = visitId;
        conn = DBConnection.getConnection();

        // Insert procedure, capture generated key so we can link to usage log
        ps = conn.prepareStatement(
            "INSERT INTO procedure_record (visit_id, procedure_name, charge_amount, notes) VALUES (?, ?, ?, ?)",
            Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, visitId);
        ps.setString(2, procedureName.trim());
        ps.setDouble(3, chargeAmount);
        ps.setString(4, (notes != null && !notes.trim().isEmpty()) ? notes.trim() : null);

        int rows = ps.executeUpdate();
        if (rows == 0) throw new Exception("Procedure could not be saved.");

        // Get the generated procedure_id
        int procedureId = -1;
        ResultSet genKeys = ps.getGeneratedKeys();
        if (genKeys.next()) procedureId = genKeys.getInt(1);
        genKeys.close();

        // Optional inventory usage
        if (itemIdStr != null && !itemIdStr.trim().isEmpty() &&
            qtyUsedStr != null && !qtyUsedStr.trim().isEmpty()) {
            try {
                int itemId  = Integer.parseInt(itemIdStr.trim());
                int qtyUsed = Integer.parseInt(qtyUsedStr.trim());
                if (qtyUsed > 0) {
                    // Check available stock
                    PreparedStatement stockPs = conn.prepareStatement(
                        "SELECT qty_on_hand, item_name FROM inventory_item WHERE item_id = ?");
                    stockPs.setInt(1, itemId);
                    ResultSet stockRs = stockPs.executeQuery();
                    if (stockRs.next()) {
                        int available = stockRs.getInt("qty_on_hand");
                        String itemName = stockRs.getString("item_name");
                        stockRs.close(); stockPs.close();

                        if (available < qtyUsed) {
                            inventoryMsg = "Warning: Only " + available + " unit(s) of " + itemName +
                                           " in stock but " + qtyUsed + " requested. Inventory not updated.";
                        } else {
                            // Log usage
                            PreparedStatement logPs = conn.prepareStatement(
                                "INSERT INTO inventory_usage_log (item_id, procedure_id, qty_used, staff_id) " +
                                "VALUES (?, ?, ?, ?)");
                            logPs.setInt(1, itemId);
                            if (procedureId != -1) logPs.setInt(2, procedureId);
                            else logPs.setNull(2, Types.INTEGER);
                            logPs.setInt(3, qtyUsed);
                            logPs.setInt(4, staffId);
                            logPs.executeUpdate();
                            logPs.close();

                            // Decrement stock
                            PreparedStatement decrPs = conn.prepareStatement(
                                "UPDATE inventory_item SET qty_on_hand = qty_on_hand - ? WHERE item_id = ?");
                            decrPs.setInt(1, qtyUsed);
                            decrPs.setInt(2, itemId);
                            decrPs.executeUpdate();
                            decrPs.close();

                            inventoryMsg = "ok:" + qtyUsed + " unit(s) of " + itemName + " deducted from inventory.";
                        }
                    } else {
                        stockRs.close(); stockPs.close();
                    }
                }
            } catch (NumberFormatException e) {
                inventoryMsg = "Warning: Invalid item ID or quantity — inventory not updated.";
            }
        }

        success = true;

    } catch (SQLIntegrityConstraintViolationException e) {
        errorMsg = "Invalid Visit ID — no matching visit record exists.";
    } catch (NumberFormatException e) {
        errorMsg = "Visit ID and Charge Amount must be valid numbers.";
    } catch (Exception e) {
        errorMsg = e.getMessage();
        if (errorMsg == null || errorMsg.trim().isEmpty()) errorMsg = "An unexpected error occurred.";
    } finally {
        try { if (ps   != null) ps.close();   } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }

    boolean invOk  = inventoryMsg != null && inventoryMsg.startsWith("ok:");
    boolean invWarn = inventoryMsg != null && !invOk;
    String invDisplay = invOk ? inventoryMsg.substring(3) : inventoryMsg;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Procedure Result — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <a href="view_procedures.jsp">Procedures</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell" style="display:flex;align-items:center;justify-content:center;min-height:calc(100vh - var(--topbar-h));">
<div class="card-sm" style="width:100%;">
<div class="card" style="text-align:center;">

    <% if (success) { %>
        <div class="result-icon success">&#10003;</div>
        <h1 class="page-title">Procedure Saved</h1>
        <p class="page-subtitle">The procedure has been added to the visit record.</p>
        <% if (invOk) { %>
            <div class="alert alert-success" style="text-align:left;"><%= invDisplay %></div>
        <% } else if (invWarn) { %>
            <div class="alert alert-error" style="text-align:left;"><%= invDisplay %></div>
        <% } %>
        <div class="btn-row" style="justify-content:center;margin-top:20px;">
            <a href="add_procedure.jsp?appointment_id=<%= apptIdStr %>" class="btn btn-primary">Add Another Procedure</a>
            <a href="view_procedures.jsp?appointment_id=<%= apptIdStr %>" class="btn btn-secondary">View Procedures</a>
            <a href="hospital_dashboard.jsp" class="btn btn-secondary">Dashboard</a>
        </div>
    <% } else { %>
        <div class="result-icon error">!</div>
        <h1 class="page-title">Something Went Wrong</h1>
        <div class="alert alert-error" style="text-align:left;"><%= errorMsg %></div>
        <div class="btn-row" style="justify-content:center;">
            <a href="add_procedure.jsp" class="btn btn-primary">Try Again</a>
            <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    <% } %>

</div>
</div>
</div>

</body>
</html>
