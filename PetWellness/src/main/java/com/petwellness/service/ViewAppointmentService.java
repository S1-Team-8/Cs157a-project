package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.petwellness.util.DBConnection;

public class ViewAppointmentService {

    public static class AppointmentRecord {
        private int appointmentId;
        private int petId;
        private int vetId;
        private String appointmentDate;
        private String status;

        public AppointmentRecord(int appointmentId, int petId, int vetId, String appointmentDate, String status) {
            this.appointmentId = appointmentId;
            this.petId = petId;
            this.vetId = vetId;
            this.appointmentDate = appointmentDate;
            this.status = status;
        }

        public int getAppointmentId() {
            return appointmentId;
        }

        public int getPetId() {
            return petId;
        }

        public int getVetId() {
            return vetId;
        }

        public String getAppointmentDate() {
            return appointmentDate;
        }

        public String getStatus() {
            return status;
        }
    }

    public static List<AppointmentRecord> getAllAppointments() {
        List<AppointmentRecord> appointments = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT appointment_id, pet_id, vet_id, appointment_date, status FROM appointment ORDER BY appointment_date DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                appointments.add(new AppointmentRecord(
                    rs.getInt("appointment_id"),
                    rs.getInt("pet_id"),
                    rs.getInt("vet_id"),
                    rs.getString("appointment_date"),
                    rs.getString("status")
                ));
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }
}