package _others;

import components.audit.Action;
import components.audit.AuditService;
import components.batch.Batch;
import components.batch.BatchService;
import components.category.Category;
import components.category.CategoryService;
import components.product.Product;
import components.product.ProductService;
import components.supplier.Supplier;
import components.supplier.SupplierService;
import components.supply.Supply;
import components.supply.SupplyService;
import utilities.date.DateService;
import utilities.jdbc.JDBCService;

import java.sql.SQLException;
import java.util.List;
import java.util.Scanner;


public class MainServiceTest {
    private MainServiceTest() {}
    private static MainServiceTest instance = null;

    public static MainServiceTest getInstance() throws SQLException, ClassNotFoundException {
        if(instance == null)
        {
            instance = new MainServiceTest();
            JDBCService.getInstance();
        }
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


    public void showCategories(Scanner sc, AuditService auditService) throws SQLException {
        boolean isRunning = true;
        var categoryService = CategoryService.getInstance();

        while(isRunning) {
            System.out.println("Input action or 'help' to see CATEGORY actions:");
            String action = sc.nextLine().toLowerCase();
            if (categoryActions.contains(action))
                auditService.log(new Action("CATEGORIES", action));

            switch (action) {
                case "get" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    var category = categoryService.get(id);
                    System.out.println(category);
                }
                case "get-all" -> categoryService.getAll().forEach(System.out::println);
                case "get-products" -> {
                    System.out.println("Enter Category ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    categoryService.getProducts(id).forEach(System.out::println);
                }
                case "add" -> categoryService.add(new Category(sc));
                case "update" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    var category = categoryService.get(id);
                    var newCategory = new Category(sc);
                    categoryService.update(new Category(category, newCategory));
                }
                case "delete" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    categoryService.delete(id);
                }
                case "help" -> printHelp(categoryActions);
                case "exit" -> isRunning = false;
                default -> System.out.println("Wrong input!");
            }
        }
    }


    public void showProducts(Scanner sc, AuditService auditService) throws SQLException {
        boolean isRunning = true;
        var productService = ProductService.getInstance();

        while(isRunning) {
            System.out.println("Input action or 'help' to see PRODUCT actions:");
            String action = sc.nextLine().toLowerCase();
            if (productActions.contains(action))
                auditService.log(new Action("PRODUCTS", action));

            switch (action) {
                case "get" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.println(productService.get(id));
                }
                case "get-all" -> productService.getAll().forEach(System.out::println);
                case "get-entities.audit.category" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.println(productService.getCategory(id));
                }
                case "get-quantity" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.println(productService.getQuantity(id));
                }
                case "add" -> productService.add(new Product(sc));
                case "update" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    var product = productService.get(id);
                    var newProduct = new Product(sc);
                    productService.update(new Product(product, newProduct));
                }
                case "delete" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    productService.delete(id);
                }
                case "help" -> printHelp(productActions);
                case "exit" -> isRunning = false;
                default -> System.out.println("Wrong input!");
            }
        }
    }


    public void showSuppliers(Scanner sc, AuditService auditService) throws SQLException {
        boolean isRunning = true;
        var supplierService = SupplierService.getInstance();
        var supplyService = SupplyService.getInstance();

        while(isRunning) {
            System.out.println("Input action or 'help' to see SUPPLIER actions:");
            String action = sc.nextLine().toLowerCase();
            if (supplierActions.contains(action))
                auditService.log(new Action("SUPPLIERS", action));

            switch (action) {
                case "get" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.println(supplierService.get(id));
                }
                case "get-all" -> supplierService.getAll().forEach(System.out::println);
                case "get-products" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    supplyService.getProducts(id).forEach(System.out::println);
                }
                case "get-products-with-price" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    supplyService.getProductsWithPrice(id).forEach(x ->
                            System.out.printf("ProductPrice (entities.audit.product: %s, price: %.2f)%n", x.first().getName(), x.second()));
                }
                case "add" -> supplierService.add(new Supplier(sc));
                case "add-ps" -> supplyService.add(new Supply(sc));
                case "update" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    var self = supplierService.get(id);
                    var other = new Supplier(sc);
                    supplierService.update(new Supplier(self, other));
                }
                case "delete" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    supplierService.delete(id);
                }
                case "delete-ps" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    supplyService.delete(id);
                }
                case "help" -> printHelp(supplierActions);
                case "exit" -> isRunning = false;
                default -> System.out.println("Wrong input!");
            }
        }
    }


    public void showBatches(Scanner sc, AuditService auditService) throws SQLException {
        boolean isRunning = true;
        var batchService = BatchService.getInstance();

        while(isRunning) {
            System.out.println("Input action or 'help' to see BATCH actions:");
            String action = sc.nextLine().toLowerCase();
            if (batchActions.contains(action))
                auditService.log(new Action("BATCHES", action));

            switch (action) {
                case "get" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    System.out.println(batchService.get(id));
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
                    var prices = batchService.getPrices(id);
                    System.out.printf("Prices (entities.audit.supplier: %.2f, seller: %.2f)%n", prices.first(), prices.second());
                }
                case "get-total-prices" -> {
                    var prices = batchService.getTotalPrices();
                    System.out.printf("TotalPrices (suppliers: %.2f, sellers: %.2f)%n", prices.first(), prices.second());
                }
                case "add" -> batchService.add(new Batch(sc));
                case "update" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    var self = batchService.get(id);
                    var other = new Batch(sc);
                    batchService.update(new Batch(self, other));
                }
                case "delete" -> {
                    System.out.println("Enter ID:");
                    int id = Integer.parseInt(sc.nextLine());
                    batchService.delete(id);
                }
                case "help" -> printHelp(batchActions);
                case "exit" -> isRunning = false;
                default -> System.out.println("Wrong input!");
            }
        }
    }


    public void showActions(Scanner sc) throws SQLException {
        boolean isRunning = true;
        var auditService = AuditService.getInstance();
        var dateService = DateService.getInstance();

        while(isRunning) {
            System.out.println("Input action or 'help' to see MAIN actions:");
            String action = sc.nextLine().toLowerCase();
            if (actions.contains(action))
                auditService.log(new Action("MAIN", action));

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
