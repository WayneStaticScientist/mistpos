class TopSellerProduct {
  final String itemId;
  final String name;
  final double totalSold;
  final double revenue;

  TopSellerProduct({
    required this.itemId,
    required this.name,
    required this.totalSold,
    required this.revenue,
  });

  factory TopSellerProduct.fromJson(Map<String, dynamic> json) {
    return TopSellerProduct(
      itemId: json['itemId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      totalSold: (json['totalSold'] ?? 0).toDouble(),
      revenue: (json['revenue'] ?? 0).toDouble(),
    );
  }
}

class LowSellerProduct {
  final String itemId;
  final String name;
  final double totalSold;
  final double revenue;

  LowSellerProduct({
    required this.itemId,
    required this.name,
    required this.totalSold,
    required this.revenue,
  });

  factory LowSellerProduct.fromJson(Map<String, dynamic> json) {
    return LowSellerProduct(
      itemId: json['itemId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      totalSold: (json['totalSold'] ?? 0).toDouble(),
      revenue: (json['revenue'] ?? 0).toDouble(),
    );
  }
}

class UnsoldProduct {
  final String itemId;
  final String name;
  final double price;
  final int stockQuantity;

  UnsoldProduct({
    required this.itemId,
    required this.name,
    required this.price,
    required this.stockQuantity,
  });

  factory UnsoldProduct.fromJson(Map<String, dynamic> json) {
    return UnsoldProduct(
      itemId: json['itemId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stockQuantity: (json['stockQuantity'] ?? 0).toInt(),
    );
  }
}

class ProductSalesTrend {
  final String date;
  final double totalSold;
  final double revenue;

  ProductSalesTrend({
    required this.date,
    required this.totalSold,
    required this.revenue,
  });

  factory ProductSalesTrend.fromJson(Map<String, dynamic> json) {
    return ProductSalesTrend(
      date: json['date']?.toString() ?? '',
      totalSold: (json['totalSold'] ?? 0).toDouble(),
      revenue: (json['revenue'] ?? 0).toDouble(),
    );
  }
}

class ProductPieSlice {
  final String name;
  final double percentage;
  final double totalSold;

  ProductPieSlice({
    required this.name,
    required this.percentage,
    required this.totalSold,
  });

  factory ProductPieSlice.fromJson(Map<String, dynamic> json) {
    return ProductPieSlice(
      name: json['name']?.toString() ?? '',
      percentage: (json['percentage'] ?? 0).toDouble(),
      totalSold: (json['totalSold'] ?? 0).toDouble(),
    );
  }
}
