class Cashier {
  final String name;
  final String id;
  Cashier({required this.name, required this.id});
  factory Cashier.fromJson(Map<String, dynamic> json) {
    return Cashier(name: json['name'], id: json['id']);
  }
}

class StatsSalesModel {
  final double totalAverageCosts;
  final double totalExpenses;
  final double expensesCount;
  final double totalSales;
  final double totalTaxs;
  final double totalCost;
  final double totalRevenue;
  final double totalAmount;
  final int numberOfCashiers;
  final int totalReceipts;
  final double totalRefunds;
  final double totalCredits;
  final double totalDiscounts;
  final double totalLossValue;
  final List<Cashier> cashiers;

  // New Credit Metrics
  final int creditReceiptsCount;
  final double creditSalesTotal;
  final double creditAmountPaid;
  final double creditBalanceRemaining;

  // New Performance Metrics (Nested)
  final PerformanceMetrics dailyPerformance;
  final PerformanceMetrics monthlyPerformance;
  final PerformanceMetrics yearlyPerformance;

  // Top Customers
  final List<CustomerMetric> topCustomers;
  final List<CustomerMetric> topCreditCustomers;

  StatsSalesModel({
    required this.totalAverageCosts,
    required this.totalTaxs,
    required this.totalExpenses,
    required this.expensesCount,
    required this.totalSales,
    required this.totalAmount,
    required this.totalCredits,
    required this.numberOfCashiers,
    required this.cashiers,
    required this.totalCost,
    required this.totalRevenue,
    required this.totalReceipts,
    required this.totalDiscounts,
    required this.totalRefunds,
    required this.totalLossValue,
    required this.creditReceiptsCount,
    required this.creditSalesTotal,
    required this.creditAmountPaid,
    required this.creditBalanceRemaining,
    required this.dailyPerformance,
    required this.monthlyPerformance,
    required this.yearlyPerformance,
    required this.topCustomers,
    required this.topCreditCustomers,
  });

  factory StatsSalesModel.fromJson(Map<String, dynamic> json) {
    return StatsSalesModel(
      totalAverageCosts: (json['totalAverageCosts'] as num?)?.toDouble() ?? 0.0,
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble() ?? 0.0,
      expensesCount: (json['expensesCount'] as num?)?.toDouble() ?? 0.0,
      totalCredits: (json['totalCredits'] as num?)?.toDouble() ?? 0.0,
      totalTaxs: (json['totalTaxs'] as num?)?.toDouble() ?? 0.0,
      totalLossValue: (json['totalLossValue'] as num?)?.toDouble() ?? 0.0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      totalSales: (json['totalTotal'] as num?)?.toDouble() ?? 0.0,
      totalCost: (json['totalCosts'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      numberOfCashiers: json['numberOfCashiers'] ?? 0,
      totalReceipts: json['totalReceipts'] ?? 0,
      totalDiscounts: (json['totalDiscounts'] as num?)?.toDouble() ?? 0.0,
      totalRefunds: (json['totalRefunds'] as num?)?.toDouble() ?? 0.0,
      cashiers: json['listCashiers'] != null
          ? (json['listCashiers'] as List<dynamic>)
                .map((e) => Cashier.fromJson(e))
                .toList()
          : [],
      creditReceiptsCount: json['creditReceiptsCount'] ?? 0,
      creditSalesTotal: (json['creditSalesTotal'] as num?)?.toDouble() ?? 0.0,
      creditAmountPaid: (json['creditAmountPaid'] as num?)?.toDouble() ?? 0.0,
      creditBalanceRemaining: (json['creditBalanceRemaining'] as num?)?.toDouble() ?? 0.0,
      dailyPerformance: PerformanceMetrics.fromJson(json['performance']?['daily'] ?? {}),
      monthlyPerformance: PerformanceMetrics.fromJson(json['performance']?['monthly'] ?? {}),
      yearlyPerformance: PerformanceMetrics.fromJson(json['performance']?['yearly'] ?? {}),
      topCustomers: (json['topCustomers'] as List<dynamic>?)
              ?.map((e) => CustomerMetric.fromJson(e))
              .toList() ??
          [],
      topCreditCustomers: (json['topCreditCustomers'] as List<dynamic>?)
              ?.map((e) => CustomerMetric.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CustomerMetric {
  final String customerId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final double totalSpent;
  final int receiptsCount;

  CustomerMetric({
    required this.customerId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.totalSpent,
    required this.receiptsCount,
  });

  factory CustomerMetric.fromJson(Map<String, dynamic> json) {
    return CustomerMetric(
      customerId: json['customerId'] ?? '',
      fullName: json['fullName'] ?? 'Unknown',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
      receiptsCount: json['receiptsCount'] ?? 0,
    );
  }
}

class PerformanceMetrics {
  final double profitMargin;
  final double expenseToIncomeRatio;
  final double burnRate;
  final double cashIn;
  final double cashOut;

  PerformanceMetrics({
    required this.profitMargin,
    required this.expenseToIncomeRatio,
    required this.burnRate,
    required this.cashIn,
    required this.cashOut,
  });

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      profitMargin: (json['profitMargin'] as num?)?.toDouble() ?? 0.0,
      expenseToIncomeRatio: (json['expenseToIncomeRatio'] as num?)?.toDouble() ?? 0.0,
      burnRate: (json['burnRate'] as num?)?.toDouble() ?? 0.0,
      cashIn: (json['cashIn'] as num?)?.toDouble() ?? 0.0,
      cashOut: (json['cashOut'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
