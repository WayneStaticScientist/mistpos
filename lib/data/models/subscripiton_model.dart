class SubscriptionModel {
  DateTime? validUntil;
  bool hasExhaustedCredits;
  String type; // "trial" | "free" | "pro" | "enterprise"
  bool onlineNotified;
  bool offlineNotified;
  SubscriptionModel({
    this.type = "free",
    this.validUntil,
    this.hasExhaustedCredits = false,
    this.onlineNotified = false,
    this.offlineNotified = false,
  });
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      type: json['type'] ?? "free",
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'])
          : null,
      hasExhaustedCredits: json['hasExhaustedCredits'] ?? false,
      onlineNotified: json['onlineNotified'] ?? false,
      offlineNotified: json['offlineNotified'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "validUntil": validUntil?.toIso8601String(),
      "hasExhaustedCredits": hasExhaustedCredits,
      "onlineNotified": onlineNotified,
      "offlineNotified": offlineNotified,
    };
  }
}
