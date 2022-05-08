package components.batch.models;

import components.product.Product;
import components.product.ProductService;

import java.sql.ResultSet;
import java.sql.SQLException;

public class BatchProductModel {
    private final Product product;
    private final float price;
    private final int quantity;

    public BatchProductModel(Product product, float price, int quantity) {
        this.product = product;
        this.price = price;
        this.quantity = quantity;
    }

    public BatchProductModel(ResultSet rs) throws SQLException {
        this.product = ProductService.getInstance().get(rs.getInt(1));
        this.price = rs.getFloat(2);
        this.quantity = rs.getInt(3);
    }

    public Product getProduct() {
        return product;
    }
    public float getPrice() {
        return price;
    }
    public int getQuantity() {
        return quantity;
    }

    @Override
    public String toString() {
        return String.format("Batch-Product (id: %d, name: %s, profit: %.2f, quantity: %d)",
                getProduct().getId(), getProduct().getName(), getPrice(), getQuantity());
    }
}
