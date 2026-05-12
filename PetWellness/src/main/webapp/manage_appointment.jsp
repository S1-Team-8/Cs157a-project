<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Appointments — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <a href="view_appointments.jsp" class="nav-active">Appointments</a>
        <a href="manage_inventory.jsp">Inventory</a>
        <a href="reports.jsp">Reports</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-md">
<div class="card">

    <h1 class="page-title">Manage Appointments</h1>
    <hr class="divider">

    <!-- CREATE -->
    <p class="section-heading">Create New Appointment</p>

    <form action="manage_appointment_process.jsp" method="post">
        <input type="hidden" name="action_type" value="create">

        <div class="form-group">
            <label for="pet_id">Patient (Pet)</label>
            <select name="pet_id" id="pet_id" class="form-control" required>
                <option value="">Select patient</option>
                <%
                    Connection conn1 = null; PreparedStatement ps1 = null; ResultSet rs1 = null;
                    try {
                        conn1 = DBConnection.getConnection();
                        ps1 = conn1.prepareStatement(
                            "SELECT p.pet_id, p.pet_name, p.species, o.full_name " +
                            "FROM pet p JOIN pet_owner o ON p.owner_id = o.owner_id ORDER BY o.full_name, p.pet_name");
                        rs1 = ps1.executeQuery();
                        while (rs1.next()) { %>
                    <option value="<%= rs1.getInt("pet_id") %>">
                        <%= rs1.getString("pet_name") %> (<%= rs1.getString("species") %>) — <%= rs1.getString("full_name") %>
                    </option>
                <%      }
                    } catch (Exception e) { out.println("<option disabled>Error loading pets</option>"); }
                    finally {
                        try { if (rs1  != null) rs1.close();  } catch (Exception e) {}
                        try { if (ps1  != null) ps1.close();  } catch (Exception e) {}
                        try { if (conn1!= null) conn1.close();} catch (Exception e) {}
                    }
                %>
            </select>
        </div>

        <div class="form-group">
            <label for="vet_id">Veterinarian</label>
            <select name="vet_id" id="vet_id" class="form-control" required>
                <option value="">Select vet</option>
                <%
                    Connection conn2 = null; PreparedStatement ps2 = null; ResultSet rs2 = null;
                    try {
                        conn2 = DBConnection.getConnection();
                        ps2 = conn2.prepareStatement(
                            "SELECT employee_id, full_name, role FROM staff WHERE is_active = TRUE ORDER BY full_name");
                        rs2 = ps2.executeQuery();
                        while (rs2.next()) { %>
                    <option value="<%= rs2.getInt("employee_id") %>">
                        <%= rs2.getString("full_name") %> (<%= rs2.getString("role") %>)
                    </option>
                <%      }
                    } catch (Exception e) { out.println("<option disabled>Error loading staff</option>"); }
                    finally {
                        try { if (rs2  != null) rs2.close();  } catch (Exception e) {}
                        try { if (ps2  != null) ps2.close();  } catch (Exception e) {}
                        try { if (conn2!= null) conn2.close();} catch (Exception e) {}
                    }
                %>
            </select>
        </div>

        <div class="form-group">
            <label for="appointment_date">Date &amp; Time</label>
            <input type="datetime-local" name="appointment_date" id="appointment_date" class="form-control" required>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Create Appointment</button>
        </div>
    </form>

    <hr class="divider">

    <!-- UPDATE STATUS -->
    <p class="section-heading">Update Appointment Status</p>

    <form action="manage_appointment_process.jsp" method="post">
        <input type="hidden" name="action_type" value="update">

        <div class="form-group">
            <label for="appointment_id">Appointment ID</label>
            <input type="number" name="appointment_id" id="appointment_id" class="form-control" min="1" required
                   placeholder="Enter the appointment ID">
        </div>

        <div class="form-group">
            <label for="status">New Status</label>
            <select name="status" id="status" class="form-control" required>
                <option value="Scheduled">Scheduled</option>
                <option value="Completed">Completed</option>
                <option value="Canceled">Canceled</option>
                <option value="No-show">No-show</option>
            </select>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Update Status</button>
        </div>
    </form>

    <div class="btn-row mt-24">
        <a href="view_appointments.jsp" class="btn btn-secondary">View All Appointments</a>
        <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
