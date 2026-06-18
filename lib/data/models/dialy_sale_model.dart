class DialySaleModel {
  String productName; // Rename the product name field
  String productId; // Include the product ID
  int totalCount;
  double totalSales; // Round sales to 2 decimal places
  double totalCosts;
  DialySaleModel({
    required this.productName,
    required this.productId,
    required this.totalCount,
    required this.totalSales,
    required this.totalCosts,
  });
  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'product_id': productId,
      'total_count': totalCount,
      'total_sales': totalSales,
      'total_costs': totalCosts,
    };
  }

  factory DialySaleModel.fromJson(Map<String, dynamic> json) {
    return DialySaleModel(
      productName: json['productName'] ?? '',
      productId: json['productId'] ?? '',
      totalCount: json['totalCount'] ?? 0,
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0.0,
      totalCosts: (json['totalCosts'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class HourlyData {
  final int hour;
  final double revenue;
  final double expenses;

  HourlyData({required this.hour, required this.revenue, required this.expenses});

  factory HourlyData.fromJson(Map<String, dynamic> json) {
    return HourlyData(
      hour: json['hour'] ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      expenses: (json['expenses'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CashierSaleData {
  final String cashierName;
  final double totalProcessed;

  CashierSaleData({required this.cashierName, required this.totalProcessed});

  factory CashierSaleData.fromJson(Map<String, dynamic> json) {
    return CashierSaleData(
      cashierName: json['cashierName'] ?? 'Unknown',
      totalProcessed: (json['totalProcessed'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class DailySalesSummary {
  final double totalSales;
  final double grossProfit;
  final double netProfit;
  final double totalExpenses;
  final List<HourlyData> hourlyData;
  final List<DialySaleModel> itemsSold;
  final List<CashierSaleData> cashiers;

  DailySalesSummary({
    required this.totalSales,
    required this.grossProfit,
    required this.netProfit,
    required this.totalExpenses,
    required this.hourlyData,
    required this.itemsSold,
    required this.cashiers,
  });

  factory DailySalesSummary.fromJson(Map<String, dynamic> json) {
    return DailySalesSummary(
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0.0,
      grossProfit: (json['grossProfit'] as num?)?.toDouble() ?? 0.0,
      netProfit: (json['netProfit'] as num?)?.toDouble() ?? 0.0,
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble() ?? 0.0,
      hourlyData: (json['hourlyData'] as List<dynamic>?)
              ?.map((e) => HourlyData.fromJson(e))
              .toList() ??
          [],
      itemsSold: (json['itemsSold'] as List<dynamic>?)
              ?.map((e) => DialySaleModel.fromJson(e))
              .toList() ??
          [],
      cashiers: (json['cashiers'] as List<dynamic>?)
              ?.map((e) => CashierSaleData.fromJson(e))
              .toList() ??
          [],
    );
  }
}
