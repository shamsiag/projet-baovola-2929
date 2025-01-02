package assets;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.http.HttpSession;


public class UserDAO {

    public static String loginUser(String username, String password, HttpSession session) {
        String redirectPage = "login.jsp";
        try {

            Connection conn = Connexion.connectToDatabase();

            String sql = "SELECT ID, NAME, ISADMIN FROM USER WHERE USERNAME = ? AND PASSWORD = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("ID");
                String name = rs.getString("NAME");
                int isAdmin = rs.getInt("ISADMIN");

                session.setAttribute("userId", userId);
                session.setAttribute("username", username);
                session.setAttribute("name", name);
                session.setAttribute("isAdmin", isAdmin);

                // Redirection en fonction du rôle
                redirectPage = (isAdmin == 1) ? "productManagement.jsp" : "index.jsp";
            } else {
                // En cas d'échec de l'authentification
                session.setAttribute("errorMessage", "Nom d'utilisateur ou mot de passe incorrect.");
            }

            // Fermeture des ressources
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return redirectPage;
    }
    
    public static void logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
    }

    public static String registerUser(String name, String username, String password) {
        String message = "";

        try {

            Connection conn = Connexion.connectToDatabase();
            String checkUserSql = "SELECT ID FROM USER WHERE USERNAME = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkUserSql);
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                message = "Le nom d'utilisateur est déjà utilisé.";
            } else {
                // Insertion du nouvel utilisateur
                String insertSql = "INSERT INTO USER (NAME, USERNAME, PASSWORD, ISADMIN) VALUES (?, ?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);

                insertStmt.setString(1, name);
                insertStmt.setString(2, username);
                insertStmt.setString(3, password);
                insertStmt.setInt(4, 0);

                int rowsInserted = insertStmt.executeUpdate();

                if (rowsInserted > 0) {
                    message = "Inscription réussie. Vous pouvez vous connecter.";
                } else {
                    message = "Échec de l'inscription. Veuillez réessayer.";
                }

                insertStmt.close();
            }

            rs.close();
            checkStmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            message = "Une erreur est survenue. Veuillez réessayer plus tard.";
        }

        return message;
    }
    
     public static User getUserDetails(int userId) {
        User user = null;
        
        try {
           
            Connection conn = Connexion.connectToDatabase();
            
            
            String query = "SELECT ID, NAME, USERNAME, PASSWORD, ISADMIN FROM USER WHERE ID = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, userId);
            
           
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = new User(
                    rs.getInt("ID"),
                    rs.getString("NAME"),
                    rs.getString("USERNAME"),
                    rs.getString("PASSWORD"),
                    rs.getInt("ISADMIN")
                );
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
}