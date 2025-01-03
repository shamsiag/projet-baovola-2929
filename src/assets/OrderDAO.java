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
            conn = Connexion.connectToDatabase();// Start transaction

            // Créer une commande globale
            OrderGlobalDAO orderGlobalDAO = new OrderGlobalDAO();
            double totalValue = cartItems.stream()
                    .mapToDouble(item -> item.getPrice() * item.getQuantity())
                    .sum();
            boolean globalOrderCreated = orderGlobalDAO.createOrderGlobal(userId, totalValue, 1);

            if (!globalOrderCreated) {
                conn.rollback();
                return false;
            }

            // Récupérer l'ID de la commande globale créée
            String sqlLastInsertId = "SELECT LAST_INSERT_ID()";
            try (Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(sqlLastInsertId)) {
                if (!rs.next()) {
                    conn.rollback();
                    return false;
                }
                int globalOrderId = rs.getInt(1);

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
            }
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null)
                    conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            return false;
        }
    }
}
