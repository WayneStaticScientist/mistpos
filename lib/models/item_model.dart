import 'package:isar/isar.dart';
import 'package:mistpos/models/inv_item.dart';
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
  int stockQuantity;
  int lowStockThreshold;
  List<String>? modifiers;
  bool syncOnline = false;
  bool useProduction = false;
  bool isCompositeItem = false;
  bool isForSale = true;

  List<InvItem> compositeItems = [];

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
    this.syncOnline = false,
    this.hexId = "",
    this.isCompositeItem = false,
    this.useProduction = false,
    this.compositeItems = const [],
    this.modifiers,
    this.isForSale = true,
  });
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "category": category,
      "price": price,
      "isForSale": isForSale,
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
      "syncOnline": syncOnline,
      "modifiers": modifiers,
      "isCompositeItem": isCompositeItem,
      "useProduction": useProduction,
      "compositeItems": compositeItems.map((e) => e.toMap()).toList(),
    };
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      hexId: json["_id"],
      isForSale: json["isForSale"] as bool? ?? true,
      color: json["color"] as int?,
      sku: json["sku"] as String? ?? "",
      name: json["name"] as String? ?? "",
      shape: json["shape"] as String? ?? "",

      isCompositeItem: json["isCompositeItem"] as bool? ?? false,
      useProduction: json["useProduction"] as bool? ?? false,
      compositeItems:
          (json["compositeItems"] as List<dynamic>?)
              ?.map((e) => InvItem.fromJson(e))
              .toList() ??
          [],
      stockQuantity: json["stockQuantity"],
      avatar: json["avatar"] as String? ?? "",
      soldBy: json["soldBy"] as String? ?? "",
      barcode: json["barcode"] as String? ?? "",
      category: json["category"] as String? ?? "",
      lowStockThreshold: json["lowStockThreshold"],
      modifiers: (json["modifiers"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      cost: (json["cost"] as num?)?.toDouble() ?? 0.0,
      trackStock: json["trackStock"] as bool? ?? false,
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      syncOnline: json["syncOnline"] as bool? ?? false,
    );
  }
}
