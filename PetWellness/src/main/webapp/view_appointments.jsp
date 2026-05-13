<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page import="com.petwellness.service.ServiceCatalogService" %>
<%@ page import="com.petwellness.service.ServiceCatalogService.ServiceRecord" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("employee_id") == null) {
        response.sendRedirect("staff_login.jsp");
        return;
    }
    String staffRole = (String) session.getAttribute("staff_role");
    if (staffRole == null) staffRole = "";
    boolean isAdmin   = "Admin".equals(staffRole);
    boolean isManager = "Manager".equals(staffRole);
    boolean isVet     = "Veterinarian".equals(staffRole);
    boolean isTech    = "Technician".equals(staffRole);
    if (!isAdmin && !isManager && !isVet && !isTech) {
        response.sendRedirect("hospital_dashboard.jsp");
        return;
    }
    boolean canManage = isAdmin || isManager;

    // status filter: "active" (default) = Pending + Scheduled; "all"; or specific status
    String[] validStatuses = {"active","all","Pending","Scheduled","Completed","Canceled","No-show"};
    String statusFilter = request.getParameter("status");
    boolean validFilter = false;
    if (statusFilter != null) {
        for (String v : validStatuses) { if (v.equals(statusFilter)) { validFilter = true; break; } }
    }
    if (!validFilter) statusFilter = "active";

    String msg = request.getParameter("msg");

    List<ServiceRecord> serviceList = ServiceCatalogService.getAllServices();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="hospital_dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="hospital_dashboard.jsp">Dashboard</a>
        <a href="view_appointments.jsp" class="nav-active">Appointments</a>
        <a href="manage_inventory.jsp">Inventory</a>
        <% if (isAdmin || isManager) { %><a href="reports.jsp">Reports</a><% } %>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-lg">
<div class="card">

    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;flex-wrap:wrap;gap:12px;">
        <h1 class="page-title" style="margin-bottom:0;">Appointments</h1>
        <% if (canManage) { %>
            <button onclick="toggleNewForm()" class="btn btn-primary">+ New Appointment</button>
        <% } %>
    </div>

    <% if ("created".equals(msg)) { %>
        <div class="alert alert-success">Appointment created.</div>
    <% } else if ("approved".equals(msg)) { %>
        <div class="alert alert-success">Appointment approved and scheduled.</div>
    <% } else if ("updated".equals(msg)) { %>
        <div class="alert alert-success">Status updated.</div>
    <% } else if ("completed".equals(msg)) { %>
        <div class="alert alert-success">Marked complete — visit record created automatically.</div>
    <% } else if ("error".equals(msg)) { %>
        <div class="alert alert-error">Something went wrong. Please try again.</div>
    <% } %>

    <%-- ── New Appointment form (Admin/Manager only) ──────────────────────── --%>
    <% if (canManage) { %>
    <div id="new-appt-form" style="display:none;background:var(--bg-subtle,#f8f9fa);border:1px solid var(--border);border-radius:8px;padding:20px;margin-bottom:24px;">
        <p class="section-heading" style="margin-top:0;">Schedule New Appointment (Hospital-Initiated)</p>
        <form action="manage_appointment_process.jsp" method="post">
            <input type="hidden" name="action_type" value="create">
            <div class="form-row">
                <div class="form-group-inline">
                    <label>Patient *</label>
                    <select name="pet_id" class="form-control" required style="min-width:220px;">
                        <option value="">Select patient</option>
                        <%
                            Connection _pc = null; PreparedStatement _pp = null; ResultSet _pr = null;
                            try {
                                _pc = DBConnection.getConnection();
                                _pp = _pc.prepareStatement(
                                    "SELECT p.pet_id, p.pet_name, p.species, o.full_name " +
                                    "FROM pet p JOIN pet_owner o ON p.owner_id = o.owner_id " +
                                    "ORDER BY o.full_name, p.pet_name");
                                _pr = _pp.executeQuery();
                                while (_pr.next()) { %>
                            <option value="<%= _pr.getInt("pet_id") %>">
                                <%= _pr.getString("pet_name") %> (<%= _pr.getString("species") %>) — <%= _pr.getString("full_name") %>
                            </option>
                        <%      }
                            } catch (Exception e) { out.println("<option disabled>Error</option>"); }
                            finally {
                                try { if (_pr != null) _pr.close(); } catch (Exception e) {}
                                try { if (_pp != null) _pp.close(); } catch (Exception e) {}
                                try { if (_pc != null) _pc.close(); } catch (Exception e) {}
                            }
                        %>
                    </select>
                </div>
                <div class="form-group-inline">
                    <label>Veterinarian *</label>
                    <select name="vet_id" class="form-control" required style="min-width:180px;">
                        <option value="">Select vet</option>
                        <%
                            Connection _vc = null; PreparedStatement _vp = null; ResultSet _vr = null;
                            try {
                                _vc = DBConnection.getConnection();
                                _vp = _vc.prepareStatement(
                                    "SELECT employee_id, full_name FROM staff " +
                                    "WHERE is_active = TRUE AND role = 'Veterinarian' ORDER BY full_name");
                                _vr = _vp.executeQuery();
                                while (_vr.next()) { %>
                            <option value="<%= _vr.getInt("employee_id") %>"><%= _vr.getString("full_name") %></option>
                        <%      }
                            } catch (Exception e) { out.println("<option disabled>Error</option>"); }
                            finally {
                                try { if (_vr != null) _vr.close(); } catch (Exception e) {}
                                try { if (_vp != null) _vp.close(); } catch (Exception e) {}
                                try { if (_vc != null) _vc.close(); } catch (Exception e) {}
                            }
                        %>
                    </select>
                </div>
                <div class="form-group-inline">
                    <label>Service</label>
                    <select name="service_id" class="form-control" style="min-width:180px;">
                        <option value="">— None —</option>
                        <% for (ServiceRecord _sv : serviceList) { %>
                            <option value="<%= _sv.getServiceId() %>">
                                <%= _sv.getServiceName() %>
                                <% if (!_sv.getCategory().isEmpty()) { %> (<%= _sv.getCategory() %>)<% } %>
                            </option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group-inline">
                    <label>Date &amp; Time *</label>
                    <input type="datetime-local" name="appointment_date" class="form-control" required style="width:185px;">
                </div>
                <div class="form-group-inline">
                    <label>&nbsp;</label>
                    <button type="submit" class="btn btn-primary">Create</button>
                </div>
            </div>
        </form>
    </div>
    <% } %>

    <%-- ── Status filter ──────────────────────────────────────────────────── --%>
    <form method="get" action="view_appointments.jsp"
          style="display:flex;align-items:center;gap:10px;margin-bottom:18px;flex-wrap:wrap;">
        <label style="font-weight:600;font-size:14px;">Show:</label>
        <%
            String[] filterLabels = {"active","all","Pending","Scheduled","Completed","Canceled","No-show"};
            String[] filterDisplay = {"Pending + Scheduled","All","Pending","Scheduled","Completed","Canceled","No-show"};
            for (int fi = 0; fi < filterLabels.length; fi++) {
                boolean sel = filterLabels[fi].equals(statusFilter);
        %>
        <a href="view_appointments.jsp?status=<%= filterLabels[fi] %>"
           class="btn btn-sm <%= sel ? "btn-primary" : "btn-secondary" %>">
            <%= filterDisplay[fi] %>
        </a>
        <% } %>
    </form>

    <%-- ── Appointments table ─────────────────────────────────────────────── --%>
    <table class="data-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Patient</th>
                <th>Owner</th>
                <th>Service</th>
                <th>Date Requested</th>
                <th>Veterinarian</th>
                <th>Status</th>
                <% if (canManage) { %><th>Actions</th><% } %>
            </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
            boolean hasRows = false;
            try {
                conn = DBConnection.getConnection();

                String whereClause;
                if ("active".equals(statusFilter)) {
                    whereClause = "WHERE a.status IN ('Pending','Scheduled')";
                } else if ("all".equals(statusFilter)) {
                    whereClause = "";
                } else {
                    whereClause = "WHERE a.status = '" + statusFilter + "'";
                }

                ps = conn.prepareStatement(
                    "SELECT a.appointment_id, p.pet_name, p.species, " +
                    "o.full_name AS owner_name, s.full_name AS vet_name, " +
                    "sc.service_name, a.appointment_date, a.status " +
                    "FROM appointment a " +
                    "JOIN pet p ON a.pet_id = p.pet_id " +
                    "JOIN pet_owner o ON p.owner_id = o.owner_id " +
                    "LEFT JOIN staff s ON a.vet_id = s.employee_id " +
                    "LEFT JOIN service_catalog sc ON a.service_id = sc.service_id " +
                    whereClause + " ORDER BY a.appointment_date DESC");
                rs = ps.executeQuery();

                while (rs.next()) {
                    hasRows = true;
                    int    apptId   = rs.getInt("appointment_id");
                    String status   = rs.getString("status");
                    String vetName  = rs.getString("vet_name");
                    String svcName  = rs.getString("service_name");

                    String badgeClass = "badge-scheduled";
                    if ("Pending".equals(status))   badgeClass = "badge-noshow";
                    else if ("Completed".equals(status)) badgeClass = "badge-completed";
                    else if ("Canceled".equals(status))  badgeClass = "badge-canceled";
                    else if ("No-show".equals(status))   badgeClass = "badge-noshow";
        %>
            <tr>
                <td style="color:var(--text-muted);font-size:12px;">#<%= apptId %></td>
                <td>
                    <strong><%= rs.getString("pet_name") %></strong>
                    <span style="color:var(--text-muted);font-size:12px;"> (<%= rs.getString("species") %>)</span>
                </td>
                <td><%= rs.getString("owner_name") %></td>
                <td><%= svcName != null ? svcName : "<span style=\"color:var(--text-muted)\">—</span>" %></td>
                <td><%= rs.getString("appointment_date") %></td>
                <td>
                    <% if (vetName != null) { %>
                        <%= vetName %>
                    <% } else { %>
                        <span style="color:var(--text-muted);font-style:italic;">Unassigned</span>
                    <% } %>
                </td>
                <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                <% if (canManage) { %>
                <td style="white-space:nowrap;">
                    <% if ("Pending".equals(status)) { %>
                        <a href="approve_appointment.jsp?id=<%= apptId %>"
                           class="btn btn-primary btn-sm">Assign &amp; Approve</a>
                        <form action="manage_appointment_process.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="action_type"    value="update">
                            <input type="hidden" name="appointment_id" value="<%= apptId %>">
                            <input type="hidden" name="status"         value="Canceled">
                            <button type="submit" class="btn btn-danger btn-sm"
                                    onclick="return confirm('Decline this request?')">Decline</button>
                        </form>
                    <% } else if ("Scheduled".equals(status)) { %>
                        <form action="manage_appointment_process.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="action_type"    value="update">
                            <input type="hidden" name="appointment_id" value="<%= apptId %>">
                            <input type="hidden" name="status"         value="Completed">
                            <button type="submit" class="btn btn-success btn-sm"
                                    onclick="return confirm('Mark as completed? A visit record will be created.')">Complete</button>
                        </form>
                        <form action="manage_appointment_process.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="action_type"    value="update">
                            <input type="hidden" name="appointment_id" value="<%= apptId %>">
                            <input type="hidden" name="status"         value="Canceled">
                            <button type="submit" class="btn btn-danger btn-sm">Cancel</button>
                        </form>
                        <form action="manage_appointment_process.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="action_type"    value="update">
                            <input type="hidden" name="appointment_id" value="<%= apptId %>">
                            <input type="hidden" name="status"         value="No-show">
                            <button type="submit" class="btn btn-secondary btn-sm">No-show</button>
                        </form>
                    <% } else { %>
                        <span style="color:var(--text-muted);">—</span>
                    <% } %>
                </td>
                <% } %>
            </tr>
        <%
                }
                if (!hasRows) { %>
            <tr><td colspan="<%= canManage ? 8 : 7 %>">
                <div class="empty-state">
                    <div class="empty-state-icon">📅</div>
                    No appointments found.
                </div>
            </td></tr>
        <%  }
            } catch (Exception e) { %>
            <tr><td colspan="<%= canManage ? 8 : 7 %>">
                <div class="alert alert-error">Error loading appointments: <%= e.getMessage() %></div>
            </td></tr>
        <%  } finally {
                try { if (rs   != null) rs.close();   } catch (Exception e) {}
                try { if (ps   != null) ps.close();   } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        %>
        </tbody>
    </table>

    <div class="btn-row mt-24">
        <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

</div>
</div>
</div>

<script>
function toggleNewForm() {
    var el = document.getElementById('new-appt-form');
    el.style.display = el.style.display === 'none' ? 'block' : 'none';
}
</script>

</body>
</html>
