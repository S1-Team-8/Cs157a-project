package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.petwellness.util.DBConnection;

public class InventoryService {

    public static class InventoryRecord {
        private int itemId;
        private String itemName;
        private String category;
        private int qtyOnHand;
        private int reorderThreshold;
        private double unitCost;

        public InventoryRecord(int itemId, String itemName, String category,
                               int qtyOnHand, int reorderThreshold, double unitCost) {
            this.itemId = itemId;
            this.itemName = itemName;
            this.category = category;
            this.qtyOnHand = qtyOnHand;
            this.reorderThreshold = reorderThreshold;
            this.unitCost = unitCost;
        }

        public int getItemId() {
            return itemId;
        }

        public String getItemName() {
            return itemName;
        }

        public String getCategory() {
            return category;
        }

        public int getQtyOnHand() {
            return qtyOnHand;
        }

        public int getReorderThreshold() {
            return reorderThreshold;
        }

        public double getUnitCost() {
            return unitCost;
        }
    }

    public static void addInventoryItem(String itemName, String category,
                                        int qtyOnHand, int reorderThreshold, double unitCost) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO inventory_item (item_name, category, qty_on_hand, reorder_threshold, unit_cost) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setString(1, itemName);
            stmt.setString(2, category);
            stmt.setInt(3, qtyOnHand);
            stmt.setInt(4, reorderThreshold);
            stmt.setDouble(5, unitCost);

            stmt.executeUpdate();

            stmt.close();
            conn.close();

            System.out.println("Inventory item added successfully.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void updateInventoryQuantity(int itemId, int qtyOnHand) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE inventory_item SET qty_on_hand = ? WHERE item_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setInt(1, qtyOnHand);
            stmt.setInt(2, itemId);

            stmt.executeUpdate();

            stmt.close();
            conn.close();

            System.out.println("Inventory quantity updated successfully.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static List<InventoryRecord> getAllInventoryItems() {
        List<InventoryRecord> items = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT item_id, item_name, category, qty_on_hand, reorder_threshold, unit_cost FROM inventory_item ORDER BY item_id";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                items.add(new InventoryRecord(
                    rs.getInt("item_id"),
                    rs.getString("item_name"),
                    rs.getString("category"),
                    rs.getInt("qty_on_hand"),
                    rs.getInt("reorder_threshold"),
                    rs.getDouble("unit_cost")
                ));
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }
}