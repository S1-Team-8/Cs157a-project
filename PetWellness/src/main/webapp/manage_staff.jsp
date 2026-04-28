<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Staff</title>

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #eef2f7;
            color: #1f2d3d;
        }

        .page-wrapper {
            min-height: 100vh;
            padding: 40px 20px;
        }

        .page-card {
            max-width: 1200px;
            margin: 0 auto;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 12px 35px rgba(0,0,0,0.08);
            padding: 40px;
        }

        .page-title {
            text-align: center;
            font-size: 42px;
            color: #2f5597;
            margin-bottom: 20px;
        }

        .top-actions {
            text-align: center;
            margin-bottom: 25px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #f3f6fb;
            color: #2f5597;
            padding: 14px;
            font-size: 18px;
        }

        td {
            padding: 14px;
            text-align: center;
            border-top: 1px solid #e3e8ef;
        }

        .status-active {
            background: #e7f7ee;
            color: #1f8f4d;
            padding: 6px 12px;
            border-radius: 20px;
        }

        .status-inactive {
            background: #fdecec;
            color: #c0392b;
            padding: 6px 12px;
            border-radius: 20px;
        }

        .form-control {
            padding: 8px;
            border-radius: 8px;
            border: 1px solid #ccc;
        }

        .btn {
            padding: 10px 18px;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            cursor: pointer;
        }

        .btn-primary {
            background: #2f5597;
            color: white;
        }

        .btn-danger {
            background: #c94b4b;
            color: white;
        }

        .btn-secondary {
            background: #dfe7f2;
            color: #2f5597;
        }

        .bottom-actions {
            text-align: center;
            margin-top: 25px;
        }
    </style>
</head>

<body>
<div class="page-wrapper">
    <div class="page-card">

        <h1 class="page-title">Manage Staff Accounts</h1>

        <div class="top-actions">
            <a class="btn btn-primary" href="add_staff.jsp">Add Staff Account</a>
        </div>

        <table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Role</th>
                <th>Username</th>
                <th>Status</th>
                <th>Update Role</th>
                <th>Deactivate</th>
            </tr>

            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    conn = DBConnection.getConnection();

                    String sql = "SELECT employee_id, full_name, role, username, is_active FROM staff ORDER BY employee_id";
                    ps = conn.prepareStatement(sql);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        int id = rs.getInt("employee_id");
                        String name = rs.getString("full_name");
                        String role = rs.getString("role");
                        String username = rs.getString("username");
                        boolean active = rs.getBoolean("is_active");
            %>

            <tr>
                <td><%= id %></td>
                <td><%= name %></td>
                <td><%= role %></td>
                <td><%= username %></td>

                <td>
                    <% if (active) { %>
                        <span class="status-active">Active</span>
                    <% } else { %>
                        <span class="status-inactive">Inactive</span>
                    <% } %>
                </td>

                <!-- UPDATE ROLE -->
                <td>
                    <form action="update_staff_role_process.jsp" method="post">
                        <input type="hidden" name="employee_id" value="<%= id %>">

                        <select name="role" class="form-control">
                            <option value="Admin" <%= "Admin".equals(role) ? "selected" : "" %>>Admin</option>
                            <option value="Manager" <%= "Manager".equals(role) ? "selected" : "" %>>Manager</option>
                            <option value="Veterinarian" <%= "Veterinarian".equals(role) ? "selected" : "" %>>Veterinarian</option>
                            <option value="Technician" <%= "Technician".equals(role) ? "selected" : "" %>>Technician</option>
                            <option value="Inventory Staff" <%= "Inventory Staff".equals(role) ? "selected" : "" %>>Inventory Staff</option>
                        </select>

                        <br><br>
                        <button type="submit" class="btn btn-primary">Update</button>
                    </form>
                </td>

                <!-- DEACTIVATE -->
                <td>
                    <% if (active) { %>
                        <form action="deactivate_staff_process.jsp" method="post">
                            <input type="hidden" name="employee_id" value="<%= id %>">
                            <button type="submit" class="btn btn-danger">Deactivate</button>
                        </form>
                    <% } else { %>
                        Inactive
                    <% } %>
                </td>
            </tr>

            <%
                    }

                } catch (Exception e) {
                    out.println("<tr><td colspan='7'>Error loading staff</td></tr>");
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (ps != null) ps.close(); } catch (Exception e) {}
                    try { if (conn != null) conn.close(); } catch (Exception e) {}
                }
            %>

        </table>

        <div class="bottom-actions">
            <br>
            <a class="btn btn-secondary" href="hospital_dashboard.jsp">Back to Dashboard</a>
        </div>

    </div>
</div>
</body>
</html>