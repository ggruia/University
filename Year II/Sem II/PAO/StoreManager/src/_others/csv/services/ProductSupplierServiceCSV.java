package _others.csv.services;

import components.product.Product;
import components.supply.Supply;
import utilities.pair.Pair;

import java.io.*;
import java.util.*;

public class ProductSupplierServiceCSV implements IProductSupplierService, IServiceCSV<Supply> {
    private static ProductSupplierServiceCSV instance = null;
    private final Map<Integer, Supply> productsSuppliers = new HashMap<>();

    public static ProductSupplierServiceCSV getInstance() throws IOException {
        if (instance == null)
        {
            instance = new ProductSupplierServiceCSV();
            instance.fromCSV();
        }
        return instance;
    }


    @Override
    public void fromCSV() throws IOException {
        BufferedReader br = new BufferedReader(new FileReader("csv/products_suppliers.csv"));
        br.readLine();

        String line;

        while ((line = br.readLine()) != null) {
            String[] csv = line.split(", ");
            var record = new Supply(
                    Integer.parseInt(csv[0]),
                    Integer.parseInt(csv[1]),
                    Integer.parseInt(csv[2]),
                    Float.parseFloat(csv[3])
            );
            this.productsSuppliers.put(record.getId(), record);
        }
    }

    @Override
    public void toCSV(Supply supply) throws IOException {
        var record = String.format("%d, %s, %s, %.2f\n",
                supply.getId(),
                supply.getSupplierId(),
                supply.getProductId(),
                supply.getPrice());

        FileWriter writer = new FileWriter("csv/products_suppliers.csv", true);
        writer.append(record);
        writer.flush();
    }


    @Override
    public List<Product> getProducts(int supplierId) throws IOException {
        var productService = ProductServiceCSV.getInstance();
        var productSupplierService = ProductSupplierServiceCSV.getInstance();
        return productSupplierService
                .getAll()
                .stream()
                .filter(x -> x.getSupplierId() == supplierId)
                .map(x -> productService.get(x.getProductId()))
                .toList();
    }

    @Override
    public List<Pair<Product, Float>> getProductsWithPrice(int supplierId) throws IOException {
        var productService = ProductServiceCSV.getInstance();
        var productSupplierService = ProductSupplierServiceCSV.getInstance();
        var productIds = productSupplierService
                .getAll()
                .stream()
                .filter(x -> x.getSupplierId() == supplierId)
                .map(x -> new Pair<Integer, Float>(x.getProductId(), x.getPrice()))
                .toList();
        return productIds
                .stream()
                .map(x -> new Pair<Product, Float>(productService.get(x.first()), x.second()))
                .toList();
    }

    @Override
    public Supply get(int id) {
        return productsSuppliers.get(id);
    }

    @Override
    public List<Supply> getAll() {
        return new ArrayList<>(productsSuppliers.values());
    }


    @Override
    public void add(Supply supply) throws IOException {
        productsSuppliers.put(supply.getId(), supply);
        toCSV(supply);
    }

    @Override
    public void update(Supply supply) {

    }

    @Override
    public void delete(int id) {

    }
}
