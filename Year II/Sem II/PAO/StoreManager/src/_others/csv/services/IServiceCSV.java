package _others.csv.services;


import java.io.IOException;

public interface IServiceCSV<T> {
    void toCSV(T obj) throws IOException;
    void fromCSV() throws IOException;
}
