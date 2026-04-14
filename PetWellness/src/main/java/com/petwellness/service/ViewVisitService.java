package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.petwellness.util.DBConnection;

public class ViewVisitService {

    public static class VisitRecord {
        private int visitId;
        private int petId;
        private int vetId;
        private String visitDate;
        private String notes;

        public VisitRecord(int visitId, int petId, int vetId, String visitDate, String notes) {
            this.visitId = visitId;
            this.petId = petId;
            this.vetId = vetId;
            this.visitDate = visitDate;
            this.notes = notes;
        }

        public int getVisitId() {
            return visitId;
        }

        public int getPetId() {
            return petId;
        }

        public int getVetId() {
            return vetId;
        }

        public String getVisitDate() {
            return visitDate;
        }

        public String getNotes() {
            return notes;
        }
    }

    public static List<VisitRecord> getVisitsByPetId(int petId) {
        List<VisitRecord> visits = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT visit_id, pet_id, vet_id, visit_date, notes FROM visit WHERE pet_id = ? ORDER BY visit_date DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, petId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                visits.add(new VisitRecord(
                    rs.getInt("visit_id"),
                    rs.getInt("pet_id"),
                    rs.getInt("vet_id"),
                    rs.getString("visit_date"),
                    rs.getString("notes")
                ));
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return visits;
    }
}