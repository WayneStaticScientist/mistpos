import 'package:isar_plus/isar_plus.dart';
part 'mini_tax.g.dart';

@embedded
class MiniTax {
  String label;
  double value;
  int sumOfItems;
  MiniTax({this.label = "", this.value = 0, this.sumOfItems = 0});
  Map<String, dynamic> toJson() {
    return {"label": label, "value": value, "sumOfItems": sumOfItems};
  }

  factory MiniTax.fromJson(Map<String, dynamic> data) {
    return MiniTax(
      label: data['label'],
      value: (data['value'] as num?)?.toDouble() ?? 0.0,
      sumOfItems: data['sumOfItems'] ?? 0,
    );
  }
}
