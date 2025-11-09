import 'package:mistpos/models/inv_item.dart';

class StockAdjustmentModel {
  String notes;
  String id;
  List<InvItem> inventoryItems;
  String reason;
  String senderId;
  String company;
  String label;
  DateTime createdAt;
  StockAdjustmentModel({
    required this.id,
    required this.notes,
    required this.reason,
    required this.senderId,
    required this.inventoryItems,
    required this.company,
    this.label = '',
    required this.createdAt,
  });
  // =========================================================
  // 1. toJson() - CONVERT DART OBJECT TO JSON MAP
  // =========================================================
  Map<String, dynamic> toJson() {
    return {
      'notes': notes,
      'reason': reason,
      'senderId': senderId,
      'company': company,
      'label': label,
      'inventoryItems': inventoryItems.map((item) => item.toMap()).toList(),
    };
  }

  // =========================================================
  // 2. fromJson() - FACTORY CONSTRUCTOR TO CREATE DART OBJECT FROM JSON MAP
  // =========================================================
  factory StockAdjustmentModel.fromJson(Map<String, dynamic> json) {
    List<InvItem> items = (json['inventoryItems'] as List<dynamic>)
        .map((itemJson) => InvItem.fromJson(itemJson as Map<String, dynamic>))
        .toList();
    return StockAdjustmentModel(
      reason: json['reason'] as String,
      notes: json['notes'] as String,
      senderId: json['senderId'] as String,
      inventoryItems: items,
      id: json['_id'],
      company: json['company'],
      label: json['label'] ?? '--',
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
    );
  }
}
