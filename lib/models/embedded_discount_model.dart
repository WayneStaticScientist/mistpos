import 'package:isar/isar.dart';
import 'package:mistpos/models/discount_model.dart';
part 'embedded_discount_model.g.dart';

@embedded
class EmbeddedDiscountModel {
  String? discountId;
  double? discount;
  bool? percentageDiscount;
  String? name;
  EmbeddedDiscountModel({
    this.discountId,
    this.discount,
    this.percentageDiscount,
    this.name,
  });
  Map<String, dynamic> toJson() {
    return {
      "discountId": discountId,
      "discount": discount,
      "percentageDiscount": percentageDiscount,
      "name": name,
    };
  }

  factory EmbeddedDiscountModel.fromJson(Map<String, dynamic> data) {
    return EmbeddedDiscountModel(
      discountId: data['discountId'],
      discount: (data['discount'] as num?)?.toDouble(),
      percentageDiscount: data['percentageDiscount'],
      name: data['name'],
    );
  }
  factory EmbeddedDiscountModel.fromModel(DiscountModel model) {
    return EmbeddedDiscountModel(
      name: model.name,
      discount: model.value,
      discountId: model.hexId,
      percentageDiscount: model.percentage,
    );
  }
}
