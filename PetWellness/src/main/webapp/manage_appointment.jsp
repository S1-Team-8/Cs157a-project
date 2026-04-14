<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Appointment</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container form-box">
        <h2>Manage Appointment</h2>

        <h3>Create Appointment</h3>
        <form action="manage_appointment_process.jsp" method="post">
            <input type="hidden" name="action_type" value="create">

            <label for="pet_id">Pet ID</label>
            <input type="number" name="pet_id" id="pet_id">

            <label for="vet_id">Vet ID</label>
            <input type="number" name="vet_id" id="vet_id">

            <label for="appointment_date">Appointment Date and Time</label>
            <input type="datetime-local" name="appointment_date" id="appointment_date">

            <button type="submit" class="btn">Create Appointment</button>
        </form>

        <hr>

        <h3>Update Appointment Status</h3>
        <form action="manage_appointment_process.jsp" method="post">
            <input type="hidden" name="action_type" value="update">

            <label for="appointment_id">Appointment ID</label>
            <input type="number" name="appointment_id" id="appointment_id">

            <label for="status">Status</label>
            <select name="status" id="status">
                <option value="Scheduled">Scheduled</option>
                <option value="Completed">Completed</option>
                <option value="Canceled">Canceled</option>
                <option value="No-show">No-show</option>
            </select>

            <button type="submit" class="btn">Update Status</button>
        </form>

        <p><a class="btn" href="hospital_dashboard.jsp">Back to Dashboard</a></p>
    </div>
</body>
</html>