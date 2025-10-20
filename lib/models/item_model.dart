import 'package:isar/isar.dart';
part 'item_model.g.dart';

@collection
class ItemModel {
  Id id = Isar.autoIncrement;
  String sku;
  int? color;
  double cost;
  String name;
  double price;
  String? shape;
  String soldBy;
  String? avatar;
  String category;
  String barcode;
  bool trackStock;
  List<int>? modifierIds;
  int stockQuantity;
  int lowStockThreshold;
  bool syncOnline = false;

  ItemModel({
    required this.name,
    required this.category,
    required this.price,
    required this.cost,
    required this.soldBy,
    required this.sku,
    required this.barcode,
    required this.trackStock,
    required this.stockQuantity,
    required this.lowStockThreshold,
    required this.color,
    required this.shape,
    required this.avatar,
    this.modifierIds,
    this.syncOnline = false,
  });
}
