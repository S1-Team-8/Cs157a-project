<%@ page import="java.sql.*" %>
<%@ page import="com.petwellness.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("owner_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int ownerId = Integer.parseInt(session.getAttribute("owner_id").toString());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Visit</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #eef2f7;
            color: #1f2d3d;
        }

        .page-wrapper {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        .visit-card {
            width: 100%;
            max-width: 900px;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.08);
            padding: 40px 50px;
        }

        .page-title {
            margin: 0;
            font-size: 48px;
            font-weight: 700;
            color: #2f5597;
        }

        .page-subtitle {
            margin-top: 10px;
            margin-bottom: 30px;
            font-size: 20px;
            color: #5f6b7a;
        }

        .divider {
            border: none;
            border-top: 1px solid #d9e1ea;
            margin-bottom: 30px;
        }

        .form-group {
            display: grid;
            grid-template-columns: 180px 1fr;
            gap: 20px;
            align-items: center;
            margin-bottom: 24px;
        }

        .form-group label {
            font-size: 20px;
            font-weight: 600;
            color: #2f5597;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px;
            font-size: 18px;
            border: 1px solid #ccd6e0;
            border-radius: 12px;
            background: #fff;
            outline: none;
            transition: all 0.2s ease;
        }

        .form-control:focus {
            border-color: #2f5597;
            box-shadow: 0 0 0 4px rgba(47, 85, 151, 0.12);
        }

        textarea.form-control {
            min-height: 130px;
            resize: vertical;
        }

        .button-row {
            padding-left: 200px;
            margin-top: 10px;
        }

        .submit-btn {
            background: #2f5597;
            color: #fff;
            border: none;
            border-radius: 12px;
            padding: 15px 34px;
            font-size: 20px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s ease, transform 0.2s ease;
        }

        .submit-btn:hover {
            background: #24457a;
            transform: translateY(-1px);
        }

        @media (max-width: 768px) {
            .visit-card {
                padding: 28px 22px;
            }

            .page-title {
                font-size: 36px;
            }

            .page-subtitle {
                font-size: 18px;
            }

            .form-group {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .button-row {
                padding-left: 0;
            }

            .submit-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="page-wrapper">
        <div class="visit-card">
            <h1 class="page-title">Add Visit</h1>
            <p class="page-subtitle">Record a new visit for your pet.</p>
            <hr class="divider">

            <form action="add_visit_process.jsp" method="post">

                <div class="form-group">
                    <label for="pet_id">Pet</label>
                    <select id="pet_id" name="pet_id" class="form-control" required>
                        <option value="">Select pet</option>
                        <%
                            Connection conn1 = null;
                            PreparedStatement ps1 = null;
                            ResultSet rs1 = null;

                            try {
                                conn1 = DBConnection.getConnection();
                                String sql1 = "SELECT pet_id, pet_name FROM Pet WHERE owner_id = ?";
                                ps1 = conn1.prepareStatement(sql1);
                                ps1.setInt(1, ownerId);
                                rs1 = ps1.executeQuery();

                                while (rs1.next()) {
                        %>
                                    <option value="<%= rs1.getInt("pet_id") %>">
                                        <%= rs1.getString("pet_name") %> (ID: <%= rs1.getInt("pet_id") %>)
                                    </option>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<option disabled>Error loading pets</option>");
                            } finally {
                                try { if (rs1 != null) rs1.close(); } catch (Exception e) {}
                                try { if (ps1 != null) ps1.close(); } catch (Exception e) {}
                                try { if (conn1 != null) conn1.close(); } catch (Exception e) {}
                            }
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="vet_id">Vet</label>
                    <select id="vet_id" name="vet_id" class="form-control" required>
                        <option value="">Select vet</option>
                        <%
                            Connection conn2 = null;
                            PreparedStatement ps2 = null;
                            ResultSet rs2 = null;

                            try {
                                conn2 = DBConnection.getConnection();
                                String sql2 = "SELECT employee_id, full_name FROM staff";
                                ps2 = conn2.prepareStatement(sql2);
                                rs2 = ps2.executeQuery();

                                while (rs2.next()) {
                        %>
                                    <option value="<%= rs2.getInt("employee_id") %>">
                                        <%= rs2.getString("full_name") %> (ID: <%= rs2.getInt("employee_id") %>)
                                    </option>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<option disabled>Error loading vets</option>");
                            } finally {
                                try { if (rs2 != null) rs2.close(); } catch (Exception e) {}
                                try { if (ps2 != null) ps2.close(); } catch (Exception e) {}
                                try { if (conn2 != null) conn2.close(); } catch (Exception e) {}
                            }
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="visit_date">Visit Date</label>
                    <input type="datetime-local" id="visit_date" name="visit_date" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="notes">Notes</label>
                    <textarea id="notes" name="notes" class="form-control" placeholder="Enter any notes about the visit..."></textarea>
                </div>

                <div class="button-row">
                    <button type="submit" class="submit-btn">Add Visit</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>