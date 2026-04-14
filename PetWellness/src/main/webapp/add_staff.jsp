<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Staff Account</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container form-box">
        <h2>Add Staff Account</h2>

        <form action="add_staff_process.jsp" method="post">
            <label for="full_name">Full Name</label>
            <input type="text" name="full_name" id="full_name" required>

            <label for="role">Role</label>
            <select name="role" id="role" required>
                <option value="Admin">Admin</option>
                <option value="Manager">Manager</option>
                <option value="Veterinarian">Veterinarian</option>
                <option value="Technician">Technician</option>
                <option value="Inventory Staff">Inventory Staff</option>
            </select>

            <label for="username">Username</label>
            <input type="text" name="username" id="username" required>

            <label for="password">Password</label>
            <input type="password" name="password" id="password" required>

            <button type="submit" class="btn">Create Staff Account</button>
        </form>

        <p><a class="btn" href="manage_staff.jsp">Manage Staff</a></p>
        <p><a class="btn" href="hospital_dashboard.jsp">Back to Dashboard</a></p>
    </div>
</body>
</html>