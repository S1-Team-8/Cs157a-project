package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.petwellness.util.DBConnection;

public class ClinicServiceService {

    public static class ClinicServiceRecord {
        private int clinicServiceId;
        private int clinicId;
        private String clinicName;
        private int serviceId;
        private String serviceName;
        private String category;
        private Double priceMin;
        private Double priceMax;

        public ClinicServiceRecord(int clinicServiceId, int clinicId, String clinicName,
                                   int serviceId, String serviceName, String category,
                                   Double priceMin, Double priceMax) {
            this.clinicServiceId = clinicServiceId;
            this.clinicId        = clinicId;
            this.clinicName      = clinicName;
            this.serviceId       = serviceId;
            this.serviceName     = serviceName;
            this.category        = category;
            this.priceMin        = priceMin;
            this.priceMax        = priceMax;
        }

        public int    getClinicServiceId() { return clinicServiceId; }
        public int    getClinicId()        { return clinicId; }
        public String getClinicName()      { return clinicName  != null ? clinicName  : ""; }
        public int    getServiceId()       { return serviceId; }
        public String getServiceName()     { return serviceName != null ? serviceName : ""; }
        public String getCategory()        { return category    != null ? category    : ""; }
        public Double getPriceMin()        { return priceMin; }
        public Double getPriceMax()        { return priceMax; }

        public String getPriceDisplay() {
            if (priceMin == null) return "—";
            if (priceMax == null || priceMax.equals(priceMin))
                return String.format("$%.2f", priceMin);
            return String.format("$%.2f – $%.2f", priceMin, priceMax);
        }
    }

    public static List<ClinicServiceRecord> getAllClinicServices() {
        List<ClinicServiceRecord> list = new ArrayList<>();
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(
                "SELECT cs.clinic_service_id, cs.clinic_id, c.clinic_name, " +
                "cs.service_id, sc.service_name, sc.category, cs.price_min, cs.price_max " +
                "FROM clinic_service cs " +
                "JOIN clinic c ON cs.clinic_id = c.clinic_id " +
                "JOIN service_catalog sc ON cs.service_id = sc.service_id " +
                "ORDER BY c.clinic_name, sc.service_name");
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(build(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, stmt, conn);
        }
        return list;
    }

    public static List<ClinicServiceRecord> getServicesForClinic(int clinicId) {
        List<ClinicServiceRecord> list = new ArrayList<>();
        Connection conn = null; PreparedStatement stmt = null; ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(
                "SELECT cs.clinic_service_id, cs.clinic_id, c.clinic_name, " +
                "cs.service_id, sc.service_name, sc.category, cs.price_min, cs.price_max " +
                "FROM clinic_service cs " +
                "JOIN clinic c ON cs.clinic_id = c.clinic_id " +
                "JOIN service_catalog sc ON cs.service_id = sc.service_id " +
                "WHERE cs.clinic_id = ? ORDER BY sc.service_name");
            stmt.setInt(1, clinicId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(build(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, stmt, conn);
        }
        return list;
    }

    public static void addClinicService(int clinicId, int serviceId,
                                        Double priceMin, Double priceMax) throws Exception {
        Connection conn = null; PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(
                "INSERT IGNORE INTO clinic_service (clinic_id, service_id, price_min, price_max) " +
                "VALUES (?, ?, ?, ?)");
            stmt.setInt(1, clinicId);
            stmt.setInt(2, serviceId);
            if (priceMin != null) stmt.setDouble(3, priceMin); else stmt.setNull(3, Types.DECIMAL);
            if (priceMax != null) stmt.setDouble(4, priceMax); else stmt.setNull(4, Types.DECIMAL);
            stmt.executeUpdate();
        } finally {
            close(null, stmt, conn);
        }
    }

    public static void removeClinicService(int clinicServiceId) throws Exception {
        Connection conn = null; PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(
                "DELETE FROM clinic_service WHERE clinic_service_id = ?");
            stmt.setInt(1, clinicServiceId);
            stmt.executeUpdate();
        } finally {
            close(null, stmt, conn);
        }
    }

    private static ClinicServiceRecord build(ResultSet rs) throws Exception {
        Double pMin = rs.getObject("price_min") != null ? rs.getDouble("price_min") : null;
        Double pMax = rs.getObject("price_max") != null ? rs.getDouble("price_max") : null;
        return new ClinicServiceRecord(
            rs.getInt("clinic_service_id"),
            rs.getInt("clinic_id"),
            rs.getString("clinic_name"),
            rs.getInt("service_id"),
            rs.getString("service_name"),
            rs.getString("category"),
            pMin, pMax
        );
    }

    private static void close(ResultSet rs, PreparedStatement stmt, Connection conn) {
        try { if (rs   != null) rs.close();   } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
}
