import 'package:get/get.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/inv_item.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:mistpos/models/company_model.dart';
import 'package:mistpos/models/supplier_model.dart';
import 'package:mistpos/models/production_model.dart';
import 'package:mistpos/services/network_wrapper.dart';
import 'package:mistpos/models/product_stats_model.dart';
import 'package:mistpos/models/item_unsaved_model.dart';
import 'package:mistpos/models/transfer_order_model.dart';
import 'package:mistpos/models/purchase_order_model.dart';
import 'package:mistpos/models/exchange_rate_model.dart';
import 'package:mistpos/models/inventory_child_count.dart';
import 'package:mistpos/models/inventory_count_model.dart';
import 'package:mistpos/models/stock_adjustment_model.dart';
import 'package:mistpos/models/inventory_history_model.dart';

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

  Future<bool> updateSupplier(Map<String, dynamic> data, String id) async {
    final result = await Net.put("/admin/supplier/$id", data: data);
    if (result.hasError) {
      Toaster.showError(result.response);
      return false;
    }
    loadSuppliers();
    return true;
  }

  @override
  void onInit() {
    loadCompany();
    super.onInit();
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

  void addInvModel(ItemUnsavedModel model) {
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
  Future<void> loadSuppliers({String search = '', int page = 1}) async {
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
      final lv = usersList.map((e) => SupplierModel.fromJson(e)).toList();
      if (page == 1) {
        suppliers.assignAll(lv);
      } else {
        suppliers.addAll(lv);
      }
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
  Future<void> loadPurchaseOrders({
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
      final lv = list.map((e) => PurchaseOrderModel.fromJson(e)).toList();
      if (page == 1) {
        purchaseOrders.value = lv;
      } else {
        purchaseOrders.addAll(lv);
      }
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

  Future<PurchaseOrderModel?> receivePurchaseOrder(
    PurchaseOrderModel model,
  ) async {
    final response = await Net.put(
      "/admin/inventory/purchase-order-receive/${model.id}",
      data: model.toJson(),
    );
    if (response.hasError) {
      Toaster.showError(response.response);
      return null;
    }
    selectedSupplier.value = null;
    selectedInvItems.clear();
    loadPurchaseOrders();
    return PurchaseOrderModel.fromJson(response.body['update']);
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
  Future<void> loadStockAdjustments({
    int page = 1,
    String search = '',
    String status = '',
    String supplier = '',
  }) async {
    if (stockAdjustOrdersLoading.value) return;
    stockAdjustOrdersLoading.value = true;
    final response = await Net.get(
      "/admin/inventory/stock-adjusts?page=$page&search=$search&status=$status",
    );
    stockAdjustOrdersLoading.value = false;
    if (response.hasError) {
      return;
    }
    stockAdjustOrderPage.value = response.body['currentPage'];
    stockAdjustOrderTotalPages.value = response.body['totalPages'];
    if (response.body['list'] != null) {
      List<dynamic> list = response.body['list'];
      final lv = list.map((e) => StockAdjustmentModel.fromJson(e)).toList();
      if (page == 1) {
        stockerOrders.value = lv;
      } else {
        stockerOrders.addAll(lv);
      }
    }
  }

  Future<({bool status, List<InvItem> rejects})> addInventoryTransferOrder(
    Map<String, dynamic> data,
  ) async {
    List<InvItem> rejects = [];
    final response = await Net.post(
      "/admin/inventory/transfer-order",
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
    loadTransferOrders(page: 1);
    return (status: true, rejects: rejects);
  }

  Rx<bool> loadingTransferOrders = Rx<bool>(false);
  RxList<TransferOrderModel> transferOrders = RxList<TransferOrderModel>([]);
  RxInt transferOrderPage = RxInt(1);
  RxInt transferOrderTotalPages = RxInt(2);
  Future<void> loadTransferOrders({int page = 1, String search = ''}) async {
    if (loadingTransferOrders.value) return;
    loadingTransferOrders.value = true;
    final response = await Net.get(
      "/admin/inventory/transfer-order?page=$page&search=$search",
    );
    loadingTransferOrders.value = false;
    if (response.hasError) {
      return;
    }
    transferOrderPage.value = response.body['currentPage'];
    transferOrderTotalPages.value = response.body['totalPages'];
    if (response.body['list'] != null) {
      List<dynamic> list = response.body['list'];
      final lv = list.map((e) => TransferOrderModel.fromJson(e)).toList();
      if (page == 1) {
        transferOrders.value = lv;
      } else {
        transferOrders.addAll(lv);
      }
    }
  }

  /*
=======================================================================================
 INVENTORY COUNTS
=======================================================================================
*/

  RxList<InventoryCountModel> inventoryCounts = RxList<InventoryCountModel>([]);
  RxInt inventoryCountsPage = RxInt(1);
  RxInt inventoryCountsTotalPages = RxInt(1);
  Future<bool> addInventoryCounts(Map<String, dynamic> data) async {
    final response = await Net.post("/admin/inventory/counts", data: data);
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    selectedSupplier.value = null;
    selectedInvItems.clear();
    loadInventoriesCounts(page: 1);
    return true;
  }

  RxBool inventoryCountsLoading = RxBool(false);
  RxString inventoryCountsError = RxString("");
  Future<void> loadInventoriesCounts({
    int page = 1,
    String search = '',
    String status = '',
  }) async {
    if (inventoryCountsLoading.value) return;
    inventoryCountsLoading.value = true;
    final response = await Net.get(
      "/admin/inventory/counts?page=$page&search=$search&status=$status",
    );
    inventoryCountsLoading.value = false;
    if (response.hasError) {
      return;
    }
    inventoryCountsPage.value = response.body['currentPage'];
    inventoryCountsTotalPages.value = response.body['totalPages'];
    if (response.body['list'] != null) {
      List<dynamic> list = response.body['list'];
      final lv = list.map((e) => InventoryCountModel.fromJson(e)).toList();
      if (page == 1) {
        inventoryCounts.value = lv;
      } else {
        inventoryCounts.addAll(lv);
      }
    }
  }

  RxBool loadingInventoryCountItems = RxBool(false);
  RxList<InventoryChildCount> inventoryCountItems =
      RxList<InventoryChildCount>();
  RxString inventoryCountItemsError = RxString("");
  void loadInventoryCountItems(
    String searchFilter,
    List<String> ids, {
    bool unwrap = false,
  }) async {
    if (loadingInventoryCountItems.value) return;
    loadingInventoryCountItems.value = true;
    inventoryCountItemsError.value = "";
    final response = await Net.post(
      "/admin/products/range",
      data: {"filter": searchFilter, "ids": ids},
    );
    loadingInventoryCountItems.value = false;
    if (response.hasError) {
      inventoryCountItemsError.value = response.response;
      return;
    }
    if (response.body['list'] != null) {
      List<dynamic> list = response.body['list'];
      inventoryCountItems.value = list
          .map((e) => InventoryChildCount.fromProduct(e))
          .toList();
      if (unwrap) {
        selectedInvItems.value = list.map((e) {
          ItemModel model = ItemModel.fromJson(e);
          return InvItem(
            quantity: 1,
            sku: model.sku,
            id: model.hexId,
            cost: model.cost,
            name: model.name,
            amount: model.cost,
            barcode: model.barcode,
            inStock: model.stockQuantity,
          );
        }).toList();
      }
    }
  }

  Future<bool> updateInventoryCounts(
    Map<String, dynamic> data,
    String id,
  ) async {
    final response = await Net.put("/admin/inventory/counts/$id", data: data);
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    loadInventoriesCounts(page: 1);
    return true;
  }

  /*
   ======================================================
   PRODUCTIONS 
   ======================================================
   */
  Future<bool> addProduction(Map<String, dynamic> data) async {
    final response = await Net.post("/admin/inventory/production", data: data);
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    loadProductions(page: 1);
    return true;
  }

  RxInt productionsPage = RxInt(1);
  RxBool productionsLoading = RxBool(false);
  RxInt productionsTotalPages = RxInt(1);
  RxList<ProductionModel> productions = RxList<ProductionModel>();
  Future<void> loadProductions({int page = 1, String search = ''}) async {
    final response = await Net.get(
      "/admin/inventory/productions?page=$page&search=$search",
    );
    if (response.hasError) {
      return;
    }
    productionsPage.value = response.body['currentPage'];
    productionsTotalPages.value = response.body['totalPages'];
    if (response.body['list'] != null) {
      List<dynamic> list = response.body['list'];
      final lv = list.map((e) => ProductionModel.fromJson(e)).toList();
      if (page == 1) {
        productions.value = lv;
      } else {
        productions.addAll(lv);
      }
    }
  }

  /*
   ======================================================
   COMPANY 
   ======================================================
   */

  RxBool loadingCompany = RxBool(false);
  RxString companyError = RxString("");
  Rx<CompanyModel?> company = Rx<CompanyModel?>(null);
  void loadCompany() async {
    if (loadingCompany.value) return;
    loadingCompany.value = true;
    companyError.value = "";
    final response = await Net.get("/company");
    loadingCompany.value = false;
    if (response.hasError) {
      companyError.value = response.response;
      return;
    }
    company.value = CompanyModel.fromJson(response.body['update']);
    GetStorage storage = GetStorage();
    storage.write("company", company.value!.toJson());
  }

  Future<bool> updateCurrency(ExchangeRateModel model) async {
    final response = await Net.put(
      "/admin/company/currency",
      data: model.toJson(),
    );
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    loadCompany();
    return true;
  }

  /*
   ======================================================
   INVENTORY HISTORY 
   ======================================================
   */

  RxBool loadingInventoryHistory = RxBool(false);
  RxList<InventoryHistoryModel> inventoryHistory =
      RxList<InventoryHistoryModel>();
  Future<void> getInventoryHistory(DateTime start, DateTime end) async {
    if (loadingInventoryHistory.value) return;
    loadingInventoryHistory.value = true;
    final result = await Net.get(
      "/admin/inventory/history?endDate=${end.toIso8601String()}&startDate=${start.toIso8601String()}",
    );
    loadingInventoryHistory.value = false;
    if (result.hasError) {
      return;
    }
    if (result.body['list'] != null) {
      List<dynamic> list = result.body['list'];
      inventoryHistory.value = list
          .map((e) => InventoryHistoryModel.fromJson(e))
          .toList();
    }
  }

  /*
   ======================================================
   INVENTORY EVALUATION 
   ======================================================
   */
  RxBool loadingInventoryValuation = RxBool(false);
  Rx<StatsProductModel?> statsPoducts = Rx<StatsProductModel?>(null);
  void loadInventoryValuation({DateTime? start, DateTime? end}) async {
    if (loadingInventoryValuation.value) return;
    loadingInventoryValuation.value = true;
    final result = await Net.get(
      "/admin/inventory/evalution?startDate=${start?.toIso8601String() ?? ''}&endDate=${end?.toIso8601String() ?? ''}",
    );
    loadingInventoryValuation.value = false;
    if (result.hasError) {
      return;
    }
    statsPoducts.value = StatsProductModel.fromJson(result.body['update']);
  }

  RxBool loadingInventoryProducts = RxBool(false);
  RxInt inventoryProductsPage = RxInt(1);
  RxInt inventoryProductsTotalPages = RxInt(1);
  RxList<ItemModel> inventoryProducts = RxList<ItemModel>();
  void loadInventoryProducts({
    int page = 1,
    String search = '',
    String category = '',
  }) async {
    if (loadingInventoryProducts.value) return;
    final response = await Net.get(
      "/cashier/products?page=$page&search=$search&category=$category&salesOnly=true",
    );
    loadingInventoryProducts.value = false;
    if (response.hasError) {
      return;
    }
    inventoryProductsPage.value = response.body['currentPage'];
    inventoryProductsTotalPages.value = response.body['totalPages'];
    if (response.body['list'] != null) {
      List<dynamic> list = response.body['list'];
      inventoryProducts.value = list.map((e) => ItemModel.fromJson(e)).toList();
    }
  }

  RxBool unwrappingToIds = RxBool(false);
  void unwrapToIds(List<String> ids) {}

  RxBool mobilePaymentProcessing = RxBool(false);
  Future subscribeMobile({
    required String method,
    required double amount,
    required String subKey,
    required String phoneNumber,
  }) async {
    if (mobilePaymentProcessing.value) {
      Toaster.showError("mobile payment still processing");
      return false;
    }
    mobilePaymentProcessing.value = true;
    final response = await Net.post(
      '/admin/subscribe/paymobile',
      data: {
        "method": method,
        "amount": amount,
        "subKey": subKey,
        "phoneNumber": phoneNumber,
      },
    );
    if (response.hasError) {
      mobilePaymentProcessing.value = false;
      Toaster.showError(response.response);
      return false;
    }
    await Future.delayed(Duration(seconds: 30));
    final result = await poll(response.body['pollUrl'], subKey);
    mobilePaymentProcessing.value = false;
    return result;
  }

  RxBool webProcessingPayment = RxBool(false);
  Future<({String? redirectUrl, String? returnUrl, String? pollUrl})> payWeb(
    String method,
    double amount,
    String subKey,
  ) async {
    if (webProcessingPayment.value) {
      Toaster.showError("mobile payment still processing");
      return (redirectUrl: null, returnUrl: null, pollUrl: null);
    }
    webProcessingPayment.value = true;
    final response = await Net.post(
      '/admin/subscribe/payweb',
      data: {"method": method, "amount": amount, "subKey": subKey},
    );
    webProcessingPayment.value = false;
    if (response.hasError) {
      Toaster.showError(response.response);
      return (redirectUrl: null, returnUrl: null, pollUrl: null);
    }
    return (
      redirectUrl: response.body['redirectUrl'] as String?,
      returnUrl: response.body['returnUrl'] as String?,
      pollUrl: response.body['pollUrl'] as String?,
    );
  }

  Future<bool> poll(String pollUrl, String subKey) async {
    final poll = await Net.post(
      '/admin/subscribe/paymobile/poll',
      data: {"pollUrl": pollUrl, "subKey": subKey},
    );
    if (poll.hasError) {
      Toaster.showError(poll.response);
      return false;
    }
    if (poll.body['paid'] == true) {
      company.value = CompanyModel.fromJson(poll.body['company']);
      company.value!.saveToStorage();
      return true;
    }
    mobilePaymentProcessing.value = true;
    Toaster.showError("payment failed >> retry again in 5 seconds");
    await Future.delayed(Duration(seconds: 5));
    final poll2 = await Net.post(
      '/admin/subscribe/paymobile/poll',
      data: {"pollUrl": pollUrl},
    );
    if (poll2.hasError) {
      Toaster.showError(poll2.response);
      return false;
    }
    if (poll2.body['paid'] == true) {
      company.value = CompanyModel.fromJson(poll2.body['company']);
      company.value!.saveToStorage();
      return true;
    }
    Toaster.showError("payment reflected false");
    return false;
  }

  RxBool loadingFreeTrial = RxBool(false);
  void registerFreeTrial() async {
    if (loadingFreeTrial.value) return;
    loadingFreeTrial.value = true;
    final result = await Net.post("/admin/subscribe/freeTrial");
    loadingFreeTrial.value = false;
    if (result.hasError) {
      Toaster.showError(result.response);
      return;
    }
    company.value = CompanyModel.fromJson(result.body['company']);
    company.value!.saveToStorage();
    Toaster.showSuccess("Free trial started successfully");
    return;
  }
}
