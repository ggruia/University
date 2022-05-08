package menus.categories;

import components.audit.Action;
import components.audit.AuditService;
import components.category.Category;
import components.category.CategoryService;
import menus.Help;

import java.sql.SQLException;
import java.util.*;

public class CategoriesMenu {
    static Map<String, String> actionsMap = new LinkedHashMap<>();

    private static void populateMap() {
        if (actionsMap.isEmpty()) {
            actionsMap.put("get", "Show specified Product");
            actionsMap.put("get all", "Show all Products");
            actionsMap.put("add", "Create and add a new Product");
            actionsMap.put("update", "Update specified Product");
            actionsMap.put("delete", "Delete specified Product");
            actionsMap.put("get products", "Show all Products of specified Category");
        }
    }



    public static void showMenu(Scanner sc, AuditService auditService) throws SQLException {
        boolean isRunning = true;
        populateMap();
        var actionsList = new ArrayList<>(actionsMap.keySet());
        var categoryService = CategoryService.getInstance();
        Help.printHelp("CATEGORIES", actionsMap);

        while(isRunning) {
            System.out.println("Input action or 'help' to see CATEGORY actions:");
            String action = sc.nextLine();
            try {
                var command = Integer.parseInt(action);
                if (actionsMap.size() >= command)
                    auditService.log(new Action("CATEGORIES", actionsList.get(command - 1)));
            } catch (NumberFormatException e) {
                if (actionsMap.containsKey(action))
                    auditService.log(new Action("CATEGORIES", action));
                else if (Objects.equals(action, "?") || Objects.equals(action, "help"))
                    auditService.log(new Action("CATEGORIES", "help"));
                else if (Objects.equals(action, "!") || Objects.equals(action, "exit"))
                    auditService.log(new Action("CATEGORIES", "exit"));
            }

            switch (action) {
                case "get", "1" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    var category = categoryService.get(id);
                    System.out.println(category);
                }
                case "get all", "2" -> categoryService.getAll().forEach(System.out::println);
                case "add", "3" -> categoryService.add(new Category(sc));
                case "update", "4" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    var category = categoryService.get(id);
                    var newCategory = new Category(sc);
                    categoryService.update(new Category(category, newCategory));
                }
                case "delete", "5" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    categoryService.delete(id);
                }
                case "get products", "6" -> {
                    System.out.println("Enter Category ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    categoryService.getProducts(id).forEach(System.out::println);
                }
                case "help", "?" -> Help.printHelp("CATEGORIES", actionsMap);
                case "exit", "!" -> isRunning = false;
                default -> System.out.println("Wrong input!");
            }
        }
    }
}
