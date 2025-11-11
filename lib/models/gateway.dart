import 'package:isar/isar.dart';
part 'gateway.g.dart';

@collection
class Gateway {
  String name;
  String key;
  String hexId;
  String integrationId;
  Id id = Isar.autoIncrement;
  Gateway({
    required this.name,
    required this.key,
    required this.integrationId,
    required this.hexId,
  });
}
