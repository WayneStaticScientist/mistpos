import 'package:isar_plus/isar_plus.dart';
import 'package:mistpos/main.dart';
part 'gateway.g.dart';

@collection
class Gateway {
  String name;
  String key;
  String hexId;
  String integrationId;
  late int id = IdGen.id;
  Gateway({
    required this.name,
    required this.key,
    required this.integrationId,
    required this.hexId,
  });
}
