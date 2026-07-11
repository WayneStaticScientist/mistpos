class SalesByCustomerModel {
  final double totalCustomersSales;
  final double totalUncategorizedSales;
  final List<CustomerSalesData> topCustomers;
  final List<CustomerSalesData> list;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  SalesByCustomerModel({
    required this.totalCustomersSales,
    required this.totalUncategorizedSales,
    required this.topCustomers,
    required this.list,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  factory SalesByCustomerModel.fromJson(Map<String, dynamic> json) {
    return SalesByCustomerModel(
      totalCustomersSales: (json['totalCustomersSales'] ?? 0.0).toDouble(),
      totalUncategorizedSales: (json['totalUncategorizedSales'] ?? 0.0).toDouble(),
      topCustomers: (json['topCustomers'] as List<dynamic>?)
              ?.map((e) => CustomerSalesData.fromJson(e))
              .toList() ??
          [],
      list: (json['list'] as List<dynamic>?)
              ?.map((e) => CustomerSalesData.fromJson(e))
              .toList() ??
          [],
      currentPage: json['pagination']?['page'] ?? 1,
      totalPages: json['pagination']?['pages'] ?? 1,
      totalItems: json['pagination']?['total'] ?? 0,
    );
  }
}

class CustomerSalesData {
  final String customerId;
  final String customerName;
  final double totalPaid;
  final int receiptCount;
  final double currentCredit;

  CustomerSalesData({
    required this.customerId,
    required this.customerName,
    required this.totalPaid,
    required this.receiptCount,
    required this.currentCredit,
  });

  factory CustomerSalesData.fromJson(Map<String, dynamic> json) {
    return CustomerSalesData(
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? 'Unknown Customer',
      totalPaid: (json['totalPaid'] ?? 0.0).toDouble(),
      receiptCount: json['receiptCount'] ?? 0,
      currentCredit: (json['currentCredit'] ?? 0.0).toDouble(),
    );
  }
}
