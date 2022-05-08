package components.batch;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Objects;
import java.util.Scanner;

public class Batch {
    private final int id;
    private int supplyId;
    private int quantity;
    private final LocalDate shipmentDate;

    public Batch(int id, int supplyId, int quantity, LocalDate shipmentDate) {
        this.id = id;
        this.supplyId = supplyId;
        this.quantity = quantity;
        this.shipmentDate = shipmentDate;
    }

    public Batch(Scanner sc) {
        this.id = 0;
        System.out.println("Supply ID:");
        try {
            this.supplyId = Integer.parseInt(sc.nextLine());
        } catch (NumberFormatException e) {
            this.supplyId = 0;
        }
        System.out.println("Quantity:");
        try {
            this.quantity = Integer.parseInt(sc.nextLine());
        } catch (NumberFormatException e) {
            this.quantity = 0;
        }
        this.shipmentDate = null;
    }

    public Batch(ResultSet rs) throws SQLException {
        this.id = rs.getInt(1);
        this.supplyId = rs.getInt(2);
        this.quantity = rs.getInt(3);
        this.shipmentDate = rs.getDate(4).toLocalDate();
    }

    public Batch(Batch self, Batch other) {
        this.id = self.getId();
        this.supplyId = self.getSupplyId();
        this.quantity = Objects.equals(other.getQuantity(), 0) ? self.getQuantity() : other.getQuantity();
        this.shipmentDate = self.getShipmentDate();
    }

    @Override
    public String toString() {
        return String.format("Batch (id: %d, supplyId: %d, quantity: %d, shipmentDate: %s)",
                getId(), getSupplyId(), getQuantity(), getShipmentDate());
    }

    public int getId() {
        return id;
    }
    public int getSupplyId() {
        return supplyId;
    }
    public int getQuantity() {
        return quantity;
    }
    public LocalDate getShipmentDate() {
        return shipmentDate;
    }
}
