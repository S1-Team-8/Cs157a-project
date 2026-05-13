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
        StaffService.reactivateStaff(employeeId);
        response.sendRedirect("manage_staff.jsp");
    } catch (Exception e) {
        response.sendRedirect("manage_staff.jsp");
    }
%>
