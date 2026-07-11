class SalesByCategoryModel {
  int itemsSold;
  String categoryName;
  String categoryId;
  double grossSales;
  double refunds;
  int color;

  SalesByCategoryModel({
    required this.itemsSold,
    required this.categoryName,
    required this.categoryId,
    required this.grossSales,
    required this.refunds,
    required this.color,
  });

  factory SalesByCategoryModel.fromJson(Map<String, dynamic> json) =>
      SalesByCategoryModel(
        itemsSold: json["itemsSold"] ?? 0,
        categoryName: json["categoryName"] ?? "Uncategorized",
        categoryId: json["categoryId"] ?? "",
        grossSales: (json["grossSales"] as num?)?.toDouble() ?? 0.0,
        refunds: (json["refunds"] as num?)?.toDouble() ?? 0.0,
        color: json["color"] ?? 0,
      );
}
