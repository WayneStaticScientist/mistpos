class Cashier {
  final String name;
  final String id;
  Cashier({required this.name, required this.id});
  factory Cashier.fromJson(Map<String, dynamic> json) {
    return Cashier(name: json['name'], id: json['id']);
  }
}

class StatsSalesModel {
  final double totalSales;
  final double totalCost;
  final double totalAmount;
  final int numberOfCashiers;
  final List<Cashier> cashiers;

  StatsSalesModel({
    required this.totalSales,
    required this.totalAmount,
    required this.numberOfCashiers,
    required this.cashiers,
    required this.totalCost,
  });

  factory StatsSalesModel.fromJson(Map<String, dynamic> json) {
    return StatsSalesModel(
      totalSales: (json['totalTotal'] as num?)?.toDouble() ?? 0.0,
      totalCost: (json['totalCosts'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      numberOfCashiers: json['numberOfCashiers'] ?? 0,
      cashiers: json['listCashiers'] != null
          ? (json['listCashiers'] as List<dynamic>)
                .map((e) => Cashier.fromJson(e))
                .toList()
          : [],
    );
  }
}
