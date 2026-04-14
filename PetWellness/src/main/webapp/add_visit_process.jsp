<%@ page import="com.petwellness.service.VisitService" %>
<%
    String petIdStr = request.getParameter("pet_id");
    String vetIdStr = request.getParameter("vet_id");
    String visitDate = request.getParameter("visit_date");
    String notes = request.getParameter("notes");

    try {
        int petId = Integer.parseInt(petIdStr);
        int vetId = Integer.parseInt(vetIdStr);

        // HTML datetime-local gives: 2026-04-13T14:30
        // MySQL DATETIME usually wants: 2026-04-13 14:30:00
        String formattedVisitDate = visitDate.replace("T", " ") + ":00";

        VisitService.addVisit(petId, vetId, formattedVisitDate, notes);

        response.sendRedirect("dashboard.jsp");
    } catch (Exception e) {
        out.println("<h3>Error adding visit record.</h3>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>