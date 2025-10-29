import 'package:get/get.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:mistpos/models/purchase_order_model.dart';
import 'package:mistpos/models/stock_adjustment_model.dart';
import 'package:mistpos/models/supplier_model.dart';
import 'package:mistpos/services/network_wrapper.dart';
import 'package:mistpos/utils/toast.dart';

class InvItem {
  String id;
  String name;
  double cost;
  int quantity;
  double amount;
  String sku;
  String barcode;
  int inStock = 1;
  InvItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.quantity,
    required this.amount,
    required this.sku,
    required this.barcode,
    this.inStock = 1,
  });
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'sku': sku,
      "name": name,
      "cost": cost,
      "amount": amount,
      "barcode": barcode,
      "inStock": inStock,
      "quantity": quantity,
    };
  }

  factory InvItem.fromJson(Map<String, dynamic> data) {
    return InvItem(
      id: data['id'],
      name: data['name'],
      cost: (data['cost'] as num?)?.toDouble() ?? 0.0,
      quantity: data['quantity'],
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      sku: data['sku'] ?? '',
      barcode: data['barcode'] ?? '',
      inStock: data['inStock'] ?? 0,
    );
  }
}

class InventoryController extends GetxController {
  RxList<SupplierModel> suppliers = RxList<SupplierModel>();
  Future<bool> addSupplier(Map<String, dynamic> data) async {
    final result = await Net.post("/admin/supplier", data: data);
    if (result.hasError) {
      Toaster.showError(result.response);
      return false;
    }
    loadSuppliers();
    return true;
  }

  RxList<InvItem> selectedInvItems = RxList<InvItem>();
  void updateInvItem(InvItem item) {
    int index = selectedInvItems.indexWhere((e) => e.id == item.id);
    if (index == -1) {
      Toaster.showError("Item not found");
      return;
    }
    selectedInvItems[index] = item;
  }

  void addInvModel(ItemModel model) {
    if (selectedInvItems.indexWhere((e) => e.id == model.hexId) != -1) {
      Toaster.showError("Item already added");
      return;
    }
    selectedInvItems.add(
      InvItem(
        quantity: 1,
        sku: model.sku,
        id: model.hexId,
        cost: model.cost,
        name: model.name,
        amount: model.cost,
        barcode: model.barcode,
        inStock: model.stockQuantity,
      ),
    );
  }

  void removeodel(InvItem item) {
    int index = selectedInvItems.indexWhere((e) => e.id == item.id);
    if (index == -1) {
      Toaster.showError("Item not found");
      return;
    }
    selectedInvItems.removeAt(index);
  }

  Rx<SupplierModel?> selectedSupplier = Rx<SupplierModel?>(null);
  RxBool suppliersLoading = RxBool(false);
  RxInt supplierPage = RxInt(1);
  RxInt supplierTotalPages = RxInt(2);
  void loadSuppliers({String search = '', int page = 1}) async {
    if (suppliersLoading.value) return;
    suppliersLoading.value = true;
    final result = await Net.get("/admin/suppliers?search=$search&page=$page");
    if (result.hasError) {
      suppliersLoading.value = false;
      return;
    }
    supplierPage.value = result.body['currentPage'] ?? 1;
    supplierTotalPages.value = result.body['totalPages'] ?? 0;
    if (result.body['list'] != null) {
      List<dynamic> usersList = result.body['list'];
      suppliers.assignAll(
        usersList.map((e) => SupplierModel.fromJson(e)).toList(),
      );
    }
    suppliersLoading.value = false;
  }

  Future<bool> addInventoryPurchaseOrder(Map<String, dynamic> data) async {
    final response = await Net.post(
      "/admin/inventory/purchase-order",
      data: data,
    );
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    selectedSupplier.value = null;
    selectedInvItems.clear();
    loadPurchaseOrders(page: 1);
    return true;
  }

  RxList<PurchaseOrderModel> purchaseOrders = RxList<PurchaseOrderModel>([]);
  RxInt purchaseOrderPage = RxInt(1);
  RxInt purchaseOrderTotalPages = RxInt(1);
  RxBool purchaseOrdersLoading = RxBool(false);
  void loadPurchaseOrders({
    int page = 1,
    String search = '',
    String status = '',
    String supplier = '',
  }) async {
    if (purchaseOrdersLoading.value) return;
    purchaseOrdersLoading.value = true;
    final response = await Net.get(
      "/admin/inventory/purchase-orders?page=$page&search=$search&status=$status&supplier=$supplier",
    );
    purchaseOrdersLoading.value = false;
    if (response.hasError) {
      return;
    }
    purchaseOrderPage.value = response.body['currentPage'];
    purchaseOrderTotalPages.value = response.body['totalPages'];
    if (response.body['list'] != null) {
      List<dynamic> list = response.body['list'];
      purchaseOrders.value = list
          .map((e) => PurchaseOrderModel.fromJson(e))
          .toList();
    }
  }

  Future<({SupplierModel? model, String message})> getSupplierById(
    String id,
  ) async {
    final response = await Net.get("/admin/supplier/$id");
    if (response.hasError) {
      return (message: response.response, model: null);
    }
    return (
      model: SupplierModel.fromJson(response.body['update']),
      message: "",
    );
  }

  Future<bool> updatePurchaseOrder(PurchaseOrderModel model) async {
    final response = await Net.put(
      "/admin/inventory/purchase-order/${model.id}",
      data: model.toJson(),
    );
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    selectedSupplier.value = null;
    selectedInvItems.clear();
    loadPurchaseOrders();
    return true;
  }

  Future<({bool status, List<InvItem> rejects})> addInventoryStockAdjustment(
    Map<String, dynamic> data,
  ) async {
    List<InvItem> rejects = [];
    final response = await Net.post(
      "/admin/inventory/stock-adjust",
      data: data,
    );
    if (response.hasError) {
      Toaster.showError(response.response);
      return (status: false, rejects: rejects);
    }
    if (response.body['rejects'] != null) {
      rejects = (response.body['rejects'] as List<dynamic>)
          .map((e) => InvItem.fromJson(e))
          .toList();
    }
    selectedSupplier.value = null;
    selectedInvItems.clear();
    loadStockAdjustments(page: 1);
    return (status: true, rejects: rejects);
  }

  RxList<StockAdjustmentModel> stockerOrders = RxList<StockAdjustmentModel>([]);
  RxInt stockAdjustOrderPage = RxInt(1);
  RxInt stockAdjustOrderTotalPages = RxInt(1);
  RxBool stockAdjustOrdersLoading = RxBool(false);
  void loadStockAdjustments({
    int page = 1,
    String search = '',
    String status = '',
    String supplier = '',
  }) async {
    if (stockAdjustOrdersLoading.value) return;
    stockAdjustOrdersLoading.value = true;
    final response = await Net.get(
      "/admin/inventory/stock-adjusts?page=$page&search=$search&status=$status&supplier=$supplier",
    );
    stockAdjustOrdersLoading.value = false;
    if (response.hasError) {
      return;
    }
    stockAdjustOrderPage.value = response.body['currentPage'];
    stockAdjustOrderTotalPages.value = response.body['totalPages'];
    if (response.body['list'] != null) {
      List<dynamic> list = response.body['list'];
      stockerOrders.value = list
          .map((e) => StockAdjustmentModel.fromJson(e))
          .toList();
    }
  }
}
