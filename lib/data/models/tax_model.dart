import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/main.dart';
part 'tax_model.g.dart';

@collection
class TaxModel {
  late int id = IdGen.id;
  String label;
  bool activated;
  double value;
  bool pricesIncludeTax;
  List<String> selectedIds;
  String hexId;
  TaxModel({
    this.hexId = '',
    required this.label,
    required this.value,
    required this.activated,
    this.pricesIncludeTax = false,
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
      pricesIncludeTax: json['pricesIncludeTax'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'activated': activated,
      'pricesIncludeTax': pricesIncludeTax,
      'selectedIds': selectedIds,
    };
  }
}
