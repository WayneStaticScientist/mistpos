import 'package:get_storage/get_storage.dart';
import 'package:mistpos/models/exchange_rate_model.dart';
import 'package:mistpos/models/receit_extras_model.dart';
import 'package:mistpos/models/subscripiton_model.dart';

class AutomatedSyncModel {
  final bool hasSubscription;
  final DateTime? validUntil;
  final String phone;
  final double price;
  AutomatedSyncModel({
    required this.hasSubscription,
    required this.validUntil,
    required this.price,
    required this.phone,
  });
  Map<String, dynamic> toJson() {
    return {
      'hasSubscription': hasSubscription,
      'validUntil': validUntil?.toIso8601String(),
      'price': price,
      'phone': phone,
    };
  }

  factory AutomatedSyncModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AutomatedSyncModel(
        hasSubscription: false,
        validUntil: null,
        price: 0.0,
        phone: "",
      );
    }
    return AutomatedSyncModel(
      hasSubscription: json['hasSubscription'] ?? false,
      phone: json['phone'] ?? "",
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'])
          : null,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CompanyModel {
  String owner;
  String email;
  String name;
  bool enableCreditSale;
  bool verified;
  bool showSalesCount;
  ExchangeRateModel exchangeRates;
  SubscriptionModel subscriptionType;
  bool autoApproveAllExpenses;
  String hexId;
  final AutomatedSyncModel automatedSync;
  List<ReceitExtrasModel> receitExtras;
  CompanyModel({
    required this.owner,
    required this.email,
    required this.name,
    this.receitExtras = const [],
    required this.hexId,
    this.verified = false,
    required this.exchangeRates,
    required this.showSalesCount,
    required this.subscriptionType,
    required this.enableCreditSale,
    this.autoApproveAllExpenses = false,
    required this.automatedSync,
  });
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      automatedSync: AutomatedSyncModel.fromJson(json['automatedSync']),
      autoApproveAllExpenses: json['autoApproveAllExpenses'] ?? false,
      enableCreditSale: json['enableCreditSale'] ?? true,
      owner: json['owner'],
      email: json['email'],
      hexId: json['_id'] ?? "",
      receitExtras:
          (json['receitExtras'] as List<dynamic>?)
              ?.map((e) => ReceitExtrasModel.fromJSON(e))
              .toList() ??
          [],
      name: json['name'] ?? "-",
      verified: json['verified'] ?? false,
      showSalesCount: json['showSalesCount'] ?? false,
      subscriptionType: json['subscriptionType'] != null
          ? SubscriptionModel.fromJson(json['subscriptionType'])
          : SubscriptionModel(),
      exchangeRates: ExchangeRateModel.fromJson(json['exchangeRates']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "_id": hexId,
      "name": name,
      "owner": owner,
      "email": email,
      "verified": verified,
      'automatedSync': automatedSync.toJson(),
      "showSalesCount": showSalesCount,
      'enableCreditSale': enableCreditSale,
      "exchangeRates": exchangeRates.toJson(),
      "subscriptionType": subscriptionType.toJson(),
      'autoApproveAllExpenses': autoApproveAllExpenses,
      "receitExtras": receitExtras.map((e) => e.toJson()).toList(),
    };
  }

  void saveToStorage() {
    GetStorage storage = GetStorage();
    storage.write("company", toJson());
  }

  static CompanyModel? fromStorage() {
    GetStorage storage = GetStorage();
    if (!storage.hasData("company")) return null;
    return CompanyModel.fromJson(storage.read("company"));
  }
}
