<%@ page import="java.util.*,java.sql.*,com.petwellness.model.Clinic,com.petwellness.util.DBConnection" %>

<%
    List<Clinic> clinics = new ArrayList<>();

    String city = request.getParameter("city");
    String ratingParam = request.getParameter("rating");
    String radius = request.getParameter("radius");
    out.println("Selected radius: " + radius + "<br><br>");

    try {
        Connection conn = DBConnection.getConnection();

        String sql = "SELECT * FROM clinic WHERE 1=1";

        if (city != null && !city.trim().isEmpty()) {
            sql += " AND city = ?";
        }

        if (ratingParam != null && !ratingParam.trim().isEmpty()) {
            sql += " AND rating >= ?";
        }

        PreparedStatement stmt = conn.prepareStatement(sql);

        int index = 1;

        if (city != null && !city.trim().isEmpty()) {
            stmt.setString(index++, city.trim());
        }

        if (ratingParam != null && !ratingParam.trim().isEmpty()) {
            stmt.setDouble(index++, Double.parseDouble(ratingParam));
        }

        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Clinic c = new Clinic();
            c.setClinicId(rs.getInt("clinic_id"));
            c.setClinicName(rs.getString("clinic_name"));
            c.setCity(rs.getString("city"));
            c.setRating(rs.getDouble("rating"));
            clinics.add(c);
        }

        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<html>
<body>
<h2>Clinic Search Results</h2>

<% for (Clinic c : clinics) { %>
    <hr>
    Name: <%= c.getClinicName() %> <br>
    City: <%= c.getCity() %> <br>
    Rating: <%= c.getRating() %> <br>
<% } %>

</body>
</html>