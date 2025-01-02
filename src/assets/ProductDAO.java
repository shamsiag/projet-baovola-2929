package assets;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public static String addProduct(Product product) {
        String message = "";

        try {
            Connection conn = Connexion.connectToDatabase();

            // Préparer la requête SQL pour insérer un nouveau produit
            String query = "INSERT INTO PRODUCT (NAME, DESCRIPTION, PICTURE, IDCATEGORY) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setString(3, product.getPicture());
            stmt.setInt(4, product.getCategoryId());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                message = "Produit ajouté avec succès.";
            } else {
                message = "Erreur lors de l'ajout du produit.";
            }

            // Fermer les ressources
            stmt.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
            message = "Erreur SQL : " + e.getMessage();
        } catch (Exception e) {
            e.printStackTrace();
            message = "Erreur générale : " + e.getMessage();
        }

        return message;
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();

        // Connexion à la base de données
        try (Connection conn = Connexion.connectToDatabase();
                Statement stmt = conn.createStatement()) {

            // SQL pour récupérer tous les produits avec leur prix le plus récent
            String query = "SELECT p.ID, p.NAME, p.DESCRIPTION, p.PICTURE, p.IDCATEGORY, pr.PRICEVALUE, pr.ADDEDON " +
                    "FROM PRODUCT p " +
                    "LEFT JOIN PRICE pr ON p.ID = pr.IDPRODUCT " +
                    "WHERE pr.ADDEDON = (SELECT MAX(ADDEDON) FROM PRICE WHERE IDPRODUCT = p.ID)";

            ResultSet rs = stmt.executeQuery(query);

            // Parcours des résultats
            while (rs.next()) {
                int productId = rs.getInt("ID");
                String productName = rs.getString("NAME");
                String productDescription = rs.getString("DESCRIPTION");
                String productPicture = rs.getString("PICTURE");
                int productCategory = rs.getInt("IDCATEGORY");
                double productPrice = rs.getDouble("PRICEVALUE");
                Product product = new Product(productId, productName, productDescription, productPicture,
                        productCategory, productPrice);
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }

    public Product getProductById(int productId) {
        Product product = null;
        try (Connection conn = Connexion.connectToDatabase();
                PreparedStatement stmt = conn.prepareStatement(
                        "SELECT p.ID, p.NAME, p.DESCRIPTION, p.PICTURE, p.IDCATEGORY, pr.PRICEVALUE, pr.ADDEDON " +
                                "FROM PRODUCT p " +
                                "LEFT JOIN PRICE pr ON p.ID = pr.IDPRODUCT " +
                                "WHERE p.ID = ? " +
                                "AND pr.ADDEDON = (SELECT MAX(ADDEDON) FROM PRICE WHERE IDPRODUCT = p.ID)")) {

            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String productName = rs.getString("NAME");
                String productDescription = rs.getString("DESCRIPTION");
                String productPicture = rs.getString("PICTURE");
                int productCategory = rs.getInt("IDCATEGORY");
                double productPrice = rs.getDouble("PRICEVALUE");

                product = new Product(productId, productName, productDescription, productPicture, productCategory,
                        productPrice);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return product;
    }

    public List<Product> searchProducts(String query) {
        List<Product> products = new ArrayList<>();

        try (Connection conn = Connexion.connectToDatabase();
                PreparedStatement stmt = conn.prepareStatement(
                        "SELECT p.ID, p.NAME, p.DESCRIPTION, p.PICTURE, p.IDCATEGORY, pr.PRICEVALUE, pr.ADDEDON " +
                                "FROM PRODUCT p " +
                                "LEFT JOIN PRICE pr ON p.ID = pr.IDPRODUCT " +
                                "WHERE p.NAME LIKE ? OR p.IDCATEGORY IN (SELECT ID FROM CATEGORY WHERE NAME LIKE ?) OR p.DESCRIPTION LIKE ?"
                                +
                                "ORDER BY p.NAME")) {

            // Préparer les valeurs de recherche, pour rechercher par nom ou par catégorie
            String searchQuery = "%" + query + "%"; // Ajouter les % pour le LIKE SQL
            stmt.setString(1, searchQuery);
            stmt.setString(2, searchQuery);
            stmt.setString(3, searchQuery);

            ResultSet rs = stmt.executeQuery();

            // Récupérer les produits correspondants
            while (rs.next()) {
                int id = rs.getInt("ID");
                String name = rs.getString("NAME");
                String description = rs.getString("DESCRIPTION");
                String picture = rs.getString("PICTURE");
                int categoryId = rs.getInt("IDCATEGORY");
                double price = rs.getDouble("PRICEVALUE");

                products.add(new Product(id, name, description, picture, categoryId, price));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }
}