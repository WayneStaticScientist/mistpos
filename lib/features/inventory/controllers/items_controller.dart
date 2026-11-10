import 'dart:developer';

import 'package:get/get.dart' hide Precision;
import 'package:mistpos/main.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/data/models/mini_tax.dart';
import 'package:mistpos/data/models/tax_model.dart';
import 'package:mistpos/data/models/item_model.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/data/models/shifts_model.dart';
import 'package:mistpos/data/models/company_model.dart';
import 'package:mistpos/data/models/response_model.dart';
import 'package:mistpos/data/models/discount_model.dart';
import 'package:mistpos/data/models/customer_model.dart';
import 'package:mistpos/data/models/item_saved_model.dart';
import 'package:mistpos/data/models/item_receit_item.dart';
import 'package:mistpos/data/models/app_settings_model.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/data/models/item_receit_model.dart';
import 'package:mistpos/core/utils/receipt_list_sort.dart';
import 'package:mistpos/data/models/item_modifier_model.dart';
import 'package:mistpos/data/models/item_categories_model.dart';
import 'package:mistpos/core/utils/labeller.dart' show Labeller;
import 'package:mistpos/data/models/item_saved_items_model.dart';
import 'package:mistpos/features/devices/controllers/devices_controller.dart';
import 'package:mistpos/data/models/embedded_discount_model.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/core/utils/extensions.dart';
import 'package:mistpos/core/utils/sales_tax_calculator.dart';

class ItemsController extends GetxController {
  RxDouble totalPrice = RxDouble(0);

  /// VAT amount for current cart (inclusive or exclusive mode).
  RxDouble checkoutTaxAmount = RxDouble(0);

  /// Line subtotal after discounts, before tax (same base as [SalesTaxCalculator]).
  RxDouble checkoutSubtotal = RxDouble(0);
  RxString selectedCategory = ''.obs;
  RxBool printReceitOfShift = RxBool(false);
  RxList<TaxModel> salesTaxes = <TaxModel>[].obs;
  RxList<ItemModel> cartItems = <ItemModel>[].obs;
  RxList<ShiftsModel> shifts = <ShiftsModel>[].obs;
  RxList<ItemModel> fixedItems = <ItemModel>[].obs;
  RxList<ItemModifier> modifiers = <ItemModifier>[].obs;
  Rx<ShiftsModel?> selectedShift = Rx<ShiftsModel?>(null);
  RxList<DiscountModel> discounts = <DiscountModel>[].obs;
  RxList<CustomerModel> customers = <CustomerModel>[].obs;
  RxList<ItemReceitModel> receits = <ItemReceitModel>[].obs;
  Rx<CustomerModel?> selectedCustomer = Rx<CustomerModel?>(null);
  RxList<DiscountModel> selectedDiscounts = <DiscountModel>[].obs;
  RxList<ItemCategoryModel> categories = <ItemCategoryModel>[].obs;
  RxList<ItemSavedItemsModel> savedItems = <ItemSavedItemsModel>[].obs;
  RxList<Map<String, dynamic>> checkOutItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    _loadFixedItems();
    reopenLastUnclosedShift();
    super.onInit();
  }

  @override
  void dispose() {
    if (checkOutItems.isNotEmpty) {
      DateTime now = DateTime.now();
      saveItem(
        "${now.day}-${now.month}-${now.year} : ${now.hour}:${now.minute}",
      );
    }
    super.dispose();
  }

  /*
 =================================== CATEGORY LOADING ==============================================
 */
  //get categories
  void loadCategories() {
    if (categoriesSyncing.value) return;
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    final loadedCategories = isar.itemCategoryModels.where().findAll();
    categories.assignAll(loadedCategories);
    loadCategoriesAsync();
  }

  //async categories
  RxBool categoriesSyncing = RxBool(false);
  RxString categoriesSyncingFailed = RxString("");
  Future<void> loadCategoriesAsync() async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    categoriesSyncing.value = true;
    categoriesSyncingFailed.value = "";
    final response = await Net.get("/cashier/categories");
    if (response.hasError) {
      categoriesSyncing.value = false;
      categoriesSyncingFailed.value = response.response;
      return;
    }
    List<dynamic> list = response.body['list'] as List<dynamic>? ?? [];
    List<ItemCategoryModel> models = list
        .map((e) => ItemCategoryModel.fromJson(e))
        .toList();
    await isar.write((isar) async {
      isar.itemCategoryModels.where().deleteAll();
      isar.itemCategoryModels.putAll(models);
    });
    final loadedCategories = isar.itemCategoryModels.where().findAll();
    categories.assignAll(loadedCategories);
    categoriesSyncing.value = false;
  }

  //delete category
  void deleteCategory(String id) async {
    if (deleting.value) {
      Toaster.showError("deletion in progress please wait");
      return;
    }
    deleting.value = true;
    final response = await Net.delete("/admin/category/$id");
    if (response.hasError) {
      deleting.value = false;
      Toaster.showError(response.response);
      return;
    }
    Toaster.showSuccess("category deleted");
    deleting.value = false;
    loadCategoriesAsync();
  }

  /*
 =================================== ITEMS LOADING ==============================================
 */

  //load cart items
  RxInt page = RxInt(1);
  Future<void> loadCartItems({
    int page = 1,
    String search = "",
    String category = "",
  }) async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    if (selectedCategory.value.isNotEmpty) {
      final loadedItems = isar.itemModels
          .where()
          .categoryEqualTo(selectedCategory.value)
          .nameContains(search, caseSensitive: false)
          .findAll();
      cartItems.assignAll(loadedItems);
    } else {
      final loadedItems = isar.itemModels
          .where()
          .nameContains(search, caseSensitive: false)
          .findAll();
      cartItems.assignAll(loadedItems);
    }
  }

  //sync background
  RxBool syncingItems = RxBool(false);
  RxInt itemsPage = RxInt(1);
  RxInt totalPages = RxInt(2);
  RxString syncingItemsFailed = RxString("");
  Future<void> syncCartItemsOnBackground({
    int page = 1,
    String search = "",
    String category = "",
    bool isCompositeItems = false,
  }) async {
    if (syncingItems.value) return;
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }

    final appSettings = AppSettingsModel.fromStorage();
    if (Get.isRegistered<UserController>()) {
      final currentCompany =
          Get.find<UserController>().user.value?.company ?? "";
      if (appSettings.syncedCompanyId.isNotEmpty &&
          appSettings.syncedCompanyId != currentCompany) {
        clearAndResyncData();
        return;
      }
    }

    final lastSyncTime = appSettings.lastItemsSyncTime;

    syncingItems.value = true;
    syncingItemsFailed.value = "";
    final response = await Net.get(
      "/cashier/products?page=$page&search=$search&category=$category&salesOnly=true&lastSync=$lastSyncTime",
    );
    syncingItems.value = false;
    if (response.hasError) {
      syncingItemsFailed.value = response.response;
      return;
    }
    totalPages.value = response.body['totalPages'];
    itemsPage.value = response.body['currentPage'] as int;
    final itemList = response.body['list'] as List<dynamic>? ?? [];
    syncingItems.value = true;
    List<ItemModel> models = itemList.map((e) {
      return ItemModel.fromJson((e));
    }).toList();

    await isar.write((isar) async {
      for (var model in models) {
        final existingItem = isar.itemModels
            .where()
            .hexIdEqualTo(model.hexId)
            .findFirst();

        if (model.isDeleted) {
          if (existingItem != null) {
            isar.itemModels.delete(existingItem.id);
          }
        } else {
          if (existingItem != null) {
            model.id = existingItem.id;
          }
          isar.itemModels.put(model);
        }
      }
    });

    if (itemsPage.value >= totalPages.value) {
      appSettings.lastItemsSyncTime = DateTime.now().millisecondsSinceEpoch;
      appSettings.saveToStorage();
    }

    final loadedItems = isar.itemModels.where().findAll();
    cartItems.assignAll(loadedItems);
    syncingItems.value = false;
  }

  //search
  void searchItems(String searchTerm) {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    final loadedItems = isar.itemModels
        .where()
        .nameEndsWith(searchTerm)
        .findAll();
    cartItems.assignAll(loadedItems);
  }

  //delete
  void deleteItem(String id) async {
    if (deleting.value) {
      Toaster.showError("deletion in progress please wait");
      return;
    }
    deleting.value = true;
    final response = await Net.delete("/admin/product/$id");
    if (response.hasError && response.statusCode != 404) {
      Toaster.showError(response.response);
      deleting.value = false;
      return;
    }
    deleting.value = false;
  }

  /*
 =================================== RECEITS LOADING ==============================================
 */
  Future<void> loadReceitsStatic() async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    final r = isar.itemReceitModels.where().sortByCreatedAtDesc().findAll();
    receits.assignAll(r);
    loadReceits();
  }

  //loads receits background
  RxInt receitsPage = RxInt(1);
  RxInt receitsTotalPages = RxInt(2);
  RxBool receitsLoading = RxBool(false);
  RxBool checkoutInProgress = RxBool(false);
  RxString receitsHasError = RxString("");
  Future<void> loadReceits({
    int page = 1,
    String search = '',
    String filter = '',
  }) async {
    if (receitsLoading.value || updatingUsyncedReceits.value) return;
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    receitsHasError.value = "";
    receitsLoading.value = true;
    final response = await Net.get(
      "/cashier/receits?page=$page&search=$search&filter=$filter",
    );
    receitsLoading.value = false;
    if (!response.hasError) {
      receitsPage.value = response.body['currentPage'] as int;
      receitsTotalPages.value = response.body['totalPages'] as int;
      if (response.body['list'] != null) {
        final list = response.body['list'] as List<dynamic>;
        final lv = list.map((e) => ItemReceitModel.fromJson(e)).toList();

        await isar.write((isar) async {
          final allExisting = isar.itemReceitModels.where().findAll();
          final existingByHexId = {
            for (var e in allExisting)
              if (e.hexId.isNotEmpty) e.hexId: e.id,
          };
          final existingByClientSaleId = {
            for (var e in allExisting)
              if (e.clientSaleId.isNotEmpty) e.clientSaleId: e.id,
          };

          for (var model in lv) {
            if (model.hexId.isNotEmpty &&
                existingByHexId.containsKey(model.hexId)) {
              model.id = existingByHexId[model.hexId]!;
            } else if (model.clientSaleId.isNotEmpty &&
                existingByClientSaleId.containsKey(model.clientSaleId)) {
              model.id = existingByClientSaleId[model.clientSaleId]!;
            }
          }
          isar.itemReceitModels.putAll(lv);
        });

        if (search.isEmpty && filter.isEmpty) {
          final r = isar.itemReceitModels
              .where()
              .sortByCreatedAtDesc()
              .findAll();
          receits.assignAll(ReceiptListSort.orderForDisplay(r));
        } else {
          final unsyncedReceits = isar.itemReceitModels
              .where()
              .syncedEqualTo(false)
              .findAll();
          if (page == 1) {
            receits.assignAll(ReceiptListSort.orderForDisplay(lv));
            receits.addAll(unsyncedReceits);
          } else {
            receits.addAll(ReceiptListSort.orderForDisplay(lv));
          }
        }
      }
      _updateUnsyncedReceits();
      return;
    }
    final r = isar.itemReceitModels.where().sortByCreatedAtDesc().findAll();
    receits.assignAll(r);
  }

  Future<void> updateUnsyncedReceits() async {
    await _updateUnsyncedReceits();
  }
  /*
 =================================== MODIFIERS LOADING ==============================================
 */

  RxBool modifiersLoading = RxBool(false);
  void loadMofiers({int page = 1, String search = ''}) async {
    if (modifiersLoading.value) return;
    modifiersLoading.value = true;
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    final response = await Net.get(
      "/cashier/modifiers?page=$page&search=$search",
    );
    modifiersLoading.value = false;
    if (!response.hasError) {
      final list = response.body['list'] as List<dynamic>?;
      if (list != null) {
        modifiers.value = list.map((e) => ItemModifier.fromJson(e)).toList();
      }
      await isar.write((isar) async {
        isar.itemModifiers.where().deleteAll();
        isar.itemModifiers.putAll(modifiers);
      });
      return;
    }
    final loadedModifiers = isar.itemModifiers.where().findAll();
    modifiers.assignAll(loadedModifiers);
  }

  RxBool deleting = RxBool(false);
  Future<bool> createModifier(
    ItemModifier modefier, {
    bool updated = false,
  }) async {
    ResponseModel? net;
    if (updated) {
      net = await Net.put(
        "/admin/modifier/${modefier.hexId}",
        data: modefier.toJson(),
      );
    } else {
      net = await Net.post("/admin/modifier", data: modefier.toJson());
    }
    if (net.hasError) {
      Toaster.showError(net.response);
      return false;
    }
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return false;
    }
    try {
      isar.write((isar) async {
        if (updated) {
          isar.itemModifiers.put(modefier);
        } else {
          isar.itemModifiers.put(ItemModifier.fromJson(net!.body['update']));
        }
      });
      loadMofiers();
      return true;
    } catch (e) {
      Toaster.showError('Failed to add modifier');
    }
    return false;
  }

  Future<bool> deleteModifiers(List<int> id) async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return false;
    }
    try {
      isar.write((isar) async {
        isar.itemModifiers.deleteAll(id);
      });
      loadMofiers();
      return true;
    } catch (e) {
      Toaster.showError('Failed to delete modifier');
    }
    return false;
  }

  /*
 =================================== MODIFIERS LOADING ==============================================
 */
  //Inventory Items
  Future<void> saveItem(String name) async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return;
    }
    final allTheModels = ItemSavedItemsModel(
      name: name,
      dataMap: checkOutItems.map((e) => _getModel(e)).toList(),
      createdAt: DateTime.now(),
    );
    await isar.write((isar) async {
      isar.itemSavedItemsModels.put(allTheModels);
    });
    checkOutItems.clear();
    selectedCustomer.value = null;
    totalPrice.value = 0;
    loadSavedItems();
  }

  void loadSavedItems() {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    final loadedModels = isar.itemSavedItemsModels.where().findAll();
    savedItems.assignAll(loadedModels);
  }

  void unwrapToCart(ItemSavedItemsModel model) async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return;
    }
    try {
      checkOutItems.clear();

      final List<Map<String, dynamic>> newCheckOutItems = [];
      for (var savedItem in model.dataMap) {
        // 1. Retrieve the original ItemModel using the baseId
        final ItemModel? originalItem = isar.itemModels.get(savedItem.baseId);

        if (originalItem != null) {
          newCheckOutItems.add({
            'id': originalItem.id,
            'item': originalItem, // <--- Correctly storing the ItemModel
            "cost": savedItem.cost,
            "count": savedItem.count,
            "addenum": savedItem.addenum,
            "qouted": savedItem.qouted,
            "hexId": originalItem.hexId,
            "dataMap": _decodeDataMap(savedItem.dataMap),
          });
        } else {
          // Handle case where original item is not found (optional)
        }
      }

      checkOutItems.addAll(newCheckOutItems);

      // Delete the saved item after successfully loading it
      await isar.write((isar) async {
        isar.itemSavedItemsModels.delete(model.id);
      });

      _calculatedTotalPrice();
      loadSavedItems();
    } catch (e) {
      Toaster.showError("Error ; $e");
    }
  }

  /*
 =================================== PRICE EVALUATION ==============================================
 */
  void _calculatedTotalPrice() {
    totalPrice.value = checkOutItems.fold(0.0, (prev, item) {
      final count = item['count'] as num? ?? 0;
      final addenum = item['addenum'] as double? ?? 0.0;
      final qouted = item['qouted'] as double? ?? 0.0;
      final model = item['item'] as ItemModel;
      double price =
          count *
          (((model.wholesaleActivated && count >= model.miniItems)
                  ? model.wholesalePrice
                  : (model.price + qouted)) +
              addenum);
      if (item['discountId'] != null) {
        double discount = (item['discount'] as num?)?.toDouble() ?? 0.0;
        bool percentageDiscount = item['percentageDiscount'] as bool? ?? true;
        price = percentageDiscount
            ? price * (1 - discount / 100)
            : price - discount;
      }
      return (prev + price).toPrecision;
    });
    final totalDiscounts = selectedDiscounts.fold(0.0, (prev, data) {
      return (prev +
              (!data.percentage
                  ? data.value
                  : totalPrice.value * (data.value / 100)))
          .toPrecision;
    });
    totalPrice.value = (totalPrice.value - totalDiscounts).toPrecision;
    final subtotal = totalPrice.value;
    checkoutSubtotal.value = subtotal;
    final resolved = SalesTaxCalculator.resolveCheckout(
      checkOutItems: checkOutItems,
      taxes: salesTaxes,
      subtotalAfterDiscounts: subtotal,
    );
    checkoutTaxAmount.value = resolved.totalTaxAmount.toPrecision;
    totalPrice.value = resolved.customerTotal.toPrecision;
  }

  ItemSavedModel _getModel(Map<String, dynamic> e) {
    final model = e['item'] as ItemModel;
    final sm = ItemSavedModel()
      ..dataMap = _compileList(e['dataMap'] as Map<String, bool>? ?? {})
      ..count = (e['count'] as num?)?.toDouble() ?? 0.0
      ..cost = (e['cost'] as num?)?.toDouble() ?? 0.0
      ..addenum = (e['addenum'] as num?)?.toDouble() ?? 0.0
      ..qouted = (e['qouted'] as num?)?.toDouble() ?? 0.0
      ..baseId = model.id;
    return sm;
  }

  List<String> _compileList(Map<String, bool> map) {
    return map.keys.toList();
  }

  Map<String, bool> _decodeDataMap(List<String> dataMap) {
    Map<String, bool> data = {};
    for (var e in dataMap) {
      data[e] = true;
    }
    return data;
  }

  Future<ItemReceitModel?> refundItem(
    ItemReceitModel model,
    ItemReceitItem e,
    num count,
    int index,
  ) async {
    try {
      if (model.hexId == "" || !model.synced) {
        Toaster.showError("The item is unsynced , sync first to refund ");
        return null;
      }
      final response = await Net.put(
        "/cashier/refund/${model.hexId}/$index/$count",
      );
      if (response.hasError) {
        Toaster.showError(response.response);
        return null;
      }
      final isar = IsarStatic.getInstance();
      final mseconds = DateTime.now().millisecondsSinceEpoch;
      if (selectedShift.value != null &&
          mseconds >=
              selectedShift.value!.openShiftTime.millisecondsSinceEpoch &&
          isar != null) {
        double price = model.items[index].price * count;
        selectedShift.value!.totalSales =
            selectedShift.value!.totalSales - price;

        await isar.write((isar) async {
          isar.shiftsModels.put(selectedShift.value!);
        });
      }

      final modelUpdate = ItemReceitModel.fromJson(response.body['update']);
      model.items = modelUpdate.items;
      model.total = modelUpdate.total;
      model.amount = modelUpdate.amount;
      log("Updated item model: $modelUpdate");

      final cnJson = response.body['creditNote'];
      if (cnJson is Map) {
        final creditNote = ItemReceitModel.fromJson(
          Map<String, dynamic>.from(cnJson),
        );
        if (isar != null) {
          await isar.write((isar) async {
            isar.itemReceitModels.put(creditNote);
          });
        }
        receits.insert(0, creditNote);
        Toaster.showInfo(
          "Credit note ${creditNote.label} created — fiscalization queued.",
        );
      }
      if (e.count < 0) {
        Toaster.showError("$count should be less than ${e.count}");
        return null;
      }
      if (isar != null) {
        await isar.write((isar) async {
          isar.itemReceitModels.put(model);
        });
        final itemModel = isar.itemModels
            .where()
            .hexIdEqualTo(e.itemId)
            .findFirst();
        if (itemModel == null) {
          Toaster.showError("item not found");
          return null;
        }
        loadReceits();
        return modelUpdate;
      }
      return null;
    } catch (e) {
      Toaster.showError("There was error : $e");
      return null;
    }
  }

  RxBool addCustomerSyncing = RxBool(false);
  Future<bool> addCustomer(CustomerModel model) async {
    if (addCustomerSyncing.value) {
      Toaster.showError("syncing customer please wait");
      return false;
    }
    addCustomerSyncing.value = true;
    final response = await Net.post(
      "/cashier/customer",
      data: {"user": model.toJson()},
    );
    addCustomerSyncing.value = false;
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    loadCustomers();
    return true;
  }

  RxBool syncingCustomers = RxBool(false);
  RxString syncingCustomersFailed = RxString("");
  RxInt customerPage = RxInt(1);
  RxInt customerTotalPages = RxInt(2);
  Future<void> loadCustomers({String search = '', int page = 1}) async {
    if (syncingCustomers.value) return;
    syncingCustomers.value = true;
    syncingCustomersFailed.value = "";
    final response = await Net.get(
      "/cashier/customers?page=$page&search=$search",
    );
    syncingCustomers.value = false;
    if (response.hasError) {
      syncingCustomersFailed.value = response.response;
      return;
    }
    customerTotalPages.value = response.body['totalPages'] ?? 0;
    customerPage.value = response.body['currentPage'] as int;
    final list = response.body['list'] as List<dynamic>? ?? [];
    customers.value = list.map((e) => CustomerModel.fromJson(e)).toList();
  }

  RxBool deletingCustomer = RxBool(false);
  Future<bool> deleteCustomer(CustomerModel model) async {
    deletingCustomer.value = true;
    final response = await Net.delete("/admin/customer/${model.hexId}");
    deletingCustomer.value = false;
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    loadCustomers();
    return true;
  }

  void _loadFixedItems() {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    cartItems.value = isar.itemModels.where().findAll();
    modifiers.value = isar.itemModifiers.where().findAll();
    discounts.value = isar.discountModels.where().findAll();
    categories.value = isar.itemCategoryModels.where().findAll();
    taxes.value = isar.taxModels.where().findAll();
    final r = isar.itemReceitModels.where().sortByCreatedAtDesc().findAll();
    receits.assignAll(r);
  }

  /*
  ==============================================
  ==============================================
                   Taxes |
  ==============================================
  ==============================================
  */
  Future<bool> addTaxes(dynamic data) async {
    final response = await Net.post("/admin/tax", data: data);
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    TaxModel tax = TaxModel.fromJson(response.body['update']);
    final isar = IsarStatic.getInstance();
    if (isar != null) {
      isar.write((isar) async {
        isar.taxModels.put(tax);
      });
    }
    loadTaxes();
    return true;
  }

  Future<bool> updateTaxies(dynamic data, String id) async {
    final response = await Net.put("/admin/tax/$id", data: data);
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    loadTaxes();
    return true;
  }

  Future<bool> deleteTax(String id) async {
    final response = await Net.delete("/admin/tax/$id");
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    loadTaxes();
    return true;
  }

  RxBool syncingTaxes = RxBool(false);
  RxString syncingTaxesFailed = RxString("");
  RxList<TaxModel> taxes = RxList<TaxModel>([]);
  void loadTaxes({String search = '', int page = 1}) async {
    if (syncingTaxes.value) return;
    syncingTaxes.value = true;
    final response = await Net.get("/cashier/taxes?page=$page&search=$search");
    syncingTaxes.value = false;
    if (response.hasError) {
      return;
    }
    final list = response.body['list'] as List<dynamic>? ?? [];
    taxes.value = list.map((e) => TaxModel.fromJson(e)).toList();
    final isar = IsarStatic.getInstance();
    if (isar != null) {
      isar.write((isar) async {
        isar.taxModels.where().deleteAll();
        isar.taxModels.putAll(taxes);
      });
    }
  }

  /*
  =====================================================================
   =================== DICOUNTS========================================
  =====================================================================
*/
  Future<bool> addDiscount(dynamic data) async {
    final response = await Net.post("/admin/discount", data: data);
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    DiscountModel discount = DiscountModel.fromJson(response.body['update']);
    final isar = IsarStatic.getInstance();
    if (isar != null) {
      isar.write((isar) async {
        isar.discountModels.put(discount);
      });
    }
    loadDiscounts();
    return true;
  }

  RxBool syncingDiscounts = RxBool(false);
  RxString syncingDiscountsFailed = RxString("");
  void loadDiscounts({String search = '', int page = 1}) async {
    if (syncingDiscounts.value) return;
    syncingDiscounts.value = true;
    syncingDiscountsFailed.value = "";
    final response = await Net.get(
      "/cashier/discounts?page=$page&search=$search",
    );
    syncingDiscounts.value = false;
    if (response.hasError) {
      return;
    }
    final list = response.body['list'] as List<dynamic>? ?? [];
    discounts.value = list.map((e) => DiscountModel.fromJson(e)).toList();
    final isar = IsarStatic.getInstance();
    if (isar != null) {
      isar.write((isar) async {
        isar.discountModels.where().deleteAll();
        isar.discountModels.putAll(discounts);
      });
    }
  }

  void deleteDiscount(String id) async {
    final response = await Net.delete("/admin/discount/$id");
    if (response.hasError) {
      Toaster.showError(response.response);
      return;
    }
    loadDiscounts();
    Toaster.showSuccess("discount deleted");
  }

  Future<bool> updateDiscount(dynamic data, String id) async {
    final response = await Net.put("/admin/discount/$id", data: data);
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    loadDiscounts();
    return true;
  }

  /*
  ==============================================
  Ysssssssssss
  */
  Future<ItemModel?> findModelByBarCode(String barCode) async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return null;
    }
    ItemModel? model = isar.itemModels
        .where()
        .barcodeEqualTo(barCode)
        .findFirst();
    if (model != null) {
      return model;
    }
    final result = await Net.get("/cashier/product/barcode/$barCode");
    if (result.hasError) {
      Toaster.showError(result.response);
      return null;
    }
    return ItemModel.fromJson(result.body['update']);
  }

  /*
  ==============================================
  ==============================================
                   FIXDED ITEMS |
  ==============================================
  ==============================================
  */
  RxBool syncingFixedItems = RxBool(false);
  RxInt fixedItemsPage = RxInt(1);
  RxInt fixedItemTotalPages = RxInt(2);
  RxString syncingFixedItemsFailed = RxString("");
  Future<void> syncFixedItemsOnBackground({
    int page = 1,
    String search = "",
    String category = "",
    bool isCompositeItems = false,
  }) async {
    if (syncingFixedItems.value) return;
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    syncingFixedItems.value = true;
    syncingFixedItemsFailed.value = "";
    final response = await Net.get(
      "/cashier/products?page=$page&search=$search&category=$category&composite=${isCompositeItems ? 'true' : 'false'}",
    );
    syncingFixedItems.value = false;
    if (response.hasError) {
      syncingFixedItemsFailed.value = response.response;
      return;
    }
    fixedItemTotalPages.value = response.body['totalPages'];
    fixedItemsPage.value = response.body['currentPage'] as int;
    final itemList = response.body['list'] as List<dynamic>? ?? [];
    syncingFixedItems.value = true;
    List<ItemModel> models = itemList.map((e) {
      return ItemModel.fromJson((e));
    }).toList();
    await isar.write((isar) async {
      isar.itemModels.where().deleteAll();
      if (itemsPage.value > 1) {
        isar.itemModels.putAll(fixedItems);
      }
      isar.itemModels.putAll(models);
    });
    final loadedItems = isar.itemModels.where().findAll();
    fixedItems.assignAll(loadedItems);
    syncingFixedItems.value = false;
  }

  /*
  ==============================================
  ==============================================
                  CUSTOMERS |
  ==============================================
  ==============================================
  */
  RxBool updatingCustomerPoints = RxBool(false);
  Future<CustomerModel?> updateCustomerPoints(String id, double points) async {
    updatingCustomerPoints.value = true;
    final response = await Net.put(
      "/admin/customer/points/$id",
      data: {"points": points},
    );
    updatingCustomerPoints.value = false;
    if (response.hasError) {
      Toaster.showError(response.response);
      return null;
    }
    return CustomerModel.fromJson(response.body['update']);
  }

  RxBool mobilePaymentProcessing = RxBool(false);
  Future<bool> payMobile({
    required String method,
    required String phoneNumber,
  }) async {
    if (mobilePaymentProcessing.value) {
      Toaster.showError("mobile payment still processing");
      return false;
    }
    mobilePaymentProcessing.value = true;
    final response = await Net.post(
      '/cashier/paymobile/paynow',
      data: {
        "method": method,
        "amount": totalPrice.value,
        "phoneNumber": phoneNumber,
      },
    );
    if (response.hasError) {
      mobilePaymentProcessing.value = false;
      Toaster.showError(response.response);
      return false;
    }
    await Future.delayed(Duration(seconds: 30));
    final result = await poll(response.body['pollUrl']);
    mobilePaymentProcessing.value = false;
    return result;
  }

  RxBool webProcessingPayment = RxBool(false);
  Future<({String? redirectUrl, String? returnUrl, String? pollUrl})> payWeb(
    String method,
  ) async {
    if (webProcessingPayment.value) {
      Toaster.showError("mobile payment still processing");
      return (redirectUrl: null, returnUrl: null, pollUrl: null);
    }
    webProcessingPayment.value = true;
    final response = await Net.post(
      '/cashier/payweb/paynow',
      data: {"method": method, "amount": totalPrice.value},
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

  Future<bool> poll(String pollUrl) async {
    final poll = await Net.post(
      '/cashier/paymobile/paynow/poll',
      data: {"pollUrl": pollUrl},
    );
    if (poll.hasError) {
      Toaster.showError(poll.response);
      return false;
    }
    if (poll.body['paid'] == true) {
      return true;
    }
    mobilePaymentProcessing.value = true;
    Toaster.showError("payment failed >> retry again in 5 seconds");
    await Future.delayed(Duration(seconds: 5));
    final poll2 = await Net.post(
      '/cashier/paymobile/paynow/poll',
      data: {"pollUrl": pollUrl},
    );
    if (poll2.hasError) {
      Toaster.showError(poll.response);
      return false;
    }
    if (poll2.body['paid'] == true) {
      return true;
    }
    Toaster.showError("payment reflected false");
    return false;
  }

  /*
    ===================================================================================================
    ===================================================================================================
    OPERATIONS SECTIONS
    ===================================================================================================
    ===================================================================================================

*/
  void addDiscountToProduct(DiscountModel model) {
    if (selectedDiscounts.indexWhere((e) {
          return e.hexId == model.hexId;
        }) ==
        -1) {
      selectedDiscounts.add(model);
      _calculatedTotalPrice();
      return;
    }
    Toaster.showError("discount already added");
  }

  void removeDiscountFromProduct(DiscountModel model) {
    int selectedIndex = selectedDiscounts.indexWhere((e) {
      return e.hexId == model.hexId;
    });
    if (selectedIndex != -1) {
      selectedDiscounts.removeAt(selectedIndex);
      _calculatedTotalPrice();
      return;
    }
    Toaster.showError("discount not selected already");
  }

  void removeSelectedItem(Map<String, dynamic> e) async {
    final model = e['item'] as ItemModel;
    int indexOfSelected = checkOutItems.indexWhere((e) {
      final lmodel = e['item'] as ItemModel;
      return lmodel.hexId == model.hexId;
    });
    if (indexOfSelected < 0) {
      Toaster.showError("something went wrong");
      return;
    }
    checkOutItems.removeAt(indexOfSelected);
    if (checkOutItems.isEmpty) {
      salesTaxes.clear();
    }
    _calculatedTotalPrice();
  }

  void incrItem(Map<String, dynamic> e, int increment) async {
    final model = e['item'] as ItemModel;
    int indexOfSelected = checkOutItems.indexWhere((e) {
      final lmodel = e['item'] as ItemModel;
      return lmodel.hexId == model.hexId;
    });
    if (indexOfSelected < 0) {
      Toaster.showError("something went wrong");
      return;
    }
    final newCount = (e['count'] as num).toDouble() + increment;
    if (increment > 0) {
      final stockErr = await _stockErrorForSale(model, newCount);
      if (stockErr != null) {
        Toaster.showError(stockErr);
        return;
      }
    }
    e['count'] = newCount;
    checkOutItems[indexOfSelected] = e;
    _calculatedTotalPrice();
  }

  CompanyModel? get _company => Get.find<InventoryController>().company.value;

  bool get onlineSalesEnabled => _company?.enableOnlineSales ?? false;

  bool get onlineSalesStrictStockEnabled =>
      onlineSalesEnabled && (_company?.onlineSalesStrictStock ?? true);

  ItemModel _freshCatalogItem(ItemModel model) {
    final isar = IsarStatic.getInstance();
    if (isar == null) return model;
    final byId = isar.itemModels.get(model.id);
    if (byId != null) return byId;
    if (model.hexId.isNotEmpty) {
      final byHex = isar.itemModels
          .where()
          .hexIdEqualTo(model.hexId)
          .findFirst();
      if (byHex != null) return byHex;
    }
    return model;
  }

  bool _requiresStrictStockCheck(ItemModel model) {
    return ItemModel.parseTrackStock(model.trackStock);
  }

  bool _isCatalogStockTracked(ItemModel model) {
    if (_requiresStrictStockCheck(model)) return true;
    return _requiresStrictStockCheck(_freshCatalogItem(model));
  }

  Future<void> _refreshCartItemsStockFromServer() async {
    if (!onlineSalesStrictStockEnabled || checkOutItems.isEmpty) return;
    final ids = checkOutItems
        .map((e) => e['item'] as ItemModel)
        .where(_isCatalogStockTracked)
        .map((m) => m.hexId)
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();
    if (ids.isEmpty) return;

    final response = await Net.post(
      "/cashier/products/range",
      data: {"filter": "", "ids": ids},
    );
    if (response.hasError) return;

    final list = response.body?['list'] as List<dynamic>? ?? [];
    final isar = IsarStatic.getInstance();
    if (isar == null) return;

    await isar.write((isar) async {
      for (final raw in list) {
        if (raw is! Map<String, dynamic>) continue;
        final model = ItemModel.fromJson(raw);
        final existing = isar.itemModels
            .where()
            .hexIdEqualTo(model.hexId)
            .findFirst();
        if (existing != null) {
          model.id = existing.id;
        }
        isar.itemModels.put(model);
      }
    });
    _refreshCheckoutItemsFromCatalog();
  }

  void _refreshCheckoutItemsFromCatalog() {
    for (var i = 0; i < checkOutItems.length; i++) {
      final line = checkOutItems[i];
      final model = line['item'] as ItemModel;
      line['item'] = _freshCatalogItem(model);
      checkOutItems[i] = line;
    }
  }

  Future<ItemModel> _catalogItemForStockRules(ItemModel model) async {
    if (!onlineSalesStrictStockEnabled || model.hexId.isEmpty) {
      return _freshCatalogItem(model);
    }
    if (!_isCatalogStockTracked(model)) {
      return _freshCatalogItem(model);
    }
    final response = await Net.post(
      "/cashier/products/range",
      data: {
        "filter": "",
        "ids": [model.hexId],
      },
    );
    if (response.hasError) {
      return _freshCatalogItem(model);
    }
    final list = response.body?['list'] as List<dynamic>? ?? [];
    if (list.isEmpty) return _freshCatalogItem(model);
    final raw = list.first;
    if (raw is! Map<String, dynamic>) return _freshCatalogItem(model);
    final serverItem = ItemModel.fromJson(raw);
    final isar = IsarStatic.getInstance();
    if (isar != null) {
      await isar.write((isar) async {
        final existing = isar.itemModels
            .where()
            .hexIdEqualTo(serverItem.hexId)
            .findFirst();
        if (existing != null) {
          serverItem.id = existing.id;
        }
        isar.itemModels.put(serverItem);
      });
    }
    return serverItem;
  }

  String? _stockErrorForItem(ItemModel live, double requestedCount) {
    if (!onlineSalesStrictStockEnabled) return null;
    if (!_requiresStrictStockCheck(live)) return null;
    final available = live.stockQuantity;
    if (requestedCount <= available) return null;
    if (available <= 0) {
      return "${live.name} is out of stock (online sales)";
    }
    return "${live.name}: only ${available.toStringAsFixed(available == available.roundToDouble() ? 0 : 2)} available";
  }

  Future<String?> _stockErrorForSale(
    ItemModel model,
    double requestedCount,
  ) async {
    if (!onlineSalesStrictStockEnabled) return null;
    if (!_isCatalogStockTracked(model)) return null;
    final live = await _catalogItemForStockRules(model);
    return _stockErrorForItem(live, requestedCount);
  }

  String? validateCartStockForOnlineSales() {
    if (!onlineSalesStrictStockEnabled) return null;
    _refreshCheckoutItemsFromCatalog();
    for (final line in checkOutItems) {
      final model = line['item'] as ItemModel;
      if (!_isCatalogStockTracked(model)) continue;
      final count = (line['count'] as num?)?.toDouble() ?? 0;
      final err = _stockErrorForItem(model, count);
      if (err != null) return err;
    }
    return null;
  }

  Future<bool> _probeServerReachable() async {
    final response = await Net.get("/cashier/products?limit=1");
    return !response.hasError;
  }

  /// Online checkout only — server must return a fiscalized receipt before print.
  Future<ItemReceitModel?> _purchaseOnServer(ItemReceitModel draft) async {
    final response = await Net.post("/cashier/purchase", data: draft.toJson());
    if (response.hasError) {
      if (response.statusCode == 503) {
        Toaster.showError(
          response.response.isNotEmpty
              ? response.response
              : "ZIMRA fiscalization failed. The sale was not recorded — please retry.",
        );
        return null;
      }
      final rejects = response.body?['rejects'];
      if (rejects is List && rejects.isNotEmpty) {
        final first = rejects.first;
        if (first is Map && first['rejectedReason'] != null) {
          Toaster.showError("${first['rejectedReason']}");
        } else {
          Toaster.showError(response.response);
        }
      } else {
        Toaster.showError(response.response);
      }
      return null;
    }
    final update = response.body?['update'];
    if (update == null) {
      Toaster.showError("Server did not return a receipt");
      return null;
    }
    final map = update as Map<String, dynamic>;
    final receipt = ItemReceitModel.fromJson(map);
    receipt.applyZimraFiscalizationFrom(map);
    if (!receipt.fiscalized) {
      Toaster.showError(
        "Server receipt was not fiscalized — check ZIMRA before printing",
      );
      return null;
    }
    return receipt;
  }

  Future<void> removeAllSelected() async {
    salesTaxes.clear();
    checkOutItems.clear();
    selectedDiscounts.clear();
    selectedCustomer.value = null;
    totalPrice.value = 0;
    loadCartItems();
  }

  void addSelectedItem(
    ItemModel model, {
    double count = -1,
    String? discountId,
    double qouted = 0.0,
    double addenum = 0.0,
    double discount = 0.0,
    double restoreAmount = -1,
    Map<String, bool>? dataMap,
    bool percentageDiscount = true,
  }) async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      Toaster.showError("Database initilization error");
      return;
    }
    final invController = Get.find<InventoryController>();
    if (invController.company.value?.shiftBasedSales == true &&
        selectedShift.value == null) {
      Toaster.showError("You must open a shift to sell items");
      return;
    }
    if (checkOutItems.isEmpty) {
      salesTaxes.value = isar.taxModels
          .where()
          .activatedEqualTo(true)
          .findAll();
    }
    final dataFound = checkOutItems.indexWhere((e) {
      final id = e['id'];
      if (id is int) {
        return id == model.id;
      }
      return false;
    });
    if (dataFound == -1) {
      final stockErr = await _stockErrorForSale(model, count < 0 ? 1 : count);
      if (stockErr != null) {
        Toaster.showError(stockErr);
        return;
      }
    } else {
      final existing = checkOutItems[dataFound];
      final nextCount = count < 0
          ? (existing['count'] as num).toDouble() + 1
          : count.toDouble();
      final stockErr = await _stockErrorForSale(model, nextCount);
      if (stockErr != null) {
        Toaster.showError(stockErr);
        return;
      }
    }
    if (dataFound == -1) {
      checkOutItems.add({
        'id': model.id,
        'item': model,
        "count": count < 0 ? 1 : count,
        "addenum": addenum,
        "qouted": qouted,
        "dataMap": dataMap ?? <String, bool>{},
        "hexId": model.hexId,
        "cost": model.cost,
        "discount": discount,
        "discountId": discountId,
        "restoreAmount": restoreAmount,
        "percentageDiscount": percentageDiscount,
      });
      _calculatedTotalPrice();
      return;
    }
    final modelFound = checkOutItems[dataFound];
    modelFound['count'] = count < 0 ? modelFound['count'] + 1 : count;
    modelFound['dataMap'] = dataMap ?? <String, bool>{};
    modelFound['addenum'] = addenum;
    modelFound['qouted'] = qouted;
    modelFound['discount'] = discount;
    modelFound['discountId'] = discountId;
    modelFound['restoreAmount'] = restoreAmount;
    modelFound['percentageDiscount'] = percentageDiscount;
    checkOutItems[dataFound] = modelFound;
    _calculatedTotalPrice();
  }

  RxBool creatingItem = RxBool(false);
  Future<bool> createItem(ItemModel item, {update = true}) async {
    if (syncingItems.value == true) {
      Toaster.showError("syncing items please wait");
      return false;
    }
    try {
      dynamic response;
      if (update) {
        response = await Net.put(
          "/admin/product/${item.hexId}",
          data: item.toJson(),
        );
      } else {
        response = await Net.post("/admin/product", data: item.toJson());
      }
      if (response.hasError) {
        Toaster.showError(response.response);
        return false;
      }
      final obj = ItemModel.fromJson(response.body['update']);
      final isar = IsarStatic.getInstance();
      if (isar == null) {
        Toaster.showError('Database not initialized');
        return false;
      }
      await isar.write((isar) async {
        if (update) {
          isar.itemModels.put(item);
        } else {
          isar.itemModels.put(obj);
        }
      });
      syncCartItemsOnBackground();
      return true;
    } catch (e) {
      Toaster.showError('Failed to create item');
      return false;
    }
  }

  Future<bool> createCategory(
    ItemCategoryModel category, {
    update = true,
  }) async {
    if (categoriesSyncing.value == true) {
      Toaster.showError("categories syncing please wait");
      return false;
    }
    try {
      dynamic response;
      if (update) {
        response = await Net.put(
          "/admin/category/${category.hexId}",
          data: category.toJson(),
        );
      } else {
        response = await Net.post("/admin/category", data: category.toJson());
      }
      if (response.hasError) {
        Toaster.showError(response.response);
        return false;
      }
      final obj = ItemCategoryModel.fromJson(response.body['update']);
      final isar = IsarStatic.getInstance();
      if (isar == null) {
        Toaster.showError('Database not initialized');
        return false;
      }
      await isar.write((isar) async {
        if (update) {
          category.name = obj.name;
          category.color = obj.color;
          isar.itemCategoryModels.put(category);
        } else {
          isar.itemCategoryModels.put(obj);
        }
      });
      loadCategories();
      return true;
    } catch (e) {
      Toaster.showError('Failed to add category');
    }
    return false;
  }

  /*
  =========================================================================
  =========================================================================
  RECEIT Payment
  =========================================================================
  =========================================================================
*/
  Future<bool> addReceitFromItemModel(
    double payedAmount,
    String payment, {
    required bool allowOfflinePurchase,
    bool printReceits = false,
    required User user,
    bool creditPayment = false,
  }) async {
    if (checkoutInProgress.value) {
      return false;
    }
    checkoutInProgress.value = true;
    try {
      final isar = IsarStatic.getInstance();
      if (isar == null) {
        Toaster.showError('Database not initialized');
        return false;
      }
      final discounts = selectedDiscounts;

      final itemReceitModel = ItemReceitModel(
        hexId: "",
        clientSaleId: generateClientSaleId(),
        currency: user.baseCurrence,
        cashier: "admin",
        label: Labeller.generateRecietNumber(
          fullName: user.fullName,
          count: user.receitsCount,
          companyName: user.companyName,
        ),
        miniTax: salesTaxes
            .map(
              (e) => MiniTax(
                label: e.label,
                value: e.value,
                sumOfItems: e.selectedIds.length,
              ),
            )
            .toList(),
        payment: payment,
        amount: payedAmount,
        creditSale: creditPayment,
        synced: false,
        discounts: discounts
            .map((e) => EmbeddedDiscountModel.fromModel(e))
            .toList(),
        customerId: selectedCustomer.value?.hexId,
        items: checkOutItems.map((e) {
          final model = e['item'] as ItemModel;
          final count = (e['count'] as num?)?.toDouble() ?? 0.0;

          double itemTaxAmount = 0.0;
          double itemTaxPercentage = 0.0;
          String? itemTaxName;

          for (final tax in salesTaxes) {
            if (tax.activated == false) continue;
            if (tax.selectedIds.isNotEmpty &&
                !tax.selectedIds.contains(model.hexId)) {
              continue;
            }
            itemTaxPercentage = tax.value;
            itemTaxName = tax.label;
            itemTaxAmount =
                (itemTaxAmount +
                        SalesTaxCalculator.lineTaxForRow(cartRow: e, tax: tax))
                    .toPrecision;
          }

          final receit = ItemReceitItem()
            ..name = model.name
            ..baseId = model.id
            ..itemId = e['hexId']
            ..originalCount = ((e['count'] as num?)?.toDouble() ?? 1)
            ..cost = e['cost'] as double? ?? 0.0
            ..discountId = e['discountId'] as String?
            ..addenum = e['addenum'] as double? ?? 0.0
            ..price =
                (model.wholesaleActivated &&
                    ((e['count'] as num?)?.toDouble() ?? 1) >= model.miniItems)
                ? model.wholesalePrice
                : (model.price + e['qouted'] as double? ?? 0.0)
            ..discount = (e['discount'] as num?)?.toDouble() ?? 0.0
            ..percentageDiscount = e['percentageDiscount'] as bool? ?? true
            ..count = count
            ..taxAmount = itemTaxAmount
            ..taxPercentage = itemTaxPercentage
            ..taxName = itemTaxName;
          return receit;
        }).toList(),
        change: (payedAmount - totalPrice.value).toPrecision,
        createdAt: DateTime.now(),
        total: totalPrice.value,
      );
      final totalTax = SalesTaxCalculator.resolveCheckout(
        checkOutItems: checkOutItems,
        taxes: salesTaxes,
        subtotalAfterDiscounts: checkoutSubtotal.value,
      ).totalTaxAmount;
      itemReceitModel.tax = SalesTaxCalculator.primaryTaxRatePercent(
        salesTaxes,
      );
      itemReceitModel.taxAmount = totalTax.toPrecision;
      final company = Get.find<InventoryController>().company.value;
      final useOnlineCheckout = company?.enableOnlineSales ?? false;
      ItemReceitModel receiptToStore = itemReceitModel;

      if (useOnlineCheckout) {
        if (company?.onlineSalesSyncBeforeCheckout != false) {
          await syncCartItemsOnBackground(page: 1);
        }
        await _refreshCartItemsStockFromServer();
        _refreshCheckoutItemsFromCatalog();
        final stockErr = validateCartStockForOnlineSales();
        if (stockErr != null) {
          Toaster.showError(stockErr);
          return false;
        }
        if (!await _probeServerReachable()) {
          Toaster.showError(
            "Online sales requires an active internet connection",
          );
          return false;
        }
        receitsLoading.value = true;
        var serverReceipt = await _purchaseOnServer(itemReceitModel);
        receitsLoading.value = false;
        if (serverReceipt == null) {
          return false;
        }
        serverReceipt.synced = true;
        if (serverReceipt.clientSaleId.isEmpty) {
          serverReceipt.clientSaleId = itemReceitModel.clientSaleId;
        }
        receiptToStore = serverReceipt;
      }

      int newReceitId = -1;
      await isar.write((isar) async {
        isar.itemReceitModels.put(receiptToStore);
        newReceitId = receiptToStore.id;
      });
      if (selectedShift.value != null) {
        selectedShift.value!.totalSales += totalPrice.value;
        selectedShift.value!.totalCustomers++;
        selectedShift.value!.salesQuantity += checkOutItems.length;
        await isar.write((isar) async {
          isar.shiftsModels.put(selectedShift.value!);
        });
      }
      user.receitsCount++;
      User.saveToStorage(user);

      if (!useOnlineCheckout) {
        updateReceitsInBackground(newReceitId, receiptToStore);
        if (printReceits) {
          DevicesController.printReceitToBackround(
            receiptToStore,
            user,
            selectedCustomer.value,
            salesTaxes,
          );
        }
      } else {
        if (printReceits) {
          // [receiptToStore] is the fiscal server payload (QR, counters, signature).
          DevicesController.printReceitToBackround(
            receiptToStore,
            user,
            selectedCustomer.value,
            salesTaxes,
          );
        }
        syncCartItemsOnBackground();
      }
      salesTaxes.clear();
      discounts.clear();
      checkOutItems.clear();
      selectedCustomer.value = null;
      totalPrice.value = 0;
      loadReceitsStatic();
      loadReceits();
      return true;
    } catch (e) {
      Toaster.showError("There was error : $e");
      return false;
    } finally {
      checkoutInProgress.value = false;
    }
  }

  Future<bool> payReceitCredit({
    required double amount,
    required String id,
  }) async {
    final response = await Net.post(
      "/cashier/credit/purchase",
      data: {"id": id, "amount": amount},
    );
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    loadReceits();
    return true;
  }

  Future<void> updateReceitsInBackground(
    int id,
    ItemReceitModel itemReceitModel,
  ) async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    receitsLoading.value = true;
    final response = await Net.post(
      "/cashier/purchase",
      data: itemReceitModel.toJson(),
    );
    receitsLoading.value = false;
    if (response.hasError) {
      return;
    }
    final map = response.body['update'] as Map<String, dynamic>;
    final receivedModel = ItemReceitModel.fromJson(map);
    receivedModel.applyZimraFiscalizationFrom(map);
    await isar.write((isar) async {
      receivedModel.id = id;
      if (receivedModel.clientSaleId.isEmpty &&
          itemReceitModel.clientSaleId.isNotEmpty) {
        receivedModel.clientSaleId = itemReceitModel.clientSaleId;
      }
      isar.itemReceitModels.put(receivedModel);
    });
    loadReceitsStatic();
    loadReceits();
    syncCartItemsOnBackground();
  }

  RxBool updatingUsyncedReceits = RxBool(false);
  Future<void> _updateUnsyncedReceits() async {
    if (updatingUsyncedReceits.value) return;
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    updatingUsyncedReceits.value = true;
    final allUnsynced = isar.itemReceitModels
        .where()
        .syncedEqualTo(false)
        .findAll();
    for (final receit in allUnsynced) {
      await updateReceitsInBackground(receit.id, receit);
      await Future.delayed(Duration(milliseconds: 500));
    }
    updatingUsyncedReceits.value = false;
    if (allUnsynced.isNotEmpty) {
      syncCartItemsOnBackground();
    }
  }

  /*
  =========================================================================
  =========================================================================
  SHIFTS
  =========================================================================
  =========================================================================
*/
  void openShift(double amountInDrawer, User user) async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      Toaster.showError("something went wrong on opening a shift");
      return;
    }
    final count = isar.shiftsModels.where().count();
    final model = ShiftsModel(
      cashDrawerEnd: amountInDrawer,
      cashDrawerStart: amountInDrawer,
      openShiftTime: DateTime.now(),
      closeShiftTime: DateTime.now(),
      userId: user.hexId,
      shiftLabel: Labeller.getShiftLabeller(
        fullName: user.fullName,
        companyName: user.companyName,
        count: count,
      ),
    );
    await isar.write((isar) async {
      isar.shiftsModels.put(model);
    });
    selectedShift.value = model;
    Toaster.showSuccess("shift opened");
    loadShifts();
  }

  void closeShift(double amountInDrawer, User user) async {
    if (selectedShift.value == null) {
      Toaster.showError("something went wrong on closing a shift");
      return;
    }
    if (printReceitOfShift.value) {
      DevicesController.printShift(selectedShift.value!, user);
    }
    final isar = IsarStatic.getInstance();
    if (isar == null || selectedShift.value == null) {
      Toaster.showError("something went wrong on closing a shift");
      return;
    }
    selectedShift.value!.shiftIsClosed = true;
    selectedShift.value!.cashDrawerEnd = amountInDrawer;
    selectedShift.value!.closeShiftTime = DateTime.now();
    await isar.write((isar) async {
      isar.shiftsModels.put(selectedShift.value!);
    });
    loadShifts();
    selectedShift.value = null;
  }

  void reopenLastUnclosedShift() async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    selectedShift.value = isar.shiftsModels
        .where()
        .shiftIsClosedEqualTo(false)
        .findFirst();
  }

  void loadShifts() async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    shifts.value = isar.shiftsModels
        .where()
        .sortByOpenShiftTimeDesc()
        .findAll();
  }

  void syncAllShifts() async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    final allShifts = isar.shiftsModels
        .where()
        .shiftIsClosedEqualTo(true)
        .and()
        .syncedEqualTo(false)
        .findAll();
    for (final shift in allShifts) {
      final response = await Net.post("/cashier/shifts", data: shift.toJson());
      if (response.hasError) {
        break;
      }
      final updatedShift = ShiftsModel.fromJson(response.body['update']);
      await isar.write((isar) async {
        shift.synced = true;
        shift.userId = updatedShift.userId;
        isar.shiftsModels.put(shift);
      });
    }
  }

  void removeSalesTax(TaxModel tax) {
    int index = salesTaxes.indexWhere((e) => e.hexId == tax.hexId);
    if (index < 0) {
      Toaster.showError("something went wrong");
      return;
    }
    salesTaxes.removeAt(index);
    _calculatedTotalPrice();
  }

  void restoreTaxs() async {
    final isar = IsarStatic.getInstance();
    if (isar == null) {
      return;
    }
    salesTaxes.value = isar.taxModels.where().findAll();
    _calculatedTotalPrice();
  }

  Future<({String? redirectUrl, String? returnUrl, String? pollUrl})>
  payWeForAutomation(
    double amount,
    String phone, {
    String type = 'daily',
  }) async {
    if (webProcessingPayment.value) {
      Toaster.showError("mobile payment still processing");
      return (redirectUrl: null, returnUrl: null, pollUrl: null);
    }
    webProcessingPayment.value = true;
    final response = await Net.post(
      '/cashier/payweb/paynow-whatsapp',
      data: {"amount": amount, 'phoneNumber': phone, 'type': type},
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

  Future<bool> pollAutomation(String pollUrl, {String type = 'daily'}) async {
    final inv = Get.find<InventoryController>();
    final poll = await Net.post(
      '/cashier/paymobile/paynow/poll-whatsapp',
      data: {"pollUrl": pollUrl, 'type': type},
    );
    if (poll.hasError) {
      Toaster.showError(poll.response);
      return false;
    }
    if (poll.body['paid'] == true) {
      inv.company.value = CompanyModel.fromJson(poll.body['company']);
      inv.company.value!.saveToStorage();
      return true;
    }
    mobilePaymentProcessing.value = true;
    Toaster.showError("payment failed >> retry again in 5 seconds");
    await Future.delayed(Duration(seconds: 5));
    final poll2 = await Net.post(
      '/cashier/paymobile/paynow/poll-whatsapp',
      data: {"pollUrl": pollUrl, 'type': type},
    );
    if (poll2.hasError) {
      Toaster.showError(poll.response);
      return false;
    }
    if (poll2.body['paid'] == true) {
      inv.company.value = CompanyModel.fromJson(poll2.body['company']);
      inv.company.value!.saveToStorage();
      return true;
    }
    Toaster.showError("payment reflected false");
    return false;
  }

  void clearAndResyncData() async {
    final isar = IsarStatic.getInstance();
    if (isar != null) {
      await isar.write((isar) async {
        isar.itemModels.where().deleteAll();
        isar.itemCategoryModels.where().deleteAll();
        isar.discountModels.where().deleteAll();
        isar.taxModels.where().deleteAll();
        isar.itemModifiers.where().deleteAll();
        isar.itemSavedItemsModels.where().deleteAll();
      });
    }

    final appSettings = AppSettingsModel.fromStorage();
    appSettings.lastItemsSyncTime = 0;
    if (Get.isRegistered<UserController>()) {
      appSettings.syncedCompanyId =
          Get.find<UserController>().user.value?.company ?? "";
    }
    appSettings.saveToStorage();
    loadCategoriesAsync();
    syncCartItemsOnBackground(page: 1);
    loadTaxes();
    loadDiscounts();
    loadCustomers();
    loadShifts();
    loadMofiers();
    if (Get.isRegistered<InventoryController>()) {
      Get.find<InventoryController>().loadCompany();
    }
  }
}
