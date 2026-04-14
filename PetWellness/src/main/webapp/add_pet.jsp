<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Pet - PetWellness</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container form-box">
        <h2>Add a Pet</h2>

        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");

            if ("1".equals(success)) {
        %>
            <p class="success">Pet added successfully.</p>
        <%
            } else if ("1".equals(error)) {
        %>
            <p class="error">Please enter both pet name and species.</p>
        <%
            } else if ("2".equals(error)) {
        %>
            <p class="error">Unable to add pet. Please try again.</p>
        <%
            }
        %>

        <form action="add_pet_process.jsp" method="post">
            <label>Pet Name</label>
            <input type="text" name="pet_name" required>

            <label>Species</label>
            <select name="species" required>
                <option value="">Select species</option>
                <option value="Dog">Dog</option>
                <option value="Cat">Cat</option>
                <option value="Bird">Bird</option>
                <option value="Rabbit">Rabbit</option>
                <option value="Reptile">Reptile</option>
                <option value="Other">Other</option>
            </select>

            <button type="submit" class="btn">Add Pet</button>
        </form>

        <p><a href="dashboard.jsp">Back to Dashboard</a></p>
    </div>
</body>
</html>