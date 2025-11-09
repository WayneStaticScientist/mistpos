import 'package:mistpos/models/inventory_child_count.dart';

class InventoryCountModel {
  String notes;
  String id;
  String label;
  String status;
  String company;
  String senderId;
  int totalCalculations = 0;
  double totalDifference = 0;
  double totalCostDifference = 0;
  String countBasedOn;
  List<InventoryChildCount> inventoryItems;
  DateTime? createdAt;
  DateTime? updatedAt;
  InventoryCountModel({
    required this.id,
    required this.notes,
    required this.status,
    required this.company,
    required this.senderId,
    this.totalDifference = 0,
    required this.countBasedOn,
    this.totalCalculations = 0,
    this.label = '',
    required this.inventoryItems,
    this.totalCostDifference = 0,
    this.createdAt,
    this.updatedAt,
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
      'countBasedOn': countBasedOn,
      'totalDifference': totalDifference,
      'totalCostDifference': totalCostDifference,
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
      label: json['label'] ?? '',
      notes: json['notes'] as String,
      status: json['status'] as String,
      senderId: json['senderId'] as String,
      countBasedOn: json['countBasedOn'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'])?.toLocal(),
      updatedAt: DateTime.tryParse(json['updatedAt'])?.toLocal(),
      totalDifference: (json['totalDifference'] as num?)?.toDouble() ?? 0,
      totalCostDifference:
          (json['totalCostDifference'] as num?)?.toDouble() ?? 0,
    );
  }
}
