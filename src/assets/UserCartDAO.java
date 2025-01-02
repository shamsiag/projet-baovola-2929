package assets;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserCartDAO {
    // Connexion à la base de données
    

    // CREATE - Ajouter un produit au panier
    public boolean addProductToCart(UserCart userCart) {
        String query = "INSERT INTO USER_CART (IDUSER, IDPRODUCT, QUANTITY, ADDEDON) VALUES (?, ?, ?, ?)";

        try (Connection conn = Connexion.connectToDatabase();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, userCart.getUserId());
            stmt.setInt(2, userCart.getProductId());
            stmt.setInt(3, userCart.getQuantity());
            stmt.setTimestamp(4, Timestamp.valueOf(userCart.getAddedOn()));

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0; // Retourne true si l'insertion a réussi

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // READ - Récupérer tous les produits du panier d'un utilisateur
    public List<UserCart> getCartItems(int userId) {
        List<UserCart> cartItems = new ArrayList<>();
        String query = "SELECT * FROM USER_CART WHERE IDUSER = ? AND DELETEDAT IS NULL";

        try (Connection conn = Connexion.connectToDatabase();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                UserCart cartItem = new UserCart(
                        rs.getInt("ID"),
                        rs.getInt("IDUSER"),
                        rs.getInt("IDPRODUCT"),
                        rs.getInt("QUANTITY"),
                        rs.getTimestamp("ADDEDON").toLocalDateTime(),
                        rs.getTimestamp("DELETEDAT") != null ? rs.getTimestamp("DELETEDAT").toLocalDateTime() : null,
                        rs.getTimestamp("BOUGHTON") != null ? rs.getTimestamp("BOUGHTON").toLocalDateTime() : null);
                cartItems.add(cartItem);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cartItems;
    }

    // READ - Récupérer un produit spécifique dans le panier d'un utilisateur
    public UserCart getCartItem(int userId, int productId) {
        String query = "SELECT * FROM USER_CART WHERE IDUSER = ? AND IDPRODUCT = ? AND DELETEDAT IS NULL";
        UserCart cartItem = null;

        try (Connection conn = Connexion.connectToDatabase();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                cartItem = new UserCart(
                        rs.getInt("ID"),
                        rs.getInt("IDUSER"),
                        rs.getInt("IDPRODUCT"),
                        rs.getInt("QUANTITY"),
                        rs.getTimestamp("ADDEDON").toLocalDateTime(),
                        rs.getTimestamp("DELETEDAT") != null ? rs.getTimestamp("DELETEDAT").toLocalDateTime() : null,
                        rs.getTimestamp("BOUGHTON") != null ? rs.getTimestamp("BOUGHTON").toLocalDateTime() : null);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cartItem;
    }

    // UPDATE - Mettre à jour la quantité d'un produit dans le panier
    public boolean updateCartItemQuantity(int cartItemId, int newQuantity) {
        String query = "UPDATE USER_CART SET QUANTITY = ?, ADDEDON = ? WHERE ID = ?";

        try (Connection conn = Connexion.connectToDatabase();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, newQuantity);
            stmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now())); // Date de mise à jour
            stmt.setInt(3, cartItemId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE - Supprimer un produit du panier
    public boolean removeProductFromCart(int cartItemId) {
        String query = "UPDATE USER_CART SET DELETEDAT = ? WHERE ID = ?";

        try (Connection conn = Connexion.connectToDatabase();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now())); // Date de suppression
            stmt.setInt(2, cartItemId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE - Vider le panier d'un utilisateur
    public boolean clearCart(int userId) {
        String query = "UPDATE USER_CART SET DELETEDAT = ? WHERE IDUSER = ? AND DELETEDAT IS NULL";

        try (Connection conn = Connexion.connectToDatabase();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now())); // Date de suppression
            stmt.setInt(2, userId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
