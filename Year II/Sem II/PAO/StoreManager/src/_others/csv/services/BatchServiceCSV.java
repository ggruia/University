package _others.csv.services;

import _others.csv.classes.BatchCSV;
import components.batch.models.BatchProductModel;
import utilities.date.DateService;
import utilities.pair.Pair;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDate;
import java.util.*;

public class BatchServiceCSV implements IBatchService, IServiceCSV<BatchCSV> {
    private static BatchServiceCSV instance = null;
    private final Map<Integer, BatchCSV> batches = new HashMap<>();

    public BatchServiceCSV() {}

    public static BatchServiceCSV getInstance() throws IOException {
        if (instance == null)
        {
            instance = new BatchServiceCSV();
            instance.fromCSV();
        }
        return instance;
    }


    @Override
    public void fromCSV() throws IOException {
        BufferedReader br = new BufferedReader(new FileReader("csv/batches.csv"));
        br.readLine();

        String line;

        while ((line = br.readLine()) != null) {
            String[] csv = line.split(", ");
            var record = new BatchCSV(
                    Integer.parseInt(csv[0]),
                    Integer.parseInt(csv[1]),
                    Integer.parseInt(csv[2]),
                    LocalDate.parse(csv[3])
            );
            this.batches.put(record.getId(), record);
        }
    }

    @Override
    public void toCSV(BatchCSV batch) throws IOException {
        var record = String.format("%d, %d, %d, %s\n",
                batch.getId(),
                batch.getSupplyId(),
                batch.getQuantity(),
                batch.getShipmentDate());

        FileWriter writer = new FileWriter("csv/batches.csv", true);
        writer.append(record);
        writer.flush();
    }


    public List<BatchProductModel> getProducts(int supplierId) throws IOException {
        var productService = ProductServiceCSV.getInstance();
        var productSupplierService = ProductSupplierServiceCSV.getInstance();
        return getInstance().getAll()
                .stream()
                .filter(x -> productSupplierService.get(x.getSupplyId()).getSupplierId() == supplierId)
                .map(x -> new BatchProductModel(
                        productService.get(productSupplierService.get(x.getSupplyId()).getProductId()),
                        productSupplierService.get(x.getSupplyId()).getPrice(),
                        x.getQuantity()))
                .toList();
    }

    public List<BatchProductModel> getExp(int supplierId) throws IOException {
        var productService = ProductServiceCSV.getInstance();
        var productSupplierService = ProductSupplierServiceCSV.getInstance();
        var dateService = DateService.getInstance();
        return getInstance().getAll()
                .stream()
                .filter(x -> productSupplierService
                        .get(x.getSupplyId())
                        .getSupplierId() == supplierId)
                .filter(x ->
                        dateService.hasPassed(
                                x.getShipmentDate(),
                                productService
                                        .get(productSupplierService
                                                .get(x.getSupplyId())
                                                .getProductId())
                                        .getExpirationPeriod()))
                .map(x -> new BatchProductModel(
                        productService
                                .get(productSupplierService
                                        .get(x.getSupplyId())
                                        .getProductId()),
                        productSupplierService
                                .get(x.getSupplyId())
                                .getPrice(),
                        x.getQuantity()))
                .toList();
    }

    public List<BatchProductModel> getAllExp() throws IOException {
        var productService = ProductServiceCSV.getInstance();
        var productSupplierService = ProductSupplierServiceCSV.getInstance();
        var dateService = DateService.getInstance();
        return getInstance().getAll()
                .stream()
                .filter(x ->
                        dateService.hasPassed(
                                x.getShipmentDate(),
                                productService
                                        .get(productSupplierService
                                                .get(x.getSupplyId())
                                                .getProductId())
                                        .getExpirationPeriod()))
                .map(x -> new BatchProductModel(
                        productService
                                .get(productSupplierService
                                        .get(x.getSupplyId())
                                        .getProductId()),
                        productSupplierService
                                .get(x.getSupplyId())
                                .getPrice(),
                        x.getQuantity()))
                .toList();
    }

    public Pair<Float, Float> getPrices(int id) throws IOException {
        var productSupplierService = ProductSupplierServiceCSV.getInstance();
        var productService = ProductServiceCSV.getInstance();

        var productSupplierPrice = productSupplierService
                .get(get(id)
                        .getSupplyId())
                .getPrice() * get(id).getQuantity();
        var productPrice = productService
                .get(productSupplierService
                        .get(get(id)
                                .getSupplyId())
                        .getProductId())
                .getPrice() * get(id).getQuantity();

        return new Pair<Float, Float>(productPrice, productSupplierPrice);
    }

    public Pair<Float, Float> getTotalPrices() {
        return getAll()
                .stream()
                .map(BatchCSV::getId)
                .map(x -> {
                    try {
                        return getPrices(x);
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                })
                .reduce(new Pair<Float, Float>(0f, 0f), (x, y) ->
                        new Pair<Float, Float>(
                                x.first() + y.first(),
                                x.second() + y.second()));
    }

    @Override
    public BatchCSV get(int id) {
        return batches.get(id);
    }

    @Override
    public List<BatchCSV> getAll() {
        return new ArrayList<>(batches.values());
    }

    @Override
    public void add(BatchCSV batch) throws IOException {
        batches.put(batch.getId(), batch);
        toCSV(batch);
    }

    @Override
    public void update(BatchCSV obj) {

    }

    @Override
    public void delete(int id) {

    }
}
