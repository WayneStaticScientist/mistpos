import 'package:isar/isar.dart';
import 'package:mistpos/models/modifier_embedder.dart';
part 'item_modifier_model.g.dart';

@collection
class ItemModifier {
  Id id = Isar.autoIncrement;
  @Index()
  String name;
  List<ModifierEmbedder> list;
  ItemModifier({required this.name, required this.list});
}
