<%@ page import="java.util.List" %>
<%@ page import="com.petwellness.service.ViewVisitService" %>
<%@ page import="com.petwellness.service.ViewVisitService.VisitRecord" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String petIdStr = request.getParameter("pet_id");
    List<VisitRecord> visits = null;
    Integer petId = null;

    if (petIdStr != null && !petIdStr.trim().isEmpty()) {
        try {
            petId = Integer.parseInt(petIdStr);
            visits = ViewVisitService.getVisitsByPetId(petId);
        } catch (Exception e) {
            petId = null;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Patient History</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h2>View Patient History</h2>

        <form method="get" action="view_visits.jsp">
            <label for="pet_id">Enter Pet ID</label>
            <input type="number" name="pet_id" id="pet_id" required>
            <button type="submit" class="btn">Search</button>
        </form>

        <br>

        <%
            if (petIdStr != null) {
                if (petId == null) {
        %>
                    <p class="error">Invalid Pet ID.</p>
        <%
                } else if (visits == null || visits.isEmpty()) {
        %>
                    <p>No visit history found for pet ID <%= petId %>.</p>
        <%
                } else {
        %>
                    <h3>Visit History for Pet ID <%= petId %></h3>
                    <table border="1" cellpadding="10" cellspacing="0" style="margin: 0 auto; background: white;">
                        <tr>
                            <th>Visit ID</th>
                            <th>Pet ID</th>
                            <th>Vet ID</th>
                            <th>Visit Date</th>
                            <th>Notes</th>
                        </tr>
                        <%
                            for (VisitRecord visit : visits) {
                        %>
                        <tr>
                            <td><%= visit.getVisitId() %></td>
                            <td><%= visit.getPetId() %></td>
                            <td><%= visit.getVetId() %></td>
                            <td><%= visit.getVisitDate() %></td>
                            <td><%= visit.getNotes() %></td>
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
        <p><a class="btn" href="hospital_dashboard.jsp">Back to Dashboard</a></p>
    </div>
</body>
</html>