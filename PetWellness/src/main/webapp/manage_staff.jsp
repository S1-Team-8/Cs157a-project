<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    if (!"Admin".equals(session.getAttribute("staff_role"))) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Staff — PetWellness</title>
    <link rel="stylesheet" href="style.css">
    <style>
        /* Compact role select + update button inline */
        .role-form { display: flex; flex-direction: column; gap: 6px; align-items: center; }
        .role-select { padding: 6px 10px; border: 1.5px solid var(--border); border-radius: 8px;
                       font-size: 13px; color: var(--text); background: #fff; cursor: pointer; }
    </style>
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
<div class="card-lg">
<div class="card">

    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:24px;flex-wrap:wrap;gap:12px;">
        <h1 class="page-title" style="margin-bottom:0;">Manage Staff Accounts</h1>
        <a href="add_staff.jsp" class="btn btn-primary">+ Add Staff Account</a>
    </div>

    <table class="data-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Role</th>
                <th>Username</th>
                <th>Status</th>
                <th>Update Role</th>
                <th>Deactivate</th>
            </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
            try {
                conn = DBConnection.getConnection();
                ps = conn.prepareStatement(
                    "SELECT employee_id, full_name, role, username, is_active FROM staff ORDER BY employee_id");
                rs = ps.executeQuery();

                while (rs.next()) {
                    int    id       = rs.getInt("employee_id");
                    String name     = rs.getString("full_name");
                    String role     = rs.getString("role");
                    String username = rs.getString("username");
                    boolean active  = rs.getBoolean("is_active");
        %>
            <tr>
                <td><%= id %></td>
                <td><strong><%= name %></strong></td>
                <td><%= role %></td>
                <td style="color:var(--text-muted);font-size:13px;"><%= username %></td>

                <td>
                    <% if (active) { %>
                        <span class="badge badge-active">Active</span>
                    <% } else { %>
                        <span class="badge badge-inactive">Inactive</span>
                    <% } %>
                </td>

                <!-- Update role -->
                <td>
                    <form action="update_staff_role_process.jsp" method="post" class="role-form">
                        <input type="hidden" name="employee_id" value="<%= id %>">
                        <select name="role" class="role-select">
                            <option value="Admin"           <%= "Admin".equals(role)           ? "selected" : "" %>>Admin</option>
                            <option value="Manager"         <%= "Manager".equals(role)         ? "selected" : "" %>>Manager</option>
                            <option value="Veterinarian"    <%= "Veterinarian".equals(role)    ? "selected" : "" %>>Veterinarian</option>
                            <option value="Technician"      <%= "Technician".equals(role)      ? "selected" : "" %>>Technician</option>
                            <option value="Inventory Staff" <%= "Inventory Staff".equals(role) ? "selected" : "" %>>Inventory Staff</option>
                        </select>
                        <button type="submit" class="btn btn-primary btn-sm">Update</button>
                    </form>
                </td>

                <!-- Deactivate / Reactivate -->
                <td>
                    <% if (active) { %>
                        <form action="deactivate_staff_process.jsp" method="post">
                            <input type="hidden" name="employee_id" value="<%= id %>">
                            <button type="submit" class="btn btn-danger btn-sm">Deactivate</button>
                        </form>
                    <% } else { %>
                        <form action="reactivate_staff_process.jsp" method="post">
                            <input type="hidden" name="employee_id" value="<%= id %>">
                            <button type="submit" class="btn btn-success btn-sm">Reactivate</button>
                        </form>
                    <% } %>
                </td>
            </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr class='no-data'><td colspan='7'>Error loading staff: " + e.getMessage() + "</td></tr>");
            } finally {
                try { if (rs   != null) rs.close();   } catch (Exception e) {}
                try { if (ps   != null) ps.close();   } catch (Exception e) {}
                try { if (conn != null) conn.close();  } catch (Exception e) {}
            }
        %>
        </tbody>
    </table>

    <div class="btn-row mt-24">
        <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
