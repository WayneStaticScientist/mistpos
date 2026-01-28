import 'package:isar/isar.dart';
import 'package:mistpos/models/mini_tax.dart';
import 'package:mistpos/models/item_receit_item.dart';
import 'package:mistpos/models/embedded_discount_model.dart';
part 'item_receit_model.g.dart';

@collection
class ItemReceitModel {
  Id id = Isar.autoIncrement;
  final String cashier;
  final String payment;
  final double change;
  bool creditSale = false;
  double tax;
  double amount;
  double total;
  bool synced = false;
  DateTime createdAt;
  String hexId = "";
  String? customerId;
  String label;
  List<MiniTax> miniTax;
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
    this.miniTax = const [],
    this.tax = 0,
    this.customerId,
    this.label = "",
    this.synced = false,
    this.creditSale = false,
    this.discounts = const [],
  });
  Map<String, dynamic> toJson() {
    return {
      "creditSale": creditSale,
      "customerId": customerId,
      "cashier": cashier,
      "payment": payment,
      "change": change,
      "amount": amount,
      "total": total,
      "synced": synced,
      "label": label,
      "tax": tax,
      'miniTax': miniTax.map((e) => e.toJson()).toList(),
      "createdAt": createdAt.toIso8601String(),
      "discounts": discounts
          .map<Map<String, dynamic>>((e) => e.toJson())
          .toList(),
      "items": items.map<Map<String, dynamic>>((e) => e.toJson()).toList(),
    };
  }

  factory ItemReceitModel.fromJson(Map<String, dynamic> data) {
    return ItemReceitModel(
      creditSale: data['creditSale'] ?? false,
      customerId: data['customerId'],
      items: data['items'] != null
          ? (data['items'] as List<dynamic>)
                .map((e) => ItemReceitItem.fromJson(e))
                .toList()
          : [],
      label: data['label'] ?? "-",
      miniTax: data['miniTax'] != null
          ? (data['miniTax'] as List<dynamic>)
                .map((e) => MiniTax.fromJson(e))
                .toList()
          : [],
      tax: (data['tax'] as num?)?.toDouble() ?? 0.0,
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
