<%@ page import="java.util.List" %>
<%@ page import="com.petwellness.service.ViewProcedureService" %>
<%@ page import="com.petwellness.service.ViewProcedureService.ProcedureRecord" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String visitIdStr = request.getParameter("visit_id");
    List<ProcedureRecord> procedures = null;
    Integer visitId = null;

    if (visitIdStr != null && !visitIdStr.trim().isEmpty()) {
        try {
            visitId = Integer.parseInt(visitIdStr);
            procedures = ViewProcedureService.getProceduresByVisitId(visitId);
        } catch (Exception e) {
            visitId = null;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Procedures for a Visit</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h2>View Procedures for a Visit</h2>

        <form method="get" action="view_procedures.jsp">
            <label for="visit_id">Enter Visit ID</label>
            <input type="number" name="visit_id" id="visit_id" required>
            <button type="submit" class="btn">Search</button>
        </form>

        <br>

        <%
            if (visitIdStr != null) {
                if (visitId == null) {
        %>
                    <p class="error">Invalid Visit ID.</p>
        <%
                } else if (procedures == null || procedures.isEmpty()) {
        %>
                    <p>No procedures found for visit ID <%= visitId %>.</p>
        <%
                } else {
        %>
                    <h3>Procedures for Visit ID <%= visitId %></h3>
                    <table border="1" cellpadding="10" cellspacing="0" style="margin: 0 auto; background: white;">
                        <tr>
                            <th>Procedure ID</th>
                            <th>Visit ID</th>
                            <th>Procedure Name</th>
                            <th>Charge Amount</th>
                            <th>Notes</th>
                        </tr>
                        <%
                            for (ProcedureRecord procedure : procedures) {
                        %>
                        <tr>
                            <td><%= procedure.getProcedureId() %></td>
                            <td><%= procedure.getVisitId() %></td>
                            <td><%= procedure.getProcedureName() %></td>
                            <td><%= procedure.getChargeAmount() %></td>
                            <td><%= procedure.getNotes() %></td>
                        </tr>
                        <%
                            }
                        %>
                    </table>
        <%
                }
            }
        %>

        <br>
        <p><a class="btn" href="hospital_dashboard.jsp">Back to Hospital Dashboard</a></p>
    </div>
</body>
</html>