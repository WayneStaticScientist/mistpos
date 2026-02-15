class ExpenseCategoryModel {
  final String id;
  final String label;

  ExpenseCategoryModel({required this.id, required this.label});
  factory ExpenseCategoryModel.fromJson(dynamic json) {
    return ExpenseCategoryModel(id: json['_id'], label: json['label']);
  }
  Map<String, dynamic> toJson() {
    return {'_id': id, 'label': label};
  }
}
