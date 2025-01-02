package assets;

import java.time.LocalDateTime;

public class UserFavorite {
    private int id;
    private int userId;
    private int productId;
    private LocalDateTime addedOn;
    private LocalDateTime removedOn;

    public UserFavorite() {
    }

    public UserFavorite(int id, int userId, int productId, LocalDateTime addedOn, LocalDateTime removedOn) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.addedOn = addedOn;
        this.removedOn = removedOn;
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

    public LocalDateTime getAddedOn() {
        return addedOn;
    }

    public void setAddedOn(LocalDateTime addedOn) {
        this.addedOn = addedOn;
    }

    public LocalDateTime getRemovedOn() {
        return removedOn;
    }

    public void setRemovedOn(LocalDateTime removedOn) {
        this.removedOn = removedOn;
    }
}
