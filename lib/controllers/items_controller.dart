import 'dart:developer';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mistpos/models/item_modifier_model.dart';
import 'package:mistpos/models/item_saved_items_model.dart';
import 'package:mistpos/models/item_saved_model.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:mistpos/models/item_categories_model.dart';

class ItemsController extends GetxController {
  RxDouble totalPrice = RxDouble(0);
  RxString selectedCategory = ''.obs;
  RxList<ItemModel> cartItems = <ItemModel>[].obs;
  RxList<ItemModifier> modifiers = <ItemModifier>[].obs;
  RxList<ItemCategoryModel> categories = <ItemCategoryModel>[].obs;
  RxList<Map<String, dynamic>> checkOutItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMofiers();
    loadCartItems();
    loadCategories();
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
      md.stockQuantity = md.stockQuantity - 1;
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
    final sm = ItemSavedModel();
    final model = e['item'] as ItemModel;
    sm.baseId = model.id;
    sm.dataMap = _compileList(e['dataMap'] as Map<String, bool>? ?? {});
    sm.count = e['count'];
    sm.addenum = e['addenum'] as double? ?? 0.0;
    sm.qouted = e['qouted'] as double? ?? 0.0;
    return sm;
  }

  List<String> _compileList(Map<String, bool> map) {
    return map.keys.toList();
  }
}
