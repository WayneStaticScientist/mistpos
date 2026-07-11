class MultiShopData {
  final String companyId;
  final String companyName;
  final MultiShopStats stats;

  MultiShopData({
    required this.companyId,
    required this.companyName,
    required this.stats,
  });

  factory MultiShopData.fromJson(Map<String, dynamic> json) {
    return MultiShopData(
      companyId: json['companyId'] ?? '',
      companyName: json['companyName'] ?? '',
      stats: MultiShopStats.fromJson(json['stats'] ?? {}),
    );
  }
}

class MultiShopGraphData {
  final String companyId;
  final String companyName;
  final List<dynamic> graphData;

  MultiShopGraphData({
    required this.companyId,
    required this.companyName,
    required this.graphData,
  });

  factory MultiShopGraphData.fromJson(Map<String, dynamic> json) {
    return MultiShopGraphData(
      companyId: json['companyId'] ?? '',
      companyName: json['companyName'] ?? '',
      graphData: json['graphData'] ?? [],
    );
  }
}

class MultiShopStats {
  final double totalSales;
  final double totalCost;
  final double totalExpenses;
  final double totalTaxs;
  final double totalLossValue;
  final double totalRefunds;
  final double totalDiscounts;
  final double totalStock;
  final double totalStockValue;
  final double totalStockRevenue;

  MultiShopStats({
    required this.totalSales,
    required this.totalCost,
    required this.totalExpenses,
    required this.totalTaxs,
    required this.totalLossValue,
    required this.totalRefunds,
    required this.totalDiscounts,
    required this.totalStock,
    required this.totalStockValue,
    required this.totalStockRevenue,
  });

  factory MultiShopStats.fromJson(Map<String, dynamic> json) {
    return MultiShopStats(
      totalSales: (json['totalTotal'] ?? json['totalSales'] ?? 0.0).toDouble(),
      totalCost: (json['totalCosts'] ?? json['totalCost'] ?? 0.0).toDouble(),
      totalExpenses: (json['totalExpenses'] ?? 0.0).toDouble(),
      totalTaxs: (json['totalTaxs'] ?? 0.0).toDouble(),
      totalLossValue: (json['totalLossValue'] ?? 0.0).toDouble(),
      totalRefunds: (json['totalRefunds'] ?? 0.0).toDouble(),
      totalDiscounts: (json['totalDiscounts'] ?? 0.0).toDouble(),
      totalStock: (json['totalStock'] ?? 0.0).toDouble(),
      totalStockValue: (json['totalCost'] ?? 0.0).toDouble(),
      totalStockRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
    );
  }
}

class MultiShopDailySalesData {
  final String companyId;
  final String companyName;
  final Map<String, dynamic> dailyData;

  MultiShopDailySalesData({
    required this.companyId,
    required this.companyName,
    required this.dailyData,
  });

  factory MultiShopDailySalesData.fromJson(Map<String, dynamic> json) {
    return MultiShopDailySalesData(
      companyId: json['companyId'] ?? '',
      companyName: json['companyName'] ?? '',
      dailyData: json['dailyData'] ?? {},
    );
  }
}
