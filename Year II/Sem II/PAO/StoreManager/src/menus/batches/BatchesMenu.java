package menus.batches;

import components.audit.Action;
import components.audit.AuditService;
import components.batch.Batch;
import components.batch.BatchService;
import menus.Help;

import java.sql.SQLException;
import java.util.*;

public class BatchesMenu {
    static Map<String, String> actionsMap = new LinkedHashMap<>();

    private static void populateMap() {
        if (actionsMap.isEmpty()) {
            actionsMap.put("get", "Show specified Batch");
            actionsMap.put("get all", "Show all Batches");
            actionsMap.put("add", "Create and add a new Batch");
            actionsMap.put("update", "Update specified Batch");
            actionsMap.put("delete", "Delete specified Batch");
            actionsMap.put("get products", "Show all Products of specified Supplier (from Batches)");
            actionsMap.put("get exp", "Show all Products of specified Supplier that passed their ExpiryDate");
            actionsMap.put("get all exp", "Show all Products that passed their ExpiryDate");
            actionsMap.put("get prices", "Show SupplierPrice and SellerPrice of specified Supplier");
            actionsMap.put("get all prices", "Show SupplierPrice and SellerPrice");
        }
    }



    public static void showMenu(Scanner sc, AuditService auditService) throws SQLException {
        boolean isRunning = true;
        populateMap();
        var actionsList = new ArrayList<>(actionsMap.keySet());
        var batchService = BatchService.getInstance();
        Help.printHelp("BATCHES", actionsMap);

        while (isRunning) {
            System.out.println("Input action or 'help' to see BATCH actions:");
            String action = sc.nextLine();
            try {
                var command = Integer.parseInt(action);
                if (actionsMap.size() >= command)
                    auditService.log(new Action("BATCHES", actionsList.get(command - 1)));
            } catch (NumberFormatException e) {
                if (actionsMap.containsKey(action))
                    auditService.log(new Action("BATCHES", action));
                else if (Objects.equals(action, "?") || Objects.equals(action, "help"))
                    auditService.log(new Action("BATCHES", "help"));
                else if (Objects.equals(action, "!") || Objects.equals(action, "exit"))
                    auditService.log(new Action("BATCHES", "exit"));
            }

            switch (action) {
                case "get", "1" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.println(batchService.get(id));
                }
                case "get all", "2" -> batchService.getAll().forEach(System.out::println);
                case "add", "3" -> batchService.add(new Batch(sc));
                case "update", "4" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    var self = batchService.get(id);
                    var other = new Batch(sc);
                    batchService.update(new Batch(self, other));
                }
                case "delete", "5" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    batchService.delete(id);
                }
                case "get products", "6" -> {
                    System.out.println("Enter SupplierID:");
                    int id = Integer.parseInt(sc.nextLine());
                    batchService.getProducts(id).forEach(System.out::println);
                }
                case "get exp", "7" -> {
                    System.out.println("Enter SupplierID:");
                    int id = Integer.parseInt(sc.nextLine());
                    batchService.getExp(id).forEach(System.out::println);
                }
                case "get all exp", "8" -> batchService.getAllExp().forEach(System.out::println);
                case "get prices", "9" -> {
                    System.out.println("Enter SupplierID:");
                    int id = Integer.parseInt(sc.nextLine());
                    var prices = batchService.getPrices(id);
                    System.out.printf("Prices (supplier: %.2f, seller: %.2f)%n", prices.first(), prices.second());
                }
                case "get total prices", "10" -> {
                    var prices = batchService.getTotalPrices();
                    System.out.printf("TotalPrices (suppliers: %.2f, sellers: %.2f)%n", prices.first(), prices.second());
                }
                case "help", "?" -> Help.printHelp("BATCHES", actionsMap);
                case "exit", "!" -> isRunning = false;
                default -> System.out.println("Wrong input!");
            }
        }
    }
}
