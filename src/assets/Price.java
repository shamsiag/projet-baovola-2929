package assets;

import java.time.LocalDateTime;

public class Price {
    private int id;
    private int productId;
    private double priceValue;
    private LocalDateTime addedOn;
    private LocalDateTime deletedOn;

    public Price() {
    }

    public Price(int id, int productId, double priceValue, LocalDateTime addedOn, LocalDateTime deletedOn) {
        this.id = id;
        this.productId = productId;
        this.priceValue = priceValue;
        this.addedOn = addedOn;
        this.deletedOn = deletedOn;
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

    public double getPriceValue() {
        return priceValue;
    }

    public void setPriceValue(double priceValue) {
        this.priceValue = priceValue;
    }

    public LocalDateTime getAddedOn() {
        return addedOn;
    }

    public void setAddedOn(LocalDateTime addedOn) {
        this.addedOn = addedOn;
    }

    public LocalDateTime getDeletedOn() {
        return deletedOn;
    }

    public void setDeletedOn(LocalDateTime deletedOn) {
        this.deletedOn = deletedOn;
    }
}
