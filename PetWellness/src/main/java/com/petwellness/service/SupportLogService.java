package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Types;
import com.petwellness.util.DBConnection;

public class SupportLogService {

    public static void addSupportLog(int visitId, int technicianId, Double weight, Double temperature, String notes) throws Exception {
        Connection conn = DBConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement(
            "INSERT INTO visit_support_log (visit_id, technician_id, weight, temperature, notes) VALUES (?, ?, ?, ?, ?)");
        try {
            stmt.setInt(1, visitId);
            stmt.setInt(2, technicianId);
            if (weight != null) stmt.setDouble(3, weight); else stmt.setNull(3, Types.DOUBLE);
            if (temperature != null) stmt.setDouble(4, temperature); else stmt.setNull(4, Types.DOUBLE);
            stmt.setString(5, (notes != null && !notes.trim().isEmpty()) ? notes.trim() : null);
            stmt.executeUpdate();
        } finally {
            try { stmt.close(); } catch (Exception e) {}
            try { conn.close(); } catch (Exception e) {}
        }
    }
}
