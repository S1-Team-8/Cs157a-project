<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());

    String selectedClinicId = request.getParameter("clinic_id");

    String petIdStr = request.getParameter("pet_id");
    String clinicIdStr = request.getParameter("clinic_id");
    String serviceIdStr = request.getParameter("service_id");
    String appointmentDate = request.getParameter("appointment_date");
    String notes = request.getParameter("notes");

    String successMessage = null;
    String errorMessage = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if (petIdStr != null && clinicIdStr != null && appointmentDate != null
                && !petIdStr.trim().isEmpty()
                && !clinicIdStr.trim().isEmpty()
                && !appointmentDate.trim().isEmpty()) {

            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                conn = DBConnection.getConnection();

                int petId = Integer.parseInt(petIdStr);
                int clinicId = Integer.parseInt(clinicIdStr);

                Integer serviceId = null;
                if (serviceIdStr != null && !serviceIdStr.trim().isEmpty()) {
                    serviceId = Integer.parseInt(serviceIdStr);
                }

                stmt = conn.prepareStatement(
                    "INSERT INTO appointment (pet_id, vet_id, appointment_date, status, service_id) " +
                    "VALUES (?, ?, ?, 'Pending', ?)"
                );

                stmt.setInt(1, petId);
                stmt.setInt(2, clinicId);
                stmt.setString(3, appointmentDate.replace("T", " "));

                if (serviceId != null) {
                    stmt.setInt(4, serviceId);
                } else {
                    stmt.setNull(4, java.sql.Types.INTEGER);
                }

                stmt.executeUpdate();

                successMessage = "Appointment request submitted successfully.";

            } catch (Exception e) {
                errorMessage = "Unable to submit request: " + e.getMessage();
            } finally {
                try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        } else {
            errorMessage = "Please select a pet, clinic, and preferred date.";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Request Appointment — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="view_pets.jsp">My Pets</a>
        <a href="view_my_appointments.jsp" class="nav-active">Appointments</a>
        <a href="search_clinic.jsp">Clinics</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-sm" style="width:100%;">
<div class="card">

    <h1 class="page-title">Request an Appointment</h1>
    <p class="page-subtitle">Submit a request — the clinic will review and confirm your time.</p>
    <hr class="divider">

    <% if (successMessage != null) { %>
        <div class="alert alert-success"><%= successMessage %></div>
    <% } %>

    <% if (errorMessage != null) { %>
        <div class="alert alert-error"><%= errorMessage %></div>
    <% } %>

    <form method="post" action="schedule_appointment.jsp">

        <div class="form-group">
            <label for="pet_id">Your Pet *</label>
            <select name="pet_id" id="pet_id" class="form-control" required>
                <option value="">-- Select a Pet --</option>

                <%
                    Connection petConn = null;
                    PreparedStatement petStmt = null;
                    ResultSet petRs = null;

                    try {
                        petConn = DBConnection.getConnection();
                        petStmt = petConn.prepareStatement(
                            "SELECT pet_id, pet_name, species FROM pet WHERE owner_id = ?"
                        );
                        petStmt.setInt(1, ownerId);
                        petRs = petStmt.executeQuery();

                        while (petRs.next()) {
                            String species = petRs.getString("species");
                %>
                    <option value="<%= petRs.getInt("pet_id") %>">
                        <%= petRs.getString("pet_name") %><%= species != null ? " (" + species + ")" : "" %>
                    </option>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<option disabled>Error loading pets</option>");
                    } finally {
                        try { if (petRs != null) petRs.close(); } catch (Exception e) {}
                        try { if (petStmt != null) petStmt.close(); } catch (Exception e) {}
                        try { if (petConn != null) petConn.close(); } catch (Exception e) {}
                    }
                %>
            </select>
        </div>

        <div class="form-group">
            <label for="clinic_id">Clinic *</label>
            <select name="clinic_id" id="clinic_id" class="form-control" required>
                <option value="">-- Select a Clinic --</option>

                <%
                    Connection clinicConn = null;
                    PreparedStatement clinicStmt = null;
                    ResultSet clinicRs = null;

                    try {
                        clinicConn = DBConnection.getConnection();
                        clinicStmt = clinicConn.prepareStatement(
                            "SELECT clinic_id, clinic_name FROM clinic ORDER BY clinic_name"
                        );
                        clinicRs = clinicStmt.executeQuery();

                        while (clinicRs.next()) {
                            String clinicId = String.valueOf(clinicRs.getInt("clinic_id"));
                %>
                    <option value="<%= clinicId %>" <%= clinicId.equals(selectedClinicId) ? "selected" : "" %>>
                        <%= clinicRs.getString("clinic_name") %>
                    </option>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<option disabled>Error loading clinics</option>");
                    } finally {
                        try { if (clinicRs != null) clinicRs.close(); } catch (Exception e) {}
                        try { if (clinicStmt != null) clinicStmt.close(); } catch (Exception e) {}
                        try { if (clinicConn != null) clinicConn.close(); } catch (Exception e) {}
                    }
                %>
            </select>
        </div>

        <div class="form-group">
            <label for="service_id">Service</label>
            <select name="service_id" id="service_id" class="form-control">
                <option value="">-- No Specific Service --</option>

                <%
                    Connection serviceConn = null;
                    PreparedStatement serviceStmt = null;
                    ResultSet serviceRs = null;

                    try {
                        serviceConn = DBConnection.getConnection();
                        serviceStmt = serviceConn.prepareStatement(
                            "SELECT service_id, service_name, category FROM service_catalog ORDER BY service_name"
                        );
                        serviceRs = serviceStmt.executeQuery();

                        while (serviceRs.next()) {
                            String category = serviceRs.getString("category");
                %>
                    <option value="<%= serviceRs.getInt("service_id") %>">
                        <%= serviceRs.getString("service_name") %>
                        <%= category != null && !category.trim().isEmpty() ? " (" + category + ")" : "" %>
                    </option>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<option disabled>Error loading services</option>");
                    } finally {
                        try { if (serviceRs != null) serviceRs.close(); } catch (Exception e) {}
                        try { if (serviceStmt != null) serviceStmt.close(); } catch (Exception e) {}
                        try { if (serviceConn != null) serviceConn.close(); } catch (Exception e) {}
                    }
                %>
            </select>
        </div>

        <div class="form-group">
            <label for="appointment_date">Preferred Date &amp; Time *</label>
            <input type="datetime-local" name="appointment_date" id="appointment_date"
                   class="form-control" required>
        </div>

        <div class="form-group">
            <label for="notes">Notes</label>
            <textarea name="notes" id="notes" class="form-control"
                      placeholder="Describe your concern or reason for the visit..."></textarea>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Submit Request</button>
            <a href="view_my_appointments.jsp" class="btn btn-secondary">My Appointments</a>
            <a href="search_clinic.jsp" class="btn btn-secondary">Back to Clinics</a>
        </div>

    </form>

</div>
</div>
</div>

</body>
</html>