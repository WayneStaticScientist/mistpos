import 'package:isar/isar.dart';
part 'tax_model.g.dart';

@collection
class TaxModel {
  Id id = Isar.autoIncrement;
  String label;
  bool activated;
  double value;
  List<String> selectedIds;
  String hexId;
  TaxModel({
    this.hexId = '',
    required this.label,
    required this.value,
    required this.activated,
    required this.selectedIds,
  });
  factory TaxModel.fromJson(Map<String, dynamic> json) {
    return TaxModel(
      label: json['label'],
      hexId: json['_id'],
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      selectedIds:
          (json['selectedIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      activated: json['activated'] ?? true,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'activated': activated,
      'selectedIds': selectedIds,
    };
  }
}
