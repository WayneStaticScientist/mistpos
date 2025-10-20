import 'package:isar/isar.dart';
part 'item_categories_model.g.dart';

@collection
class ItemCategoryModel {
  late Id id = Isar.autoIncrement;
  @Index(unique: true)
  String name;
  int? color;
  ItemCategoryModel({required this.name, this.color});
}
