class ShiftsStatsModel {
  String userName;
  String userId;
  int numberOfShifts;
  double totalShiftHours;
  double totalSales;
  double totalSalesQuantity;
  double averageSalePerShift;
  ShiftsStatsModel({
    required this.userName,
    required this.userId,
    required this.numberOfShifts,
    required this.totalShiftHours,
    required this.totalSales,
    required this.totalSalesQuantity,
    required this.averageSalePerShift,
  });
  factory ShiftsStatsModel.fromJson(Map<String, dynamic> json) {
    return ShiftsStatsModel(
      userName: json['userName'] ?? '',
      userId: json['userId'] ?? '',
      numberOfShifts: json['numberOfShifts'] ?? 0,
      totalShiftHours: (json['totalShiftHours'] as num?)?.toDouble() ?? 0.0,
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0.0,
      totalSalesQuantity:
          (json['totalSalesQuantity'] as num?)?.toDouble() ?? 0.0,
      averageSalePerShift:
          (json['averageSalePerShift'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
