import 'package:mistpos/models/inv_item.dart';

class ProductionModel {
  final String hexId;
  final String label;
  final List<InvItem> items;
  ProductionModel({
    required this.items,
    required this.hexId,
    required this.label,
  });
  factory ProductionModel.fromJson(Map<String, dynamic> json) {
    return ProductionModel(
      hexId: json['_id'] ?? '',
      label: json['label'],
      items:
          (json['compositeItems'] as List<dynamic>?)
              ?.map((e) => InvItem.fromJson(e))
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'hexId': hexId,
      'label': label,
      'compositeItems': items.map((e) => e.toMap()).toList(),
    };
  }
}
