import 'package:isar/isar.dart';
part 'item_categories_model.g.dart';

@collection
class ItemCategoryModel {
  late Id id = Isar.autoIncrement;
  @Index(unique: true)
  String name;
  int? color;
  String hexId;
  ItemCategoryModel({required this.name, this.color, this.hexId = ''});
  Map<String, dynamic> toJson() {
    return {"name": name, "color": color, "hexId": hexId};
  }

  factory ItemCategoryModel.fromJson(Map<String, dynamic> json) {
    return ItemCategoryModel(
      color: json["color"] as int?,
      name: json["name"] as String? ?? "",
      hexId: json["_id"] as String? ?? "",
    );
  }
}
