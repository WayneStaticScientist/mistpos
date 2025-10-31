import 'package:mistpos/models/inventory_child_count.dart';

class InventoryCountModel {
  String notes;
  String id;
  String status;
  String company;
  String senderId;
  int totalCalculations = 0;
  int totalDifference = 0;
  List<InventoryChildCount> inventoryItems;
  InventoryCountModel({
    required this.id,
    required this.notes,
    required this.status,
    required this.company,
    required this.senderId,
    required this.inventoryItems,
  });
  // =========================================================
  // 1. toJson() - CONVERT DART OBJECT TO JSON MAP
  // =========================================================
  Map<String, dynamic> toJson() {
    return {
      'notes': notes,
      'status': status,
      'company': company,
      'senderId': senderId,
      'inventoryItems': inventoryItems.map((item) => item.toJson()).toList(),
    };
  }

  // =========================================================
  // 2. fromJson() - FACTORY CONSTRUCTOR TO CREATE DART OBJECT FROM JSON MAP
  // =========================================================
  factory InventoryCountModel.fromJson(Map<String, dynamic> json) {
    List<InventoryChildCount> items = (json['inventoryItems'] as List<dynamic>)
        .map(
          (itemJson) =>
              InventoryChildCount.fromJson(itemJson as Map<String, dynamic>),
        )
        .toList();
    return InventoryCountModel(
      id: json['_id'],
      inventoryItems: items,
      company: json['company'],
      notes: json['notes'] as String,
      status: json['status'] as String,
      senderId: json['senderId'] as String,
    );
  }
}
