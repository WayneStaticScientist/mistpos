import 'package:isar/isar.dart';
part 'item_receit_item.g.dart';

@embedded
class ItemReceitItem {
  late String name;
  late int count;
  late double price;
  late double addenum;
  bool refunded = false;
  int baseId = 0;
  ItemReceitItem();
}
