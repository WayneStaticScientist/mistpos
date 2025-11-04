import 'dart:developer';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:mistpos/models/user_model.dart';
import 'package:mistpos/models/response_model.dart';
import 'package:mistpos/models/customer_model.dart';
import 'package:mistpos/models/item_saved_model.dart';
import 'package:mistpos/models/item_receit_item.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/services/network_wrapper.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/models/item_modifier_model.dart';
import 'package:mistpos/models/item_categories_model.dart';
import 'package:mistpos/models/item_saved_items_model.dart';
import 'package:pos_universal_printer/pos_universal_printer.dart';

class ItemsController extends GetxController {
  RxDouble totalPrice = RxDouble(0);
  RxString selectedCategory = ''.obs;
  RxList<ItemModel> cartItems = <ItemModel>[].obs;
  RxList<ItemModifier> modifiers = <ItemModifier>[].obs;
  RxList<CustomerModel> customers = <CustomerModel>[].obs;
  RxList<ItemReceitModel> receits = <ItemReceitModel>[].obs;
  Rx<CustomerModel?> selectedCustomer = Rx<CustomerModel?>(null);
  RxList<ItemCategoryModel> categories = <ItemCategoryModel>[].obs;
  RxList<ItemSavedItemsModel> savedItems = <ItemSavedItemsModel>[].obs;
  RxList<Map<String, dynamic>> checkOutItems = <Map<String, dynamic>>[].obs;
  @override
  void onInit() {
    _loadFixedItems();
    _loadFixedCategories();
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

  void removeSelectedItem(Map<String, dynamic> e) async {
    final model = e['item'] as ItemModel;
    int indexOfSelected = checkOutItems.indexWhere((e) {
      final lmodel = e['item'] as ItemModel;
      return lmodel.id == model.id;
    });
    if (indexOfSelected < 0) {
      Toaster.showError("something went wrong");
      return;
    }
    checkOutItems.removeAt(indexOfSelected);
    _calculatedTotalPrice();
  }

  Future<void> removeAllSelected() async {
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return;
    }
    checkOutItems.clear();
    selectedCustomer.value = null;
    totalPrice.value = 0;
    loadCartItems();
  }

  void addSelectedItem(
    ItemModel model, {
    int count = -1,
    double qouted = 0.0,
    double addenum = 0.0,
    Map<String, bool>? dataMap,
    int restoreAmount = -1,
  }) async {
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
      });
      _calculatedTotalPrice();
      return;
    }
    final modelFound = checkOutItems[dataFound];
    modelFound['count'] = count < 0 ? modelFound['count'] + 1 : count;
    modelFound['dataMap'] = dataMap ?? <String, bool>{};
    modelFound['addenum'] = addenum;
    modelFound['qouted'] = qouted;
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
      loadCartItems();
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

  void loadSavedItems() {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    final loadedModels = isar.itemSavedItemsModels.where().findAllSync();
    savedItems.assignAll(loadedModels);
  }

  void loadReceits({int page = 1, String search = ''}) async {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    final response = await Net.get(
      "/cashier/receits?page=$page&search=$search",
    );
    if (!response.hasError) {
      if (response.body['list'] != null) {
        final list = response.body['list'] as List<dynamic>;
        receits.assignAll(
          list.map((e) => ItemReceitModel.fromJson(e)).toList(),
        );
      }
      await isar.writeTxn(() async {
        await isar.itemReceitModels.where().deleteAll();
        await isar.itemReceitModels.putAll(receits);
      });
      return;
    }

    final r = isar.itemReceitModels.where().sortByCreatedAtDesc().findAllSync();
    receits.assignAll(r);
  }

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
    if (page > 1) {
      syncCartItemsOnBackground(page: page, search: search, category: category);
      return;
    }
    if (selectedCategory.value.isNotEmpty) {
      final loadedItems = isar.itemModels
          .filter()
          .categoryEqualTo(selectedCategory.value)
          .nameContains(search)
          .findAllSync();
      cartItems.assignAll(loadedItems);
    } else {
      final loadedItems = isar.itemModels
          .filter()
          .nameContains(search)
          .findAllSync();
      cartItems.assignAll(loadedItems);
    }
    syncCartItemsOnBackground(page: page, search: search, category: category);
  }

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
      "/cashier/products?page=$page&search=$search&category=$category&$isCompositeItems=${isCompositeItems ? "true" : "false"}",
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

  RxBool deleting = RxBool(false);
  void deleteCategory(String id) async {
    if (deleting.value) {
      Toaster.showError("deletion in progress please wait");
      return;
    }
    deleting.value = true;
    final response = await Net.delete("/admin/category/$id");
    if (response.hasError && response.statusCode != 404) {
      deleting.value = false;
      Toaster.showError(response.response);
      return;
    }

    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError("database not initialized");
      deleting.value = false;
      return;
    }
    await isar.writeTxn(() async {
      final count = await isar.itemCategoryModels
          .filter()
          .hexIdEqualTo(id)
          .deleteAll();
      Toaster.showSuccess("deleted $count");
    });
    loadCategories();
    deleting.value = false;
  }

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
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError("database not initialized");
      deleting.value = false;
      return;
    }
    await isar.writeTxn(() async {
      final count = await isar.itemModels.filter().hexIdEqualTo(id).deleteAll();
      Toaster.showSuccess("deleted $count");
    });
    loadCartItems();
    deleting.value = false;
  }

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

  void _calculatedTotalPrice() {
    totalPrice.value = checkOutItems.fold(0.0, (prev, item) {
      final count = item['count'] as int? ?? 0;
      final addenum = item['addenum'] as double? ?? 0.0;
      final qouted = item['qouted'] as double? ?? 0.0;
      final model = item['item'] as ItemModel;
      return prev + count * (model.price + addenum + qouted);
    });
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

  Map<String, bool> _decodeDataMap(List<String> dataMap) {
    Map<String, bool> data = {};
    for (var e in dataMap) {
      data[e] = true;
    }
    return data;
  }

  Future<({bool success, List<ItemReceitItem>? rejects})>
  addReceitFromItemModel(
    double payedAmount,
    String payment, {
    required bool allowOfflinePurchase,
    bool printReceits = false,
    required User user,
  }) async {
    List<ItemReceitItem>? rejects;
    try {
      final isar = Isar.getInstance();
      if (isar == null) {
        Toaster.showError('Database not initialized');
        return (success: false, rejects: rejects);
      }
      final itemReceitModel = ItemReceitModel(
        hexId: "",
        cashier: "admin",
        payment: payment,
        amount: payedAmount,
        customerId: selectedCustomer.value?.hexId,
        items: checkOutItems.map((e) {
          final model = e['item'] as ItemModel;
          final receit = ItemReceitItem()
            ..itemId = e['hexId']
            ..name = model.name
            ..cost = e['cost'] as double? ?? 0.0
            ..baseId = model.id
            ..originalCount = e['count'] ?? 0
            ..price = model.price + e['qouted'] as double? ?? 0.0
            ..addenum = e['addenum'] as double? ?? 0.0
            ..count = e['count'] ?? 0;
          return receit;
        }).toList(),
        change: payedAmount - totalPrice.value,
        createdAt: DateTime.now(),
        total: totalPrice.value,
      );
      final response = await Net.post(
        "/cashier/purchase",
        data: itemReceitModel.toJson(),
      );
      if (response.hasError &&
          (response.statusCode == null || response.statusCode! > 0)) {
        Toaster.showError(response.response);
        return (success: false, rejects: rejects);
      }
      if (response.hasError && (response.statusCode! < 0)) {
        if (allowOfflinePurchase) {
          Toaster.showError(response.response);
          return (success: false, rejects: rejects);
        }
        Toaster.showError("syncing to online server failed continuing offline");
      }
      if (response.hasError) {
        await isar.writeTxn(() async {
          await isar.itemReceitModels.put(itemReceitModel);
        });
      } else {
        List<dynamic>? drejects = response.body['rejects'];
        if (drejects != null && drejects.isNotEmpty) {
          rejects = drejects.map((e) => ItemReceitItem.fromJson(e)).toList();
        }
        final receivedModel = ItemReceitModel.fromJson(response.body['update']);
        await isar.writeTxn(() async {
          await isar.itemReceitModels.put(receivedModel);
        });
      }
      checkOutItems.clear();
      selectedCustomer.value = null;
      totalPrice.value = 0;
      if (printReceits) printReceitToBackround(itemReceitModel, user);
      loadReceits();
      syncCartItemsOnBackground();
      return (success: true, rejects: rejects);
    } catch (e) {
      Toaster.showError("There was error : $e");
      return (success: false, rejects: rejects);
    }
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
  void loadCustomers({String search = '', int page = 1}) async {
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

  void printReceitToBackround(ItemReceitModel itemReceitModel, User user) {
    final printer = PosUniversalPrinter.instance;
    final b = EscPosBuilder();
    b.text(user.companyName.toString());
    b.feed(2);
    b.text("Company ${user.companyName.toString()}");
    b.text('*** Fiscal Receipt ***', bold: true, align: PosAlign.center);
    b.text('Role: ${user.role.toString()}');
    b.text('Time: ${DateTime.now().toIso8601String()}');
    b.feed(2);
    for (final item in itemReceitModel.items) {
      if (item.count > 1) {
        b.text(item.name);
        b.text(
          "${item.count}    ${CurrenceConverter.getCurrenceFloatInStrings(item.addenum + item.price)}   - ${CurrenceConverter.getCurrenceFloatInStrings((item.addenum + item.price)) * item.count}",
        );
      } else {
        b.text(
          "${item.name}      -  ${CurrenceConverter.getCurrenceFloatInStrings(item.price)}}",
        );
      }
    }
    b.feed(2);
    b.text(
      "total       - ${CurrenceConverter.getCurrenceFloatInStrings(itemReceitModel.total)}",
    );
    b.text('--- END ---', align: PosAlign.center);
    b.cut(); // Add a paper cut command
    printer.printEscPos(PosPrinterRole.cashier, b);
  }

  void _loadFixedItems() {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    cartItems.value = isar.itemModels.where().findAllSync();
  }

  void _loadFixedCategories() {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    categories.value = isar.itemCategoryModels.where().findAllSync();
  }
}
