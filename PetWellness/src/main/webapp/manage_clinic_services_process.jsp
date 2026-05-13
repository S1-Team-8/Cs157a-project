<%@ page import="com.petwellness.service.ClinicServiceService" %>
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

    String action           = request.getParameter("action");
    String redirectClinicId = request.getParameter("redirect_clinic_id");
    String backParam        = (redirectClinicId != null && !redirectClinicId.trim().isEmpty())
                              ? "?clinic_id=" + redirectClinicId : "";

    try {
        if ("add".equals(action)) {
            int clinicId  = Integer.parseInt(request.getParameter("clinic_id"));
            int serviceId = Integer.parseInt(request.getParameter("service_id"));

            String pMinStr = request.getParameter("price_min");
            String pMaxStr = request.getParameter("price_max");
            Double priceMin = (pMinStr != null && !pMinStr.trim().isEmpty())
                              ? Double.parseDouble(pMinStr) : null;
            Double priceMax = (pMaxStr != null && !pMaxStr.trim().isEmpty())
                              ? Double.parseDouble(pMaxStr) : null;

            ClinicServiceService.addClinicService(clinicId, serviceId, priceMin, priceMax);
            response.sendRedirect("manage_clinic_services.jsp?clinic_id=" + clinicId + "&msg=added");

        } else if ("remove".equals(action)) {
            int clinicServiceId = Integer.parseInt(request.getParameter("clinic_service_id"));
            ClinicServiceService.removeClinicService(clinicServiceId);
            response.sendRedirect("manage_clinic_services.jsp" + backParam + "&msg=removed");

        } else {
            response.sendRedirect("manage_clinic_services.jsp");
        }
    } catch (Exception e) {
        response.sendRedirect("manage_clinic_services.jsp" + backParam + "&msg=error");
    }
%>
