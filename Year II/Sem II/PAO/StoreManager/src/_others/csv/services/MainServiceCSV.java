package _others.csv.services;

import components.category.Category;
import components.product.Product;
import components.supplier.Supplier;
import components.supply.Supply;
import _others.csv.classes.BatchCSV;
import utilities.date.DateService;


import java.io.IOException;
import java.util.List;
import java.util.Scanner;


public class MainServiceCSV {
    private MainServiceCSV() {}
    private static MainServiceCSV instance = null;

    public static MainServiceCSV getInstance() {
        if(instance == null)
            instance = new MainServiceCSV();
        return instance;
    }





    protected static List<String> actions = List.of(
            "categories",
            "products",
            "suppliers",
            "batches",
            "pass-day",
            "help",
            "stop"
    );

    protected static List<String> categoryActions = List.of(
            "get",
            "get-all",
            "get-products",
            "add",
            "update",
            "delete",
            "help",
            "exit"
    );

    protected static List<String> productActions = List.of(
            "get",
            "get-all",
            "get-entities.audit.category",
            "get-quantity",
            "add",
            "update",
            "delete",
            "help",
            "exit"
    );

    protected static List<String> supplierActions = List.of(
            "get",
            "get-all",
            "get-products",
            "get-products-with-price",
            "add",
            "add-ps",
            "update",
            "delete",
            "delete-ps",
            "help",
            "exit"
    );

    protected static List<String> batchActions = List.of(
            "get",
            "get-all",
            "get-products",
            "get-exp",
            "get-all-exp",
            "get-prices",
            "get-total-prices",
            "add",
            "update",
            "delete",
            "help",
            "exit"
    );


    private static void printHelp(List<String> act) {
        for (int i = 0; i < act.size() ; i++)
            System.out.printf("%d. %s%n", i + 1, act.get(i));
    }


    public void showCategories(Scanner sc, AuditServiceCSV auditService) throws IOException {
        boolean isRunning = true;
        var categoryService = CategoryServiceCSV.getInstance();

        while(isRunning) {
            System.out.println("Input action or 'help' to see CATEGORY actions:");
            String action = sc.nextLine().toLowerCase();
            if (categoryActions.contains(action))
                auditService.log("CATEGORIES, " + action);

            switch (action) {
                case "get" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    var category = categoryService.get(id);
                    System.out.println(category.toString());
                }
                case "get-all" -> {
                    var categories = categoryService.getAll();
                    for (var category : categories)
                        System.out.println(category.toString());
                }
                case "get-products" -> {
                    System.out.println("Enter Category ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    var products = categoryService.getProducts(id);
                    for (var product : products)
                        System.out.println(product.toString());
                }
                case "add" -> categoryService.add(new Category(sc));
                case "update" -> System.out.println("Update");
                case "delete" -> System.out.println("Delete");
                case "help" -> printHelp(categoryActions);
                case "exit" -> isRunning = false;
                default -> System.out.println("Wrong input!");
            }
        }
    }

    public void showProducts(Scanner sc, AuditServiceCSV auditService) throws IOException {
        boolean isRunning = true;
        var productService = ProductServiceCSV.getInstance();

        while(isRunning) {
            System.out.println("Input action or 'help' to see PRODUCT actions:");
            String action = sc.nextLine().toLowerCase();
            if (productActions.contains(action))
                auditService.log("PRODUCTS, " + action);

            switch (action) {
                case "get" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.println(productService.get(id).toString());
                }
                case "get-all" -> productService.getAll().forEach(System.out::println);
                case "get-entities.audit.category" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.println(productService.getCategory(id).toString());
                }
                case "get-quantity" -> System.out.println("Get quantity");
                case "add" -> productService.add(new Product(sc));
                case "update" -> System.out.println("Update");
                case "delete" -> System.out.println("Delete");
                case "help" -> printHelp(productActions);
                case "exit" -> isRunning = false;
                default -> System.out.println("Wrong input!");
            }
        }
    }

    public void showSuppliers(Scanner sc, AuditServiceCSV auditService) throws IOException {
        boolean isRunning = true;
        var supplierService = SupplierServiceCSV.getInstance();
        var productSupplierService = ProductSupplierServiceCSV.getInstance();

        while(isRunning) {
            System.out.println("Input action or 'help' to see SUPPLIER actions:");
            String action = sc.nextLine().toLowerCase();
            if (supplierActions.contains(action))
                auditService.log("SUPPLIERS, " + action);

            switch (action) {
                case "get" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.println(supplierService.get(id).toString());
                }
                case "get-all" -> supplierService.getAll().forEach(System.out::println);
                case "get-products" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    productSupplierService.getProducts(id).forEach(System.out::println);
                }
                case "get-products-with-price" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    productSupplierService.getProductsWithPrice(id).forEach(x ->
                            System.out.printf("Supply (entities.audit.product: %s, price: %.2f)%n", x.first().getName(), x.second()));
                }
                case "add" -> supplierService.add(new Supplier(sc));
                case "add-ps" -> productSupplierService.add(new Supply(sc));
                case "update" -> System.out.println("Update");
                case "delete" -> System.out.println("Delete");
                case "delete-ps" -> System.out.println("Delete ps");
                case "help" -> printHelp(supplierActions);
                case "exit" -> isRunning = false;
                default -> System.out.println("Wrong input!");
            }
        }
    }

    public void showBatches(Scanner sc, AuditServiceCSV auditService) throws IOException {
        boolean isRunning = true;
        var batchService = BatchServiceCSV.getInstance();

        while(isRunning) {
            System.out.println("Input action or 'help' to see BATCH actions:");
            String action = sc.nextLine().toLowerCase();
            if (batchActions.contains(action))
                auditService.log("BATCHES, " + action);

            switch (action) {
                case "get" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.println(batchService.get(id).toString());
                }
                case "get-all" -> batchService.getAll().forEach(System.out::println);
                case "get-products" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    batchService.getProducts(id).forEach(System.out::println);
                }
                case "get-exp" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    batchService.getExp(id).forEach(System.out::println);
                }
                case "get-all-exp" -> batchService.getAllExp().forEach(System.out::println);
                case "get-prices" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.printf("Prices (entities.audit.supplier: %.2f, seller: %.2f)%n",
                            batchService.getPrices(id).second(),
                            batchService.getPrices(id).first()
                    );
                }
                case "get-total-prices" -> {
                    System.out.printf("Prices (totalSuppliers: %.2f, totalSellers: %.2f)%n",
                            batchService.getTotalPrices().second(),
                            batchService.getTotalPrices().first()
                    );
                }
                case "add" -> batchService.add(new BatchCSV(sc));
                case "update" -> System.out.println("Update");
                case "delete" -> System.out.println("Delete");
                case "help" -> printHelp(batchActions);
                case "exit" -> isRunning = false;
                default -> System.out.println("Wrong input!");
            }
        }
    }

    public void showActions(Scanner sc) throws IOException {
        boolean isRunning = true;
        var auditService = AuditServiceCSV.getInstance();
        var dateService = DateService.getInstance();

        while(isRunning) {
            System.out.println("Input action or 'help' to see MAIN actions:");
            String action = sc.nextLine().toLowerCase();
            if (actions.contains(action))
                auditService.log("MAIN, " + action);

            switch (action) {
                case "categories" -> showCategories(sc, auditService);
                case "products" -> showProducts(sc, auditService);
                case "suppliers" -> showSuppliers(sc, auditService);
                case "batches" -> showBatches(sc, auditService);
                case "pass-day" -> dateService.passDay();
                case "help" -> printHelp(actions);
                case "stop" -> isRunning = false;
                default -> System.out.println("Wrong input!");
            }
        }
    }
}
