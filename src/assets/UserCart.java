package assets;

import java.time.LocalDateTime;

public class UserCart {
    private int id;
    private int userId;
    private int productId;
    private int quantity;
    private LocalDateTime addedOn;
    private LocalDateTime deletedAt;
    private LocalDateTime boughtOn;

    public UserCart() {
    }

    public UserCart(int id, int userId, int productId, int quantity, LocalDateTime addedOn, LocalDateTime deletedAt, LocalDateTime boughtOn) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.quantity = quantity;
        this.addedOn = addedOn;
        this.deletedAt = deletedAt;
        this.boughtOn = boughtOn;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public LocalDateTime getAddedOn() {
        return addedOn;
    }

    public void setAddedOn(LocalDateTime addedOn) {
        this.addedOn = addedOn;
    }

    public LocalDateTime getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(LocalDateTime deletedAt) {
        this.deletedAt = deletedAt;
    }

    public LocalDateTime getBoughtOn() {
        return boughtOn;
    }

    public void setBoughtOn(LocalDateTime boughtOn) {
        this.boughtOn = boughtOn;
    }
}
