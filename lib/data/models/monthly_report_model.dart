class MonthlyReportModel {
  final double totalProfit;
  final double totalRevenue;
  final double totalExpenses;
  final double totalLosses;
  final int totalRefundsCount;
  final double totalMoneyRefunded;
  final int numberOfReceipts;
  final int numberOfItemsSold;
  final String peakSalesTime;
  final String salesRecommendation;
  final List<MonthlyDayData> top5SellingDays;
  final List<MonthlyExpenseData> top5ExpensiveExpenses;
  final List<MonthlyGraphData> monthlyRevenueGraph;
  final List<MonthlyGraphData> expensesGraph;

  MonthlyReportModel({
    required this.totalProfit,
    required this.totalRevenue,
    required this.totalExpenses,
    required this.totalLosses,
    required this.totalRefundsCount,
    required this.totalMoneyRefunded,
    required this.numberOfReceipts,
    required this.numberOfItemsSold,
    required this.peakSalesTime,
    required this.salesRecommendation,
    required this.top5SellingDays,
    required this.top5ExpensiveExpenses,
    required this.monthlyRevenueGraph,
    required this.expensesGraph,
  });

  factory MonthlyReportModel.fromJson(Map<String, dynamic> json) {
    return MonthlyReportModel(
      totalProfit: (json['totalProfit'] ?? 0).toDouble(),
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      totalExpenses: (json['totalExpenses'] ?? 0).toDouble(),
      totalLosses: (json['totalLosses'] ?? 0).toDouble(),
      totalRefundsCount: json['totalRefundsCount'] ?? 0,
      totalMoneyRefunded: (json['totalMoneyRefunded'] ?? 0).toDouble(),
      numberOfReceipts: json['numberOfReceipts'] ?? 0,
      numberOfItemsSold: json['numberOfItemsSold'] ?? 0,
      peakSalesTime: json['peakSalesTime'] ?? '00:00',
      salesRecommendation: json['salesRecommendation'] ?? '',
      top5SellingDays: (json['top5SellingDays'] as List? ?? [])
          .map((e) => MonthlyDayData.fromJson(e))
          .toList(),
      top5ExpensiveExpenses: (json['top5ExpensiveExpenses'] as List? ?? [])
          .map((e) => MonthlyExpenseData.fromJson(e))
          .toList(),
      monthlyRevenueGraph: (json['monthlyRevenueGraph'] as List? ?? [])
          .map((e) => MonthlyGraphData.fromJson(e))
          .toList(),
      expensesGraph: (json['expensesGraph'] as List? ?? [])
          .map((e) => MonthlyGraphData.fromJson(e))
          .toList(),
    );
  }
}

class MonthlyDayData {
  final String date;
  final double sales;

  MonthlyDayData({required this.date, required this.sales});

  factory MonthlyDayData.fromJson(Map<String, dynamic> json) {
    return MonthlyDayData(
      date: json['date'] ?? '',
      sales: (json['sales'] ?? 0).toDouble(),
    );
  }
}

class MonthlyExpenseData {
  final String name;
  final double amount;
  final String date;

  MonthlyExpenseData({required this.name, required this.amount, required this.date});

  factory MonthlyExpenseData.fromJson(Map<String, dynamic> json) {
    return MonthlyExpenseData(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['date'] ?? '',
    );
  }
}

class MonthlyGraphData {
  final String date;
  final double amount;

  MonthlyGraphData({required this.date, required this.amount});

  factory MonthlyGraphData.fromJson(Map<String, dynamic> json) {
    return MonthlyGraphData(
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}
