<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Procedure</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container form-box">
        <h2>Add Procedure / Treatment</h2>

        <form action="add_procedure_process.jsp" method="post">
            <label for="visit_id">Visit ID</label>
            <input type="number" name="visit_id" id="visit_id" required>

            <label for="procedure_name">Procedure Name</label>
            <input type="text" name="procedure_name" id="procedure_name" required>

            <label for="charge_amount">Charge Amount</label>
            <input type="number" step="0.01" name="charge_amount" id="charge_amount" required>

            <label for="notes">Notes</label>
            <textarea name="notes" id="notes" rows="5"></textarea>

            <button type="submit" class="btn">Add Procedure</button>
        </form>

        <p><a class="btn" href="hospital_dashboard.jsp">Back to Dashboard</a></p>
    </div>
</body>
</html>