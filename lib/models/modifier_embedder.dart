import 'package:isar/isar.dart';
part 'modifier_embedder.g.dart';

@embedded
class ModifierEmbedder {
  late String key;
  late double value;
  ModifierEmbedder();
  factory ModifierEmbedder.fromJson(Map<String, dynamic> json) {
    final embedder = ModifierEmbedder();
    embedder.key = json['key'];
    embedder.value = json['value'];
    return embedder;
  }
}
