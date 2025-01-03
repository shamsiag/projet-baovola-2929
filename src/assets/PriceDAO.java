package assets;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PriceDAO {

    public boolean addPrice(Price price) {
        String sql = "INSERT INTO PRICE (IDPRODUCT, PRICEVALUE, ADDEDON, DELETEDON) VALUES (?, ?, ?, ?)";
        try (Connection conn = Connexion.connectToDatabase(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, price.getProductId());
            stmt.setDouble(2, price.getPriceValue());
            stmt.setTimestamp(3, Timestamp.valueOf(price.getAddedOn()));
            stmt.setTimestamp(4, price.getDeletedOn() != null ? Timestamp.valueOf(price.getDeletedOn()) : null);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deletePrice(int priceId) {
        String sql = "UPDATE PRICE SET DELETEDON = ? WHERE ID = ?";
        try (Connection conn = Connexion.connectToDatabase(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(2, priceId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Price> getPricesForProduct(int productId) {
        String sql = "SELECT * FROM PRICE WHERE IDPRODUCT = ? ORDER BY ADDEDON DESC";
        List<Price> prices = new ArrayList<>();
        try (Connection conn = Connexion.connectToDatabase(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Price price = new Price();
                price.setId(rs.getInt("ID"));
                price.setProductId(rs.getInt("IDPRODUCT"));
                price.setPriceValue(rs.getDouble("PRICEVALUE"));
                price.setAddedOn(rs.getTimestamp("ADDEDON").toLocalDateTime());
                price.setDeletedOn(
                        rs.getTimestamp("DELETEDON") != null ? rs.getTimestamp("DELETEDON").toLocalDateTime() : null);
                prices.add(price);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return prices;
    }

    public double getLatestPriceForProduct(int productId) {
        String sql = "SELECT PRICEVALUE FROM PRICE WHERE IDPRODUCT = ? AND DELETEDON IS NULL ORDER BY ADDEDON DESC LIMIT 1";
        try (Connection conn = Connexion.connectToDatabase(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("PRICEVALUE");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0; // Retourne 0 si aucun prix trouvé
    }
}
