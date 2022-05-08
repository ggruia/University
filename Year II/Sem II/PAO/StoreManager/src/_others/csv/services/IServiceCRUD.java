package _others.csv.services;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public interface IServiceCRUD<T> {
    T get(int id) throws SQLException;

    List<T> getAll() throws SQLException;

    void add(T obj) throws IOException, SQLException;

    void update(T obj) throws SQLException;

    void delete(int id) throws SQLException;
}
