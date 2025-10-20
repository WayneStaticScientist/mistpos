import 'dart:developer';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/item_model.dart';
import 'package:mistpos/models/item_categories_model.dart';

class ItemsController extends GetxController {
  RxDouble totalPrice = RxDouble(0);
  RxString selectedCategory = ''.obs;
  RxList<ItemModel> cartItems = <ItemModel>[].obs;
  RxList<ItemCategoryModel> categories = <ItemCategoryModel>[].obs;
  RxList<Map<String, dynamic>> checkOutItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
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

  void addSelectedItem(ItemModel model) async {
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
      checkOutItems.add({'id': model.id, 'item': model, "count": 1});
      return;
    }
    final modelFound = checkOutItems[dataFound];
    modelFound['count'] = modelFound['count'] + 1;
    checkOutItems[dataFound] = modelFound;
    totalPrice.value = checkOutItems.fold(0, (prev, item) {
      final count = item['count'] as int? ?? 0;
      final model = item['item'] as ItemModel;
      return prev + count * model.price;
    });
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
}
