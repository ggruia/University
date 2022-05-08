package components.product;

import components.category.Category;
import components.category.CategoryService;
import utilities.jdbc.JDBCServiceInterface;
import utilities.jdbc.JDBCService;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class ProductService implements JDBCServiceInterface<Product> {
    private static ProductService instance = null;
    private ProductService() {}

    public static ProductService getInstance() {
        if (instance == null)
            instance = new ProductService();
        return instance;
    }



    @Override
    public Product get(int id) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = "SELECT * FROM products WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(sql);
        prep.setInt(1, id);
        prep.execute();
        var rs = prep.getResultSet();
        rs.next();
        return new Product(rs);
    }

    @Override
    public List<Product> getAll() throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = "SELECT * FROM products";

        ResultSet rs = jdbcService.getStatement().executeQuery(sql);
        var records = new ArrayList<Product>();
        while(rs.next()) {
            var record = new Product(rs);
            records.add(record);
        }
        return records;
    }


    @Override
    public void add(Product product) throws SQLException {
        CategoryService.getInstance().get(product.getCategoryId());
        var jdbcService = JDBCService.getInstance();
        String query = "INSERT INTO products (name, price, expDays, description, categoryId) VALUES (?, ?, ?, ?, ?)";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setString(1, product.getName());
        prep.setFloat(2, product.getPrice());
        prep.setInt(3, product.getExpirationPeriod());
        prep.setString(4, product.getDescription());
        prep.setInt(5, product.getCategoryId());
        prep.execute();
        prep.close();
    }

    @Override
    public void update(Product product) throws SQLException {
        get(product.getId());
        var jdbcService = JDBCService.getInstance();
        String query = "UPDATE products SET name = ?, price = ?, expDays = ?, description = ?, categoryId = ? WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setString(1, product.getName());
        prep.setFloat(2, product.getPrice());
        prep.setInt(3, product.getExpirationPeriod());
        prep.setString(4, product.getDescription());
        prep.setInt(5, product.getCategoryId());
        prep.setInt(6, product.getId());
        prep.executeUpdate();
        prep.close();
    }

    @Override
    public void delete(int id) throws SQLException {
        get(id);
        var jdbcService = JDBCService.getInstance();
        String query = "DELETE FROM products WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setInt(1, id);
        prep.execute();
        prep.close();
    }



    public Category getCategory(int id) throws SQLException {
        get(id);
        var jdbcService = JDBCService.getInstance();
        String sql = "SELECT * FROM categories WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(sql);
        prep.setInt(1, id);
        prep.execute();
        var rs = prep.getResultSet();
        rs.next();
        return new Category(rs);
    }

    public int getQuantity(int id) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = """
                SELECT IFNULL(SUM(b.quantity), 0)
                FROM batches b
                JOIN supplies s ON s.id = b.supplyId
                JOIN products p ON p.id = s.productId
                WHERE p.id = ?
                """;

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(sql);
        prep.setInt(1, id);
        prep.execute();
        var rs = prep.getResultSet();
        rs.next();
        return rs.getInt(1);
    }
}
