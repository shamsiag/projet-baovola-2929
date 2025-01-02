package assets;

public class Product {
    private int id;
    private String name;
    private String description;
    private String picture;
    private int categoryId;
    private double price;
    public Product() {
    }

    public Product(int id, String name, String description, String picture, int categoryId) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.picture = picture;
        this.categoryId = categoryId;
    }

    public Product(int id, String name, String description, String picture, int categoryId, double price) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.picture = picture;
        this.categoryId = categoryId;
        this.price = price;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}
