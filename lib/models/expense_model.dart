class ExpenseModel {
  final String id;

  final String notes;
  final DateTime date;
  final double amount;
  final Map category;
  final String expenseFor;
  final String paymentType;
  final String referenceNumber;

  ExpenseModel({
    required this.id,
    required this.notes,
    required this.date,
    required this.amount,
    required this.category,
    required this.expenseFor,
    required this.paymentType,
    required this.referenceNumber,
  });
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['_id'],
      notes: json['notes'],
      category: json['category'],
      expenseFor: json['expenseFor'],
      paymentType: json['paymentType'],
      date: DateTime.parse(json['date']),
      referenceNumber: json['referenceNumber'],
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
