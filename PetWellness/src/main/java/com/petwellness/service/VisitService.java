package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import com.petwellness.util.DBConnection;

public class VisitService {

    public static void addVisit(int petId, int vetId, String visitDate, String notes) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO visit (pet_id, vet_id, visit_date, notes) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setInt(1, petId);
            stmt.setInt(2, vetId);
            stmt.setString(3, visitDate);
            stmt.setString(4, notes);

            stmt.executeUpdate();

            stmt.close();
            conn.close();

            System.out.println("Visit record added successfully.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}