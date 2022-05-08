package components.audit;

import utilities.jdbc.JDBCService;

import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AuditService {
    private AuditService() {}
    private static AuditService instance = null;

    public static AuditService getInstance() {
        if(instance == null)
            instance = new AuditService();
        return instance;
    }

    public void log(Action action) throws SQLException {
        var jdbcService = JDBCService.getInstance();
        String query = "INSERT INTO audit (context, action) VALUES (?, ?)";

        PreparedStatement prep = jdbcService.getConnection().prepareStatement(query);
        prep.setString(1, action.getContext());
        prep.setString(2, action.getAction());
        prep.execute();
        prep.close();
    }
}
