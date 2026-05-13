<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String cityFilter = request.getParameter("city");
    if (cityFilter != null) cityFilter = cityFilter.trim();
    if (cityFilter != null && cityFilter.isEmpty()) cityFilter = null;

    java.util.List<Object[]> clinics = new java.util.ArrayList<>();
    java.util.Map<Integer, java.util.List<String>> clinicServices = new java.util.HashMap<>();
    String loadError = null;

    Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
    try {
        conn = DBConnection.getConnection();

        // Load clinics
        String sql = "SELECT clinic_id, clinic_name, city, address, phone, email, rating " +
                     "FROM clinic ";
        if (cityFilter != null) sql += "WHERE LOWER(city) LIKE ? ";
        sql += "ORDER BY clinic_name";
        ps = conn.prepareStatement(sql);
        if (cityFilter != null) ps.setString(1, "%" + cityFilter.toLowerCase() + "%");
        rs = ps.executeQuery();
        while (rs.next()) {
            clinics.add(new Object[]{
                rs.getInt("clinic_id"),
                rs.getString("clinic_name"),
                rs.getString("city"),
                rs.getString("address"),
                rs.getString("phone"),
                rs.getString("email"),
                rs.getDouble("rating")
            });
        }
        rs.close(); ps.close();

        // Load clinic services with pricing
        ps = conn.prepareStatement(
            "SELECT cs.clinic_id, sc.service_name, sc.category, " +
            "cs.price_min, cs.price_max " +
            "FROM clinic_service cs " +
            "JOIN service_catalog sc ON cs.service_id = sc.service_id " +
            "ORDER BY sc.service_name");
        rs = ps.executeQuery();
        while (rs.next()) {
            int cid = rs.getInt("clinic_id");
            String svcName  = rs.getString("service_name");
            String category = rs.getString("category");
            double priceMin = rs.getDouble("price_min");
            double priceMax = rs.getDouble("price_max");

            StringBuilder entry = new StringBuilder(svcName);
            if (category != null && !category.isEmpty()) entry.append(" (").append(category).append(")");
            if (priceMin > 0 || priceMax > 0) {
                entry.append(" — ");
                if (priceMin > 0 && priceMax > 0 && priceMin != priceMax) {
                    entry.append("$").append(String.format("%.0f", priceMin))
                         .append("–$").append(String.format("%.0f", priceMax));
                } else if (priceMax > 0) {
                    entry.append("$").append(String.format("%.0f", priceMax));
                } else {
                    entry.append("$").append(String.format("%.0f", priceMin));
                }
            }

            clinicServices.computeIfAbsent(cid, k -> new java.util.ArrayList<>()).add(entry.toString());
        }
        rs.close(); ps.close();
    } catch (Exception e) {
        loadError = "Error loading clinics: " + e.getMessage();
    } finally {
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Find a Clinic — PetWellness</title>
    <link rel="stylesheet" href="style.css">
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

    <!-- Search bar -->
    <form method="get" action="search_clinic.jsp">
        <div class="form-row" style="align-items:flex-end;gap:12px;">
            <div class="form-group-inline" style="flex:1;">
                <label for="city">Filter by City</label>
                <input type="text" name="city" id="city" class="form-control"
                       placeholder="e.g., San Jose"
                       value="<%= cityFilter != null ? cityFilter : "" %>">
            </div>
            <div class="form-group-inline">
                <button type="submit" class="btn btn-primary" style="margin-top:2px;">Search</button>
            </div>
            <% if (cityFilter != null) { %>
            <div class="form-group-inline">
                <a href="search_clinic.jsp" class="btn btn-secondary" style="margin-top:2px;">Clear</a>
            </div>
            <% } %>
        </div>
    </form>

    <% if (loadError != null) { %>
        <div class="alert alert-error"><%= loadError %></div>
    <% } else if (clinics.isEmpty()) { %>
        <div class="alert alert-warning">
            No clinics found<%= cityFilter != null ? " in \"" + cityFilter + "\"" : "" %>.
            <% if (cityFilter != null) { %> <a href="search_clinic.jsp" style="text-decoration:underline;">View all clinics</a><% } %>
        </div>
    <% } else { %>

    <% if (cityFilter != null) { %>
        <p class="text-muted" style="margin-bottom:16px;">
            Showing <%= clinics.size() %> clinic<%= clinics.size() == 1 ? "" : "s" %> in "<strong><%= cityFilter %></strong>"
        </p>
    <% } %>

    <!-- Clinic cards -->
    <% for (Object[] c : clinics) {
           int    cId     = (int)    c[0];
           String cName   = (String) c[1];
           String cCity   = (String) c[2];
           String cAddr   = (String) c[3];
           String cPhone  = (String) c[4];
           String cEmail  = (String) c[5];
           double cRating = (double) c[6];
           java.util.List<String> svcList = clinicServices.getOrDefault(cId, new java.util.ArrayList<>());
    %>
    <div style="background:#f3f6fb;border-radius:var(--radius-lg);padding:22px 24px;margin-bottom:18px;border-left:4px solid var(--primary);">
        <div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:8px;">
            <div>
                <h3 style="font-size:18px;font-weight:700;color:var(--primary);margin-bottom:4px;"><%= cName %></h3>
                <% if (cCity != null || cAddr != null) { %>
                    <p class="text-muted" style="font-size:14px;margin-bottom:2px;">
                        <%= cCity != null ? cCity : "" %><%= cCity != null && cAddr != null ? " · " : "" %><%= cAddr != null ? cAddr : "" %>
                    </p>
                <% } %>
                <% if (cPhone != null) { %>
                    <p class="text-muted" style="font-size:13px;margin-bottom:0;">Phone: <%= cPhone %></p>
                <% } %>
                <% if (cEmail != null) { %>
                    <p class="text-muted" style="font-size:13px;margin-bottom:0;">Email: <%= cEmail %></p>
                <% } %>
            </div>
            <% if (cRating > 0) { %>
            <div style="text-align:center;min-width:64px;">
                <div style="font-size:22px;font-weight:700;color:var(--warning);">
                    <%= String.format("%.1f", cRating) %>
                </div>
                <div class="text-muted" style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.5px;">Rating</div>
            </div>
            <% } %>
        </div>

        <% if (!svcList.isEmpty()) { %>
        <div style="margin-top:14px;">
            <p style="font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:0.5px;color:var(--text-muted);margin-bottom:8px;">Services Offered</p>
            <div style="display:flex;flex-wrap:wrap;gap:7px;">
                <% for (String svc : svcList) { %>
                    <span style="background:#ffffff;border:1px solid var(--border);border-radius:20px;
                                 padding:4px 12px;font-size:13px;color:var(--text);">
                        <%= svc %>
                    </span>
                <% } %>
            </div>
        </div>
        <% } else { %>
            <p class="text-muted" style="font-size:13px;margin-top:10px;font-style:italic;">No services listed for this clinic yet.</p>
        <% } %>
    </div>
    <% } %>

    <% } %>

    <div class="btn-row mt-24">
        <a href="schedule_appointment.jsp" class="btn btn-primary">Request an Appointment</a>
        <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

</body>
</html>
