<%@ page import="java.util.List" %>
<%@ page import="com.petwellness.service.StaffService" %>
<%@ page import="com.petwellness.service.StaffService.StaffRecord" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<StaffRecord> staffList = StaffService.getAllStaff();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Staff</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h2>Manage Staff Accounts</h2>

        <p><a class="btn" href="add_staff.jsp">Add Staff Account</a></p>

        <table border="1" cellpadding="10" cellspacing="0" style="margin: 0 auto; background: white;">
            <tr>
                <th>Employee ID</th>
                <th>Full Name</th>
                <th>Role</th>
                <th>Username</th>
                <th>Status</th>
                <th>Update Role</th>
                <th>Deactivate</th>
            </tr>

            <%
                for (StaffRecord staff : staffList) {
            %>
            <tr>
                <td><%= staff.getEmployeeId() %></td>
                <td><%= staff.getFullName() %></td>
                <td><%= staff.getRole() %></td>
                <td><%= staff.getUsername() %></td>
                <td><%= staff.isActive() ? "Active" : "Inactive" %></td>

                <td>
                    <form action="update_staff_role_process.jsp" method="post">
                        <input type="hidden" name="employee_id" value="<%= staff.getEmployeeId() %>">
                        <select name="role">
                            <option value="Admin">Admin</option>
                            <option value="Manager">Manager</option>
                            <option value="Veterinarian">Veterinarian</option>
                            <option value="Technician">Technician</option>
                            <option value="Inventory Staff">Inventory Staff</option>
                        </select>
                        <button type="submit" class="btn">Update</button>
                    </form>
                </td>

                <td>
                    <form action="deactivate_staff_process.jsp" method="post">
                        <input type="hidden" name="employee_id" value="<%= staff.getEmployeeId() %>">
                        <button type="submit" class="btn">Deactivate</button>
                    </form>
                </td>
            </tr>
            <%
                }
            %>
        </table>

        <br>
        <p><a class="btn" href="hospital_dashboard.jsp">Back to Dashboard</a></p>
    </div>
</body>
</html>