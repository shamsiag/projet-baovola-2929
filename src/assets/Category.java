package assets;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Category {
    private int id;
    private String name;

    public Category() {
    }

    public Category(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Category> getAllCategories() {
    
        List<Category> categories = new ArrayList<>();
        
        try (
            
            Connection conn = Connexion.connectToDatabase();
            java.sql.Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT ID, NAME FROM CATEGORY")) {

            while (rs.next()) {
                int categoryId = rs.getInt("ID");
                String categoryName = rs.getString("NAME");
                categories.add(new Category(categoryId, categoryName));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categories;
    }
}
