import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/models/item_saved_model.dart';

import '../main.dart';
part 'item_saved_items_model.g.dart';

@collection
class ItemSavedItemsModel {
  String name;
  late int id = IdGen.id;
  List<ItemSavedModel> dataMap;
  DateTime createdAt;
  ItemSavedItemsModel({
    required this.name,
    required this.dataMap,
    required this.createdAt,
  });
}
