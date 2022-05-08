package _others.csv.services;

import components.category.Category;
import components.product.Product;

import java.io.*;
import java.util.*;

public class CategoryServiceCSV implements ICategoryService, IServiceCSV<Category> {
    private static CategoryServiceCSV instance = null;
    private final Map<Integer, Category> categories = new HashMap<>();

    public static CategoryServiceCSV getInstance() throws IOException {
        if (instance == null)
        {
            instance = new CategoryServiceCSV();
            instance.fromCSV();
        }
        return instance;
    }


    @Override
    public void fromCSV() throws IOException {
        BufferedReader br = new BufferedReader(new FileReader("csv/categories.csv"));
        br.readLine();

        String line;

        while ((line = br.readLine()) != null) {
            String[] csv = line.split(", ");
            var record = new Category(
                    Integer.parseInt(csv[0]),
                    csv[1],
                    csv[2]
            );
            this.categories.put(record.getId(), record);
        }
    }

    @Override
    public void toCSV(Category category) throws IOException {
        String record = String.format("%d, %s, %s\n",
                category.getId(),
                category.getName(),
                category.getDescription());

        FileWriter writer = new FileWriter("csv/categories.csv", true);
        writer.append(record);
        writer.flush();
    }


    @Override
    public List<Product> getProducts(int categoryId) throws IOException {
        var productService = ProductServiceCSV.getInstance();
        return productService
                .getAll()
                .stream()
                .filter(x -> x.getCategoryId() == categoryId)
                .toList();
    }

    @Override
    public Category get(int id) {
        return categories.get(id);
    }

    @Override
    public List<Category> getAll() {
        return new ArrayList<>(categories.values());
    }

    @Override
    public void add(Category category) throws IOException {
        categories.put(category.getId(), category);
        toCSV(category);
    }

    @Override
    public void update(Category obj) {

    }

    @Override
    public void delete(int id) {

    }
}
