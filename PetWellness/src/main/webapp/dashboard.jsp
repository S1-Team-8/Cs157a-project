<%@ page import="java.util.List" %>
<%@ page import="com.petwellness.model.PetOwner" %>
<%@ page import="com.petwellness.model.Pet" %>
<%@ page import="com.petwellness.service.PetOwnerService" %>
<%@ page import="com.petwellness.service.ViewPetService" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
    PetOwner owner = PetOwnerService.getOwnerById(ownerId);
    List<Pet> pets = ViewPetService.getPetsByOwnerId(ownerId);

    if (owner == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Dashboard — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="view_pets.jsp">My Pets</a>
        <a href="view_my_appointments.jsp">Appointments</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-lg">

    <!-- Welcome banner -->
    <div class="welcome-banner">
        <h1>Welcome, <%= owner.getFullName() %>!</h1>
        <p><%= owner.getEmail() %></p>

        <% if (pets != null && !pets.isEmpty()) { %>
            <ul class="pet-list" style="margin-top:16px;">
                <% for (Pet pet : pets) { %>
                    <li class="pet-chip">🐾 <%= pet.getPetName() %> &mdash; <%= pet.getSpecies() %></li>
                <% } %>
            </ul>
        <% } %>
    </div>

    <!-- Action grid -->
    <div class="dashboard-grid">

        <!-- My Pets -->
        <div class="dashboard-section">
            <div class="dashboard-section-title">
                <span class="dashboard-section-icon">🐾</span> My Pets
            </div>
            <a class="section-btn" href="add_pet.jsp">Add a Pet</a>
            <a class="section-btn" href="view_pets.jsp">View My Pets</a>
            <a class="section-btn" href="view_visits.jsp">View Visit History</a>
        </div>

        <!-- Appointments -->
        <div class="dashboard-section">
            <div class="dashboard-section-title">
                <span class="dashboard-section-icon">📅</span> Appointments
            </div>
            <a class="section-btn" href="schedule_appointment.jsp">Schedule Appointment</a>
            <a class="section-btn" href="view_my_appointments.jsp">View My Appointments</a>
        </div>

        <!-- Clinics -->
        <div class="dashboard-section">
            <div class="dashboard-section-title">
                <span class="dashboard-section-icon">🏥</span> Clinics
            </div>
            <a class="section-btn" href="search_clinic.jsp">Search Clinics</a>
        </div>

        <!-- Account -->
        <div class="dashboard-section">
            <div class="dashboard-section-title">
                <span class="dashboard-section-icon">⚙️</span> Account
            </div>
            <a class="section-btn" href="logout.jsp">Logout</a>
        </div>

    </div><!-- /.dashboard-grid -->

</div><!-- /.card-lg -->
</div><!-- /.page-shell -->

</body>
</html>
