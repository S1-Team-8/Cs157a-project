package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.petwellness.model.PetOwner;
import com.petwellness.util.DBConnection;

public class PetOwnerService {

    public static void addOwner(String name, String email, String password) {
        String sql = "INSERT INTO pet_owner (full_name, email, password_hash) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.executeUpdate();

            System.out.println("Owner added!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static PetOwner getOwnerById(int ownerId) {
        String sql = "SELECT owner_id, full_name, email FROM pet_owner WHERE owner_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ownerId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    PetOwner owner = new PetOwner();
                    owner.setOwnerId(rs.getInt("owner_id"));
                    owner.setFullName(rs.getString("full_name"));
                    owner.setEmail(rs.getString("email"));
                    return owner;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}