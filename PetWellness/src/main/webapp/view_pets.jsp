<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Pets — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="view_pets.jsp" class="nav-active">My Pets</a>
        <a href="view_my_appointments.jsp">Appointments</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-md">
<div class="card">

    <h1 class="page-title">My Pets</h1>
    <p class="page-subtitle">All pets registered under your account.</p>
    <hr class="divider">

    <%
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT pet_id, pet_name, species FROM pet WHERE owner_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, ownerId);
            ResultSet rs = stmt.executeQuery();

            boolean hasPets = false;
    %>

    <table class="data-table">
        <thead>
            <tr>
                <th>Pet Name</th>
                <th>Species</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            while (rs.next()) {
                hasPets = true;
                int petId = rs.getInt("pet_id");
        %>
            <tr>
                <td><strong><%= rs.getString("pet_name") %></strong></td>
                <td><%= rs.getString("species") %></td>
                <td>
                    <a href="view_visits.jsp?pet_id=<%= petId %>" class="btn btn-secondary btn-sm">View History</a>
                </td>
            </tr>
        <%
            }

            if (!hasPets) {
        %>
            <tr class="no-data">
                <td colspan="3">
                    <div class="empty-state-icon">🐾</div>
                    No pets found. Add your first pet!
                </td>
            </tr>
        <%
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<div class=\"alert alert-error\">Error loading pets: " + e.getMessage() + "</div>");
        }
    %>
        </tbody>
    </table>

    <div class="btn-row mt-24">
        <a href="add_pet.jsp" class="btn btn-primary">+ Add a Pet</a>
        <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
