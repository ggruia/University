package menus.suppliers;

import components.audit.Action;
import components.audit.AuditService;
import menus.Help;
import components.supplier.Supplier;
import components.supplier.SupplierService;
import components.supply.Supply;
import components.supply.SupplyService;

import java.sql.SQLException;
import java.util.*;

public class SuppliersMenu {
    static Map<String, String> actionsMap = new LinkedHashMap<>();

    private static void populateMap() {
        if (actionsMap.isEmpty()) {
            actionsMap.put("get", "Show specified Supplier");
            actionsMap.put("get all", "Show all Suppliers");
            actionsMap.put("add", "Create and add a new Supplier");
            actionsMap.put("update", "Update specified Supplier");
            actionsMap.put("delete", "Delete specified Supplier");
            actionsMap.put("add supply", "Create and add a new Supply");
            actionsMap.put("delete supply", "Delete specified Product");
            actionsMap.put("get products", "Show all Products of specified Supplier");
            actionsMap.put("get products with price", "Show all Products of specified Supplier (with Prices)");
        }
    }



    public static void showMenu(Scanner sc, AuditService auditService) throws SQLException {
        boolean isRunning = true;
        populateMap();
        var actionsList = new ArrayList<>(actionsMap.keySet());
        var supplierService = SupplierService.getInstance();
        var supplyService = SupplyService.getInstance();
        Help.printHelp("SUPPLIERS & SUPPLIES", actionsMap);

        while (isRunning) {
            System.out.println("Input action or 'help' to see SUPPLIER actions:");
            String action = sc.nextLine();
            try {
                var command = Integer.parseInt(action);
                if (actionsMap.size() >= command)
                    auditService.log(new Action("SUPPLIERS", actionsList.get(command - 1)));
            } catch (NumberFormatException e) {
                if (actionsMap.containsKey(action))
                    auditService.log(new Action("SUPPLIERS", action));
                else if (Objects.equals(action, "?") || Objects.equals(action, "help"))
                    auditService.log(new Action("SUPPLIERS", "help"));
                else if (Objects.equals(action, "!") || Objects.equals(action, "exit"))
                    auditService.log(new Action("SUPPLIERS", "exit"));
            }

            switch (action) {
                case "get", "1" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.println(supplierService.get(id));
                }
                case "get all", "2" -> supplierService.getAll().forEach(System.out::println);
                case "add", "3" -> supplierService.add(new Supplier(sc));
                case "update", "4" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    var self = supplierService.get(id);
                    var other = new Supplier(sc);
                    supplierService.update(new Supplier(self, other));
                }
                case "delete", "5" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    supplierService.delete(id);
                }
                case "add supply", "6" -> supplyService.add(new Supply(sc));
                case "delete supply", "7" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    supplyService.delete(id);
                }
                case "get products", "8" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    supplyService.getProducts(id).forEach(System.out::println);
                }
                case "get products with price", "9" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    supplyService.getProductsWithPrice(id).forEach(x ->
                            System.out.printf("ProductPrice (product: %s, price: %.2f)%n", x.first().getName(), x.second()));
                }
                case "help", "?" -> Help.printHelp("SUPPLIERS & SUPPLIES", actionsMap);
                case "exit", "!" -> isRunning = false;
                default -> System.out.println("Wrong input!");
            }
        }
    }
}
