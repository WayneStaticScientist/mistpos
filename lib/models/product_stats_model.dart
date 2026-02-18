class StatsProductModel {
  final double totalCost;
  final double totalRevenue;
  final double totalAverageCosts;
  final int totalStock;
  StatsProductModel({
    required this.totalCost,
    required this.totalStock,
    required this.totalRevenue,
    required this.totalAverageCosts,
  });

  factory StatsProductModel.fromJson(Map<String, dynamic> json) {
    return StatsProductModel(
      totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0.0,
      totalStock: json['totalStock'] ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      totalAverageCosts: (json['totalAverageCosts'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
