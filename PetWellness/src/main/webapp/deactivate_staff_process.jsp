<%@ page import="com.petwellness.service.StaffService" %>
<%
    try {
        int employeeId = Integer.parseInt(request.getParameter("employee_id"));

        StaffService.deactivateStaff(employeeId);

        response.sendRedirect("manage_staff.jsp");
    } catch (Exception e) {
        out.println("<h3>Error deactivating staff account.</h3>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>