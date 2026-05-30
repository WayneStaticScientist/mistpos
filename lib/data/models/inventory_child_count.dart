class InventoryChildCount {
  String id;
  String name;
  double count;
  double cost = 0;
  double difference = 0;
  double counted = 0;
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
      count: (json['count'] as num?)?.toDouble() ?? 0.0,
      difference: (json['difference'] as num?)?.toDouble() ?? 0.0,
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      counted: (json['counted'] as num?)?.toDouble() ?? 0,
      costDifference: (json['costDifference'] as num?)?.toDouble() ?? 0.0,
    );
  }
  factory InventoryChildCount.fromProduct(Map<String, dynamic> data) {
    return InventoryChildCount(
      id: data['_id'],
      name: data['name'],
      cost: (data['cost'] as num?)?.toDouble() ?? 0.0,
      count: (data['stockQuantity'] as num?)?.toDouble() ?? 0.0,
      counted: (data['stockQuantity'] as num?)?.toDouble() ?? 0,
      difference: 0.0,
      costDifference: 0,
    );
  }
}
