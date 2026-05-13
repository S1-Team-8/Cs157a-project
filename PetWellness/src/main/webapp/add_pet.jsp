<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String err = request.getParameter("error");
    String suc = request.getParameter("success");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Pet — PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="dashboard.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="view_pets.jsp" class="nav-active">My Pets</a>
        <a href="view_my_appointments.jsp">Appointments</a>
        <a href="search_clinic.jsp">Clinics</a>
        <a href="logout.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="page-shell">
<div class="card-sm" style="width:100%;">
<div class="card">

    <h1 class="page-title">Add a Pet</h1>
    <p class="page-subtitle">Register a new pet to your account.</p>
    <hr class="divider">

    <% if ("1".equals(suc)) { %>
        <div class="alert alert-success">Pet added successfully.</div>
    <% } else if ("1".equals(err)) { %>
        <div class="alert alert-error">Please enter both a pet name and species.</div>
    <% } else if ("2".equals(err)) { %>
        <div class="alert alert-error">Unable to add pet. Please try again.</div>
    <% } %>

    <form action="add_pet_process.jsp" method="post">

        <div class="form-group">
            <label for="pet_name">Pet Name *</label>
            <input type="text" name="pet_name" id="pet_name" class="form-control"
                   placeholder="e.g., Buddy" required autofocus>
        </div>

        <div class="form-group">
            <label for="species">Species *</label>
            <select name="species" id="species" class="form-control" required>
                <option value="">— Select species —</option>
                <option value="Dog">Dog</option>
                <option value="Cat">Cat</option>
                <option value="Bird">Bird</option>
                <option value="Rabbit">Rabbit</option>
                <option value="Reptile">Reptile</option>
                <option value="Other">Other</option>
            </select>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Add Pet</button>
            <a href="view_pets.jsp" class="btn btn-secondary">My Pets</a>
            <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>
    </form>

</div>
</div>
</div>

</body>
</html>
