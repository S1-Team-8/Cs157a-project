package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.petwellness.util.DBConnection;

public class PetService {

    public static void addPet(int ownerId, String petName, String species) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "INSERT INTO pet (owner_id, pet_name, species) VALUES (?, ?, ?)")) {

            stmt.setInt(1, ownerId);
            stmt.setString(2, petName);
            stmt.setString(3, species);

            stmt.executeUpdate();
            System.out.println("Pet added!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}