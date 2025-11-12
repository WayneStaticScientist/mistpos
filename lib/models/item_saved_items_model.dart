import 'package:isar/isar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mistpos/models/item_saved_model.dart';
import 'package:mistpos/models/item_unsaved_model.dart';
part 'item_saved_items_model.g.dart';

@collection
class ItemSavedItemsModel {
  String name;
  Id id = Isar.autoIncrement;
  RxList<ItemUnsavedModel> cartItems = RxList();
  List<ItemSavedModel> dataMap;
  DateTime createdAt;
  ItemSavedItemsModel({
    required this.name,
    required this.dataMap,
    required this.createdAt,
  });
}
