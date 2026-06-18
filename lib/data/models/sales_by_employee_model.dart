class SalesByEmployeeModel {
  int numberOfReceipts;
  String sellerName;
  String sellerId;
  double grossSales;
  double refunds;
  double discounts;
  double averageSales;
  int uniqueCustomerCount;
  double expenses;
  SalesByEmployeeModel({
    required this.numberOfReceipts,
    required this.sellerName,
    required this.sellerId,
    required this.grossSales,
    required this.refunds,
    required this.discounts,
    required this.averageSales,
    required this.uniqueCustomerCount,
    required this.expenses,
  });
  factory SalesByEmployeeModel.fromJson(Map<String, dynamic> json) =>
      SalesByEmployeeModel(
        numberOfReceipts: json["numberOfReceipts"],
        sellerName: json["sellerName"] ?? "",
        sellerId: json["sellerId"] ?? "",
        grossSales: (json["grossSales"] as num?)?.toDouble() ?? 0.0,
        refunds: (json["refunds"] as num?)?.toDouble() ?? 0.0,
        discounts: (json["discounts"] as num?)?.toDouble() ?? 0.0,
        averageSales: (json["averageSales"] as num?)?.toDouble() ?? 0.0,
        uniqueCustomerCount: json["uniqueCustomerCount"] ?? 0,
        expenses: (json["expenses"] as num?)?.toDouble() ?? 0.0,
      );
}
