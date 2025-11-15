class SalesByPayment {
  double refunds;
  double netSales;
  double grossSales;
  double discounts;
  String paymentMethod;
  int numberOfReceipts;
  int uniqueCustomerCount;
  double averageSalesPerReceipt;
  SalesByPayment({
    required this.refunds,
    required this.netSales,
    required this.discounts,
    required this.grossSales,
    required this.paymentMethod,
    required this.numberOfReceipts,
    required this.uniqueCustomerCount,
    required this.averageSalesPerReceipt,
  });
  factory SalesByPayment.fromJson(Map<String, dynamic> json) {
    return SalesByPayment(
      uniqueCustomerCount: json['uniqueCustomerCount'] ?? 0,
      discounts: (json['discounts'] as num?)?.toDouble() ?? 0.0,
      refunds: (json['refunds'] as num?)?.toDouble() ?? 0.0,
      netSales: (json['netSales'] as num?)?.toDouble() ?? 0.0,
      grossSales: (json['grossSales'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] ?? '',
      numberOfReceipts: json['numberOfReceipts'] ?? 0,
      averageSalesPerReceipt:
          (json['averageSalesPerReceipt'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
