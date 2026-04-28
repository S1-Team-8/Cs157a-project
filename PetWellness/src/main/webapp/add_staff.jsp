<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Staff Account</title>
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

        .form-card {
            width: 100%;
            max-width: 850px;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.08);
            padding: 40px 50px;
        }

        .page-title {
            margin: 0;
            font-size: 44px;
            font-weight: 700;
            color: #2f5597;
        }

        .page-subtitle {
            margin-top: 10px;
            margin-bottom: 30px;
            font-size: 19px;
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

        .button-row {
            padding-left: 200px;
            margin-top: 12px;
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-block;
            text-decoration: none;
            border: none;
            border-radius: 12px;
            padding: 14px 28px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s ease, transform 0.2s ease;
        }

        .btn-primary {
            background: #2f5597;
            color: #ffffff;
        }

        .btn-primary:hover {
            background: #24457a;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: #dfe7f2;
            color: #2f5597;
        }

        .btn-secondary:hover {
            background: #cfd9e8;
            transform: translateY(-1px);
        }

        @media (max-width: 768px) {
            .form-card {
                padding: 28px 22px;
            }

            .page-title {
                font-size: 34px;
            }

            .page-subtitle {
                font-size: 17px;
            }

            .form-group {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .button-row {
                padding-left: 0;
                flex-direction: column;
            }

            .btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="page-wrapper">
        <div class="form-card">
            <h1 class="page-title">Add Staff Account</h1>
            <p class="page-subtitle">Create a new staff login for the clinic system.</p>
            <hr class="divider">

            <form action="add_staff_process.jsp" method="post">
                <div class="form-group">
                    <label for="full_name">Full Name</label>
                    <input type="text" name="full_name" id="full_name" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="role">Role</label>
                    <select name="role" id="role" class="form-control" required>
                        <option value="">Select role</option>
                        <option value="Admin">Admin</option>
                        <option value="Manager">Manager</option>
                        <option value="Veterinarian">Veterinarian</option>
                        <option value="Technician">Technician</option>
                        <option value="Inventory Staff">Inventory Staff</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" name="username" id="username" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" name="password" id="password" class="form-control" required>
                </div>

                <div class="button-row">
                    <button type="submit" class="btn btn-primary">Create Staff Account</button>
                    <a href="manage_staff.jsp" class="btn btn-secondary">Manage Staff</a>
                    <a href="hospital_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>