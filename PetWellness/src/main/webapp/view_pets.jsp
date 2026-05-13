<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
    String msg = request.getParameter("msg");
    String err = request.getParameter("error");
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
        <a href="search_clinic.jsp">Clinics</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-md">
<div class="card">

    <h1 class="page-title">My Pets</h1>
    <p class="page-subtitle">All pets registered under your account.</p>
    <hr class="divider">

    <% if ("updated".equals(msg)) { %>
        <div class="alert alert-success">Pet updated successfully.</div>
    <% } else if ("deleted".equals(msg)) { %>
        <div class="alert alert-success">Pet removed from your account.</div>
    <% } else if ("added".equals(msg)) { %>
        <div class="alert alert-success">Pet added successfully.</div>
    <% } else if ("fk".equals(err)) { %>
        <div class="alert alert-error">This pet has visit history and cannot be deleted.</div>
    <% } else if ("auth".equals(err)) { %>
        <div class="alert alert-error">You do not have permission to modify that pet.</div>
    <% } %>

    <%
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        boolean hasPets = false;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(
                "SELECT pet_id, pet_name, species FROM pet WHERE owner_id = ? ORDER BY pet_name");
            stmt.setInt(1, ownerId);
            rs = stmt.executeQuery();
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
                <td><%= rs.getString("species") != null ? rs.getString("species") : "—" %></td>
                <td>
                    <a href="view_visits.jsp?pet_id=<%= petId %>" class="btn btn-secondary btn-sm">History</a>
                    <a href="edit_pet.jsp?pet_id=<%= petId %>" class="btn btn-secondary btn-sm">Edit</a>
                    <form method="post" action="delete_pet_process.jsp" style="display:inline;"
                          onsubmit="return confirm('Remove <%= rs.getString("pet_name").replace("'","&#39;") %> from your account?');">
                        <input type="hidden" name="pet_id" value="<%= petId %>">
                        <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                    </form>
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
        } catch (Exception e) {
            out.println("<tr><td colspan=\"3\"><div class=\"alert alert-error\">Error loading pets: " + e.getMessage() + "</div></td></tr>");
        } finally {
            try { if (rs   != null) rs.close();   } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
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
