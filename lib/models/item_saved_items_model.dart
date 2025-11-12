import 'package:isar/isar.dart';
import 'package:mistpos/models/item_saved_model.dart';
part 'item_saved_items_model.g.dart';

@collection
class ItemSavedItemsModel {
  String name;
  Id id = Isar.autoIncrement;
  List<ItemSavedModel> dataMap;
  DateTime createdAt;
  ItemSavedItemsModel({
    required this.name,
    required this.dataMap,
    required this.createdAt,
  });
}
