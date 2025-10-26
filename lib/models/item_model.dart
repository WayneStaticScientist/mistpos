import 'package:isar/isar.dart';
part 'item_model.g.dart';

@collection
class ItemModel {
  Id id = Isar.autoIncrement;
  String sku;
  int? color;
  double cost;
  String name;
  String hexId;
  double price;
  String? shape;
  String soldBy;
  String? avatar;
  String category;
  String barcode;
  bool trackStock;
  List<int>? modifierIds;
  List<String>? modifiers;
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
    this.hexId = "",
    this.modifiers,
  });
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "category": category,
      "price": price,
      "cost": cost,
      "soldBy": soldBy,
      "sku": sku,
      "barcode": barcode,
      "trackStock": trackStock,
      "stockQuantity": stockQuantity,
      "lowStockThreshold": lowStockThreshold,
      "color": color,
      "shape": shape,
      "avatar": avatar,
      "modifierIds": modifierIds,
      "syncOnline": syncOnline,
      "modifiers": modifiers,
    };
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      hexId: json["_id"],
      color: json["color"] as int?,
      sku: json["sku"] as String? ?? "",
      name: json["name"] as String? ?? "",
      shape: json["shape"] as String? ?? "",
      stockQuantity: json["stockQuantity"],
      avatar: json["avatar"] as String? ?? "",
      soldBy: json["soldBy"] as String? ?? "",
      barcode: json["barcode"] as String? ?? "",
      category: json["category"] as String? ?? "",
      lowStockThreshold: json["lowStockThreshold"],
      modifiers: json["modifiers"] as List<String>?,
      cost: (json["cost"] as num?)?.toDouble() ?? 0.0,
      trackStock: json["trackStock"] as bool? ?? false,
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      syncOnline: json["syncOnline"] as bool? ?? false,
    );
  }
}
