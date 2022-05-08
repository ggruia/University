package _others.csv.services;

import components.product.Product;
import components.supply.Supply;
import utilities.pair.Pair;

import java.io.IOException;
import java.util.List;

public interface IProductSupplierService extends IServiceCRUD<Supply> {
    List<Product> getProducts(int id) throws IOException;

    List<Pair<Product, Float>> getProductsWithPrice(int supplierId) throws IOException;
}
