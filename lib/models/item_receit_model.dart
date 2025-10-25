import 'package:isar/isar.dart';
import 'package:mistpos/models/item_receit_item.dart';
part 'item_receit_model.g.dart';

@collection
class ItemReceitModel {
  Id id = Isar.autoIncrement;
  final String cashier;
  final String payment;
  final double change;
  double amount;
  double total;
  DateTime createdAt;
  List<ItemReceitItem> items = [];
  ItemReceitModel({
    required this.items,
    required this.total,
    required this.amount,
    required this.change,
    required this.cashier,
    required this.payment,
    required this.createdAt,
  });
}
