package components.supply;

import components.product.Product;
import utilities.jdbc.JDBCServiceInterface;
import utilities.jdbc.JDBCService;
import utilities.pair.Pair;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SupplyService implements JDBCServiceInterface<Supply> {
    private SupplyService() {}
    private static SupplyService instance = null;

    public static SupplyService getInstance() {
        if (instance == null)
            instance = new SupplyService();
        return instance;
    }


    @Override
    public Supply get(int id) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = "SELECT * FROM supplies WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(sql);
        prep.setInt(1, id);
        prep.execute();
        prep.getResultSet().next();
        return new Supply(prep.getResultSet());
    }

    @Override
    public List<Supply> getAll() throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = "SELECT * FROM supplies";

        ResultSet rs = jdbcService.getStatement().executeQuery(sql);
        var records = new ArrayList<Supply>();
        while(rs.next()) {
            var record = new Supply(rs);
            records.add(record);
        }
        return records;
    }


    @Override
    public void add(Supply supply) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String query = "INSERT INTO supplies (supplierId, productId, price) VALUES (?, ?, ?)";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setInt(1, supply.getSupplierId());
        prep.setInt(2, supply.getProductId());
        prep.setFloat(3, supply.getPrice());
        prep.execute();
        prep.close();
    }

    @Override
    public void update(Supply supply) throws SQLException {
        get(supply.getId());
        var jdbcService = JDBCService.getInstance();
        String query = "UPDATE supplies SET price = ? WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setFloat(1, supply.getPrice());
        prep.setInt(2, supply.getId());
        prep.executeUpdate();
        prep.close();
    }

    @Override
    public void delete(int id) throws SQLException {
        get(id);
        var jdbcService = JDBCService.getInstance();
        String query = "DELETE FROM supplies WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setInt(1, id);
        prep.execute();
        prep.close();
    }



    public List<Product> getProducts(int id) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = """
                SELECT p.*
                FROM suppliers sr
                JOIN supplies s ON s.supplierId = sr.id
                JOIN products p ON s.productId = p.id
                WHERE sr.id = ?
                """;

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(sql);
        prep.setInt(1, id);

        prep.execute();
        var rs = prep.getResultSet();
        var records = new ArrayList<Product>();
        while(rs.next()) {
            var record = new Product(rs);
            records.add(record);
        }
        return records;
    }

    public List<Pair<Product, Float>> getProductsWithPrice(int id) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = """
                SELECT p.*, s.price
                FROM suppliers sr
                JOIN supplies s ON s.supplierId = sr.id
                JOIN products p ON s.productId = p.id
                WHERE sr.id = ?
                """;

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(sql);
        prep.setInt(1, id);
        prep.execute();
        var rs = prep.getResultSet();
        var records = new ArrayList<Pair<Product, Float>>();
        while(rs.next()) {
            var record = new Pair<>(new Product(rs), rs.getFloat(7));
            records.add(record);
        }
        return records;
    }
}
