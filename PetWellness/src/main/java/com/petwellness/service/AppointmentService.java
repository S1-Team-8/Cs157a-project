package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Types;
import com.petwellness.util.DBConnection;

public class AppointmentService {

    public static void addAppointment(int petId, int vetId, String appointmentDate) throws Exception {
        addAppointment(petId, vetId, appointmentDate, null);
    }

    public static void addAppointment(int petId, int vetId, String appointmentDate,
                                      Integer serviceId) throws Exception {
        Connection conn = DBConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement(
            "INSERT INTO appointment (pet_id, vet_id, appointment_date, status, service_id) " +
            "VALUES (?, ?, ?, 'Scheduled', ?)");
        try {
            stmt.setInt(1, petId);
            stmt.setInt(2, vetId);
            stmt.setString(3, appointmentDate);
            if (serviceId != null) stmt.setInt(4, serviceId);
            else                   stmt.setNull(4, Types.INTEGER);
            stmt.executeUpdate();
        } finally {
            try { stmt.close(); } catch (Exception e) {}
            try { conn.close(); } catch (Exception e) {}
        }
    }

    public static void updateAppointmentStatus(int appointmentId, String status) throws Exception {
        Connection conn = DBConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement(
            "UPDATE appointment SET status = ? WHERE appointment_id = ?");
        try {
            stmt.setString(1, status);
            stmt.setInt(2, appointmentId);
            int rows = stmt.executeUpdate();
            if (rows == 0) {
                throw new Exception("No appointment found with ID " + appointmentId + ".");
            }
        } finally {
            try { stmt.close(); } catch (Exception e) {}
            try { conn.close(); } catch (Exception e) {}
        }
    }
}
