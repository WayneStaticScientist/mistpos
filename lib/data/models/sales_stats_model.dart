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
    );
  }
}
