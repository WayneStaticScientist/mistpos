class AverageProfitModel {
  String date;
  double totalPaid;
  double totalProfit;
  int uniqueCustomersCount;
  AverageProfitModel({
    required this.date,
    required this.totalPaid,
    required this.totalProfit,
    required this.uniqueCustomersCount,
  });
  factory AverageProfitModel.fromJson(Map<String, dynamic> json) {
    return AverageProfitModel(
      date: json["date"] ?? "",
      totalPaid: (json["totalPaid"] as num?)?.toDouble() ?? 0.0,
      totalProfit: (json["totalProfit"] as num?)?.toDouble() ?? 0.0,
      uniqueCustomersCount: json["uniqueCustomersCount"] ?? 0,
    );
  }
}
