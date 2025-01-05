package assets;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OrderGlobalDAO {

    public boolean createOrderGlobal(int userId, double totalValue, int status, Connection conn) throws SQLException {
        PreparedStatement ps = null;

        try {
            conn = Connexion.connectToDatabase();
            String sql = "INSERT INTO ORDER_GLOBAL (IDUSER, ORDERDATE, TOTALVALUE, STATUS) VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setDouble(3, totalValue);
            ps.setInt(4, status);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public OrderGlobal getOrderGlobalById(int orderId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = Connexion.connectToDatabase();
            String sql = "SELECT * FROM ORDER_GLOBAL WHERE ID = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return new OrderGlobal(
                        rs.getInt("ID"),
                        rs.getInt("IDUSER"),
                        rs.getTimestamp("ORDERDATE").toLocalDateTime(),
                        rs.getDouble("TOTALVALUE"),
                        rs.getInt("STATUS"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<OrderGlobal> getOrdersByUserId(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<OrderGlobal> orders = new ArrayList<>();

        try {
            conn = Connexion.connectToDatabase();
            String sql = "SELECT * FROM ORDER_GLOBAL WHERE IDUSER = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(new OrderGlobal(
                        rs.getInt("ID"),
                        rs.getInt("IDUSER"),
                        rs.getTimestamp("ORDERDATE").toLocalDateTime(),
                        rs.getDouble("TOTALVALUE"),
                        rs.getInt("STATUS")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    public boolean updateOrderGlobalStatus(int orderId, int newStatus) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = Connexion.connectToDatabase();
            String sql = "UPDATE ORDER_GLOBAL SET STATUS = ? WHERE ID = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, newStatus);
            ps.setInt(2, orderId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<OrderGlobal> getAllOrdersWithStatus() throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<OrderGlobal> orders = new ArrayList<>();

        try {
            conn = Connexion.connectToDatabase();
            String sql = "SELECT OG.ID, OG.IDUSER, OG.ORDERDATE, OG.TOTALVALUE, OG.STATUS " +
                    "FROM ORDER_GLOBAL OG " +
                    "ORDER BY OG.ORDERDATE DESC";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(new OrderGlobal(
                        rs.getInt("ID"),
                        rs.getInt("IDUSER"),
                        rs.getTimestamp("ORDERDATE").toLocalDateTime(),
                        rs.getDouble("TOTALVALUE"),
                        rs.getInt("STATUS")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null)
                rs.close();
            if (ps != null)
                ps.close();
            if (conn != null)
                conn.close();
        }
        return orders;
    }

    public List<OrderGlobal> getOrdersByStatus(int status) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<OrderGlobal> orders = new ArrayList<>();

        try {
            conn = Connexion.connectToDatabase();
            String sql = "SELECT OG.ID, OG.IDUSER, OG.ORDERDATE, OG.TOTALVALUE, OG.STATUS " +
                    "FROM ORDER_GLOBAL OG WHERE OG.STATUS = ? ORDER BY OG.ORDERDATE DESC";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, status);
            rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(new OrderGlobal(
                        rs.getInt("ID"),
                        rs.getInt("IDUSER"),
                        rs.getTimestamp("ORDERDATE").toLocalDateTime(),
                        rs.getDouble("TOTALVALUE"),
                        rs.getInt("STATUS")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null)
                rs.close();
            if (ps != null)
                ps.close();
            if (conn != null)
                conn.close();
        }
        return orders;
    }

    public OrderGlobal getOrderGlobalWithDetailsById(int orderId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = Connexion.connectToDatabase();
            String sql = "SELECT OG.ID, OG.IDUSER, OG.ORDERDATE, OG.TOTALVALUE, OG.STATUS " +
                    "FROM ORDER_GLOBAL OG WHERE OG.ID = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return new OrderGlobal(
                        rs.getInt("ID"),
                        rs.getInt("IDUSER"),
                        rs.getTimestamp("ORDERDATE").toLocalDateTime(),
                        rs.getDouble("TOTALVALUE"),
                        rs.getInt("STATUS"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null)
                rs.close();
            if (ps != null)
                ps.close();
            if (conn != null)
                conn.close();
        }
        return null;
    }

}
