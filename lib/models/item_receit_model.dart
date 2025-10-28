import 'package:isar/isar.dart';
import 'package:mistpos/models/item_receit_item.dart';
part 'item_receit_model.g.dart';

@collection
class ItemReceitModel {
  Id id = Isar.autoIncrement;
  final String cashier;
  final String payment;
  final double change;
  double amount;
  double total;
  bool synced = false;
  DateTime createdAt;
  String hexId = "";
  String? customerId;
  List<ItemReceitItem> items = [];
  ItemReceitModel({
    required this.items,
    required this.total,
    required this.amount,
    required this.hexId,
    required this.change,
    required this.cashier,
    required this.payment,
    required this.createdAt,
    this.customerId,
    this.synced = false,
  });
  Map<String, dynamic> toJson() {
    return {
      "customerId": customerId,
      "cashier": cashier,
      "payment": payment,
      "change": change,
      "amount": amount,
      "total": total,
      "synced": synced,
      "items": items.map<Map<String, dynamic>>((e) => e.toJson()).toList(),
    };
  }

  factory ItemReceitModel.fromJson(Map<String, dynamic> data) {
    return ItemReceitModel(
      customerId: data['customerId'],
      items: data['items'] != null
          ? (data['items'] as List<dynamic>)
                .map((e) => ItemReceitItem.fromJson(e))
                .toList()
          : [],
      synced: data['synced'] ?? false,
      hexId: data['_id'],
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      change: (data['change'] as num?)?.toDouble() ?? 0.0,
      cashier: data['cashier'],
      payment: data['payment'],
      createdAt: DateTime.now(),
    );
  }
}
