<%@ page import="com.petwellness.service.StaffService" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    if (!"Admin".equals(session.getAttribute("staff_role"))) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }
    try {
        int employeeId = Integer.parseInt(request.getParameter("employee_id"));
        String role = request.getParameter("role");

        StaffService.updateStaffRole(employeeId, role);

        response.sendRedirect("manage_staff.jsp");
    } catch (Exception e) {
        out.println("<h3>Error updating staff role.</h3>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>