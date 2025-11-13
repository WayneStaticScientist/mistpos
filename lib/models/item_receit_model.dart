import 'package:isar/isar.dart';
import 'package:mistpos/models/embedded_discount_model.dart';
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
  String label;
  List<ItemReceitItem> items = [];
  List<EmbeddedDiscountModel> discounts = [];
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
    this.label = "",
    this.discounts = const [],
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
      "label": label,
      "createdAt": createdAt.toIso8601String(),
      "discounts": discounts
          .map<Map<String, dynamic>>((e) => e.toJson())
          .toList(),
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
      label: data['label'] ?? "-",
      synced: data['synced'] ?? false,
      hexId: data['_id'],
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      change: (data['change'] as num?)?.toDouble() ?? 0.0,
      cashier: data['cashier'],
      payment: data['payment'],
      discounts: data['discounts'] != null
          ? (data['discounts'] as List<dynamic>)
                .map((e) => EmbeddedDiscountModel.fromJson(e))
                .toList()
          : [],
      createdAt: DateTime.tryParse(data['createdAt']) ?? DateTime.now(),
    );
  }
}
