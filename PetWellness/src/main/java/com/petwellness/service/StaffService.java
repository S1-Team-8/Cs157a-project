package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.petwellness.util.DBConnection;

public class StaffService {

    public static class StaffRecord {
        private int employeeId;
        private String fullName;
        private String role;
        private String username;
        private boolean isActive;

        public StaffRecord(int employeeId, String fullName, String role, String username, boolean isActive) {
            this.employeeId = employeeId;
            this.fullName = fullName;
            this.role = role;
            this.username = username;
            this.isActive = isActive;
        }

        public int getEmployeeId() {
            return employeeId;
        }

        public String getFullName() {
            return fullName;
        }

        public String getRole() {
            return role;
        }

        public String getUsername() {
            return username;
        }

        public boolean isActive() {
            return isActive;
        }
    }

    public static void updateStaffRole(int employeeId, String role) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE staff SET role = ? WHERE employee_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setString(1, role);
            stmt.setInt(2, employeeId);

            stmt.executeUpdate();

            stmt.close();
            conn.close();

            System.out.println("Staff role updated successfully.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void deactivateStaff(int employeeId) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE staff SET is_active = FALSE WHERE employee_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setInt(1, employeeId);

            stmt.executeUpdate();

            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void reactivateStaff(int employeeId) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE staff SET is_active = TRUE WHERE employee_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setInt(1, employeeId);

            stmt.executeUpdate();

            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static List<StaffRecord> getAllStaff() {
        List<StaffRecord> staffList = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT employee_id, full_name, role, username, is_active FROM staff ORDER BY employee_id";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                StaffRecord staff = new StaffRecord(
                    rs.getInt("employee_id"),
                    rs.getString("full_name"),
                    rs.getString("role"),
                    rs.getString("username"),
                    rs.getBoolean("is_active")
                );
                staffList.add(staff);
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return staffList;
    }
}