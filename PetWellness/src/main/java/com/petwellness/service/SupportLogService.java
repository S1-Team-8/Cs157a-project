package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import com.petwellness.util.DBConnection;

public class SupportLogService {

    public static void addSupportLog(int visitId, int technicianId, double weight, double temperature, String notes) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO visit_support_log (visit_id, technician_id, weight, temperature, notes) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setInt(1, visitId);
            stmt.setInt(2, technicianId);
            stmt.setDouble(3, weight);
            stmt.setDouble(4, temperature);
            stmt.setString(5, notes);

            stmt.executeUpdate();

            stmt.close();
            conn.close();

            System.out.println("Support log added successfully.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}