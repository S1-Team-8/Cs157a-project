<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
    String petIdStr = request.getParameter("pet_id");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Pet History</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
    <h2>View Pet History</h2>

    <!-- Pet selection -->
    <form method="get" action="view_visits.jsp">
        <label>Select Your Pet</label>
        <select name="pet_id" required>
            <option value="">-- Select a Pet --</option>

            <%
                try {
                    Connection conn = DBConnection.getConnection();

                    String sql = "SELECT pet_id, pet_name FROM pet WHERE owner_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, ownerId);

                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {
                        int id = rs.getInt("pet_id");
                        String name = rs.getString("pet_name");
            %>
                        <option value="<%= id %>"
                            <%= (petIdStr != null && petIdStr.equals(String.valueOf(id))) ? "selected" : "" %>>
                            <%= name %>
                        </option>
            <%
                    }

                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p>Error loading pets.</p>");
                }
            %>
        </select>

        <br><br>
        <button type="submit" class="btn">Search</button>
    </form>

    <br>

    <!-- Visit history -->
    <%
        if (petIdStr != null && !petIdStr.trim().isEmpty()) {

            String selectedPetName = null;

            try {
                int petId = Integer.parseInt(petIdStr);

                Connection conn = DBConnection.getConnection();

                // Get pet name
                String nameSql = "SELECT pet_name FROM pet WHERE pet_id = ? AND owner_id = ?";
                PreparedStatement nameStmt = conn.prepareStatement(nameSql);
                nameStmt.setInt(1, petId);
                nameStmt.setInt(2, ownerId);

                ResultSet nameRs = nameStmt.executeQuery();
                if (nameRs.next()) {
                    selectedPetName = nameRs.getString("pet_name");
                }

                nameRs.close();
                nameStmt.close();

                if (selectedPetName != null) {

                    // Get visit history
                    String visitSql = "SELECT visit_id, vet_id, visit_date, notes FROM visit WHERE pet_id = ?";
                    PreparedStatement visitStmt = conn.prepareStatement(visitSql);
                    visitStmt.setInt(1, petId);

                    ResultSet visitRs = visitStmt.executeQuery();

                    boolean hasVisits = false;
    %>

    <h3>Visit History for <%= selectedPetName %></h3>

    <table border="1" cellpadding="10" cellspacing="0" style="margin: auto; background: white;">
        <tr>
            <th>Visit ID</th>
            <th>Vet ID</th>
            <th>Visit Date</th>
            <th>Notes</th>
        </tr>

    <%
                    while (visitRs.next()) {
                        hasVisits = true;
    %>
        <tr>
            <td><%= visitRs.getInt("visit_id") %></td>
            <td><%= visitRs.getInt("vet_id") %></td>
            <td><%= visitRs.getString("visit_date") %></td>
            <td><%= visitRs.getString("notes") %></td>
        </tr>
    <%
                    }

                    if (!hasVisits) {
    %>
        <tr>
            <td colspan="4">There is no history available for <%= selectedPetName %>.</td>
        </tr>
    <%
                    }

                    visitRs.close();
                    visitStmt.close();

                } else {
    %>
        <p>Invalid pet selection.</p>
    <%
                }

                conn.close();

            } catch (Exception e) {
                if (selectedPetName != null) {
    %>
        <p>There is no history available for <%= selectedPetName %>.</p>
    <%
                } else {
    %>
        <p>Unable to retrieve pet history.</p>
    <%
                }
            }
        }
    %>

    <br>
    <a class="btn" href="dashboard.jsp">Back to Dashboard</a>

</div>
</body>
</html>