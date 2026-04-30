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
    String clinicIdStr = request.getParameter("clinic_id");
    String visitDate = request.getParameter("visit_date");
    String notes = request.getParameter("notes");

    String successMessage = null;
    String errorMessage = null;

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

                int petId = Integer.parseInt(petIdStr);
                int clinicId = Integer.parseInt(clinicIdStr);

                String insertSql = "INSERT INTO visit (pet_id, vet_id, visit_date, notes) VALUES (?, ?, ?, ?)";
                insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, petId);
                insertStmt.setInt(2, clinicId);   // storing clinic_id in vet_id for now
                insertStmt.setString(3, visitDate.replace("T", " "));
                insertStmt.setString(4, notes);

                insertStmt.executeUpdate();

                String petSql = "SELECT pet_name FROM pet WHERE pet_id = ? AND owner_id = ?";
                petStmt = conn.prepareStatement(petSql);
                petStmt.setInt(1, petId);
                petStmt.setInt(2, ownerId);
                petRs = petStmt.executeQuery();

                String petName = "";
                if (petRs.next()) {
                    petName = petRs.getString("pet_name");
                }

                String clinicSql = "SELECT clinic_name FROM clinic WHERE clinic_id = ?";
                clinicStmt = conn.prepareStatement(clinicSql);
                clinicStmt.setInt(1, clinicId);
                clinicRs = clinicStmt.executeQuery();

                String clinicName = "";
                if (clinicRs.next()) {
                    clinicName = clinicRs.getString("clinic_name");
                }

                successMessage = "Appointment scheduled for " + petName
                        + " at " + clinicName
                        + " on " + visitDate.replace("T", " ") + ".";

            } catch (Exception e) {
                errorMessage = "Unable to schedule appointment.";
            } finally {
                if (petRs != null) petRs.close();
                if (clinicRs != null) clinicRs.close();
                if (insertStmt != null) insertStmt.close();
                if (petStmt != null) petStmt.close();
                if (clinicStmt != null) clinicStmt.close();
                if (conn != null) conn.close();
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
    <title>Schedule Appointment</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
    <h2>Schedule Appointment</h2>

    <% if (successMessage != null) { %>
        <p><strong><%= successMessage %></strong></p>
    <% } %>

    <% if (errorMessage != null) { %>
        <p><strong><%= errorMessage %></strong></p>
    <% } %>

    <form method="post" action="schedule_appointment.jsp">
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
            %>
                <option value="<%= rs.getInt("pet_id") %>">
                    <%= rs.getString("pet_name") %>
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

        <label>Select Clinic / Hospital</label>
        <select name="clinic_id" required>
            <option value="">-- Select a Clinic --</option>
            <%
                try {
                    Connection conn = DBConnection.getConnection();
                    String sql = "SELECT clinic_id, clinic_name, city FROM clinic";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {
            %>
                <option value="<%= rs.getInt("clinic_id") %>">
                    <%= rs.getString("clinic_name") %> - <%= rs.getString("city") %>
                </option>
            <%
                    }

                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p>Error loading clinics.</p>");
                }
            %>
        </select>

        <br><br>

        <label>Appointment Date and Time</label>
        <input type="datetime-local" name="visit_date" required>

        <br><br>

        <label>Notes</label>
        <textarea name="notes" rows="4" cols="40"></textarea>

        <br><br>
        <button type="submit" class="btn">Schedule</button>
    </form>

    <br>
    <a class="btn" href="dashboard.jsp">Back to Dashboard</a>
</div>
</body>
</html>