import 'package:isar/isar.dart';
part 'inv_item.g.dart';

@embedded
class InvItem {
  String id;
  String name;
  double cost;
  int quantity;
  double amount;
  String sku;
  String barcode;
  int inStock = 1;
  int difference = 0;
  bool updated = false;
  InvItem({
    this.id = '',
    this.name = '',
    this.cost = 0.0,
    this.quantity = 0,
    this.amount = 0,
    this.sku = '',
    this.barcode = '',
    this.difference = 0,
    this.inStock = 1,
    this.updated = false,
  });
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'sku': sku,
      "name": name,
      "cost": cost,
      "amount": amount,
      "updated": updated,
      "barcode": barcode,
      "inStock": inStock,
      "quantity": quantity,
      "difference": difference,
    };
  }

  factory InvItem.fromJson(Map<String, dynamic> data) {
    return InvItem(
      id: data['id'],
      name: data['name'],
      sku: data['sku'] ?? '',
      quantity: data['quantity'],
      inStock: data['inStock'] ?? 0,
      barcode: data['barcode'] ?? '',
      updated: data['updated'] ?? false,
      difference: data['difference'] ?? 0,
      cost: (data['cost'] as num?)?.toDouble() ?? 0.0,
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
