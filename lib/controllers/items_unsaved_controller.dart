import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/services/network_wrapper.dart';
import 'package:mistpos/models/item_unsaved_model.dart';

class ItemsUnsavedController extends GetxController {
  RxList<ItemUnsavedModel> cartItems = RxList();
  RxInt itemsPage = RxInt(1);
  RxInt totalPages = RxInt(2);
  RxBool syncingItems = RxBool(false);
  RxString syncingItemsFailed = RxString("");
  @override
  void onInit() {
    _loadFixedItems();
    super.onInit();
  }

  Future<bool> createItem(ItemUnsavedModel item, {update = true}) async {
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
      final obj = ItemUnsavedModel.fromJson(response.body['update']);
      final isar = Isar.getInstance();
      if (isar == null) {
        Toaster.showError('Database not initialized');
        return false;
      }
      await isar.writeTxn(() async {
        if (update) {
          await isar.itemUnsavedModels.put(item);
        } else {
          await isar.itemUnsavedModels.put(obj);
        }
      });
      syncCartItemsOnBackground();
      return true;
    } catch (e) {
      Toaster.showError('Failed to create item');
      return false;
    }
  }

  //delete
  RxBool deleting = RxBool(false);
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
    syncCartItemsOnBackground();
  }

  Future<void> search({String search = "", String category = ""}) async {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    syncingItems.value = true;
    cartItems.value = isar.itemUnsavedModels
        .filter()
        .nameContains(search, caseSensitive: false)
        .and()
        .categoryContains(category)
        .findAllSync();
    syncingItems.value = false;
  }

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
      "/cashier/products?page=$page&search=$search&category=$category&composite=$isCompositeItems",
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
    List<ItemUnsavedModel> models = itemList.map((e) {
      return ItemUnsavedModel.fromJson((e));
    }).toList();

    await isar.writeTxn(() async {
      await isar.itemUnsavedModels.where().deleteAll();
      await isar.itemUnsavedModels.putAll(models);
    });
    final loadedItems = isar.itemUnsavedModels.where().findAllSync();
    cartItems.assignAll(loadedItems);
    syncingItems.value = false;
  }

  void _loadFixedItems() {
    final isar = Isar.getInstance();
    if (isar == null) {
      return;
    }
    final loadedItems = isar.itemUnsavedModels.where().findAllSync();
    cartItems.assignAll(loadedItems);
  }
}
