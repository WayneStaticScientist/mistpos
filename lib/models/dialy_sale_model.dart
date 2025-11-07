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
