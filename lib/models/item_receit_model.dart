import 'package:isar/isar.dart';
import 'package:mistpos/models/item_receit_item.dart';
part 'item_receit_model.g.dart';

@collection
class ItemReceitModel {
  Id id = Isar.autoIncrement;
  final String cashier;
  final double amount;
  DateTime createdAt;
  List<ItemReceitItem> items = [];
  ItemReceitModel(
    this.cashier, {
    required this.items,
    required this.amount,
    required this.createdAt,
  });
}
