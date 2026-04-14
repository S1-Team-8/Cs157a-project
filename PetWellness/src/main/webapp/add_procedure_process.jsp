<%@ page import="com.petwellness.service.ProcedureService" %>
<%
    String visitIdStr = request.getParameter("visit_id");
    String procedureName = request.getParameter("procedure_name");
    String chargeAmountStr = request.getParameter("charge_amount");
    String notes = request.getParameter("notes");

    try {
        int visitId = Integer.parseInt(visitIdStr);
        double chargeAmount = Double.parseDouble(chargeAmountStr);

        ProcedureService.addProcedure(visitId, procedureName, chargeAmount, notes);

        response.sendRedirect("dashboard.jsp");
    } catch (Exception e) {
        out.println("<h3>Error adding procedure.</h3>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>