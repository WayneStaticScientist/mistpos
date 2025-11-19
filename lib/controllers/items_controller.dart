import 'dart:developer';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mistpos/models/mini_tax.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/tax_model.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/models/shifts_model.dart';
import 'package:mistpos/models/response_model.dart';
import 'package:mistpos/models/discount_model.dart';
import 'package:mistpos/models/customer_model.dart';
import 'package:mistpos/models/item_saved_model.dart';
import 'package:mistpos/models/item_receit_item.dart';
import 'package:mistpos/services/network_wrapper.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/models/item_modifier_model.dart';
import 'package:mistpos/models/item_categories_model.dart';
import 'package:mistpos/utils/labeller.dart' show Labeller;
import 'package:mistpos/models/item_saved_items_model.dart';
import 'package:mistpos/controllers/devices_controller.dart';
import 'package:mistpos/models/embedded_discount_model.dart';

class ItemsController extends GetxController {
  RxDouble totalPrice = RxDouble(0);
  RxString selectedCategory = ''.obs;
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
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    final loadedCategories = isar.itemCategoryModels.where().findAllSync();
    categories.assignAll(loadedCategories);
    loadCategoriesAsync();
  }

  //async categories
  RxBool categoriesSyncing = RxBool(false);
  RxString categoriesSyncingFailed = RxString("");
  void loadCategoriesAsync() async {
    final isar = Isar.getInstance();
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
    await isar.writeTxn(() async {
      await isar.itemCategoryModels.where().deleteAll();
      await isar.itemCategoryModels.putAll(models);
    });
    final loadedCategories = isar.itemCategoryModels.where().findAllSync();
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
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    if (selectedCategory.value.isNotEmpty) {
      final loadedItems = isar.itemModels
          .filter()
          .categoryEqualTo(selectedCategory.value)
          .nameContains(search, caseSensitive: false)
          .findAllSync();
      cartItems.assignAll(loadedItems);
    } else {
      final loadedItems = isar.itemModels
          .filter()
          .nameContains(search, caseSensitive: false)
          .findAllSync();
      cartItems.assignAll(loadedItems);
    }
    if (search.trim().isEmpty && category.trim().isEmpty) {
      syncCartItemsOnBackground();
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
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    syncingItems.value = true;
    syncingItemsFailed.value = "";
    final response = await Net.get(
      "/cashier/products?page=$page&search=$search&category=$category&salesOnly=true",
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

    await isar.writeTxn(() async {
      await isar.itemModels.where().deleteAll();
      if (itemsPage.value > 1) {
        await isar.itemModels.putAll(cartItems);
      }
      await isar.itemModels.putAll(models);
    });
    final loadedItems = isar.itemModels.where().findAllSync();
    cartItems.assignAll(loadedItems);
    syncingItems.value = false;
  }

  //search
  void searchItems(String searchTerm) {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    final loadedItems = isar.itemModels
        .filter()
        .nameEndsWith(searchTerm)
        .findAllSync();
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
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    final r = isar.itemReceitModels.where().sortByCreatedAtDesc().findAllSync();
    receits.assignAll(r);
    loadReceits();
  }

  //loads receits background
  RxInt receitsPage = RxInt(1);
  RxInt receitsTotalPages = RxInt(2);
  RxBool receitsLoading = RxBool(false);
  RxString receitsHasError = RxString("");
  Future<void> loadReceits({int page = 1, String search = ''}) async {
    if (receitsLoading.value) return;
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    receitsHasError.value = "";
    receitsLoading.value = true;
    final response = await Net.get(
      "/cashier/receits?page=$page&search=$search",
    );
    receitsLoading.value = false;
    if (!response.hasError) {
      receitsPage.value = response.body['currentPage'] as int;
      receitsTotalPages.value = response.body['totalPages'] as int;
      if (response.body['list'] != null) {
        final list = response.body['list'] as List<dynamic>;
        final lv = list.map((e) => ItemReceitModel.fromJson(e)).toList();
        if (page == 1) {
          receits.assignAll(lv);
        } else {
          receits.addAll(lv);
        }
        await isar.writeTxn(() async {
          if (page == 1) {
            await isar.itemReceitModels
                .filter()
                .syncedEqualTo(true)
                .deleteAll();
            await isar.itemReceitModels.putAll(receits);
          } else {
            await isar.itemReceitModels.putAll(receits);
          }
        });
        return;
      }
    }
    final r = isar.itemReceitModels.where().sortByCreatedAtDesc().findAllSync();
    if (page == 1) {
      receits.assignAll(r);
    } else {
      receits.addAll(r);
    }
    _updateUnsyncedReceits();
  }

  /*
 =================================== MODIFIERS LOADING ==============================================
 */

  RxBool modifiersLoading = RxBool(false);
  void loadMofiers({int page = 1, String search = ''}) async {
    if (modifiersLoading.value) return;
    modifiersLoading.value = true;
    final isar = Isar.getInstance();
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
      await isar.writeTxn(() async {
        await isar.itemModifiers.where().deleteAll();
        await isar.itemModifiers.putAll(modifiers);
      });
      return;
    }
    final loadedModifiers = isar.itemModifiers.where().findAllSync();
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
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return false;
    }
    try {
      await isar.writeTxn(() async {
        if (updated) {
          await isar.itemModifiers.put(modefier);
        } else {
          await isar.itemModifiers.put(
            ItemModifier.fromJson(net!.body['update']),
          );
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
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return false;
    }
    try {
      await isar.writeTxn(() async {
        await isar.itemModifiers.deleteAll(id);
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
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return;
    }
    final allTheModels = ItemSavedItemsModel(
      name: name,
      dataMap: checkOutItems.map((e) => _getModel(e)).toList(),
      createdAt: DateTime.now(),
    );
    await isar.writeTxn(() async {
      await isar.itemSavedItemsModels.put(allTheModels);
    });
    checkOutItems.clear();
    selectedCustomer.value = null;
    totalPrice.value = 0;
    loadSavedItems();
  }

  void loadSavedItems() {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    final loadedModels = isar.itemSavedItemsModels.where().findAllSync();
    savedItems.assignAll(loadedModels);
  }

  void unwrapToCart(ItemSavedItemsModel model) async {
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return;
    }
    try {
      checkOutItems.clear();

      final List<Map<String, dynamic>> newCheckOutItems = [];
      for (var savedItem in model.dataMap) {
        // 1. Retrieve the original ItemModel using the baseId
        final ItemModel? originalItem = await isar.itemModels.get(
          savedItem.baseId,
        );

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
          log(
            'Warning: Original ItemModel not found for baseId: ${savedItem.baseId}',
          );
        }
      }

      checkOutItems.addAll(newCheckOutItems);

      // Delete the saved item after successfully loading it
      await isar.writeTxn(() async {
        await isar.itemSavedItemsModels.delete(model.id);
      });

      _calculatedTotalPrice();
      loadSavedItems();
    } catch (e) {
      Toaster.showError("Error ; $e");
      log(e.toString());
    }
  }

  /*
 =================================== PRICE EVALUATION ==============================================
 */
  void _calculatedTotalPrice() {
    totalPrice.value = checkOutItems.fold(0.0, (prev, item) {
      final count = item['count'] as int? ?? 0;
      final addenum = item['addenum'] as double? ?? 0.0;
      final qouted = item['qouted'] as double? ?? 0.0;
      final model = item['item'] as ItemModel;
      double price = count * (model.price + addenum + qouted);
      if (item['discountId'] != null) {
        double discount = (item['discount'] as num?)?.toDouble() ?? 0.0;
        bool percentageDiscount = item['percentageDiscount'] as bool? ?? true;
        price = percentageDiscount
            ? price * (1 - discount / 100)
            : price - discount;
      }
      return prev + price;
    });
    final totalDiscounts = selectedDiscounts.fold(0.0, (prev, data) {
      return prev +
          (!data.percentage
              ? data.value
              : totalPrice.value * (data.value / 100));
    });
    totalPrice.value -= totalDiscounts;
    final totalTax = salesTaxes.fold(0.0, (prev, data) {
      if (data.selectedIds.isNotEmpty) {
        final totalPriceAdded = checkOutItems.fold(0.0, (prv, cv) {
          final model = cv['item'] as ItemModel;
          if (data.selectedIds.contains(model.hexId)) {
            return prv + (model.price * data.value) / 100;
          }
          return prv;
        });
        return prev + totalPriceAdded;
      }
      return prev + (totalPrice.value * data.value) / 100;
    });
    totalPrice.value += totalTax;
  }

  ItemSavedModel _getModel(Map<String, dynamic> e) {
    final model = e['item'] as ItemModel;
    final sm = ItemSavedModel()
      ..dataMap = _compileList(e['dataMap'] as Map<String, bool>? ?? {})
      ..count = e['count']
      ..cost = e['cost'] as double? ?? 0.0
      ..addenum = e['addenum'] as double? ?? 0.0
      ..qouted = e['qouted'] as double? ?? 0.0
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
    int count,
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
      final isar = Isar.getInstance();
      if (isar == null) {
        Toaster.showError("database not initialized");
        return null;
      }
      final modelUpdate = ItemReceitModel.fromJson(response.body['update']);
      model.items[index] = modelUpdate.items[index];
      model.total = modelUpdate.total;
      model.amount = modelUpdate.amount;
      if (e.count < 0) {
        Toaster.showError("$count should be less than ${e.count}");
        return null;
      }
      model.items[index] = e;
      await isar.writeTxn(() async {
        await isar.itemReceitModels.put(model);
      });
      final itemModel = await isar.itemModels.get(e.baseId);
      if (itemModel == null) {
        Toaster.showError("item not found");
        return null;
      }
      if (itemModel.trackStock) {
        itemModel.stockQuantity = itemModel.stockQuantity + count;
        await isar.writeTxn(() async {
          await isar.itemModels.put(itemModel);
        });
      }
      return model;
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
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    cartItems.value = isar.itemModels.where().findAllSync();
    modifiers.value = isar.itemModifiers.where().findAllSync();
    discounts.value = isar.discountModels.where().findAllSync();
    categories.value = isar.itemCategoryModels.where().findAllSync();
    taxes.value = isar.taxModels.where().findAllSync();
    final r = isar.itemReceitModels.where().sortByCreatedAtDesc().findAllSync();
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
    final isar = Isar.getInstance();
    if (isar != null) {
      await isar.writeTxn(() async {
        await isar.taxModels.put(tax);
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
    syncingTaxesFailed.value = "";
    final response = await Net.get("/cashier/taxes?page=$page&search=$search");
    syncingTaxes.value = false;
    if (response.hasError) {
      syncingTaxesFailed.value = response.response;
      return;
    }
    final list = response.body['list'] as List<dynamic>? ?? [];
    taxes.value = list.map((e) => TaxModel.fromJson(e)).toList();
    final isar = Isar.getInstance();
    if (isar != null) {
      await isar.writeTxn(() async {
        await isar.taxModels.where().deleteAll();
        await isar.taxModels.putAll(taxes);
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
    final isar = Isar.getInstance();
    if (isar != null) {
      await isar.writeTxn(() async {
        await isar.discountModels.put(discount);
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
      syncingDiscountsFailed.value = response.response;
      return;
    }
    final list = response.body['list'] as List<dynamic>? ?? [];
    discounts.value = list.map((e) => DiscountModel.fromJson(e)).toList();
    final isar = Isar.getInstance();
    if (isar != null) {
      await isar.writeTxn(() async {
        await isar.discountModels.where().deleteAll();
        await isar.discountModels.putAll(discounts);
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
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return null;
    }
    ItemModel? model = isar.itemModels
        .filter()
        .barcodeEqualTo(barCode)
        .findFirstSync();
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
    final isar = Isar.getInstance();
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
    await isar.writeTxn(() async {
      await isar.itemModels.where().deleteAll();
      if (itemsPage.value > 1) {
        await isar.itemModels.putAll(fixedItems);
      }
      await isar.itemModels.putAll(models);
    });
    final loadedItems = isar.itemModels.where().findAllSync();
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
    e['count'] += increment;
    checkOutItems[indexOfSelected] = e;
    _calculatedTotalPrice();
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
    int count = -1,
    String? discountId,
    double qouted = 0.0,
    double addenum = 0.0,
    double discount = 0.0,
    int restoreAmount = -1,
    Map<String, bool>? dataMap,
    bool percentageDiscount = true,
  }) async {
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError("Database initilization error");
      return;
    }
    if (checkOutItems.isEmpty) {
      salesTaxes.value = isar.taxModels
          .filter()
          .activatedEqualTo(true)
          .findAllSync();
    }
    final dataFound = checkOutItems.indexWhere((e) {
      final id = e['id'];
      if (id is int) {
        return id == model.id;
      }
      return false;
    });
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
      final isar = Isar.getInstance();
      if (isar == null) {
        Toaster.showError('Database not initialized');
        return false;
      }
      await isar.writeTxn(() async {
        if (update) {
          await isar.itemModels.put(item);
        } else {
          await isar.itemModels.put(obj);
        }
      });
      syncCartItemsOnBackground();
      return true;
    } catch (e) {
      log("Error $e");
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
      final isar = Isar.getInstance();
      if (isar == null) {
        Toaster.showError('Database not initialized');
        return false;
      }
      await isar.writeTxn(() async {
        if (update) {
          category.name = obj.name;
          category.color = obj.color;
          await isar.itemCategoryModels.put(category);
        } else {
          await isar.itemCategoryModels.put(obj);
        }
      });
      loadCategories();
      return true;
    } catch (e) {
      log('Error adding category: $e');
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
  }) async {
    try {
      final isar = Isar.getInstance();
      if (isar == null) {
        Toaster.showError('Database not initialized');
        return false;
      }
      final discounts = selectedDiscounts;
      final itemReceitModel = ItemReceitModel(
        hexId: "",
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
        synced: false,
        discounts: discounts
            .map((e) => EmbeddedDiscountModel.fromModel(e))
            .toList(),
        customerId: selectedCustomer.value?.hexId,
        items: checkOutItems.map((e) {
          final model = e['item'] as ItemModel;
          final receit = ItemReceitItem()
            ..name = model.name
            ..baseId = model.id
            ..itemId = e['hexId']
            ..originalCount = e['count'] ?? 0
            ..cost = e['cost'] as double? ?? 0.0
            ..discountId = e['discountId'] as String?
            ..addenum = e['addenum'] as double? ?? 0.0
            ..price = model.price + e['qouted'] as double? ?? 0.0
            ..discount = (e['discount'] as num?)?.toDouble() ?? 0.0
            ..percentageDiscount = e['percentageDiscount'] as bool? ?? true
            ..count = e['count'] ?? 0;
          return receit;
        }).toList(),
        change: payedAmount - totalPrice.value,
        createdAt: DateTime.now(),
        total: totalPrice.value,
      );
      final totalTax = salesTaxes.fold(0.0, (prev, data) {
        if (data.selectedIds.isNotEmpty) {
          final totalPriceAdded = checkOutItems.fold(0.0, (prv, cv) {
            final model = cv['item'] as ItemModel;
            if (data.selectedIds.contains(model.hexId)) {
              return prv + (model.price * data.value) / 100;
            }
            return prv;
          });
          return prev + totalPriceAdded;
        }
        return prev + (totalPrice.value * data.value) / 100;
      });
      itemReceitModel.tax = totalTax;
      int newReceitId = -1;
      await isar.writeTxn(() async {
        newReceitId = await isar.itemReceitModels.put(itemReceitModel);
      });
      if (selectedShift.value != null) {
        selectedShift.value!.totalSales += totalPrice.value;
        selectedShift.value!.totalCustomers++;
        selectedShift.value!.salesQuantity += checkOutItems.length;
        await isar.writeTxn(() async {
          isar.shiftsModels.put(selectedShift.value!);
        });
      }
      user.receitsCount++;
      User.saveToStorage(user);
      updateReceitsInBackground(newReceitId, itemReceitModel);
      if (printReceits) {
        DevicesController.printReceitToBackround(
          itemReceitModel,
          user,
          selectedCustomer.value,
          salesTaxes,
        );
      }
      salesTaxes.clear();
      discounts.clear();
      checkOutItems.clear();
      selectedCustomer.value = null;
      totalPrice.value = 0;
      loadReceitsStatic();
      return true;
    } catch (e) {
      Toaster.showError("There was error : $e");
      return false;
    }
  }

  Future<void> updateReceitsInBackground(
    int id,
    ItemReceitModel itemReceitModel,
  ) async {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    receitsLoading.value = true;
    final response = await Net.post(
      "/cashier/purchase",
      data: itemReceitModel.toJson(),
    );
    if (response.hasError) {
      receitsLoading.value = true;
      return;
    }
    final receivedModel = ItemReceitModel.fromJson(response.body['update']);
    await isar.writeTxn(() async {
      receivedModel.id = id;
      await isar.itemReceitModels.put(receivedModel);
    });
    loadReceits();
    syncCartItemsOnBackground();
  }

  RxBool updatingUsyncedReceits = RxBool(true);
  void _updateUnsyncedReceits() async {
    if (updatingUsyncedReceits.value) return;
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    updatingUsyncedReceits.value = true;
    final allUnsynced = await isar.itemReceitModels
        .filter()
        .syncedEqualTo(false)
        .findAll();
    for (final receit in allUnsynced) {
      await updateReceitsInBackground(receit.id, receit);
      await Future.delayed(Duration(milliseconds: 500));
    }
    updatingUsyncedReceits.value = false;
  }

  /*
  =========================================================================
  =========================================================================
  SHIFTS
  =========================================================================
  =========================================================================
*/
  void openShift(double amountInDrawer, User user) async {
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError("something went wrong on opening a shift");
      return;
    }
    final count = await isar.shiftsModels.where().count();
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
    await isar.writeTxn(() async {
      await isar.shiftsModels.put(model);
    });
    selectedShift.value = model;
  }

  void closeShift(double amountInDrawer, User user) async {
    if (selectedShift.value == null) {
      Toaster.showError("something went wrong on closing a shift");
      return;
    }
    final isar = Isar.getInstance();
    if (isar == null || selectedShift.value == null) {
      Toaster.showError("something went wrong on closing a shift");
      return;
    }
    selectedShift.value!.shiftIsClosed = true;
    selectedShift.value!.cashDrawerEnd = amountInDrawer;
    selectedShift.value!.closeShiftTime = DateTime.now();
    await isar.writeTxn(() async {
      await isar.shiftsModels.put(selectedShift.value!);
    });
    selectedShift.value = null;
  }

  void reopenLastUnclosedShift() async {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    selectedShift.value = await isar.shiftsModels
        .filter()
        .shiftIsClosedEqualTo(false)
        .findFirst();
  }

  void loadShifts() async {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    shifts.value = await isar.shiftsModels
        .where()
        .sortByOpenShiftTimeDesc()
        .findAll();
  }

  void syncAllShifts() async {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    final allShifts = isar.shiftsModels
        .filter()
        .shiftIsClosedEqualTo(true)
        .and()
        .syncedEqualTo(false)
        .findAllSync();
    for (final shift in allShifts) {
      final response = await Net.post("/cashier/shifts", data: shift.toJson());
      if (response.hasError) {
        break;
      }
      final updatedShift = ShiftsModel.fromJson(response.body['update']);
      await isar.writeTxn(() async {
        shift.synced = true;
        shift.userId = updatedShift.userId;
        await isar.shiftsModels.put(shift);
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
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    salesTaxes.value = isar.taxModels.where().findAllSync();
    _calculatedTotalPrice();
  }
}
