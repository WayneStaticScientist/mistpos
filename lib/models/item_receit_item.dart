import 'package:isar/isar.dart';
part 'item_receit_item.g.dart';

@embedded
class ItemReceitItem {
  late String name;
  late int count;
  late double price;
  double cost = 0;
  late double addenum;
  late String itemId;
  String rejectedReason = "";
  bool refunded = false;
  int originalCount = 0;
  double discount = 0;
  String? discountId;
  bool percentageDiscount = true;
  int baseId = 0;
  ItemReceitItem();
  Map<String, dynamic> toJson() {
    return {
      "cost": cost,
      "name": name,
      "count": count,
      "price": price,
      "addenum": addenum,
      "itemId": itemId,
      "refunded": refunded,
      "baseId": baseId,
      "originalCount": originalCount,
      "rejectedReason": rejectedReason,
      "discount": discount,
      "discountId": discountId,
      "percentageDiscount": percentageDiscount,
    };
  }

  factory ItemReceitItem.fromJson(Map<String, dynamic> data) {
    return ItemReceitItem()
      ..name = data["name"]
      ..count = data['count']
      ..cost = (data['cost'] as num?)?.toDouble() ?? 0.0
      ..price = (data['price'] as num?)?.toDouble() ?? 0.0
      ..addenum = (data['addenum'] as num?)?.toDouble() ?? 0.0
      ..itemId = data['itemId'] ?? ''
      ..refunded = data['refunded'] ?? false
      ..baseId = data['baseId'] ?? 0
      ..discount = (data['discount'] as num?)?.toDouble() ?? 0.0
      ..discountId = data['discountId'] ?? ''
      ..percentageDiscount = data['percentageDiscount'] ?? true
      ..rejectedReason = data['rejectedReason'] ?? ""
      ..originalCount = data['originalCount'] ?? 0;
  }
}
