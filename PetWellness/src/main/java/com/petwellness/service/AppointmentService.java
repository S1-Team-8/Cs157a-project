package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import com.petwellness.util.DBConnection;

public class AppointmentService {

    public static void addAppointment(int petId, int vetId, String appointmentDate) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO appointment (pet_id, vet_id, appointment_date, status) VALUES (?, ?, ?, 'Scheduled')";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setInt(1, petId);
            stmt.setInt(2, vetId);
            stmt.setString(3, appointmentDate);

            stmt.executeUpdate();

            stmt.close();
            conn.close();

            System.out.println("Appointment created successfully.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void updateAppointmentStatus(int appointmentId, String status) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE appointment SET status = ? WHERE appointment_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setString(1, status);
            stmt.setInt(2, appointmentId);

            stmt.executeUpdate();

            stmt.close();
            conn.close();

            System.out.println("Appointment status updated successfully.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}