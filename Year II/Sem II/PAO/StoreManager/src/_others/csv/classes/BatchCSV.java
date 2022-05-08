package _others.csv.classes;

import java.time.LocalDate;
import java.util.Scanner;

public class BatchCSV {
    private static int nrBatches = 0;
    private final int id;
    private final int supplyId;
    private final int quantity;
    private final LocalDate shipmentDate;

    public BatchCSV(int id, int supplyId, int quantity, LocalDate shipmentDate) {
        this.id = id;
        this.supplyId = supplyId;
        this.quantity = quantity;
        this.shipmentDate = shipmentDate;
        if(id > nrBatches)
            nrBatches++;
    }

    public BatchCSV(int supplyId, int quantity, LocalDate shipmentDate) {
        this.id = ++nrBatches;
        this.supplyId = supplyId;
        this.quantity = quantity;
        this.shipmentDate = shipmentDate;
    }

    public BatchCSV(Scanner sc) {
        this.id = ++nrBatches;
        System.out.println("Supply ID:");
        this.supplyId = Integer.parseInt(sc.nextLine());
        System.out.println("Quantity:");
        this.quantity = Integer.parseInt(sc.nextLine());
        this.shipmentDate = LocalDate.now();
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
