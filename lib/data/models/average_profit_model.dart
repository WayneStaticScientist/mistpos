class AverageProfitModel {
  String date;
  double totalPaid;
  double totalProfit;
  double totalExpenses;
  int uniqueCustomersCount;
  int receiptsCount;
  AverageProfitModel({
    required this.date,
    required this.totalPaid,
    required this.totalProfit,
    required this.totalExpenses,
    required this.uniqueCustomersCount,
    required this.receiptsCount,
  });
  factory AverageProfitModel.fromJson(Map<String, dynamic> json) {
    return AverageProfitModel(
      date: json["date"] ?? "",
      totalPaid: (json["totalPaid"] as num?)?.toDouble() ?? 0.0,
      totalProfit: (json["totalProfit"] as num?)?.toDouble() ?? 0.0,
      totalExpenses: (json["totalExpenses"] as num?)?.toDouble() ?? 0.0,
      uniqueCustomersCount: json["uniqueCustomersCount"] ?? 0,
      receiptsCount: json["receiptsCount"] ?? 0,
    );
  }
}
