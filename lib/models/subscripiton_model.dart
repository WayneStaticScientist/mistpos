class SubscriptionModel {
  DateTime? validUntil;
  bool hasExhaustedCredits;
  String type; // "trial" | "free" | "pro" | "enterprise"

  SubscriptionModel({
    this.type = "free",
    this.validUntil,
    this.hasExhaustedCredits = false,
  });
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      type: json['type'] ?? "free",
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'])
          : null,
      hasExhaustedCredits: json['hasExhaustedCredits'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "validUntil": validUntil?.toIso8601String(),
      "hasExhaustedCredits": hasExhaustedCredits,
    };
  }
}
