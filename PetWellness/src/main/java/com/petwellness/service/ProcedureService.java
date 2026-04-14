package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import com.petwellness.util.DBConnection;

public class ProcedureService {

    public static void addProcedure(int visitId, String procedureName, double chargeAmount, String notes) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO procedure_record (visit_id, procedure_name, charge_amount, notes) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setInt(1, visitId);
            stmt.setString(2, procedureName);
            stmt.setDouble(3, chargeAmount);
            stmt.setString(4, notes);

            stmt.executeUpdate();

            stmt.close();
            conn.close();

            System.out.println("Procedure added successfully.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}