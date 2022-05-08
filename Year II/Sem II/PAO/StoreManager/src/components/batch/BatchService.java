package components.batch;

import components.batch.models.BatchProductModel;
import utilities.date.DateService;
import utilities.jdbc.JDBCServiceInterface;
import utilities.jdbc.JDBCService;
import utilities.pair.Pair;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BatchService implements JDBCServiceInterface<Batch> {
    private BatchService() {}
    private static BatchService instance = null;

    public static BatchService getInstance() {
        if (instance == null)
            instance = new BatchService();
        return instance;
    }


    @Override
    public Batch get(int id) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = "SELECT * FROM batches WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(sql);
        prep.setInt(1, id);
        prep.execute();
        prep.getResultSet().next();
        return new Batch(prep.getResultSet());
    }

    @Override
    public List<Batch> getAll() throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = "SELECT * FROM batches";

        ResultSet rs = jdbcService.getStatement().executeQuery(sql);
        var records = new ArrayList<Batch>();
        while(rs.next()) {
            var record = new Batch(rs);
            records.add(record);
        }
        return records;
    }


    @Override
    public void add(Batch record) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String query = "INSERT INTO batches (supplyId, quantity) VALUES (?, ?)";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setInt(1, record.getSupplyId());
        prep.setInt(2, record.getQuantity());
        prep.execute();
        prep.close();
    }

    @Override
    public void update(Batch record) throws SQLException {
        get(record.getId());
        var jdbcService = JDBCService.getInstance();
        String query = "UPDATE batches SET quantity = ? WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setInt(1, record.getQuantity());
        prep.setInt(2, record.getId());
        prep.executeUpdate();
        prep.close();
    }

    @Override
    public void delete(int id) throws SQLException {
        get(id);
        var jdbcService = JDBCService.getInstance();
        String query = "DELETE FROM batches WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setInt(1, id);
        prep.execute();
        prep.close();
    }



    public List<BatchProductModel> getProducts(int id) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = """
                SELECT p.id, s.price, sum(b.quantity)
                FROM products p
                JOIN supplies s ON s.productId = p.id
                JOIN batches b ON b.supplyId = s.id
                WHERE s.supplierId = ?
                GROUP BY p.id, s.price
                """;

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(sql);
        prep.setInt(1, id);
        prep.execute();
        var rs = prep.getResultSet();
        var records = new ArrayList<BatchProductModel>();
        while(rs.next()) {
            var record = new BatchProductModel(rs);
            records.add(record);
        }
        return records;
    }

    public List<BatchProductModel> getExp(int id) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        var dateService = DateService.getInstance();
        String sql = """
                SELECT p.id, p.price - s.price, SUM(b.quantity), b.shipmentDate, p.expDays
                FROM batches b
                JOIN supplies s ON s.id = b.supplyId
                JOIN products p ON s.productId = p.id
                JOIN suppliers sr ON sr.id = s.supplierId
                WHERE sr.id = ?
                GROUP BY p.id, b.shipmentDate
                HAVING DATE_ADD(b.shipmentDate, INTERVAL p.expDays DAY) < ?
                """;

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(sql);
        prep.setInt(1, id);
        prep.setDate(2, Date.valueOf(dateService.getDate()));
        prep.execute();
        var rs = prep.getResultSet();
        var records = new ArrayList<BatchProductModel>();
        while(rs.next()) {
            var record = new BatchProductModel(rs);
            records.add(record);
        }
        return records;
    }

    public List<BatchProductModel> getAllExp() throws SQLException {
        var jdbcService = JDBCService.getInstance();
        var dateService = DateService.getInstance();
        String sql = """
                SELECT p.id, p.price - s.price, SUM(b.quantity), b.shipmentDate, p.expDays
                FROM batches b
                JOIN supplies s ON s.id = b.supplyId
                JOIN products p ON s.productId = p.id
                JOIN suppliers sr ON sr.id = s.supplierId
                GROUP BY p.id, b.shipmentDate
                HAVING DATE_ADD(b.shipmentDate, INTERVAL p.expDays DAY) < ?
                """;

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(sql);
        prep.setDate(1, Date.valueOf(dateService.getDate()));
        prep.execute();
        var rs = prep.getResultSet();
        var records = new ArrayList<BatchProductModel>();
        while(rs.next()) {
            var record = new BatchProductModel(rs);
            records.add(record);
        }
        return records;
    }

    public Pair<Float, Float> getPrices(int id) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = """
                SELECT sum(b.quantity * s.price), sum(b.quantity * p.price)
                FROM batches b
                JOIN supplies s ON s.id = b.supplyId
                JOIN products p ON p.id = s.productId
                JOIN suppliers sr ON sr.id = s.supplierId
                WHERE sr.id = ?
                """;

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(sql);
        prep.setInt(1, id);
        prep.execute();
        var rs = prep.getResultSet();
        rs.next();
        return new Pair<>(rs.getFloat(1), rs.getFloat(2));
    }

    public Pair<Float, Float> getTotalPrices() throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = """
                SELECT sum(b.quantity * s.price), sum(b.quantity * p.price)
                FROM batches b
                JOIN supplies s ON s.id = b.supplyId
                JOIN products p ON p.id = s.productId
                JOIN suppliers sr ON sr.id = s.supplierId
                """;

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(sql);
        prep.execute();
        var rs = prep.getResultSet();
        rs.next();
        return new Pair<>(rs.getFloat(1), rs.getFloat(2));
    }
}
