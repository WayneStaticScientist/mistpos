class InventoryChildCount {
  String id;
  String name;
  int count;
  double cost = 0;
  int difference = 0;
  InventoryChildCount({
    required this.id,
    required this.name,
    required this.count,
    required this.difference,
    required this.cost,
  });
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "count": count,
      "difference": difference,
      "cost": cost,
    };
  }

  factory InventoryChildCount.fromJson(Map<String, dynamic> json) {
    return InventoryChildCount(
      id: json['_id'],
      name: json['name'],
      count: json['count'],
      difference: json['difference'],
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
