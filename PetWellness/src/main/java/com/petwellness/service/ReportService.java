package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.petwellness.util.DBConnection;

public class ReportService {

    public static class DashboardStats {
        private double totalRevenue;
        private int totalVisits;
        private int totalAppointments;
        private int completedAppointments;
        private int canceledAppointments;
        private int noShowAppointments;
        private String mostCommonProcedure;

        public DashboardStats(double totalRevenue, int totalVisits, int totalAppointments,
                              int completedAppointments, int canceledAppointments,
                              int noShowAppointments, String mostCommonProcedure) {
            this.totalRevenue = totalRevenue;
            this.totalVisits = totalVisits;
            this.totalAppointments = totalAppointments;
            this.completedAppointments = completedAppointments;
            this.canceledAppointments = canceledAppointments;
            this.noShowAppointments = noShowAppointments;
            this.mostCommonProcedure = mostCommonProcedure;
        }

        public double getTotalRevenue() {
            return totalRevenue;
        }

        public int getTotalVisits() {
            return totalVisits;
        }

        public int getTotalAppointments() {
            return totalAppointments;
        }

        public int getCompletedAppointments() {
            return completedAppointments;
        }

        public int getCanceledAppointments() {
            return canceledAppointments;
        }

        public int getNoShowAppointments() {
            return noShowAppointments;
        }

        public String getMostCommonProcedure() {
            return mostCommonProcedure;
        }
    }

    public static DashboardStats getDashboardStats() {
        double totalRevenue = 0.0;
        int totalVisits = 0;
        int totalAppointments = 0;
        int completedAppointments = 0;
        int canceledAppointments = 0;
        int noShowAppointments = 0;
        String mostCommonProcedure = "N/A";

        try {
            Connection conn = DBConnection.getConnection();

            // Total revenue
            String revenueSql = "SELECT COALESCE(SUM(charge_amount), 0) AS total_revenue FROM procedure_record";
            PreparedStatement revenueStmt = conn.prepareStatement(revenueSql);
            ResultSet revenueRs = revenueStmt.executeQuery();
            if (revenueRs.next()) {
                totalRevenue = revenueRs.getDouble("total_revenue");
            }
            revenueRs.close();
            revenueStmt.close();

            // Total visits
            String visitsSql = "SELECT COUNT(*) AS total_visits FROM visit";
            PreparedStatement visitsStmt = conn.prepareStatement(visitsSql);
            ResultSet visitsRs = visitsStmt.executeQuery();
            if (visitsRs.next()) {
                totalVisits = visitsRs.getInt("total_visits");
            }
            visitsRs.close();
            visitsStmt.close();

            // Total appointments
            String totalAppointmentsSql = "SELECT COUNT(*) AS total_appointments FROM appointment";
            PreparedStatement totalAppointmentsStmt = conn.prepareStatement(totalAppointmentsSql);
            ResultSet totalAppointmentsRs = totalAppointmentsStmt.executeQuery();
            if (totalAppointmentsRs.next()) {
                totalAppointments = totalAppointmentsRs.getInt("total_appointments");
            }
            totalAppointmentsRs.close();
            totalAppointmentsStmt.close();

            // Completed appointments
            String completedSql = "SELECT COUNT(*) AS completed_count FROM appointment WHERE status = 'Completed'";
            PreparedStatement completedStmt = conn.prepareStatement(completedSql);
            ResultSet completedRs = completedStmt.executeQuery();
            if (completedRs.next()) {
                completedAppointments = completedRs.getInt("completed_count");
            }
            completedRs.close();
            completedStmt.close();

            // Canceled appointments
            String canceledSql = "SELECT COUNT(*) AS canceled_count FROM appointment WHERE status = 'Canceled'";
            PreparedStatement canceledStmt = conn.prepareStatement(canceledSql);
            ResultSet canceledRs = canceledStmt.executeQuery();
            if (canceledRs.next()) {
                canceledAppointments = canceledRs.getInt("canceled_count");
            }
            canceledRs.close();
            canceledStmt.close();

            // No-show appointments
            String noShowSql = "SELECT COUNT(*) AS no_show_count FROM appointment WHERE status = 'No-show'";
            PreparedStatement noShowStmt = conn.prepareStatement(noShowSql);
            ResultSet noShowRs = noShowStmt.executeQuery();
            if (noShowRs.next()) {
                noShowAppointments = noShowRs.getInt("no_show_count");
            }
            noShowRs.close();
            noShowStmt.close();

            // Most common procedure
            String procedureSql =
                "SELECT procedure_name, COUNT(*) AS procedure_count " +
                "FROM procedure_record " +
                "GROUP BY procedure_name " +
                "ORDER BY procedure_count DESC " +
                "LIMIT 1";
            PreparedStatement procedureStmt = conn.prepareStatement(procedureSql);
            ResultSet procedureRs = procedureStmt.executeQuery();
            if (procedureRs.next()) {
                mostCommonProcedure = procedureRs.getString("procedure_name");
            }
            procedureRs.close();
            procedureStmt.close();

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new DashboardStats(
            totalRevenue,
            totalVisits,
            totalAppointments,
            completedAppointments,
            canceledAppointments,
            noShowAppointments,
            mostCommonProcedure
        );
    }
}