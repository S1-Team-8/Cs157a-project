<%@ page import="java.security.MessageDigest" %>
<%@ page import="com.petwellness.service.StaffService" %>

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
    String fullName = request.getParameter("full_name");
    String role = request.getParameter("role");
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    try {
        String hashedPassword = hashPassword(password);
        StaffService.addStaff(fullName, role, username, hashedPassword);
        response.sendRedirect("manage_staff.jsp");
    } catch (Exception e) {
        out.println("<h3>Error creating staff account.</h3>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>