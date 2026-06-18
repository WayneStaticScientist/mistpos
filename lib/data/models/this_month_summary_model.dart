class BestDayModel {
  final String date;
  final double salesAmount;
  final int receitsCount;

  BestDayModel({
    required this.date,
    required this.salesAmount,
    required this.receitsCount,
  });

  factory BestDayModel.fromJson(Map<String, dynamic> json) {
    return BestDayModel(
      date: json['date'] ?? "",
      salesAmount: (json['salesAmount'] as num?)?.toDouble() ?? 0.0,
      receitsCount: (json['receitsCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class ThisMonthSummaryModel {
  final double totalRevenue;
  final double totalCost;
  final double totalExpenses;
  final int totalReceipts;
  final double totalItemsSold;
  final String peakSalesRange;
  final List<BestDayModel> bestDays;

  ThisMonthSummaryModel({
    required this.totalRevenue,
    required this.totalCost,
    required this.totalExpenses,
    required this.totalReceipts,
    required this.totalItemsSold,
    required this.peakSalesRange,
    required this.bestDays,
  });

  double get grossProfit => totalRevenue - totalCost;
  double get netProfit => totalRevenue - totalCost - totalExpenses;

  factory ThisMonthSummaryModel.fromJson(Map<String, dynamic> json) {
    return ThisMonthSummaryModel(
      totalRevenue: (json['totalTotal'] as num?)?.toDouble() ?? 0.0,
      totalCost: (json['totalCosts'] as num?)?.toDouble() ?? 0.0,
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble() ?? 0.0,
      totalReceipts: (json['totalReceipts'] as num?)?.toInt() ?? 0,
      totalItemsSold: (json['totalItemsSold'] as num?)?.toDouble() ?? 0.0,
      peakSalesRange: json['peakSalesRange'] ?? "N/A",
      bestDays: json['bestDays'] != null
          ? (json['bestDays'] as List<dynamic>)
              .map((e) => BestDayModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
