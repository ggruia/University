package components.category;

import components.product.Product;
import utilities.jdbc.JDBCService;
import utilities.jdbc.JDBCServiceInterface;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class CategoryService implements JDBCServiceInterface<Category> {
    private static CategoryService instance = null;
    public CategoryService() {}

    public static CategoryService getInstance() {
        if (instance == null)
            instance = new CategoryService();
        return instance;
    }



    @Override
    public Category get(int id) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = "SELECT * FROM categories WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(sql);
        prep.setInt(1, id);
        prep.execute();
        var rs = prep.getResultSet();
        rs.next();
        return new Category(rs);
    }

    @Override
    public List<Category> getAll() throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = "SELECT * FROM categories";

        ResultSet rs = jdbcService.getStatement().executeQuery(sql);
        var categories = new ArrayList<Category>();
        while(rs.next()) {
            var category = new Category(rs);
            categories.add(category);
        }
        return categories;
    }


    @Override
    public void add(Category category) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String query = "INSERT INTO categories (name, description) VALUES (?, ?)";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setString(1, category.getName());
        prep.setString(2, category.getDescription());
        prep.execute();
        prep.close();
    }

    @Override
    public void update(Category category) throws SQLException {
        get(category.getId());
        var jdbcService = JDBCService.getInstance();
        String query = "UPDATE categories SET name = ?, description = ? WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setString(1, category.getName());
        prep.setString(2, category.getDescription());
        prep.setInt(3, category.getId());
        prep.executeUpdate();
        prep.close();
    }

    @Override
    public void delete(int id) throws SQLException {
        get(id);
        var jdbcService = JDBCService.getInstance();
        String query = "DELETE FROM categories WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setInt(1, id);
        prep.execute();
        prep.close();
    }



    public List<Product> getProducts(int id) throws SQLException {
        get(id);
        var jdbcService = JDBCService.getInstance();
        String query = "SELECT * FROM products WHERE categoryId = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setInt(1, id);
        prep.execute();
        var rs = prep.getResultSet();
        var products = new ArrayList<Product>();
        while(rs.next()) {
            var product = new Product(rs);
            products.add(product);
        }
        return products;
    }
}
