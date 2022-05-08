package _others.csv.services;

import components.category.Category;
import components.product.Product;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public interface ICategoryService extends IServiceCRUD<Category> {
    List<Product> getProducts(int id) throws IOException, SQLException;
}
