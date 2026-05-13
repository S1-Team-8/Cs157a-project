<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());

    String petIdStr   = request.getParameter("pet_id");
    String clinicIdStr = request.getParameter("clinic_id");
    String visitDate  = request.getParameter("visit_date");
    String notes      = request.getParameter("notes");

    String successMessage = null;
    String errorMessage   = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if (petIdStr != null && clinicIdStr != null && visitDate != null
                && !petIdStr.trim().isEmpty()
                && !clinicIdStr.trim().isEmpty()
                && !visitDate.trim().isEmpty()) {

            Connection conn = null;
            PreparedStatement insertStmt = null;
            PreparedStatement petStmt = null;
            PreparedStatement clinicStmt = null;
            ResultSet petRs = null;
            ResultSet clinicRs = null;

            try {
                conn = DBConnection.getConnection();

                int petId    = Integer.parseInt(petIdStr);
                int clinicId = Integer.parseInt(clinicIdStr);

                String insertSql = "INSERT INTO visit (pet_id, vet_id, visit_date, notes) VALUES (?, ?, ?, ?)";
                insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, petId);
                insertStmt.setInt(2, clinicId);
                insertStmt.setString(3, visitDate.replace("T", " "));
                insertStmt.setString(4, notes);
                insertStmt.executeUpdate();

                String petSql = "SELECT pet_name FROM pet WHERE pet_id = ? AND owner_id = ?";
                petStmt = conn.prepareStatement(petSql);
                petStmt.setInt(1, petId);
                petStmt.setInt(2, ownerId);
                petRs = petStmt.executeQuery();
                String petName = petRs.next() ? petRs.getString("pet_name") : "";

                String clinicSql = "SELECT clinic_name FROM clinic WHERE clinic_id = ?";
                clinicStmt = conn.prepareStatement(clinicSql);
                clinicStmt.setInt(1, clinicId);
                clinicRs = clinicStmt.executeQuery();
                String clinicName = clinicRs.next() ? clinicRs.getString("clinic_name") : "";

                successMessage = "Appointment scheduled for " + petName
                        + " at " + clinicName
                        + " on " + visitDate.replace("T", " ") + ".";

            } catch (Exception e) {
                errorMessage = "Unable to schedule appointment. Please try again.";
            } finally {
                try { if (petRs    != null) petRs.close();    } catch (Exception e) {}
                try { if (clinicRs != null) clinicRs.close(); } catch (Exception e) {}
                try { if (insertStmt != null) insertStmt.close(); } catch (Exception e) {}
                try { if (petStmt   != null) petStmt.close();     } catch (Exception e) {}
                try { if (clinicStmt != null) clinicStmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        } else {
            errorMessage = "Please fill out all required fields.";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Schedule Appointment — PetWellness</title>
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
<div class="card-sm" style="width:100%;">
<div class="card">

    <h1 class="page-title">Schedule Appointment</h1>
    <p class="page-subtitle">Book a visit for one of your pets at a clinic.</p>
    <hr class="divider">

    <% if (successMessage != null) { %>
        <div class="alert alert-success"><%= successMessage %></div>
    <% } %>
    <% if (errorMessage != null) { %>
        <div class="alert alert-error"><%= errorMessage %></div>
    <% } %>

    <form method="post" action="schedule_appointment.jsp">

        <div class="form-group">
            <label for="pet_id">Your Pet</label>
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
                %>
                    <option value="<%= rs.getInt("pet_id") %>"><%= rs.getString("pet_name") %></option>
                <%
                        }
                        rs.close(); stmt.close(); conn.close();
                    } catch (Exception e) {
                        out.println("<option disabled>Error loading pets</option>");
                    }
                %>
            </select>
        </div>

        <div class="form-group">
            <label for="clinic_id">Clinic</label>
            <select name="clinic_id" id="clinic_id" class="form-control" required>
                <option value="">-- Select a Clinic --</option>
                <%
                    try {
                        Connection conn = DBConnection.getConnection();
                        String sql = "SELECT clinic_id, clinic_name, city FROM clinic ORDER BY clinic_name";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        ResultSet rs = stmt.executeQuery();
                        while (rs.next()) {
                %>
                    <option value="<%= rs.getInt("clinic_id") %>">
                        <%= rs.getString("clinic_name") %> — <%= rs.getString("city") %>
                    </option>
                <%
                        }
                        rs.close(); stmt.close(); conn.close();
                    } catch (Exception e) {
                        out.println("<option disabled>Error loading clinics</option>");
                    }
                %>
            </select>
        </div>

        <div class="form-group">
            <label for="visit_date">Date &amp; Time</label>
            <input type="datetime-local" name="visit_date" id="visit_date" class="form-control" required>
        </div>

        <div class="form-group">
            <label for="notes">Notes</label>
            <textarea name="notes" id="notes" class="form-control"></textarea>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Schedule</button>
            <a href="view_my_appointments.jsp" class="btn btn-secondary">View My Appointments</a>
            <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>

    </form>

</div>
</div>
</div>

</body>
</html>
