package menus.main;

import components.audit.Action;
import components.audit.AuditService;
import menus.Help;
import menus.batches.BatchesMenu;
import menus.categories.CategoriesMenu;
import menus.products.ProductsMenu;
import menus.suppliers.SuppliersMenu;
import utilities.date.DateService;

import java.sql.SQLException;
import java.util.*;

public class MainMenu {
    static Map<String, String> actionsMap = new LinkedHashMap<>();

    private static void populateMap() {
        if (actionsMap.isEmpty()) {
            actionsMap.put("categories", "Show CATEGORIES menu");
            actionsMap.put("products", "Show PRODUCTS menu");
            actionsMap.put("suppliers", "Show SUPPLIERS and SUPPLIES menu");
            actionsMap.put("batches", "Show BATCHES menu");
            actionsMap.put("pass day", "Forward ServerDate by 1 DAY");
        }
    }



    public static void showActions(Scanner sc) throws SQLException {
        boolean isRunning = true;
        populateMap();
        var actionsList = new ArrayList<>(actionsMap.keySet());
        var auditService = AuditService.getInstance();
        var dateService = DateService.getInstance();
        Help.printHelp("MAIN", actionsMap);

        while(isRunning) {
            System.out.println("Input action or 'help' to see MAIN actions:");
            String action = sc.nextLine().toLowerCase();
            try {
                var command = Integer.parseInt(action);
                if (actionsMap.size() >= command)
                    auditService.log(new Action("MAIN", actionsList.get(command - 1)));
            } catch (NumberFormatException e) {
                if (actionsMap.containsKey(action))
                    auditService.log(new Action("MAIN", action));
                else if (Objects.equals(action, "?") || Objects.equals(action, "help"))
                    auditService.log(new Action("MAIN", "help"));
                else if (Objects.equals(action, "!") || Objects.equals(action, "exit"))
                    auditService.log(new Action("MAIN", "exit"));
            }

            switch (action) {
                case "categories", "1" -> CategoriesMenu.showMenu(sc, auditService);
                case "products", "2" -> ProductsMenu.showMenu(sc, auditService);
                case "suppliers", "3" -> SuppliersMenu.showMenu(sc, auditService);
                case "batches", "4" -> BatchesMenu.showMenu(sc, auditService);
                case "pass day", "5" -> dateService.passDay();
                case "help", "?" -> Help.printHelp("MAIN", actionsMap);
                case "exit", "!" -> isRunning = false;
                default -> System.out.println("Wrong input!");
            }
        }
    }
}
