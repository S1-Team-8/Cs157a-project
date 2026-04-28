<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String visitIdStr = request.getParameter("visit_id");
    String procedureName = request.getParameter("procedure_name");
    String chargeAmountStr = request.getParameter("charge_amount");
    String notes = request.getParameter("notes");

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        if (visitIdStr == null || visitIdStr.trim().isEmpty() ||
            procedureName == null || procedureName.trim().isEmpty() ||
            chargeAmountStr == null || chargeAmountStr.trim().isEmpty()) {
            out.println("<h3>Error: Missing required fields.</h3>");
            return;
        }

        int visitId = Integer.parseInt(visitIdStr);
        double chargeAmount = Double.parseDouble(chargeAmountStr);

        conn = DBConnection.getConnection();

        String sql = "INSERT INTO Procedure (visit_id, procedure_name, charge_amount, notes) VALUES (?, ?, ?, ?)";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, visitId);
        ps.setString(2, procedureName.trim());
        ps.setDouble(3, chargeAmount);
        ps.setString(4, notes);

        int rows = ps.executeUpdate();

        if (rows > 0) {
            response.sendRedirect("dashboard.jsp");
        } else {
            out.println("<h3>Error adding procedure.</h3>");
        }

    } catch (Exception e) {
        out.println("<h3>Error adding procedure.</h3>");
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        try {
            if (ps != null) ps.close();
        } catch (Exception e) {}

        try {
            if (conn != null) conn.close();
        } catch (Exception e) {}
    }
%>