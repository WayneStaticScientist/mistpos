import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/main.dart';
import 'package:mistpos/models/modifier_embedder.dart';
part 'item_modifier_model.g.dart';

@collection
class ItemModifier {
  late int id = IdGen.id;
  @Index()
  String name;
  String hexId;
  List<ModifierEmbedder> list;
  ItemModifier({required this.name, required this.list, this.hexId = ''});
  Map<String, dynamic> toJson() {
    return {'name': name, 'list': list.map((m) => m.toJson()).toList()};
  }

  factory ItemModifier.fromJson(Map<String, dynamic> json) {
    final listRaw = json['list'] as List<dynamic>? ?? <dynamic>[];
    final parsedList = listRaw.map((e) {
      return ModifierEmbedder.fromJson(e);
    }).toList();

    final instance = ItemModifier(
      hexId: json['_id'],
      name: json['name'] as String,
      list: parsedList.cast<ModifierEmbedder>(),
    );
    return instance;
  }
}
