import java.sql.SQLException;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) throws SQLException {
        var mainService = MainService.getInstance();
        Scanner sc = new Scanner(System.in);

        mainService.start(sc);
    }
}
