package utilities.jdbc;

import java.sql.*;

public class JDBCService {
    private JDBCService() {}
    private static JDBCService instance = null;
    private static Connection connection;
    private static Statement statement;

    public static JDBCService getInstance() {
        if(instance == null)
        {
            instance = new JDBCService();

            String jdbcDriver = "com.mysql.cj.jdbc.Driver";
            String address = "jdbc:mysql://localhost:3036/";
            String db = "storemanagementdb";
            String username = "ggruia";
            String password = "ggruia";

            try {
                Class.forName(jdbcDriver);
            } catch (ClassNotFoundException e) {
                throw new RuntimeException(e);
            }

            try {
                connection = DriverManager.getConnection(address + db, username, password);
                statement = connection.createStatement();

                instance.createDatabase(db);

                instance.createTableAUDIT();
                instance.createTableCATEGORIES();
                instance.createTablePRODUCTS();
                instance.createTableSUPPLIERS();
                instance.createTableSUPPLIES();
                instance.createTableBATCHES();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
        return instance;
    }


    public Statement getStatement() {
        return statement;
    }

    public Connection getConnection() {
        return connection;
    }


    private void createDatabase(String db) throws SQLException {
        getStatement().execute("CREATE DATABASE IF NOT EXISTS " + db);
    }


    private void createTableAUDIT() throws SQLException {
        String sql =
                "CREATE TABLE IF NOT EXISTS audit (" +
                "context VARCHAR(30) NOT NULL," +
                "action VARCHAR(30) NOT NULL," +
                "date DATE DEFAULT (CURDATE()))";
        getStatement().execute(sql);
    }

    private void createTableCATEGORIES() throws SQLException {
        String sql =
                "CREATE TABLE IF NOT EXISTS categories (" +
                "id INT NOT NULL AUTO_INCREMENT PRIMARY KEY," +
                "name VARCHAR(30) NOT NULL," +
                "description TEXT)";
        getStatement().execute(sql);
    }

    private void createTablePRODUCTS() throws SQLException {
        String sql =
                "CREATE TABLE IF NOT EXISTS products (" +
                "id INT NOT NULL AUTO_INCREMENT PRIMARY KEY," +
                "name VARCHAR(30)," +
                "price FLOAT(2) NOT NULL," +
                "expDays INT NOT NULL," +
                "description TEXT," +
                "categoryId INT," +
                "FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE)";
        getStatement().execute(sql);
    }

    private void createTableSUPPLIERS() throws SQLException {
        String sql =
                "CREATE TABLE IF NOT EXISTS suppliers (" +
                "id INT NOT NULL AUTO_INCREMENT PRIMARY KEY," +
                "name VARCHAR(30) NOT NULL," +
                "description TEXT)";
        getStatement().execute(sql);
    }

    private void createTableSUPPLIES() throws SQLException {
        String sql =
                "CREATE TABLE IF NOT EXISTS supplies (" +
                "id INT NOT NULL AUTO_INCREMENT PRIMARY KEY," +
                "productId INT NOT NULL," +
                "supplierId INT NOT NULL," +
                "price FLOAT(2) NOT NULL," +
                "FOREIGN KEY (productId) REFERENCES products (id) ON DELETE CASCADE," +
                "FOREIGN KEY (supplierId) REFERENCES suppliers (id) ON DELETE CASCADE," +
                "UNIQUE (productId, supplierId))";
        getStatement().execute(sql);
    }

    private void createTableBATCHES() throws SQLException {
        String sql =
                "CREATE TABLE IF NOT EXISTS batches (" +
                "id INT NOT NULL AUTO_INCREMENT PRIMARY KEY," +
                "supplyId INT NOT NULL," +
                "quantity FLOAT(2) NOT NULL," +
                "shipmentDate DATE DEFAULT (CURDATE())," +
                "FOREIGN KEY (supplyId) REFERENCES supplies (id) ON DELETE CASCADE)";
        getStatement().execute(sql);
    }
}