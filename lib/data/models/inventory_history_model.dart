class InventoryHistoryModel {
  DateTime? createdAt;
  String? itemId;
  String? itemName;
  String? documentType;
  int? quantityChange;
  InventoryHistoryModel(
    this.createdAt,
    this.itemId,
    this.itemName,
    this.documentType,
    this.quantityChange,
  );
  factory InventoryHistoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryHistoryModel(
      DateTime.tryParse(json['createdAt'])?.toLocal(),
      json['itemId'],
      json['itemName'],
      json['documentType'],
      json['quantityChange'],
    );
  }
}
