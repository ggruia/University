package menus.products;

import components.audit.Action;
import components.audit.AuditService;
import menus.Help;
import components.product.Product;
import components.product.ProductService;

import java.sql.SQLException;
import java.util.*;

public class ProductsMenu {
    static Map<String, String> actionsMap = new LinkedHashMap<>();

    private static void populateMap() {
        if (actionsMap.isEmpty()) {
            actionsMap.put("get", "Show specified Product");
            actionsMap.put("get all", "Show all Products");
            actionsMap.put("add", "Create and add a new Product");
            actionsMap.put("update", "Update specified Product");
            actionsMap.put("delete", "Delete specified Product");
            actionsMap.put("get category", "Show Category of specified Product");
            actionsMap.put("get quantity", "Show Quantity of specified Product");
        }
    }



    public static void showMenu(Scanner sc, AuditService auditService) throws SQLException {
        boolean isRunning = true;
        populateMap();
        var actionsList = new ArrayList<>(actionsMap.keySet());
        var productService = ProductService.getInstance();
        Help.printHelp("PRODUCTS", actionsMap);

        while (isRunning) {
            System.out.println("Input action or 'help' to see PRODUCT actions:");
            String action = sc.nextLine();
            try {
                var command = Integer.parseInt(action);
                if (actionsMap.size() >= command)
                    auditService.log(new Action("PRODUCTS", actionsList.get(command - 1)));
            } catch (NumberFormatException e) {
                if (actionsMap.containsKey(action))
                    auditService.log(new Action("PRODUCTS", action));
                else if (Objects.equals(action, "?") || Objects.equals(action, "help"))
                    auditService.log(new Action("PRODUCTS", "help"));
                else if (Objects.equals(action, "!") || Objects.equals(action, "exit"))
                    auditService.log(new Action("PRODUCTS", "exit"));
            }

            switch (action) {
                case "get", "1" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.println(productService.get(id));
                }
                case "get all", "2" -> productService.getAll().forEach(System.out::println);
                case "add", "3" -> productService.add(new Product(sc));
                case "update", "4" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    var product = productService.get(id);
                    var newProduct = new Product(sc);
                    productService.update(new Product(product, newProduct));
                }
                case "delete", "5" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    productService.delete(id);
                }
                case "get category", "6" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.println(productService.getCategory(id));
                }
                case "get quantity", "7" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.println(productService.getQuantity(id));
                }
                case "help", "?" -> Help.printHelp("PRODUCTS", actionsMap);
                case "exit", "!" -> isRunning = false;
                default -> System.out.println("Wrong input!");
            }
        }
    }
}
