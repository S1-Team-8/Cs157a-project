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
    if (petIdStr == null || petIdStr.trim().isEmpty()) {
        response.sendRedirect("view_pets.jsp");
        return;
    }

    int petId = 0;
    String petName = null;
    String species = null;
    String loadError = null;

    try {
        petId = Integer.parseInt(petIdStr.trim());
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(
            "SELECT pet_name, species FROM pet WHERE pet_id = ? AND owner_id = ?");
        ps.setInt(1, petId);
        ps.setInt(2, ownerId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            petName = rs.getString("pet_name");
            species = rs.getString("species");
        } else {
            response.sendRedirect("view_pets.jsp?error=auth");
            return;
        }
        rs.close(); ps.close(); conn.close();
    } catch (Exception e) {
        loadError = "Unable to load pet details.";
    }

    String err = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Pet — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="view_pets.jsp" class="nav-active">My Pets</a>
        <a href="view_my_appointments.jsp">Appointments</a>
        <a href="search_clinic.jsp">Clinics</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-sm" style="width:100%;">
<div class="card">

    <h1 class="page-title">Edit Pet</h1>
    <p class="page-subtitle">Update your pet's name or species.</p>
    <hr class="divider">

    <% if (loadError != null) { %>
        <div class="alert alert-error"><%= loadError %></div>
    <% } else { %>

    <% if ("1".equals(err)) { %>
        <div class="alert alert-error">Pet name and species are required.</div>
    <% } else if ("2".equals(err)) { %>
        <div class="alert alert-error">Unable to save changes. Please try again.</div>
    <% } %>

    <form action="edit_pet_process.jsp" method="post">
        <input type="hidden" name="pet_id" value="<%= petId %>">

        <div class="form-group">
            <label for="pet_name">Pet Name *</label>
            <input type="text" name="pet_name" id="pet_name" class="form-control"
                   value="<%= petName != null ? petName : "" %>" required autofocus>
        </div>

        <div class="form-group">
            <label for="species">Species *</label>
            <select name="species" id="species" class="form-control" required>
                <option value="">— Select species —</option>
                <% String[] speciesOptions = {"Dog","Cat","Bird","Rabbit","Reptile","Other"};
                   for (String opt : speciesOptions) { %>
                    <option value="<%= opt %>" <%= opt.equals(species) ? "selected" : "" %>><%= opt %></option>
                <% } %>
            </select>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Save Changes</button>
            <a href="view_pets.jsp" class="btn btn-secondary">Cancel</a>
        </div>
    </form>

    <% } %>

</div>
</div>
</div>

</body>
</html>
