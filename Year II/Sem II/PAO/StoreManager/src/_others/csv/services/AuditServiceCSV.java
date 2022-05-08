package _others.csv.services;

import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDate;


public class AuditServiceCSV implements IAuditService<String> {
    private AuditServiceCSV() {}
    public static AuditServiceCSV instance = null;

    public static AuditServiceCSV getInstance() {
        if(instance == null)
            instance = new AuditServiceCSV();
        return instance;
    }


    public void log(String action) {
        FileWriter writer;
        try {
            writer = new FileWriter("csv/entities.audit.csv", true);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        try {
            writer.append(String.format("%s, %s\n", action, LocalDate.now()));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        try {
            writer.flush();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
