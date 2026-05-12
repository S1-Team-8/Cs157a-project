package com.petwellness.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.petwellness.util.DBConnection;

public class InventoryReportService {

    public static class LowStockRecord {
        private int itemId;
        private String itemName;
        private String category;
        private int qtyOnHand;
        private int reorderThreshold;
        private double unitCost;

        public LowStockRecord(int itemId, String itemName, String category,
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

    public static List<LowStockRecord> getLowStockItems() {
        List<LowStockRecord> items = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT item_id, item_name, category, qty_on_hand, reorder_threshold, unit_cost " +
                         "FROM inventory_item " +
                         "WHERE qty_on_hand <= reorder_threshold " +
                         "ORDER BY qty_on_hand ASC, item_name ASC";

            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                items.add(new LowStockRecord(
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