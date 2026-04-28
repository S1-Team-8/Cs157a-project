<form action="test_clinic.jsp" method="get">

    City:
    <input type="text" name="city">
    <br><br>

    Minimum Rating:
    <input type="number" step="0.1" name="rating">
    <br><br>

    Search Radius (miles):
    <select name="radius">
        <option value="">Any</option>
        <option value="5">5 miles</option>
        <option value="10">10 miles</option>
    </select>
    <br><br>

    <input type="submit" value="Search">

</form>
