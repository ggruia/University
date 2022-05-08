package components.supply;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class Supply {
    private final int id;
    private int productId;
    private int supplierId;
    private float price;

    public Supply(int id, int supplierId, int productId, float price) {
        this.id = id;
        this.supplierId = supplierId;
        this.productId = productId;
        this.price = price;
    }

    public Supply(int supplierId, int productId, float price) {
        this.id = 0;
        this.productId = productId;
        this.supplierId = supplierId;
        this.price = price;
    }

    public Supply(Scanner sc) {
        this.id = 0;
        System.out.println("Supplier ID: ");
        try {
            this.supplierId = Integer.parseInt(sc.nextLine());
        } catch (NumberFormatException e) {
            this.supplierId = 0;
        }
        System.out.println("Product ID: ");
        try {
            this.productId = Integer.parseInt(sc.nextLine());
        } catch (NumberFormatException e) {
            this.productId = 0;
        }
        System.out.println("Price: ");
        try {
            this.price = Float.parseFloat(sc.nextLine());
        } catch (NumberFormatException e) {
            this.price = 0f;
        }
    }

    public Supply(ResultSet rs) throws SQLException {
        this.id = rs.getInt(1);
        this.supplierId = rs.getInt(2);
        this.productId = rs.getInt(3);
        this.price = rs.getFloat(4);
    }

    @Override
    public String toString() {
        return String.format("Supply (id: %d, supplierId: %s, productId: %s, price: %.2f)",
                getId(), getSupplierId(), getProductId(), getPrice());
    }

    public int getId() {
        return id;
    }
    public int getProductId() {
        return productId;
    }
    public int getSupplierId() {
        return supplierId;
    }
    public float getPrice() {
        return price;
    }
}
