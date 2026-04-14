<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Visit Record</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container form-box">
        <h2>Create Visit Record</h2>

        <form action="add_visit_process.jsp" method="post">
            <label for="pet_id">Pet ID</label>
            <input type="number" name="pet_id" id="pet_id" required>

            <label for="vet_id">Vet ID</label>
            <input type="number" name="vet_id" id="vet_id" required>

            <label for="visit_date">Visit Date and Time</label>
            <input type="datetime-local" name="visit_date" id="visit_date" required>

            <label for="notes">Notes / Diagnosis</label>
            <textarea name="notes" id="notes" rows="5"></textarea>

            <button type="submit" class="btn">Add Visit</button>
        </form>

        <p><a href="hospital_dashboard.jsp">Back to Dashboard</a></p>
    </div>
</body>
</html>