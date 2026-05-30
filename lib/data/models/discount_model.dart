import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/main.dart';
part 'discount_model.g.dart';

@collection
class DiscountModel {
  String name;
  double value;
  String company;
  bool percentage;
  String hexId = "";
  late int id = IdGen.id;
  DiscountModel({
    required this.name,
    required this.value,
    required this.company,
    required this.percentage,
    this.hexId = '',
  });
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "value": value,
      "company": company,
      "percentage": percentage,
    };
  }

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      hexId: json['_id'] ?? '',
      name: json['name'],
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      company: json['company'],
      percentage: json['percentage'] ?? true,
    );
  }
}
