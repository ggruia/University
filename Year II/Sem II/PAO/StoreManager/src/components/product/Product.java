package components.product;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Objects;
import java.util.Scanner;


public class Product {
    private final int id;
    private final String name;
    private float price;
    private int expirationPeriod;
    private final String description;
    private int categoryId;

    public Product(int id, String name, float price, int expirationPeriod, String description, int categoryId) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.expirationPeriod = expirationPeriod;
        this.description = description;
        this.categoryId = categoryId;
    }

    public Product(String name, float price, int expirationPeriod, String description, int categoryId) {
        this.id = 0;
        this.name = name;
        this.price = price;
        this.expirationPeriod = expirationPeriod;
        this.description = description;
        this.categoryId = categoryId;
    }

    public Product(Product self, Product other) {
        this.id = self.getId();
        this.name = Objects.equals(other.getName(), "") ? self.getName() : other.getName();
        this.price = Objects.equals(other.getPrice(), 0f) ? self.getPrice() : other.getPrice();
        this.expirationPeriod = Objects.equals(other.getExpirationPeriod(), 0) ? self.getExpirationPeriod() : other.getExpirationPeriod();
        this.description = Objects.equals(other.getDescription(), "") ? self.getDescription() : other.getDescription();
        this.categoryId = Objects.equals(other.getCategoryId(), 0) ? self.getCategoryId() : other.getCategoryId();
    }

    public Product(Scanner sc) {
        this.id = 0;
        System.out.println("Name: ");
        this.name = sc.nextLine();
        System.out.println("Price: ");
        try {
            this.price = Float.parseFloat(sc.nextLine());
        }
        catch(NumberFormatException ex) {
            this.price = 0f;
        }
        System.out.println("Expiration period: ");
        try {
            this.expirationPeriod = Integer.parseInt(sc.nextLine());
        }
        catch(NumberFormatException ex) {
            this.expirationPeriod = 0;
        }
        System.out.println("Description: ");
        this.description = sc.nextLine();
        System.out.println("Category ID: ");
        try {
            this.categoryId = Integer.parseInt(sc.nextLine());
        }
        catch(NumberFormatException ex) {
            this.categoryId = 0;
        }
    }

    public Product(ResultSet rs) throws SQLException {
        this.id = rs.getInt(1);
        this.name = rs.getString(2);
        this.price = rs.getFloat(3);
        this.expirationPeriod = rs.getInt(4);
        this.description = rs.getString(5);
        this.categoryId = rs.getInt(6);
    }

    @Override
    public String toString() {
        return String.format("Product (id: %d, name: %s, price: %.2f, exp: %d, description: %s, categoryId: %s)",
                getId(), getName(), getPrice(), getExpirationPeriod(), getDescription(), getCategoryId());
    }

    public int getId() {
        return id;
    }
    public int getCategoryId() {
        return categoryId;
    }
    public String getName() {
        return name;
    }
    public float getPrice() {
        return price;
    }
    public int getExpirationPeriod() {
        return expirationPeriod;
    }
    public String getDescription() {
        return description;
    }
}
