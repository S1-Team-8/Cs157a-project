<%@ page import="com.petwellness.service.ServiceCatalogService" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    String _role = (String) session.getAttribute("staff_role");
    if (_role == null) _role = "";
    if (!"Admin".equals(_role) && !"Manager".equals(_role)) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }

    String action = request.getParameter("action");

    try {
        if ("add".equals(action)) {
            String serviceName  = request.getParameter("service_name");
            String category     = request.getParameter("category");
            String description  = request.getParameter("description");

            if (serviceName == null || serviceName.trim().isEmpty()) {
                response.sendRedirect("manage_services.jsp?msg=error");
                return;
            }

            ServiceCatalogService.addService(
                serviceName.trim(),
                category != null ? category.trim() : null,
                description != null ? description.trim() : null
            );
            response.sendRedirect("manage_services.jsp?msg=added");

        } else if ("delete".equals(action)) {
            int serviceId = Integer.parseInt(request.getParameter("service_id"));
            ServiceCatalogService.deleteService(serviceId);
            response.sendRedirect("manage_services.jsp?msg=deleted");

        } else {
            response.sendRedirect("manage_services.jsp");
        }
    } catch (Exception e) {
        response.sendRedirect("manage_services.jsp?msg=error");
    }
%>
