package utilities.jdbc;

import java.sql.SQLException;
import java.util.List;

public interface JDBCServiceInterface<T> {
    T get(int id) throws SQLException;

    List<T> getAll() throws SQLException;

    void add(T record) throws SQLException;

    void update(T record) throws SQLException;

    void delete(int id) throws SQLException;
}