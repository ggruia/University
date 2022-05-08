package components.supplier;

import utilities.jdbc.JDBCServiceInterface;
import utilities.jdbc.JDBCService;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class SupplierService implements JDBCServiceInterface<Supplier> {
    private static SupplierService instance = null;

    public static SupplierService getInstance() {
        if (instance == null)
        {
            instance = new SupplierService();
        }
        return instance;
    }


    @Override
    public Supplier get(int id) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = "SELECT * FROM suppliers WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(sql);
        prep.setInt(1, id);
        prep.execute();
        prep.getResultSet().next();
        return new Supplier(prep.getResultSet());
    }

    @Override
    public List<Supplier> getAll() throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String sql = "SELECT * FROM suppliers";

        ResultSet rs = jdbcService.getStatement().executeQuery(sql);
        var suppliers = new ArrayList<Supplier>();
        while(rs.next()) {
            var supplier = new Supplier(rs);
            suppliers.add(supplier);
        }
        return suppliers;
    }


    @Override
    public void add(Supplier supplier) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String query = "INSERT INTO suppliers (name, description) VALUES (?, ?)";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setString(1, supplier.getName());
        prep.setString(2, supplier.getDescription());
        prep.execute();
        prep.close();
    }

    @Override
    public void update(Supplier supplier) throws SQLException {
        get(supplier.getId());
        var jdbcService = JDBCService.getInstance();
        String query = "UPDATE suppliers SET name = ?, description = ? WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setString(1, supplier.getName());
        prep.setString(2, supplier.getDescription());
        prep.setInt(3, supplier.getId());
        prep.executeUpdate();
        prep.close();
    }

    @Override
    public void delete(int id) throws SQLException {
        get(id);
        var jdbcService = JDBCService.getInstance();
        String query = "DELETE FROM suppliers WHERE id = ?";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setInt(1, id);
        prep.execute();
        prep.close();
    }
}