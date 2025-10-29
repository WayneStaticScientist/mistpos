import 'package:mistpos/controllers/inventory_controller.dart';

class PurchaseOrderModel {
  DateTime expectedDate;
  String notes;
  String sellerId;
  List<InvItem> inventoryItems;
  String senderId;
  String status;
  PurchaseOrderModel({
    required this.notes,
    required this.status,
    required this.sellerId,
    required this.senderId,
    required this.expectedDate,
    required this.inventoryItems,
  });
  // =========================================================
  // 1. toJson() - CONVERT DART OBJECT TO JSON MAP
  // =========================================================
  Map<String, dynamic> toJson() {
    return {
      'expectedDate': expectedDate
          .toIso8601String(), // Convert DateTime to String
      'notes': notes,
      'sellerId': sellerId,
      'status': status,
      'senderId': senderId,
      'inventoryItems': inventoryItems.map((item) => item.toMap()).toList(),
    };
  }

  // =========================================================
  // 2. fromJson() - FACTORY CONSTRUCTOR TO CREATE DART OBJECT FROM JSON MAP
  // =========================================================
  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    List<InvItem> items = (json['inventoryItems'] as List<dynamic>)
        .map((itemJson) => InvItem.fromJson(itemJson as Map<String, dynamic>))
        .toList();
    return PurchaseOrderModel(
      expectedDate: DateTime.parse(json['expectedDate'] as String),
      notes: json['notes'] as String,
      status: json['status'] as String,
      sellerId: json['sellerId'] as String,
      senderId: json['senderId'] as String,
      inventoryItems: items,
    );
  }
}
