package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.petwellness.util.DBConnection;

public class ViewProcedureService {

    public static class ProcedureRecord {
        private int procedureId;
        private int visitId;
        private String procedureName;
        private double chargeAmount;
        private String notes;

        public ProcedureRecord(int procedureId, int visitId, String procedureName, double chargeAmount, String notes) {
            this.procedureId = procedureId;
            this.visitId = visitId;
            this.procedureName = procedureName;
            this.chargeAmount = chargeAmount;
            this.notes = notes;
        }

        public int getProcedureId() {
            return procedureId;
        }

        public int getVisitId() {
            return visitId;
        }

        public String getProcedureName() {
            return procedureName;
        }

        public double getChargeAmount() {
            return chargeAmount;
        }

        public String getNotes() {
            return notes;
        }
    }

    public static List<ProcedureRecord> getProceduresByVisitId(int visitId) {
        List<ProcedureRecord> procedures = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT procedure_id, visit_id, procedure_name, charge_amount, notes " +
                         "FROM procedure_record WHERE visit_id = ? ORDER BY procedure_id";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, visitId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                procedures.add(new ProcedureRecord(
                    rs.getInt("procedure_id"),
                    rs.getInt("visit_id"),
                    rs.getString("procedure_name"),
                    rs.getDouble("charge_amount"),
                    rs.getString("notes")
                ));
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return procedures;
    }
}