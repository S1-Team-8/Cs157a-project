package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.petwellness.util.DBConnection;

public class ServiceCatalogService {

    public static class ServiceRecord {
        private int serviceId;
        private String serviceName;
        private String category;
        private String description;

        public ServiceRecord(int serviceId, String serviceName, String category, String description) {
            this.serviceId = serviceId;
            this.serviceName = serviceName;
            this.category = category;
            this.description = description;
        }

        public int getServiceId()      { return serviceId; }
        public String getServiceName() { return serviceName; }
        public String getCategory()    { return category != null ? category : ""; }
        public String getDescription() { return description != null ? description : ""; }
    }

    public static List<ServiceRecord> getAllServices() {
        List<ServiceRecord> services = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(
                "SELECT service_id, service_name, category, description " +
                "FROM service_catalog ORDER BY service_name");
            rs = stmt.executeQuery();
            while (rs.next()) {
                services.add(new ServiceRecord(
                    rs.getInt("service_id"),
                    rs.getString("service_name"),
                    rs.getString("category"),
                    rs.getString("description")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs   != null) rs.close();   } catch (Exception e) {}
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return services;
    }

    public static void addService(String serviceName, String category, String description)
            throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(
                "INSERT INTO service_catalog (service_name, category, description) VALUES (?, ?, ?)");
            stmt.setString(1, serviceName);
            stmt.setString(2, category != null && !category.isBlank() ? category : null);
            stmt.setString(3, description != null && !description.isBlank() ? description : null);
            stmt.executeUpdate();
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    public static void deleteService(int serviceId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(
                "DELETE FROM service_catalog WHERE service_id = ?");
            stmt.setInt(1, serviceId);
            stmt.executeUpdate();
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
