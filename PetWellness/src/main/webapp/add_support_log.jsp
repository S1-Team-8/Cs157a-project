<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Technician Support Log</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container form-box">
        <h2>Record Technician Support Notes / Vitals</h2>

        <form action="add_support_log_process.jsp" method="post">
            <label for="visit_id">Visit ID</label>
            <input type="number" name="visit_id" id="visit_id" required>

            <label for="technician_id">Technician ID</label>
            <input type="number" name="technician_id" id="technician_id" required>

            <label for="weight">Weight</label>
            <input type="number" step="0.01" name="weight" id="weight" required>

            <label for="temperature">Temperature</label>
            <input type="number" step="0.01" name="temperature" id="temperature" required>

            <label for="notes">Support Notes</label>
            <textarea name="notes" id="notes" rows="5"></textarea>

            <button type="submit" class="btn">Save Support Log</button>
        </form>

        <p><a class="btn" href="hospital_dashboard.jsp">Back to Hospital Dashboard</a></p>
    </div>
</body>
</html>