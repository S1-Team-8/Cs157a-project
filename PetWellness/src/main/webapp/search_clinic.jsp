<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Clinics</title>
    <link rel="stylesheet" href="style.css">

    <style>
        .search-layout {
            display: grid;
            grid-template-columns: 380px 1fr;
            gap: 24px;
            margin-top: 20px;
        }

        .search-form .form-group {
            grid-template-columns: 1fr;
        }

        .search-form .form-group label {
            padding-top: 0;
        }

        .search-form .form-control {
            width: 100%;
        }

        .clinic-link {
            color: var(--primary);
            font-weight: 700;
            text-decoration: underline;
        }

        .clinic-link:hover {
            color: var(--primary-dark);
        }

        @media (max-width: 900px) {
            .search-layout {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<div class="topbar">
    <div class="brand">
        <a href="dashboard.jsp">🐾 PetWellness</a>
    </div>

    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="view_pets.jsp">My Pets</a>
        <a href="view_my_appointments.jsp">Appointments</a>
    </div>
</div>

<div class="page-shell">
    <div class="card-lg">

        <div class="welcome-banner">
            <h1>Search Clinics</h1>
            <p>Find nearby pet clinics by city, rating, and distance.</p>
        </div>

        <div class="search-layout">

            <div class="dashboard-section">
                <div class="dashboard-section-title">
                    <span class="dashboard-section-icon">🏥</span>
                    Search Clinics
                </div>

                <form method="get" class="search-form">

                    <div class="form-group">
                        <label for="city">City:</label>
                        <input class="form-control" type="text" id="city" name="city"
                               value="<%= request.getParameter("city") == null ? "" : request.getParameter("city") %>">
                    </div>

                    <div class="form-group">
                        <label for="rating">Minimum Rating:</label>
                        <input class="form-control" type="number" step="0.1" id="rating" name="rating"
                               value="<%= request.getParameter("rating") == null ? "" : request.getParameter("rating") %>">
                    </div>

                    <div class="form-group">
                        <label for="radius">Search Radius:</label>
                        <select class="form-control" id="radius" name="radius">
                            <%
                                String selectedRadius = request.getParameter("radius");
                                if (selectedRadius == null) selectedRadius = "";
                            %>
                            <option value="" <%= selectedRadius.equals("") ? "selected" : "" %>>Any</option>
                            <option value="5" <%= selectedRadius.equals("5") ? "selected" : "" %>>5 miles</option>
                            <option value="10" <%= selectedRadius.equals("10") ? "selected" : "" %>>10 miles</option>
                        </select>
                    </div>

                    <div class="btn-row">
                        <input class="btn btn-primary" type="submit" value="Search">
                    </div>

                </form>
            </div>

            <div class="dashboard-section">
                <div class="dashboard-section-title">
                    Results
                </div>

                <table class="data-table">
                    <tr>
                        <th>Clinic Name</th>
                        <th>City</th>
                        <th>Rating</th>
                        <th>Distance</th>
                    </tr>

                    <%
                        String city = request.getParameter("city");
                        String rating = request.getParameter("rating");
                        String radius = request.getParameter("radius");

                        if (city == null) city = "";
                        if (rating == null || rating.trim().equals("")) rating = "0";
                        if (radius == null) radius = "";

                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;

                        try {
                            conn = DBConnection.getConnection();

                            String sql = "SELECT clinic_id, clinic_name, city, rating, distance " +
                                         "FROM clinic " +
                                         "WHERE city LIKE ? AND rating >= ?";

                            if (!radius.trim().equals("")) {
                                sql += " AND distance <= ?";
                            }

                            ps = conn.prepareStatement(sql);
                            ps.setString(1, "%" + city + "%");
                            ps.setDouble(2, Double.parseDouble(rating));

                            if (!radius.trim().equals("")) {
                                ps.setInt(3, Integer.parseInt(radius));
                            }

                            rs = ps.executeQuery();

                            boolean found = false;

                            while (rs.next()) {
                                found = true;
                    %>
                                <tr>
                                    <td>
                                        <a class="clinic-link"
                                           href="schedule_appointment.jsp?clinic_id=<%= rs.getInt("clinic_id") %>">
                                            <%= rs.getString("clinic_name") %>
                                        </a>
                                    </td>
                                    <td><%= rs.getString("city") %></td>
                                    <td><%= rs.getDouble("rating") %></td>
                                    <td><%= rs.getInt("distance") %> miles</td>
                                </tr>
                    <%
                            }

                            if (!found) {
                    %>
                                <tr class="no-data">
                                    <td colspan="4">No clinics found.</td>
                                </tr>
                    <%
                            }

                        } catch (Exception e) {
                    %>
                            <tr class="no-data">
                                <td colspan="4">Error: <%= e.getMessage() %></td>
                            </tr>
                    <%
                        } finally {
                            try { if (rs != null) rs.close(); } catch (Exception e) {}
                            try { if (ps != null) ps.close(); } catch (Exception e) {}
                            try { if (conn != null) conn.close(); } catch (Exception e) {}
                        }
                    %>
                </table>
            </div>

        </div>

    </div>
</div>

</body>
</html>