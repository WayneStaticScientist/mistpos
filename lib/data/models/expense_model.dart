class ExpenseModel {
  final String id;
  String status;
  final String notes;
  final DateTime date;
  final double amount;
  final Map category;
  final String expenseFor;
  final String paymentType;
  final dynamic senderId;
  final dynamic acceptedBy;
  final String referenceNumber;

  ExpenseModel({
    required this.id,
    required this.notes,
    required this.date,
    required this.status,
    required this.amount,
    required this.senderId,
    required this.category,
    required this.expenseFor,
    required this.acceptedBy,
    required this.paymentType,
    required this.referenceNumber,
  });
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['_id'],
      notes: json['notes'],
      category: json['category'],
      expenseFor: json['expenseFor'],
      acceptedBy: json['acceptedBy'],
      paymentType: json['paymentType'],
      senderId: json['senderId'] ?? '',
      date: DateTime.parse(json['date']),
      status: json['status'] ?? 'pending',
      referenceNumber: json['referenceNumber'],
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
