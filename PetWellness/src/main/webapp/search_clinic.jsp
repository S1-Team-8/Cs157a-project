<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Find a Clinic</title>
    <link rel="stylesheet" href="style.css">

    <style>
        .clinic-search-row {
            display: grid;
            grid-template-columns: 1fr 110px;
            gap: 12px;
            margin-bottom: 22px;
        }

        .clinic-card {
            background: #f3f6fb;
            border-left: 5px solid var(--primary);
            border-radius: 14px;
            padding: 20px 24px;
            margin-bottom: 18px;
            display: flex;
            justify-content: space-between;
            gap: 20px;
        }

        .clinic-name {
            color: var(--primary);
            font-size: 18px;
            font-weight: 700;
            text-decoration: none;
        }

        .clinic-name:hover {
            text-decoration: underline;
        }

        .clinic-info {
            margin-top: 8px;
            font-size: 14px;
            color: var(--text);
        }

        .clinic-info p {
            margin: 3px 0;
        }

        .clinic-rating {
            text-align: center;
            min-width: 70px;
        }

        .rating-number {
            font-size: 24px;
            font-weight: 800;
            color: #f59e0b;
        }

        .rating-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        .service-pill {
            display: inline-block;
            margin-top: 10px;
            padding: 6px 12px;
            background: var(--surface);
            color: var(--primary);
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            border: 1px solid var(--border);
        }

        .filter-extra {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin-bottom: 20px;
        }

        @media (max-width: 760px) {
            .clinic-search-row,
            .filter-extra {
                grid-template-columns: 1fr;
            }

            .clinic-card {
                flex-direction: column;
            }

            .clinic-rating {
                text-align: left;
            }
        }
    </style>
</head>

<body>

<nav class="topbar">
    <div class="brand"><a href="dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="view_pets.jsp">My Pets</a>
        <a href="view_my_appointments.jsp">Appointments</a>
        <a href="search_clinic.jsp" class="nav-active">Clinics</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-lg">
<div class="card">

    <h1 class="page-title">Find a Clinic</h1>
    <p class="page-subtitle">Browse available veterinary clinics and the services they offer.</p>
    <hr class="divider">

    <form method="get">
        <div class="clinic-search-row">
            <div>
                <label class="form-group-inline">
                    <span>Filter by City</span>
                    <input class="form-control" type="text" name="city"
                           placeholder="e.g., San Jose"
                           value="<%= request.getParameter("city") == null ? "" : request.getParameter("city") %>">
                </label>
            </div>

            <button class="btn btn-primary" type="submit">Search</button>
        </div>

        <div class="filter-extra">
            <div>
                <label class="form-group-inline">
                    <span>Minimum Rating</span>
                    <input class="form-control" type="number" step="0.1" name="rating"
                           placeholder="e.g., 4.0"
                           value="<%= request.getParameter("rating") == null ? "" : request.getParameter("rating") %>">
                </label>
            </div>

            <div>
                <label class="form-group-inline">
                    <span>Search Radius</span>
                    <select class="form-control" name="radius">
                        <%
                            String selectedRadius = request.getParameter("radius");
                            if (selectedRadius == null) selectedRadius = "";
                        %>
                        <option value="" <%= selectedRadius.equals("") ? "selected" : "" %>>Any</option>
                        <option value="5" <%= selectedRadius.equals("5") ? "selected" : "" %>>5 miles</option>
                        <option value="10" <%= selectedRadius.equals("10") ? "selected" : "" %>>10 miles</option>
                    </select>
                </label>
            </div>
        </div>
    </form>

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

            String sql =
                "SELECT c.clinic_id, c.clinic_name, c.city, c.address, c.phone, c.email, " +
                "c.rating, c.distance, " +
                "GROUP_CONCAT(sc.service_name SEPARATOR ', ') AS services " +
                "FROM clinic c " +
                "LEFT JOIN clinic_service cs ON c.clinic_id = cs.clinic_id " +
                "LEFT JOIN service_catalog sc ON cs.service_id = sc.service_id " +
                "WHERE c.city LIKE ? AND c.rating >= ? ";

            if (!radius.trim().equals("")) {
                sql += "AND c.distance <= ? ";
            }

            sql +=
                "GROUP BY c.clinic_id, c.clinic_name, c.city, c.address, c.phone, c.email, c.rating, c.distance " +
                "ORDER BY c.rating DESC, c.clinic_name ASC";

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

                String services = rs.getString("services");
                if (services == null || services.trim().isEmpty()) {
                    services = "No services listed";
                }
    %>

        <div class="clinic-card">
            <div>
                <a class="clinic-name"
                   href="schedule_appointment.jsp?clinic_id=<%= rs.getInt("clinic_id") %>">
                    <%= rs.getString("clinic_name") %>
                </a>

                <div class="clinic-info">
                    <p><%= rs.getString("city") %> · <%= rs.getString("address") %></p>
                    <p>Phone: <%= rs.getString("phone") %></p>
                    <p>Email: <%= rs.getString("email") %></p>
                    <p>Distance: <%= rs.getInt("distance") %> miles</p>
                </div>

                <div class="service-pill">
                    Services Offered: <%= services %>
                </div>
            </div>

            <div class="clinic-rating">
                <div class="rating-number"><%= rs.getDouble("rating") %></div>
                <div class="rating-label">Rating</div>
            </div>
        </div>

    <%
            }

            if (!found) {
    %>
        <div class="empty-state">
            <div class="empty-state-icon">🔍</div>
            No clinics found.
        </div>
    <%
            }

        } catch (Exception e) {
    %>
        <div class="alert alert-error">
            Error loading clinics: <%= e.getMessage() %>
        </div>
    <%
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    %>

</div>
</div>
</div>

</body>
</html>