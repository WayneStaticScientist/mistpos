import 'package:isar/isar.dart';
part 'shifts_model.g.dart';

@collection
class ShiftsModel {
  Id id = Isar.autoIncrement;
  bool synced = false;
  bool shiftIsClosed = false;
  String hexId;
  String userId;
  String shiftLabel;
  double totalSales;
  int salesQuantity;
  int totalCustomers;
  double cashDrawerEnd;
  double cashDrawerStart;
  DateTime openShiftTime;
  DateTime closeShiftTime = DateTime.now();
  ShiftsModel({
    required this.cashDrawerEnd,
    required this.cashDrawerStart,
    required this.openShiftTime,
    this.totalSales = 0,
    this.salesQuantity = 0,
    this.totalCustomers = 0,
    required this.closeShiftTime,
    required this.userId,
    required this.shiftLabel,
    this.shiftIsClosed = false,
    this.hexId = '',
    this.synced = false,
  });
  Map<String, dynamic> toJson() {
    return {
      'iid': id,
      'synced': synced,
      'shiftIsClosed': shiftIsClosed,
      'hexId': hexId,
      'userId': userId,
      'shiftLabel': shiftLabel,
      'totalSales': totalSales,
      'salesQuantity': salesQuantity,
      'totalCustomers': totalCustomers,
      'cashDrawerEnd': cashDrawerEnd,
      'cashDrawerStart': cashDrawerStart,
      'openShiftTime': openShiftTime.toIso8601String(),
      'closeShiftTime': closeShiftTime.toIso8601String(),
    };
  }

  factory ShiftsModel.fromJson(Map<String, dynamic> json) {
    return ShiftsModel(
      cashDrawerEnd: (json['cashDrawerEnd'] as num).toDouble(),
      totalSales: (json['totalSales'] as num).toDouble(),
      salesQuantity: json['salesQuantity'],
      totalCustomers: json['totalCustomers'],
      cashDrawerStart: (json['cashDrawerStart'] as num).toDouble(),
      synced: json['synced'] ?? false,
      shiftIsClosed: json['shiftIsClosed'] ?? false,
      openShiftTime: DateTime.parse(json['openShiftTime']),
      closeShiftTime: DateTime.parse(json['closeShiftTime']),
      userId: json['userId'],
      shiftLabel: json['shiftLabel'],
      hexId: json['_id'],
    );
  }
}
