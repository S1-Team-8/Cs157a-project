<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PetWellness — Veterinary Care Management</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<nav class="topbar">
    <div class="brand"><a href="index.jsp">🐾 PetWellness</a></div>
    <div class="nav-links">
        <a href="login.jsp">Pet Owner Login</a>
        <a href="staff_login.jsp">Staff Login</a>
    </div>
</nav>

<div class="hero">
    <div class="hero-logo">🐾</div>
    <h1 class="hero-title">PetWellness</h1>
    <p class="hero-sub">
        A complete veterinary care platform — helping pet owners track their animals'
        health and giving clinic staff the tools they need.
    </p>
</div>

<!-- Feature strip -->
<div class="feature-row">
    <div class="feature-card">
        <div class="feature-card-icon">📋</div>
        <div class="feature-card-title">Track Pet Health</div>
        <div class="feature-card-desc">View full visit histories, procedure records, and technician notes for every pet.</div>
    </div>
    <div class="feature-card">
        <div class="feature-card-icon">📅</div>
        <div class="feature-card-title">Schedule Appointments</div>
        <div class="feature-card-desc">Book and manage appointments online — owners and clinic staff stay in sync.</div>
    </div>
    <div class="feature-card">
        <div class="feature-card-icon">🏥</div>
        <div class="feature-card-title">Manage Clinic Records</div>
        <div class="feature-card-desc">Staff tools for visits, inventory, reports, and role-based access control.</div>
    </div>
</div>

<!-- Login / Signup panels -->
<div class="hero-panels" style="max-width:780px;margin:0 auto 60px;padding:0 24px;">

    <!-- Pet Owner panel -->
    <div class="hero-panel">
        <p class="hero-panel-title">🐶 Pet Owners</p>
        <p style="font-size:14px;color:var(--text-muted);margin-bottom:6px;">
            Manage your pets, view visit history, and schedule appointments.
        </p>
        <a href="signup.jsp" class="btn btn-primary">Sign Up</a>
        <a href="login.jsp"  class="btn btn-secondary">Log In</a>
    </div>

    <!-- Staff / Clinic panel -->
    <div class="hero-panel">
        <p class="hero-panel-title">🏥 Clinic Staff</p>
        <p style="font-size:14px;color:var(--text-muted);margin-bottom:6px;">
            Access the hospital dashboard to manage patients, records, and inventory.
        </p>
        <a href="staff_signup.jsp" class="btn btn-primary">Staff Sign Up</a>
        <a href="staff_login.jsp"  class="btn btn-secondary">Staff Log In</a>
    </div>

</div>

<footer class="site-footer">
    &copy; 2025 PetWellness &mdash; CS157A Course Project
</footer>

</body>
</html>
