package _others.csv.services;

import components.category.Category;
import components.product.Product;

import java.io.*;
import java.util.*;

public class ProductServiceCSV implements IProductService, IServiceCSV<Product> {
    private static ProductServiceCSV instance = null;
    private final Map<Integer, Product> products = new HashMap<>();

    public static ProductServiceCSV getInstance() throws IOException {
        if (instance == null)
        {
            instance = new ProductServiceCSV();
            instance.fromCSV();
        }
        return instance;
    }


    @Override
    public void fromCSV() throws IOException {
        BufferedReader br = new BufferedReader(new FileReader("csv/products.csv"));
        br.readLine();

        String line;

        while ((line = br.readLine()) != null) {
            String[] csv = line.split(", ");
            var record = new Product(
                    Integer.parseInt(csv[0]),
                    csv[1],
                    Float.parseFloat(csv[2]),
                    Integer.parseInt(csv[3]),
                    csv[4],
                    Integer.parseInt(csv[5])
            );
            this.products.put(record.getId(), record);
        }
    }

    @Override
    public void toCSV(Product product) throws IOException {
        var record = String.format("%d, %s, %.2f, %d, %s, %d\n",
                product.getId(),
                product.getName(),
                product.getPrice(),
                product.getExpirationPeriod(),
                product.getDescription(),
                product.getCategoryId());

        FileWriter writer = new FileWriter("csv/products.csv", true);
        writer.append(record);
        writer.flush();
    }


    @Override
    public Category getCategory(int id) throws IOException {
        var categoryService = CategoryServiceCSV.getInstance();
        return categoryService.get(get(id).getCategoryId());
    }

    @Override
    public int getQuantity(int id) {
        return 0;
    }

    @Override
    public Product get(int id) {
        return products.get(id);
    }

    @Override
    public List<Product> getAll() {
        return new ArrayList<>(products.values());
    }

    @Override
    public void add(Product product) throws IOException {
        products.put(product.getId(), product);
        toCSV(product);
    }

    @Override
    public void update(Product product) {

    }

    @Override
    public void delete(int id) {

    }
}
