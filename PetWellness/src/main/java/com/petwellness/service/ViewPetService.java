package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.petwellness.model.Pet;
import com.petwellness.util.DBConnection;

public class ViewPetService {

    public static List<Pet> getPetsByOwnerId(int ownerId) {
        List<Pet> pets = new ArrayList<>();
        String sql = "SELECT * FROM pet WHERE owner_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ownerId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Pet pet = new Pet();
                    pet.setPetId(rs.getInt("pet_id"));
                    pet.setOwnerId(rs.getInt("owner_id"));
                    pet.setPetName(rs.getString("pet_name"));
                    pet.setSpecies(rs.getString("species"));
                    pets.add(pet);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return pets;
    }
}