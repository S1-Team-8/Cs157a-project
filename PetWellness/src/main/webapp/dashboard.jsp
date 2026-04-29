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
    <title>Dashboard - PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h1>Welcome, <%= owner.getFullName() %>!</h1>
        <p>You are logged in to PetWellness.</p>
        <p>Email: <%= owner.getEmail() %></p>

        <h2>Your Pets</h2>

        <% if (pets.isEmpty()) { %>
            <p>No pets added yet.</p>
        <% } else { %>
            <ul>
                <% for (Pet pet : pets) { %>
                    <li><strong><%= pet.getPetName() %></strong> - <%= pet.getSpecies() %></li>
                <% } %>
            </ul>
        <% } %>

        <div class="button-group">
            <h2>Pet Owner Dashboard</h2>

		<a class ="btn" href="add_pet.jsp">Add Pet</a>
		<a class ="btn" href="view_pets.jsp">View My Pets</a>
		<a class ="btn" href="view_visits.jsp">View My Pet History</a>

		<a class ="btn" href="schedule_appointment.jsp">Schedule Appointment</a>
		<a class ="btn" href="view_my_appointments.jsp">View My Appointments</a>
		<a class="btn" href="search_clinic.jsp">Search Clinics</a>

		<hr>

		<a class ="btn" href="logout.jsp">Logout</a>
		
        </div>
    </div>


</body>
</html>