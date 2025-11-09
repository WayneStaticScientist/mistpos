import 'package:mistpos/models/inv_item.dart';

class TransferOrderModel {
  String notes;
  String id;
  List<InvItem> inventoryItems;
  String senderId;
  String company;
  String toCompany;
  String label;
  DateTime? createdAt;
  TransferOrderModel({
    required this.id,
    required this.notes,
    required this.toCompany,
    required this.senderId,
    required this.inventoryItems,
    required this.company,
    this.label = '',
    this.createdAt,
  });
  // =========================================================
  // 1. toJson() - CONVERT DART OBJECT TO JSON MAP
  // =========================================================
  Map<String, dynamic> toJson() {
    return {
      'notes': notes,
      'company': company,
      'senderId': senderId,
      'toCompany': toCompany,
      'inventoryItems': inventoryItems.map((item) => item.toMap()).toList(),
    };
  }

  // =========================================================
  // 2. fromJson() - FACTORY CONSTRUCTOR TO CREATE DART OBJECT FROM JSON MAP
  // =========================================================
  factory TransferOrderModel.fromJson(Map<String, dynamic> json) {
    List<InvItem> items = (json['inventoryItems'] as List<dynamic>)
        .map((itemJson) => InvItem.fromJson(itemJson as Map<String, dynamic>))
        .toList();
    return TransferOrderModel(
      toCompany: json['toCompany'] as String,
      notes: json['notes'] as String,
      senderId: json['senderId'] as String,
      inventoryItems: items,
      id: json['_id'],
      label: json['label'] ?? '--',
      company: json['company'],
      createdAt: DateTime.tryParse(json['createdAt'])?.toLocal(),
    );
  }
}
