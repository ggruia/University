package _others.csv.services;

import components.supplier.Supplier;

import java.io.*;
import java.util.*;

public class SupplierServiceCSV implements ISupplierService, IServiceCSV<Supplier> {
    private static SupplierServiceCSV instance = null;
    private final Map<Integer, Supplier> suppliers = new HashMap<>();

    public static SupplierServiceCSV getInstance() throws IOException {
        if (instance == null)
        {
            instance = new SupplierServiceCSV();
            instance.fromCSV();
        }
        return instance;
    }


    @Override
    public void fromCSV() throws IOException {
        BufferedReader br = new BufferedReader(new FileReader("csv/suppliers.csv"));
        br.readLine();

        String line;

        while ((line = br.readLine()) != null) {
            String[] csv = line.split(", ");
            var record = new Supplier(
                    Integer.parseInt(csv[0]),
                    csv[1],
                    csv[2]
            );
            this.suppliers.put(record.getId(), record);
        }
    }

    @Override
    public void toCSV(Supplier supplier) throws IOException {
        var record = String.format("%d, %s, %s\n",
                supplier.getId(),
                supplier.getName(),
                supplier.getDescription());

        FileWriter writer = new FileWriter("csv/suppliers.csv", true);
        writer.append(record);
        writer.flush();
    }


    @Override
    public Supplier get(int id) {
        return suppliers.get(id);
    }

    @Override
    public List<Supplier> getAll() {
        return new ArrayList<>(suppliers.values());
    }


    @Override
    public void add(Supplier supplier) throws IOException {
        suppliers.put(supplier.getId(), supplier);
        toCSV(supplier);
    }

    @Override
    public void update(Supplier supplier) {

    }

    @Override
    public void delete(int id) {

    }
}
