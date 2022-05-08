package _others.csv.services;

import components.category.Category;
import components.product.Product;

import java.io.IOException;


public interface IProductService extends IServiceCRUD<Product> {

    Category getCategory(int id) throws IOException;

    int getQuantity(int id);
}
