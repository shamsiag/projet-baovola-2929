package assets;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public boolean createOrder(int userId, int cartId, Integer parentOrderId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = Connexion.connectToDatabase();
            String sql = "INSERT INTO `ORDER` (IDUSER, IDCART, PARENTORDER) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setInt(2, cartId);
            if (parentOrderId != null) {
                ps.setInt(3, parentOrderId);
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }

    public List<Order> getOrdersByGlobalId(int globalOrderId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Order> orders = new ArrayList<>();

        try {
            conn = Connexion.connectToDatabase();
            String sql = "SELECT * FROM `ORDER` WHERE PARENTORDER = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, globalOrderId);
            rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(new Order(
                        rs.getInt("ID"),
                        rs.getInt("IDUSER"),
                        rs.getInt("IDCART"),
                        rs.getInt("PARENTORDER")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

        return orders;
    }

    public boolean deleteOrderById(int orderId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = Connexion.connectToDatabase();
            String sql = "DELETE FROM `ORDER` WHERE ID = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }

    public boolean processCheckout(int userId, List<UserCart> cartItems) throws SQLException {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psCart = null;

        try {
            conn = Connexion.connectToDatabase();
            conn.setAutoCommit(false); // Start transaction

            // Créer une commande globale
            OrderGlobalDAO orderGlobalDAO = new OrderGlobalDAO();
            ProductDAO productDAO = new ProductDAO();
            double totalValue = cartItems.stream()
                    .mapToDouble(item -> productDAO.getProductById(item.getProductId()).getPrice() * item.getQuantity())
                    .sum();
            boolean globalOrderCreated = orderGlobalDAO.createOrderGlobal(userId, totalValue, 1, conn);

            if (!globalOrderCreated) {
                conn.rollback();
                return false;
            }

            // Récupérer l'ID de la commande globale créée
            String sqlLastInsertId = "SELECT ID FROM ORDER_GLOBAL ORDER BY ID DESC LIMIT 1";
            int globalOrderId;

            try (Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(sqlLastInsertId)) {
                if (!rs.next()) {
                    conn.rollback();
                    return false;
                }
                globalOrderId = rs.getInt(1);
                System.out.println("Global Order ID created: " + globalOrderId);
            }

            // Vérifier les stocks
            for (UserCart item : cartItems) {
                int availableStock = StockMovementDAO.getAvailableStock(item.getProductId());
                if (availableStock < item.getQuantity()) {
                    conn.rollback();
                    throw new SQLException("Stock insuffisant pour le produit ID: " + item.getProductId());
                }
            }

            // Créer des commandes individuelles pour chaque article
            String sqlInsertOrder = "INSERT INTO `ORDER` (IDUSER, IDCART, PARENTORDER) VALUES (?, ?, ?)";
            psOrder = conn.prepareStatement(sqlInsertOrder);

            for (UserCart item : cartItems) {
                psOrder.setInt(1, userId);
                psOrder.setInt(2, item.getId());
                psOrder.setInt(3, globalOrderId);
                psOrder.addBatch();
            }
            psOrder.executeBatch();

            // Mettre à jour le stock et enregistrer les mouvements
            for (UserCart item : cartItems) {
                boolean stockUpdated = StockMovementDAO.removeStock(item.getProductId(), item.getQuantity());
                if (!stockUpdated) {
                    conn.rollback();
                    throw new SQLException(
                            "Erreur lors de la mise à jour du stock pour le produit ID: " + item.getProductId());
                }
            }

            // Marquer les articles du panier comme achetés
            String sqlUpdateCart = "UPDATE USER_CART SET BOUGHTON = ? WHERE ID = ?";
            psCart = conn.prepareStatement(sqlUpdateCart);
            for (UserCart item : cartItems) {
                psCart.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
                psCart.setInt(2, item.getId());
                psCart.addBatch();
            }
            psCart.executeBatch();

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            return false;
        } finally {
            if (psOrder != null)
                psOrder.close();
            if (psCart != null)
                psCart.close();
            if (conn != null)
                conn.close();
        }
    }

    
}
