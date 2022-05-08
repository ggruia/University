package _others.csv.services;

import java.sql.SQLException;

public interface IAuditService<T> {
    void log(T obj) throws SQLException;
}
