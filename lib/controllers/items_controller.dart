import 'dart:developer';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:mistpos/models/item_saved_model.dart';
import 'package:mistpos/models/item_receit_item.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/models/item_modifier_model.dart';
import 'package:mistpos/models/item_categories_model.dart';
import 'package:mistpos/models/item_saved_items_model.dart';

class ItemsController extends GetxController {
  RxDouble totalPrice = RxDouble(0);
  RxString selectedCategory = ''.obs;
  RxList<ItemModel> cartItems = <ItemModel>[].obs;
  RxList<ItemModifier> modifiers = <ItemModifier>[].obs;
  RxList<ItemReceitModel> receits = <ItemReceitModel>[].obs;
  RxList<ItemCategoryModel> categories = <ItemCategoryModel>[].obs;
  RxList<ItemSavedItemsModel> savedItems = <ItemSavedItemsModel>[].obs;
  RxList<Map<String, dynamic>> checkOutItems = <Map<String, dynamic>>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadMofiers();
    loadCartItems();
    loadCategories();
    loadSavedItems();
    loadReceits();
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
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return;
    }
    final count = e['count'] as int;
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
    int indexOfModel = cartItems.indexWhere((e) => e.id == model.id);
    if (indexOfModel < 0) {
      Toaster.showError("Item error found");
      return;
    }
    final mdl = cartItems[indexOfModel];
    cartItems[indexOfModel] = mdl;
    if (mdl.trackStock) {
      mdl.stockQuantity = mdl.stockQuantity + count;
      await isar.writeTxn(() async {
        await isar.itemModels.put(mdl);
      });
    }
  }

  Future<void> removeAllSelected() async {
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return;
    }
    for (var e in checkOutItems) {
      final count = e['count'] as int;
      final model = e['item'] as ItemModel;
      model.stockQuantity = model.stockQuantity + count;
      if (model.trackStock) {
        await isar.writeTxn(() async {
          await isar.itemModels.put(model);
        });
      }
    }
    checkOutItems.clear();
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
    if (model.trackStock) {
      final isar = Isar.getInstance();
      if (isar == null) {
        Toaster.showError("failed to init database");
        return;
      }
      int indexOfModel = cartItems.indexWhere((d) => d.id == model.id);
      if (indexOfModel < 0) {
        Toaster.showError("item not found");
        return;
      }
      final md = cartItems[indexOfModel];
      if (md.stockQuantity <= 0) {
        Toaster.showError("item is out of stock ");
        return;
      }
      md.stockQuantity = md.stockQuantity + restoreAmount;
      await isar.writeTxn(() async {
        await isar.itemModels.put(md);
      });
      cartItems[indexOfModel] = md;
      model = md;
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

  Future<bool> createItem(ItemModel item) async {
    try {
      final isar = Isar.getInstance();
      if (isar == null) {
        Toaster.showError('Database not initialized');
        return false;
      }
      await isar.writeTxn(() async {
        await isar.itemModels.put(item);
      });
      loadCartItems();
      return true;
    } catch (e) {
      Toaster.showError('Failed to create item');
      return false;
    }
  }

  Future<bool> createCategory(ItemCategoryModel category) async {
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return false;
    }
    try {
      await isar.writeTxn(() async {
        await isar.itemCategoryModels.put(category);
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
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    final loadedCategories = isar.itemCategoryModels.where().findAllSync();
    categories.assignAll(loadedCategories);
  }

  void loadSavedItems() {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    final loadedModels = isar.itemSavedItemsModels.where().findAllSync();
    savedItems.assignAll(loadedModels);
  }

  void loadReceits() {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    final r = isar.itemReceitModels.where().sortByCreatedAtDesc().findAllSync();
    receits.assignAll(r);
  }

  void loadMofiers() {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    final loadedModifiers = isar.itemModifiers.where().findAllSync();
    modifiers.assignAll(loadedModifiers);
  }

  void loadCartItems() {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    if (selectedCategory.value.isNotEmpty) {
      final loadedItems = isar.itemModels
          .filter()
          .categoryEqualTo(selectedCategory.value)
          .findAllSync();
      cartItems.assignAll(loadedItems);
      return;
    }
    final loadedItems = isar.itemModels.where().findAllSync();
    cartItems.assignAll(loadedItems);
  }

  void searchItems(String searchTerm) {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    final loadedItems = isar.itemModels
        .filter()
        .nameContains(searchTerm, caseSensitive: false)
        .findAllSync();
    cartItems.assignAll(loadedItems);
  }

  void deleteCategories(List<int> ids) async {
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError("database not initialized");
      return;
    }
    await isar.writeTxn(() async {
      final count = await isar.itemCategoryModels.deleteAll(ids);
      Toaster.showSuccess("deleted $count");
    });
    loadCategories();
  }

  void deleteItems(List<int> ids) async {
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError("database not initialized");
      return;
    }
    await isar.writeTxn(() async {
      final count = await isar.itemModels.deleteAll(ids);
      Toaster.showSuccess("deleted $count");
    });
    loadCartItems();
  }

  Future<bool> createModifier(ItemModifier modefier) async {
    final isar = Isar.getInstance();
    if (isar == null) {
      Toaster.showError('Database not initialized');
      return false;
    }
    try {
      await isar.writeTxn(() async {
        await isar.itemModifiers.put(modefier);
      });
      loadMofiers();
      return true;
    } catch (e) {
      log('Error adding modifier: $e');
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
    totalPrice.value = 0;
    loadSavedItems();
  }

  void _calculatedTotalPrice() {
    totalPrice.value = checkOutItems.fold(0.0, (prev, item) {
      final count = item['count'] as int? ?? 0;
      final addenum = item['addenum'] as double? ?? 0.0;
      final qouted = item['qouted'] as double? ?? 0.0;
      final model = item['item'] as ItemModel;
      return prev + count * model.price + addenum + qouted;
    });
  }

  ItemSavedModel _getModel(Map<String, dynamic> e) {
    final model = e['item'] as ItemModel;
    final sm = ItemSavedModel()
      ..dataMap = _compileList(e['dataMap'] as Map<String, bool>? ?? {})
      ..count = e['count']
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
            "count": savedItem.count,
            "addenum": savedItem.addenum,
            "qouted": savedItem.qouted,
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

  Future<bool> addReceitFromItemModel(
    double payedAmount,
    String payment,
  ) async {
    try {
      final isar = Isar.getInstance();
      if (isar == null) {
        Toaster.showError('Database not initialized');
        return false;
      }
      final itemReceitModel = ItemReceitModel(
        cashier: "admin",
        payment: payment,
        amount: payedAmount,
        items: checkOutItems.map((e) {
          final model = e['item'] as ItemModel;
          final receit = ItemReceitItem()
            ..name = model.name
            ..baseId = model.id
            ..price = model.price + e['qouted'] as double? ?? 0.0
            ..addenum = e['addenum'] as double? ?? 0.0
            ..count = e['count'] ?? 0;
          return receit;
        }).toList(),
        change: payedAmount - totalPrice.value,
        createdAt: DateTime.now(),
        total: totalPrice.value,
      );
      await isar.writeTxn(() async {
        await isar.itemReceitModels.put(itemReceitModel);
      });
      checkOutItems.clear();
      totalPrice.value = 0;
      loadReceits();
      return true;
    } catch (e) {
      Toaster.showError("There was error : $e");
      return false;
    }
  }

  Future<ItemReceitModel?> refundItem(
    ItemReceitModel model,
    ItemReceitItem e,
    int count,
    int index,
  ) async {
    try {
      final isar = Isar.getInstance();
      if (isar == null) {
        Toaster.showError("database not initialized");
        return null;
      }
      e.count = e.count - count;
      e.refunded = true;
      model.total = model.total - (e.price + e.addenum) * count;
      model.amount = model.amount + (e.price + e.addenum) * count;
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
}
