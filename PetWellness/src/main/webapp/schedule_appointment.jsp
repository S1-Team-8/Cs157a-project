<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page import="com.petwellness.service.ServiceCatalogService" %>
<%@ page import="com.petwellness.service.ServiceCatalogService.ServiceRecord" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());

    String petIdStr     = request.getParameter("pet_id");
    String serviceIdStr = request.getParameter("service_id");
    String requestedDate = request.getParameter("appointment_date");
    String notes        = request.getParameter("notes");

    String successMessage = null;
    String errorMessage   = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if (petIdStr != null && requestedDate != null
                && !petIdStr.trim().isEmpty()
                && !requestedDate.trim().isEmpty()) {

            Connection conn = null; PreparedStatement stmt = null;
            try {
                conn = DBConnection.getConnection();

                int petId = Integer.parseInt(petIdStr);
                Integer serviceId = (serviceIdStr != null && !serviceIdStr.trim().isEmpty())
                                    ? Integer.parseInt(serviceIdStr) : null;

                // Verify the pet belongs to this owner
                PreparedStatement checkStmt = conn.prepareStatement(
                    "SELECT pet_name FROM pet WHERE pet_id = ? AND owner_id = ?");
                checkStmt.setInt(1, petId);
                checkStmt.setInt(2, ownerId);
                ResultSet checkRs = checkStmt.executeQuery();
                String petName = checkRs.next() ? checkRs.getString("pet_name") : null;
                checkRs.close(); checkStmt.close();

                if (petName == null) {
                    errorMessage = "Invalid pet selection.";
                } else {
                    stmt = conn.prepareStatement(
                        "INSERT INTO appointment (pet_id, vet_id, appointment_date, status, service_id) " +
                        "VALUES (?, NULL, ?, 'Pending', ?)");
                    stmt.setInt(1, petId);
                    stmt.setString(2, requestedDate.replace("T", " "));
                    if (serviceId != null) stmt.setInt(3, serviceId);
                    else                   stmt.setNull(3, java.sql.Types.INTEGER);
                    stmt.executeUpdate();

                    successMessage = "Appointment request submitted for " + petName + ". " +
                                     "The clinic will review and confirm your time.";
                }
            } catch (Exception e) {
                errorMessage = "Unable to submit request. Please try again.";
            } finally {
                try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        } else {
            errorMessage = "Please select a pet and provide a preferred date.";
        }
    }

    List<ServiceRecord> serviceList = ServiceCatalogService.getAllServices();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
    <p class="page-subtitle">Submit a request — the clinic will assign a vet and confirm your time.</p>
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
                    Connection _pc = null; PreparedStatement _ps = null; ResultSet _pr = null;
                    try {
                        _pc = DBConnection.getConnection();
                        _ps = _pc.prepareStatement(
                            "SELECT pet_id, pet_name, species FROM pet WHERE owner_id = ?");
                        _ps.setInt(1, ownerId);
                        _pr = _ps.executeQuery();
                        while (_pr.next()) {
                            String species = _pr.getString("species");
                %>
                    <option value="<%= _pr.getInt("pet_id") %>">
                        <%= _pr.getString("pet_name") %><%= species != null ? " (" + species + ")" : "" %>
                    </option>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<option disabled>Error loading pets</option>");
                    } finally {
                        try { if (_pr != null) _pr.close(); } catch (Exception e) {}
                        try { if (_ps != null) _ps.close(); } catch (Exception e) {}
                        try { if (_pc != null) _pc.close(); } catch (Exception e) {}
                    }
                %>
            </select>
        </div>

        <div class="form-group">
            <label for="service_id">Service</label>
            <select name="service_id" id="service_id" class="form-control">
                <option value="">-- No specific service --</option>
                <% for (ServiceRecord svc : serviceList) { %>
                    <option value="<%= svc.getServiceId() %>">
                        <%= svc.getServiceName() %>
                        <% if (!svc.getCategory().isEmpty()) { %> (<%= svc.getCategory() %>)<% } %>
                    </option>
                <% } %>
            </select>
            <% if (serviceList.isEmpty()) { %>
                <p class="form-hint">No services listed yet. You can still request without selecting one.</p>
            <% } %>
        </div>

        <div class="form-group">
            <label for="appointment_date">Preferred Date &amp; Time *</label>
            <input type="datetime-local" name="appointment_date" id="appointment_date"
                   class="form-control" required>
            <p class="form-hint">The clinic may adjust the time when confirming.</p>
        </div>

        <div class="form-group">
            <label for="notes">Notes</label>
            <textarea name="notes" id="notes" class="form-control"
                      placeholder="Describe your concern or reason for the visit..."></textarea>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Submit Request</button>
            <a href="view_my_appointments.jsp" class="btn btn-secondary">My Appointments</a>
            <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>

    </form>

</div>
</div>
</div>

</body>
</html>
