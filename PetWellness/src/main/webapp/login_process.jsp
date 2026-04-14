<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="com.petwellness.util.DBConnection" %>

<%!
    public String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
%>

<%
	out.println("login_id = " + request.getParameter("login_id") + "<br>");
	out.println("password = " + request.getParameter("password") + "<br>");
	
    String loginId = request.getParameter("login_id");
    String password = request.getParameter("password");

    if (loginId == null || password == null ||
        loginId.trim().isEmpty() || password.trim().isEmpty()) {
        response.sendRedirect("login.jsp?error=2");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String enteredHash = hashPassword(password);

        // First: check pet owners by email
        String ownerSql = "SELECT owner_id, full_name, email, password_hash FROM pet_owner WHERE email = ?";
        stmt = conn.prepareStatement(ownerSql);
        stmt.setString(1, loginId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            String storedHash = rs.getString("password_hash");

            if (storedHash.equals(enteredHash)) {
                session.invalidate();
                session = request.getSession(true);

                session.setAttribute("user_type", "owner");
                session.setAttribute("owner_id", rs.getInt("owner_id"));
                session.setAttribute("full_name", rs.getString("full_name"));
                session.setAttribute("email", rs.getString("email"));

                response.sendRedirect("dashboard.jsp");
                return;
            }
        }

        rs.close();
        stmt.close();

        // Second: check staff by username
        String staffSql = "SELECT employee_id, full_name, role, username, password_hash, is_active FROM staff WHERE username = ?";
        stmt = conn.prepareStatement(staffSql);
        stmt.setString(1, loginId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            String storedHash = rs.getString("password_hash");
            boolean isActive = rs.getBoolean("is_active");

            if (isActive && storedHash.equals(enteredHash)) {
                session.invalidate();
                session = request.getSession(true);

                session.setAttribute("user_type", "staff");
                session.setAttribute("staff_id", rs.getInt("employee_id"));
                session.setAttribute("full_name", rs.getString("full_name"));
                session.setAttribute("staff_username", rs.getString("username"));
                session.setAttribute("staff_role", rs.getString("role"));

                response.sendRedirect("hospital_dashboard.jsp");
                return;
            }
        }

        response.sendRedirect("login.jsp?error=1");

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=1");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>