package assets;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class StockMovementDAO {

    // Enregistrer un mouvement de stock
    public static boolean recordMovement(int productId, int quantity, String movementType) {
        try {
            Connection conn = Connexion.connectToDatabase();
            String sql = "INSERT INTO STOCK_MOVEMENT (PRODUCTID, DATEMOVEMENT, QUANTITY, MOVEMENT_TYPE) VALUES (?, NOW(), ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ps.setInt(2, quantity);
            ps.setString(3, movementType);
            int rows = ps.executeUpdate();
            ps.close();
            conn.close();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Récupérer les mouvements pour un produit
    public static List<StockMovement> getMovementsForProduct(int productId) {
        List<StockMovement> movements = new ArrayList<>();
        try {
            Connection conn = Connexion.connectToDatabase();
            String sql = "SELECT * FROM STOCK_MOVEMENT WHERE PRODUCTID = ? ORDER BY DATEMOVEMENT DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                StockMovement movement = new StockMovement();
                movement.setId(rs.getInt("ID"));
                movement.setProductId(rs.getInt("PRODUCTID"));
                movement.setDateMovement(rs.getTimestamp("DATEMOVEMENT").toLocalDateTime());
                movement.setQuantity(rs.getInt("QUANTITY"));
                movement.setMovementType(rs.getString("MOVEMENT_TYPE"));
                movements.add(movement);
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return movements;
    }

    // Calculer le stock disponible
    public static int getAvailableStock(int productId) {
        int stock = 0;
        try {
            Connection conn = Connexion.connectToDatabase();
            String sql = "SELECT SUM(CASE WHEN MOVEMENT_TYPE = 'IN' THEN QUANTITY ELSE -QUANTITY END) AS STOCK " +
                    "FROM STOCK_MOVEMENT WHERE PRODUCTID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stock = rs.getInt("STOCK");
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stock;
    }

    public static boolean addStock(int productId, int quantity) {
        if (quantity > 0) {
            return StockMovementDAO.recordMovement(productId, quantity, "IN");
        }
        return false;
    }

    public static boolean removeStock(int productId, int quantity) {
        int currentStock = StockMovementDAO.getAvailableStock(productId);
        if (currentStock >= quantity && quantity > 0) {
            return StockMovementDAO.recordMovement(productId, quantity, "OUT");
        }
        return false;
    }

}
