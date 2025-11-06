import 'package:isar/isar.dart';
part 'discount_model.g.dart';

@collection
class DiscountModel {
  String name;
  double value;
  String company;
  bool percentage;
  String hexId = "";
  Id id = Isar.autoIncrement;
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
