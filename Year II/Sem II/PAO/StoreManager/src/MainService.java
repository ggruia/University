import menus.main.MainMenu;
import utilities.jdbc.JDBCService;

import java.sql.SQLException;
import java.util.Scanner;


public class MainService {
    private MainService() {}
    private static MainService instance = null;

    public static MainService getInstance() throws SQLException {
        if(instance == null)
        {
            instance = new MainService();
            JDBCService.getInstance();
        }
        return instance;
    }


    public void start(Scanner sc) throws SQLException {
        MainMenu.showActions(sc);
    }
}
