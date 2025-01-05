package assets;

import java.time.LocalDateTime;

public class OrderGlobal {
    private int id;
    private int userId;
    private LocalDateTime orderLocalDateTime;
    private double totalValue;
    private int status;

    public OrderGlobal() {
    }

    public OrderGlobal(int id, int userId, LocalDateTime orderLocalDateTime, double totalValue, int status) {
        this.id = id;
        this.userId = userId;
        this.orderLocalDateTime = orderLocalDateTime;
        this.totalValue = totalValue;
        this.status = status;
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

    public LocalDateTime getOrderLocalDateTime() {
        return orderLocalDateTime;
    }

    public void setOrderLocalDateTime(LocalDateTime orderLocalDateTime) {
        this.orderLocalDateTime = orderLocalDateTime;
    }

    public double getTotalValue() {
        return totalValue;
    }

    public void setTotalValue(double totalValue) {
        this.totalValue = totalValue;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
