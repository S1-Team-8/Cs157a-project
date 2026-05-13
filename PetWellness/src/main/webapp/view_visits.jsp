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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visit History — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="view_pets.jsp">My Pets</a>
        <a href="view_my_appointments.jsp">Appointments</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-md">
<div class="card">

    <h1 class="page-title">Visit History</h1>
    <p class="page-subtitle">Select a pet to view their full visit history.</p>
    <hr class="divider">

    <form method="get" action="view_visits.jsp">
        <div class="form-group">
            <label for="pet_id">Select Pet</label>
            <select name="pet_id" id="pet_id" class="form-control" required>
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
                        out.println("<option disabled>Error loading pets</option>");
                    }
                %>
            </select>
        </div>
        <div class="btn-row">
            <button type="submit" class="btn btn-primary">View History</button>
        </div>
    </form>

    <%
        if (petIdStr != null && !petIdStr.trim().isEmpty()) {
            String selectedPetName = null;

            try {
                int petId = Integer.parseInt(petIdStr);
                Connection conn = DBConnection.getConnection();

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
    %>

    <hr class="divider">
    <h2 class="section-heading">History for <%= selectedPetName %></h2>

    <%
                    String visitSql =
                        "SELECT v.visit_id, v.visit_date, v.notes, c.clinic_name " +
                        "FROM visit v " +
                        "LEFT JOIN clinic c ON v.vet_id = c.clinic_id " +
                        "WHERE v.pet_id = ? " +
                        "ORDER BY v.visit_date DESC";
                    PreparedStatement visitStmt = conn.prepareStatement(visitSql);
                    visitStmt.setInt(1, petId);
                    ResultSet visitRs = visitStmt.executeQuery();

                    boolean hasVisits = false;
    %>

    <table class="data-table">
        <thead>
            <tr>
                <th>Visit ID</th>
                <th>Clinic</th>
                <th>Date</th>
                <th>Notes</th>
            </tr>
        </thead>
        <tbody>
    <%
                    while (visitRs.next()) {
                        hasVisits = true;
                        String clinicName = visitRs.getString("clinic_name");
                        String notes = visitRs.getString("notes");
    %>
            <tr>
                <td><%= visitRs.getInt("visit_id") %></td>
                <td><%= clinicName != null ? clinicName : "—" %></td>
                <td><%= visitRs.getString("visit_date") %></td>
                <td><%= notes != null ? notes : "" %></td>
            </tr>
    <%
                    }

                    if (!hasVisits) {
    %>
            <tr class="no-data">
                <td colspan="4">No visit history for <%= selectedPetName %>.</td>
            </tr>
    <%
                    }

                    visitRs.close();
                    visitStmt.close();
    %>
        </tbody>
    </table>

    <%
                } else {
    %>
                    <div class="alert alert-error">Invalid pet selection.</div>
    <%
                }

                conn.close();

            } catch (Exception e) {
    %>
                <div class="alert alert-error">Error loading visit history.</div>
    <%
            }
        }
    %>

    <div class="btn-row mt-24">
        <a href="view_pets.jsp" class="btn btn-secondary">My Pets</a>
        <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
