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
    <title>Create Visit Record — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp" class="nav-active">Dashboard</a>
        <a href="view_appointments.jsp">Appointments</a>
        <a href="manage_inventory.jsp">Inventory</a>
        <a href="reports.jsp">Reports</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-md">
<div class="card">

    <h1 class="page-title">Create Visit Record</h1>
    <p class="page-subtitle">Record a new clinical visit for a patient.</p>
    <hr class="divider">

    <form action="hospital_add_visit_process.jsp" method="post">

        <div class="form-group">
            <label for="pet_id">Patient (Pet)</label>
            <select id="pet_id" name="pet_id" class="form-control" required>
                <option value="">Select patient</option>
                <%
                    Connection conn1 = null; PreparedStatement ps1 = null; ResultSet rs1 = null;
                    try {
                        conn1 = DBConnection.getConnection();
                        ps1 = conn1.prepareStatement(
                            "SELECT p.pet_id, p.pet_name, p.species, o.full_name " +
                            "FROM pet p JOIN pet_owner o ON p.owner_id = o.owner_id " +
                            "ORDER BY o.full_name, p.pet_name");
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
            <select id="vet_id" name="vet_id" class="form-control" required>
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
            <label for="visit_date">Visit Date</label>
            <input type="datetime-local" id="visit_date" name="visit_date" class="form-control" required>
        </div>

        <div class="form-group">
            <label for="notes">Notes</label>
            <textarea id="notes" name="notes" class="form-control" placeholder="Enter visit notes..."></textarea>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Save Visit Record</button>
            <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </form>

</div>
</div>
</div>

</body>
</html>
