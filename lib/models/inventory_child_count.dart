class InventoryChildCount {
  String id;
  String name;
  int count;
  double cost = 0;
  int difference = 0;
  int counted = 0;
  double costDifference = 0;
  InventoryChildCount({
    required this.id,
    required this.name,
    required this.count,
    required this.difference,
    required this.cost,
    this.counted = 0,
    this.costDifference = 0,
  });
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "count": count,
      "difference": difference,
      "cost": cost,
      "counted": counted,
      "costDifference": costDifference,
    };
  }

  factory InventoryChildCount.fromJson(Map<String, dynamic> json) {
    return InventoryChildCount(
      id: json['id'],
      name: json['name'],
      count: json['count'],
      difference: json['difference'],
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      counted: json['counted'] ?? 0,
      costDifference: (json['costDifference'] as num?)?.toDouble() ?? 0.0,
    );
  }
  factory InventoryChildCount.fromProduct(Map<String, dynamic> data) {
    return InventoryChildCount(
      id: data['_id'],
      name: data['name'],
      cost: (data['cost'] as num?)?.toDouble() ?? 0.0,
      count: data['stockQuantity'] ?? 0,
      counted: data['stockQuantity'] ?? 0,
      difference: 0,
      costDifference: 0,
    );
  }
}
