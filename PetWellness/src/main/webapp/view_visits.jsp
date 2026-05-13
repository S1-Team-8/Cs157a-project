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

    // Pre-load visit data if a pet is selected
    String selectedPetName = null;
    java.util.List<Object[]> visits = new java.util.ArrayList<>();
    String visitError = null;

    if (petIdStr != null && !petIdStr.trim().isEmpty()) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            int petId = Integer.parseInt(petIdStr.trim());
            conn = DBConnection.getConnection();

            ps = conn.prepareStatement(
                "SELECT pet_name FROM pet WHERE pet_id = ? AND owner_id = ?");
            ps.setInt(1, petId); ps.setInt(2, ownerId);
            rs = ps.executeQuery();
            if (rs.next()) selectedPetName = rs.getString("pet_name");
            rs.close(); ps.close();

            if (selectedPetName != null) {
                ps = conn.prepareStatement(
                    "SELECT v.visit_id, v.visit_date, v.notes, " +
                    "s.full_name AS vet_name, sc.service_name " +
                    "FROM visit v " +
                    "LEFT JOIN staff s ON v.vet_id = s.employee_id " +
                    "LEFT JOIN service_catalog sc ON v.service_id = sc.service_id " +
                    "WHERE v.pet_id = ? ORDER BY v.visit_date DESC");
                ps.setInt(1, petId);
                rs = ps.executeQuery();
                while (rs.next()) {
                    visits.add(new Object[]{
                        rs.getInt("visit_id"),
                        rs.getString("visit_date"),
                        rs.getString("vet_name"),
                        rs.getString("service_name"),
                        rs.getString("notes")
                    });
                }
                rs.close(); ps.close();
            }
        } catch (Exception e) {
            visitError = "Error loading visit history.";
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
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
        <a href="search_clinic.jsp">Clinics</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-md">
<div class="card">

    <h1 class="page-title">Visit History</h1>
    <p class="page-subtitle">Select a pet to view their completed visit history.</p>
    <hr class="divider">

    <form method="get" action="view_visits.jsp">
        <div class="form-group">
            <label for="pet_id">Select Pet</label>
            <select name="pet_id" id="pet_id" class="form-control" required>
                <option value="">— Select a Pet —</option>
                <%
                    Connection _pc = null; PreparedStatement _pp = null; ResultSet _pr = null;
                    try {
                        _pc = DBConnection.getConnection();
                        _pp = _pc.prepareStatement(
                            "SELECT pet_id, pet_name, species FROM pet WHERE owner_id = ? ORDER BY pet_name");
                        _pp.setInt(1, ownerId);
                        _pr = _pp.executeQuery();
                        while (_pr.next()) {
                            int id = _pr.getInt("pet_id");
                            String sp = _pr.getString("species");
                %>
                    <option value="<%= id %>"
                        <%= (petIdStr != null && petIdStr.equals(String.valueOf(id))) ? "selected" : "" %>>
                        <%= _pr.getString("pet_name") %><%= sp != null ? " (" + sp + ")" : "" %>
                    </option>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<option disabled>Error loading pets</option>");
                    } finally {
                        try { if (_pr != null) _pr.close(); } catch (Exception e) {}
                        try { if (_pp != null) _pp.close(); } catch (Exception e) {}
                        try { if (_pc != null) _pc.close(); } catch (Exception e) {}
                    }
                %>
            </select>
        </div>
        <div class="btn-row">
            <button type="submit" class="btn btn-primary">View History</button>
            <a href="view_pets.jsp" class="btn btn-secondary">My Pets</a>
        </div>
    </form>

    <% if (petIdStr != null && !petIdStr.trim().isEmpty()) { %>
        <hr class="divider">

        <% if (visitError != null) { %>
            <div class="alert alert-error"><%= visitError %></div>
        <% } else if (selectedPetName == null) { %>
            <div class="alert alert-error">Pet not found or does not belong to your account.</div>
        <% } else { %>
            <h2 class="section-heading">History for <%= selectedPetName %></h2>

            <table class="data-table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Veterinarian</th>
                        <th>Service</th>
                        <th>Notes</th>
                        <th>Details</th>
                    </tr>
                </thead>
                <tbody>
                <% if (visits.isEmpty()) { %>
                    <tr class="no-data">
                        <td colspan="5">No visit history for <%= selectedPetName %>.</td>
                    </tr>
                <% } else {
                       for (Object[] v : visits) {
                           int visitId     = (int)    v[0];
                           String vDate    = (String) v[1];
                           String vetName  = (String) v[2];
                           String svcName  = (String) v[3];
                           String notes    = (String) v[4];
                %>
                    <tr>
                        <td><%= vDate %></td>
                        <td><%= vetName  != null ? vetName  : "—" %></td>
                        <td><%= svcName  != null ? svcName  : "—" %></td>
                        <td><%= notes    != null && !notes.isEmpty() ? notes : "—" %></td>
                        <td>
                            <a href="view_visit_detail.jsp?visit_id=<%= visitId %>"
                               class="btn btn-secondary btn-sm">View</a>
                        </td>
                    </tr>
                <%     }
                   }
                %>
                </tbody>
            </table>
        <% } %>
    <% } %>

    <div class="btn-row mt-24">
        <a href="view_pets.jsp" class="btn btn-secondary">My Pets</a>
        <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
