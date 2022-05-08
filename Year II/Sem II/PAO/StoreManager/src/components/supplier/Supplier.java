package components.supplier;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Objects;
import java.util.Scanner;

public class Supplier {
    private final int id;
    private final String name;
    private final String description;


    public Supplier(int id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
    }

    public Supplier(String name, String description) {
        this.id = 0;
        this.name = name;
        this.description = description;
    }

    public Supplier(Scanner sc) {
        this.id = 0;
        System.out.println("Name: ");
        this.name = sc.nextLine();
        System.out.println("Description: ");
        this.description = sc.nextLine();
    }

    public Supplier(ResultSet rs) throws SQLException {
        this.id = rs.getInt(1);
        this.name = rs.getString(2);
        this.description = rs.getString(3);
    }

    public Supplier(Supplier self, Supplier other) {
        this.id = self.getId();
        this.name = Objects.equals(other.getName(), "") ? self.getName() : other.getName();
        this.description = Objects.equals(other.getDescription(), "") ? self.getDescription() : other.getDescription();
    }

    @Override
    public String toString() {
        return String.format("Supplier (id: %d, name: %s, description: %s)",
                getId(), getName(), getDescription());
    }

    public int getId() {
        return id;
    }
    public String getName() {
        return name;
    }
    public String getDescription() {
        return description;
    }
}
