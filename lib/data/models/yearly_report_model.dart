class YearlyReportModel {
  final int year;
  final YearlySummary summary;
  final List<MonthlyData> monthlyData;

  YearlyReportModel({
    required this.year,
    required this.summary,
    required this.monthlyData,
  });

  factory YearlyReportModel.fromJson(Map<String, dynamic> json) {
    return YearlyReportModel(
      year: json['year'] ?? DateTime.now().year,
      summary: YearlySummary.fromJson(json['yearlySummary'] ?? {}),
      monthlyData: (json['monthlyData'] as List<dynamic>?)
              ?.map((e) => MonthlyData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class YearlySummary {
  final double totalProfit;
  final double totalRevenue;
  final double totalExpenses;
  final double totalLosses;
  final int numberOfItemsSold;
  final int numberOfReceipts;
  final int totalRefundsCount;
  final double totalMoneyRefunded;

  YearlySummary({
    required this.totalProfit,
    required this.totalRevenue,
    required this.totalExpenses,
    required this.totalLosses,
    required this.numberOfItemsSold,
    required this.numberOfReceipts,
    required this.totalRefundsCount,
    required this.totalMoneyRefunded,
  });

  factory YearlySummary.fromJson(Map<String, dynamic> json) {
    return YearlySummary(
      totalProfit: (json['totalProfit'] ?? 0).toDouble(),
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      totalExpenses: (json['totalExpenses'] ?? 0).toDouble(),
      totalLosses: (json['totalLosses'] ?? 0).toDouble(),
      numberOfItemsSold: json['numberOfItemsSold'] ?? 0,
      numberOfReceipts: json['numberOfReceipts'] ?? 0,
      totalRefundsCount: json['totalRefundsCount'] ?? 0,
      totalMoneyRefunded: (json['totalMoneyRefunded'] ?? 0).toDouble(),
    );
  }
}

class MonthlyData {
  final int month;
  final double revenue;
  final double profit;
  final double expenses;
  final int itemsSold;
  final int receiptsCount;
  final double losses;
  final int refunds;
  final double moneyRefunded;

  MonthlyData({
    required this.month,
    required this.revenue,
    required this.profit,
    required this.expenses,
    required this.itemsSold,
    required this.receiptsCount,
    required this.losses,
    required this.refunds,
    required this.moneyRefunded,
  });

  factory MonthlyData.fromJson(Map<String, dynamic> json) {
    return MonthlyData(
      month: json['month'] ?? 1,
      revenue: (json['revenue'] ?? 0).toDouble(),
      profit: (json['profit'] ?? 0).toDouble(),
      expenses: (json['expenses'] ?? 0).toDouble(),
      itemsSold: json['itemsSold'] ?? 0,
      receiptsCount: json['receiptsCount'] ?? 0,
      losses: (json['losses'] ?? 0).toDouble(),
      refunds: json['refunds'] ?? 0,
      moneyRefunded: (json['moneyRefunded'] ?? 0).toDouble(),
    );
  }
}
