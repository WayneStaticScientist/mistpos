class PaymentRequestModel {
  final String id;
  final double amount;
  final String status;
  final String subscription;
  final int months;
  final DateTime? payedAt;
  final DateTime createdAt;

  PaymentRequestModel({
    required this.id,
    required this.amount,
    required this.status,
    required this.subscription,
    required this.months,
    this.payedAt,
    required this.createdAt,
  });

  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) {
    return PaymentRequestModel(
      id: json['_id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pending',
      subscription: json['subscription'] ?? '',
      months: json['months'] ?? 1,
      payedAt: json['payedAt'] != null ? DateTime.parse(json['payedAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
