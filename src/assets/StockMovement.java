package assets;

import java.time.LocalDateTime;

public class StockMovement {
    private int id;
    private int productId;
    private LocalDateTime LocalDateTimeMovement;
    private int quantity;

    public StockMovement() {
    }

    public StockMovement(int id, int productId, LocalDateTime LocalDateTimeMovement, int quantity) {
        this.id = id;
        this.productId = productId;
        this.LocalDateTimeMovement = LocalDateTimeMovement;
        this.quantity = quantity;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public LocalDateTime getLocalDateTimeMovement() {
        return LocalDateTimeMovement;
    }

    public void setLocalDateTimeMovement(LocalDateTime LocalDateTimeMovement) {
        this.LocalDateTimeMovement = LocalDateTimeMovement;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
