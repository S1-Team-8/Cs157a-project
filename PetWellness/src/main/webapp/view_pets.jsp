<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View My Pets</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
    <h1>My Pets</h1>

    <%
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT pet_name, species FROM pet WHERE owner_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, ownerId);

            ResultSet rs = stmt.executeQuery();

            boolean hasPets = false;
    %>

    <ul>
    <%
            while (rs.next()) {
                hasPets = true;
    %>
        <li>
            <strong><%= rs.getString("pet_name") %></strong> - <%= rs.getString("species") %>
        </li>
    <%
            }
    %>
    </ul>

    <%
            if (!hasPets) {
    %>
        <p>No pets found.</p>
    <%
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    %>

    <br>
    <a class="btn" href="dashboard.jsp">Back to Dashboard</a>
</div>
</body>
</html>