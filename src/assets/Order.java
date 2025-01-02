package assets;

public class Order {
    private int id;
    private int userId;
    private int cartId;
    private Integer parentOrderId;

    public Order() {
    }

    public Order(int id, int userId, int cartId, Integer parentOrderId) {
        this.id = id;
        this.userId = userId;
        this.cartId = cartId;
        this.parentOrderId = parentOrderId;
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

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public Integer getParentOrderId() {
        return parentOrderId;
    }

    public void setParentOrderId(Integer parentOrderId) {
        this.parentOrderId = parentOrderId;
    }
}
