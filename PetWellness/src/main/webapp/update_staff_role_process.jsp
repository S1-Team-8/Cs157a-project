<%@ page import="com.petwellness.service.StaffService" %>
<%
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